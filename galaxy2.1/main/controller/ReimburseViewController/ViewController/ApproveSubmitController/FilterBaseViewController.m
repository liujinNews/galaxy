//
//  FilterBaseViewController.m
//  galaxy
//
//  Created by hfk on 16/8/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FilterBaseViewController.h"
#import "FilterBaseHeadView.h"
#import "FilterBaseCell.h"
static NSString *const CellIdentifier = @"FilterBaseCell";
static NSString *const HeadViewIdentifier = @"FilterBaseHeadView";
@interface FilterBaseViewController ()
@property(nonatomic,strong)NSString *type;
@end

@implementation FilterBaseViewController
-(id)initWithType:(NSString *)type{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"筛选", nil) backButton:YES ];
    [self resetAndSureBtn];
    _mainArray=[NSMutableArray array];
    _firstArray=[NSMutableArray array];
    _secondArray=[NSMutableArray array];
    _thirdArray = [NSMutableArray array];
    _firstSelect = @"";
    _secondSelect = @"";
    _thirdSelect = @"0";
    [self createScrollView];
    [self updateMainView];
}

//MARK:底部按钮
-(void)resetAndSureBtn{
    
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    _resetBtn=[GPUtils createButton:CGRectMake(0, 0, ScreenRect.size.width/2, 50)action:@selector(resetClick:) delegate:self];
    _resetBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_resetBtn setTitle:Custing(@"重置", nil) forState:UIControlStateNormal];
    _resetBtn.titleLabel.font=Font_filterTitle_17;
    [_resetBtn setTitleColor:Color_Black_Important_20 forState:UIControlStateNormal];
    [self.dockView addSubview:_resetBtn];
    
    _sureBtn=[GPUtils createButton:CGRectMake(ScreenRect.size.width/2, 0, ScreenRect.size.width/2, 50)action:@selector(sureClick:) delegate:self];
    _sureBtn.backgroundColor = Color_Blue_Important_20;
    [_sureBtn setTitle:Custing(@"确定", nil) forState:UIControlStateNormal];
    _sureBtn.titleLabel.font=Font_filterTitle_17;
    [_sureBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:_sureBtn];
}

//MARK:操作完成后回来刷新
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    _contentView =[[UIView alloc]init];
    _contentView.userInteractionEnabled=YES;
    _contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _View_Collect=[[UIView alloc]init];
    _View_Collect.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_Collect];
    [_View_Collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Branch=[[UIView alloc]init];
    _View_Branch.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_Branch];
    [_View_Branch makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Collect.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CostCenter = [[UIView alloc]init];
    _View_CostCenter.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_CostCenter];
    [_View_CostCenter makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Branch.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Apply=[[UIView alloc]init];
    _View_Apply.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_Apply];
    [_View_Apply makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CostCenter.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Department=[[UIView alloc]init];
    _View_Department.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_Department];
    [_View_Department makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Apply.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SerialNo=[[UIView alloc]init];
    _View_SerialNo.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_SerialNo];
    [_View_SerialNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Department.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
  
    _View_TaskName=[[UIView alloc]init];
    _View_TaskName.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_TaskName];
    [_View_TaskName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SerialNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Time=[[UIView alloc]init];
    _View_Time.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_Time];
    [_View_Time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TaskName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FinishData = [[UIView alloc]init];
    _View_FinishData.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_FinishData];
    [_View_FinishData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Time.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Amount=[[UIView alloc]init];
    _View_Amount.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_Amount];
    [_View_Amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FinishData.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}
-(void)updateMainView{
//MARK:高度计算方法
    //头部Hight=32(流程...)
    //带标题=42(全部,出差....)
    [self getShowAndDealData];
    if ([_type isEqualToString:@"WorkHasSubmit"]){
        [_mainArray addObject:_firstArray];
        [_mainArray addObject:_secondArray];
        [_mainArray addObject:_thirdArray];
        [self createCollectionViewWithHeight:_collectHeight];
        [self createSerialNoView];
        [self createDateView];
        
    }else if ([_type isEqualToString:@"WorkHasApprove"]){
        [_mainArray addObject:_firstArray];
        [_mainArray addObject:_secondArray];
        [self createCollectionViewWithHeight:_collectHeight];
        [self createBranchView];
        [self createApplyPeopleView];
        [self createSerialNoView];
        [self createTaskNameView];
        [self createDateView];
        [self createFinishDateView];
    }else if ([_type isEqualToString:@"WorkCCTOME"]){
        [_mainArray addObject:_firstArray];
        [_mainArray addObject:_secondArray];
        [self createCollectionViewWithHeight:_collectHeight];
        [self createApplyPeopleView];
        [self createSerialNoView];
        [self createTaskNameView];
        [self createDateView];
    }else if ([_type isEqualToString:@"PayMengtWaitPay"]){
        [_mainArray addObject:_firstArray];
        [self createCollectionViewWithHeight:_collectHeight];
        [self createBranchView];
        [self createApplyPeopleView];
        [self createSerialNoView];
    }else if ([_type isEqualToString:@"PayMengtHasPay"]){
        [_mainArray addObject:_firstArray];
        [self createCollectionViewWithHeight:_collectHeight];
        [self createBranchView];
        [self createApplyPeopleView];
        [self createSerialNoView];
        [self createDateView];
        
    }else if ([_type isEqualToString:@"DocumentSearch"]){
        [_mainArray addObject:_firstArray];
        [_mainArray addObject:_secondArray];
        [self createCollectionViewWithHeight:_collectHeight];
        [self createBranchView];
        [self createCostCenterView];
        [self createApplyPeopleView];
        [self createDepartmentView];
        [self createSerialNoView];
        [self createTaskNameView];
        [self createDateView];
        [self createAmountView];
        
    }else if ([_type isEqualToString:@"WorkWaitApprove"]){
        [_mainArray addObject:_firstArray];
        [self createCollectionViewWithHeight:_collectHeight];
        [self createApplyPeopleView];
        [self createDepartmentView];
        [self createSerialNoView];
        [self createBranchView];
        
    }else if ([_type isEqualToString:@"PayMengtPro"]){
        [_mainArray addObject:_firstArray];
        [self createCollectionViewWithHeight:_collectHeight];
        
    }
    [_contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Amount.bottom);
    }];
}
-(void)createCollectionViewWithHeight:(NSInteger)height{
    [_View_Collect updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
    }
    _layOut.minimumInteritemSpacing =0;
    _layOut.minimumLineSpacing =0;
    
    if (!_collView) {
        _collView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, Main_Screen_Width-30, height) collectionViewLayout:_layOut];
    }
    _collView.delegate = self;
    _collView.dataSource = self;
    //    _collView.alwaysBounceVertical=YES;
    _collView.backgroundColor =Color_form_TextFieldBackgroundColor;
    [_collView registerClass:[FilterBaseCell class] forCellWithReuseIdentifier:CellIdentifier];
    [_collView registerClass:[FilterBaseHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier];
    [_View_Collect addSubview:_collView];
    
    if (_mainArray.count==2) {
        NSArray *arr=_mainArray[0];
        NSInteger count=ceilf((float)(arr.count)/3);
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 32+42*count, Main_Screen_Width, 0.5)];
        lineView.backgroundColor=Color_LineGray_Same_20;
        [_View_Collect addSubview:lineView];
    }else if (_mainArray.count==3){
        NSArray *arr=_mainArray[0];
        NSInteger count=ceilf((float)(arr.count)/3);
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 32+42*count, Main_Screen_Width, 0.5)];
        lineView.backgroundColor=Color_LineGray_Same_20;
        [_View_Collect addSubview:lineView];
        
        NSArray *arr1=_mainArray[1];
        NSInteger count1=ceilf((float)(arr1.count)/3);
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,Y(lineView)+32+42*count1, Main_Screen_Width, 0.5)];
        lineView1.backgroundColor=Color_LineGray_Same_20;
        [_View_Collect addSubview:lineView1];
    }
}

-(void)createBranchView{
    _txf_Branch=[[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Branch WithContent:_txf_Branch WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"公司", nil) WithTips:Custing(@"请选择公司", nil)  WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BranchCompany"];
        vc.ChooseCategoryId=self.str_BranchId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_BranchId=model.groupId;
            weakSelf.txf_Branch.text=model.groupName;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_Branch addSubview:view];
}
-(void)createCostCenterView{
    _txf_CostCenter = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_CostCenter WithContent:_txf_CostCenter WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"成本中心", nil) WithTips:Custing(@"请选择成本中心", nil)  WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"costCenter"];
        vc.ChooseCategoryId = self.str_CostCenterId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_CostCenterId = model.Id;
            weakSelf.txf_CostCenter.text = model.costCenter;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_CostCenter addSubview:view];
}
-(void)createApplyPeopleView{
    _ApplyPeopleTF=[[UITextField alloc]init];
    [_View_Apply addSubview:[[SubmitFormView alloc]initBaseView:_View_Apply WithContent:_ApplyPeopleTF WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"申请人", nil) WithTips:Custing(@"请输入申请人", nil)  WithInfodict:nil]];
}

-(void)createDepartmentView{
    _DepartmentTF = [[UITextField alloc]init];
    [_View_Department addSubview:[[SubmitFormView alloc]initBaseView:_View_Department WithContent:_DepartmentTF WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"部门", nil) WithTips:Custing(@"请输入部门", nil)  WithInfodict:nil]];
}

-(void)createSerialNoView{
    _SerialNoTF=[[UITextField alloc]init];
    [_View_SerialNo addSubview:[[SubmitFormView alloc]initBaseView:_View_SerialNo WithContent:_SerialNoTF WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"单号", nil) WithTips:Custing(@"请输入单号", nil)  WithInfodict:nil]];
    _SerialNoTF .keyboardType = UIKeyboardTypeNumberPad;
}

-(void)createTaskNameView{
    _txf_TaskName=[[UITextField alloc]init];
    [_View_TaskName addSubview:[[SubmitFormView alloc]initBaseView:_View_TaskName WithContent:_txf_TaskName WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"标题", nil) WithTips:Custing(@"请输入标题", nil)  WithInfodict:nil]];
}

-(void)createDateView{
    [_View_Time updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@95);
    }];
    
    UIView *upLineView=[[UIView alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
    upLineView.backgroundColor=Color_LineGray_Same_20;
    [_View_Time addSubview:upLineView];
    
    UILabel *titleLab=[GPUtils createLable:CGRectMake(15, 8,Main_Screen_Width-30, 16) text:Custing(@"申请时间", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    if ([_type isEqualToString:@"PayMengtHasPay"]) {
        titleLab.text=Custing(@"支付时间", nil);
    }
    [_View_Time addSubview:titleLab];
    
    UIView *midLineView=[[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-12, 59, 24, 1)];
    midLineView.backgroundColor=Color_FilterLineColor_Weak_20;
    [_View_Time addSubview:midLineView];
    
    _startTimeTxf=[GPUtils createTextField:CGRectMake(12, 43, Main_Screen_Width/2-36, 32) placeholder:Custing(@"开始时间", nil) delegate:self font:Font_Same_14_20 textColor:Color_Blue_Important_20];
    _startTimeTxf.delegate=self;
    _startTimeTxf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _startTimeTxf.leftViewMode = UITextFieldViewModeAlways;
    _startTimeTxf.backgroundColor=Color_form_TextFieldBackgroundColor;
    _startTimeTxf.keyboardType =UIKeyboardTypeDecimalPad;
    _startTimeTxf.layer.masksToBounds=YES;
    _startTimeTxf.layer.cornerRadius=3.0f;
    _startTimeTxf.layer.borderWidth=1.0;
    _startTimeTxf.layer.borderColor=Color_GrayLight_Same_20.CGColor;
    _startTimeTxf.userInteractionEnabled=NO;
    [_View_Time addSubview:_startTimeTxf];

    UIButton *start=[GPUtils createButton:CGRectMake(12, 43, Main_Screen_Width/2-36, 32) action:@selector(startAndendTimeBtnClick:) delegate:self];
    start.tag=1;
    [_View_Time addSubview:start];

    _endTimeTxf=[GPUtils createTextField:CGRectMake(Main_Screen_Width/2+24, 43, Main_Screen_Width/2-36, 32) placeholder:Custing(@"结束时间", nil) delegate:self font:Font_Same_14_20 textColor:Color_Blue_Important_20];
    _endTimeTxf.delegate=self;
    _endTimeTxf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _endTimeTxf.leftViewMode = UITextFieldViewModeAlways;
    _endTimeTxf.backgroundColor=Color_form_TextFieldBackgroundColor;
    _endTimeTxf.keyboardType =UIKeyboardTypeDecimalPad;
    _endTimeTxf.layer.masksToBounds=YES;
    _endTimeTxf.layer.cornerRadius=3.0f;
    _endTimeTxf.layer.borderWidth=1.0;
    _endTimeTxf.layer.borderColor=Color_GrayLight_Same_20.CGColor;
    _endTimeTxf.userInteractionEnabled=NO;
    [_View_Time addSubview:_endTimeTxf];
    UIButton *end=[GPUtils createButton:CGRectMake(Main_Screen_Width/2+24, 43, Main_Screen_Width/2-36, 32) action:@selector(startAndendTimeBtnClick:) delegate:self];
    end.tag=2;
    [_View_Time addSubview:end];

}
-(void)createFinishDateView{
    [_View_FinishData updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@95);
    }];
    
    UIView *upLineView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
    upLineView.backgroundColor = Color_LineGray_Same_20;
    [_View_FinishData addSubview:upLineView];
    
    UILabel *titleLab = [GPUtils createLable:CGRectMake(15, 8,Main_Screen_Width-30, 16) text:Custing(@"审批完成时间", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_View_FinishData addSubview:titleLab];
    
    UIView *midLineView = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-12, 59, 24, 1)];
    midLineView.backgroundColor = Color_FilterLineColor_Weak_20;
    [_View_FinishData addSubview:midLineView];
    
    _finishDateSTxf = [GPUtils createTextField:CGRectMake(12, 43, Main_Screen_Width/2-36, 32) placeholder:Custing(@"开始时间", nil) delegate:self font:Font_Same_14_20 textColor:Color_Blue_Important_20];
    _finishDateSTxf.delegate = self;
    _finishDateSTxf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _finishDateSTxf.leftViewMode = UITextFieldViewModeAlways;
    _finishDateSTxf.backgroundColor = Color_form_TextFieldBackgroundColor;
    _finishDateSTxf.keyboardType = UIKeyboardTypeDecimalPad;
    _finishDateSTxf.layer.masksToBounds = YES;
    _finishDateSTxf.layer.cornerRadius = 3.0f;
    _finishDateSTxf.layer.borderWidth = 1.0;
    _finishDateSTxf.layer.borderColor = Color_GrayLight_Same_20.CGColor;
    _finishDateSTxf.userInteractionEnabled = NO;
    [_View_FinishData addSubview:_finishDateSTxf];
    
    UIButton *start = [GPUtils createButton:CGRectMake(12, 43, Main_Screen_Width/2-36, 32) action:@selector(startAndendTimeBtnClick:) delegate:self];
    start.tag = 3;
    [_View_FinishData addSubview:start];
    
    _finishDateETxf = [GPUtils createTextField:CGRectMake(Main_Screen_Width/2+24, 43, Main_Screen_Width/2-36, 32) placeholder:Custing(@"结束时间", nil) delegate:self font:Font_Same_14_20 textColor:Color_Blue_Important_20];
    _finishDateETxf.delegate = self;
    _finishDateETxf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _finishDateETxf.leftViewMode = UITextFieldViewModeAlways;
    _finishDateETxf.backgroundColor = Color_form_TextFieldBackgroundColor;
    _finishDateETxf.keyboardType = UIKeyboardTypeDecimalPad;
    _finishDateETxf.layer.masksToBounds = YES;
    _finishDateETxf.layer.cornerRadius = 3.0f;
    _finishDateETxf.layer.borderWidth = 1.0;
    _finishDateETxf.layer.borderColor = Color_GrayLight_Same_20.CGColor;
    _finishDateETxf.userInteractionEnabled = NO;
    [_View_FinishData addSubview:_finishDateETxf];
    UIButton *end = [GPUtils createButton:CGRectMake(Main_Screen_Width/2+24, 43, Main_Screen_Width/2-36, 32) action:@selector(startAndendTimeBtnClick:) delegate:self];
    end.tag = 4;
    [_View_FinishData addSubview:end];
}

//MARK:开始时间
-(void)startAndendTimeBtnClick:(UIButton *)btn{
    [self keyClose];
    _datePicker = [[UIDatePicker alloc]init];
    NSString *dateStr;
    if (btn.tag == 1) {
        _btnIndex = 1;
        if ([NSString isEqualToNull:self.startTimeTxf.text]) {
            dateStr = self.startTimeTxf.text;
            _startSelectData = dateStr;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            pickerFormatter.timeZone = [NSTimeZone localTimeZone];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *currStr = [pickerFormatter stringFromDate:pickerDate];
            dateStr = currStr;
            _startSelectData = currStr;
        }
    }else if (btn.tag == 2){
        _btnIndex = 2;
        if ([NSString isEqualToNull:self.endTimeTxf.text]) {
            dateStr = self.endTimeTxf.text;
            _endSelectData = dateStr;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            pickerFormatter.timeZone = [NSTimeZone localTimeZone];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *currStr = [pickerFormatter stringFromDate:pickerDate];
            dateStr = currStr;
            _endSelectData = currStr;
        }
    }else if (btn.tag == 3){
        _btnIndex = 3;
        if ([NSString isEqualToNull:self.finishDateSTxf.text]) {
            dateStr = self.finishDateSTxf.text;
            _finishDateS = dateStr;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            pickerFormatter.timeZone = [NSTimeZone localTimeZone];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *currStr = [pickerFormatter stringFromDate:pickerDate];
            dateStr = currStr;
            _finishDateS = currStr;
        }
    }else if (btn.tag == 4){
        _btnIndex = 4;
        if ([NSString isEqualToNull:self.finishDateETxf.text]) {
            dateStr = self.finishDateETxf.text;
            _finishDateE = dateStr;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            pickerFormatter.timeZone = [NSTimeZone localTimeZone];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
            dateStr = currStr;
            _finishDateE = currStr;
        }
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    _datePicker.date = fromDate;
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl = [GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text = Custing(@"时间", nil);
    lbl.font = Font_cellContent_16;
    lbl.textColor = Color_cellTitle;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn = [GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:sureDataBtn];
    
    UIButton *cancelDataBtn = [GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:cancelDataBtn];
    
    if (!_DateChooseView) {
        _DateChooseView = [[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
        _DateChooseView.delegate = self;
    }
    
    [_DateChooseView showUpView:_datePicker];
    [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)DateChanged:(UIDatePicker *)sender{
    [self keyClose];
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    if (_btnIndex == 1) {
        _startSelectData = str;
    }else if (_btnIndex == 2){
        _endSelectData = str;
    }else if (_btnIndex == 3){
        _finishDateS = str;
    }else if (_btnIndex == 4){
        _finishDateE = str;
    }
}
//MARK:时间选择确定按钮
-(void)sureData{
    if (_btnIndex == 1) {
        if (_startSelectData) {
            self.startTimeTxf.text = _startSelectData;
        }
    }else if (_btnIndex == 2){
        if (_endSelectData) {
            self.endTimeTxf.text = _endSelectData;
        }
    }else if (_btnIndex == 3){
        if (_finishDateS) {
            self.finishDateSTxf.text = _finishDateS;
        }
    }else if (_btnIndex == 4){
        if (_finishDateE) {
            self.finishDateETxf.text = _finishDateE;
        }
    }
    [self.DateChooseView remove];
}
-(void)btn_Cancel_Click{
    [self.DateChooseView remove];
}

-(void)createAmountView{
    [_View_Amount updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@95);
    }];
    
    UIView *upLineView=[[UIView alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12,0.5)];
    upLineView.backgroundColor=Color_LineGray_Same_20;
    [_View_Amount addSubview:upLineView];
    
    UILabel *titleLab=[GPUtils createLable:CGRectMake(15, 8,Main_Screen_Width-30, 16) text:Custing(@"报销金额", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_View_Amount addSubview:titleLab];
    
    
    UIView *midLineView=[[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-12, 59, 24, 1)];
    midLineView.backgroundColor=Color_FilterLineColor_Weak_20;
    [_View_Amount addSubview:midLineView];

    _StartAmountTF=[GPUtils createTextField:CGRectMake(12, 43, Main_Screen_Width/2-36, 32) placeholder:Custing(@"请输入起始金额", nil) delegate:self font:Font_Same_14_20 textColor:Color_Blue_Important_20];
    _StartAmountTF.delegate=self;
    _StartAmountTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _StartAmountTF.leftViewMode = UITextFieldViewModeAlways;
    _StartAmountTF.backgroundColor=Color_form_TextFieldBackgroundColor;
    _StartAmountTF.keyboardType =UIKeyboardTypeDecimalPad;
    _StartAmountTF.layer.masksToBounds=YES;
    _StartAmountTF.layer.cornerRadius=3.0f;
    _StartAmountTF.layer.borderWidth=1.0;
    _StartAmountTF.layer.borderColor=Color_GrayLight_Same_20.CGColor;
    [_View_Amount addSubview:_StartAmountTF];
    
    _EndAmountTF=[GPUtils createTextField:CGRectMake(Main_Screen_Width/2+24, 43, Main_Screen_Width/2-36, 32) placeholder:Custing(@"请输入结束金额", nil) delegate:self font:Font_Same_14_20 textColor:Color_Blue_Important_20];
    _EndAmountTF.delegate=self;
    _EndAmountTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _EndAmountTF.leftViewMode = UITextFieldViewModeAlways;
    _EndAmountTF.backgroundColor=Color_form_TextFieldBackgroundColor;
    _EndAmountTF.keyboardType =UIKeyboardTypeDecimalPad;
    _EndAmountTF.layer.masksToBounds=YES;
    _EndAmountTF.layer.cornerRadius=3.0f;
    _EndAmountTF.layer.borderWidth=1.0;
    _EndAmountTF.layer.borderColor=Color_GrayLight_Same_20.CGColor;
    [_View_Amount addSubview:_EndAmountTF];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((Main_Screen_Width-54)/3, 42);;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 12;
}

#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Main_Screen_Width, 32);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
       FilterBaseHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier forIndexPath:indexPath];
        [headView configHeadViewWith:indexPath.section withArray:[_type isEqualToString:@"PayMengtPro"]?@[Custing(@"进程", nil)]:@[Custing(@"流程", nil),Custing(@"状态", nil),Custing(@"支付状态", nil)]];
        return  headView;
    }else{
        return  [[UICollectionReusableView alloc]init];
    }
}

#pragma mark - CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _mainArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr=_mainArray[section];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [_cell configCollectCellWithData:_mainArray WithType:_type WithFirstChoosed:_firstSelect WithSecondChoosed:_secondSelect WithThirdChoosed:_thirdSelect WithIndex:indexPath];
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        _firstSelect = _mainArray[0][indexPath.row];
    }else if (indexPath.section==1){
        _secondSelect = _mainArray[1][indexPath.row];
    }else if (indexPath.section==2){
        _thirdSelect = _mainArray[2][indexPath.row];
    }
    [_collView reloadData];
}

//MARK:日期选择底层视图代理
-(void)dimsissPDActionView{
    _DateChooseView=nil;
}

//MARK:重置
-(void)resetClick:(UIButton *)btn{
    NSLog(@"重置");
    if ([_type isEqualToString:@"WorkHasSubmit"]){
        _firstSelect = @"F0000";
        _secondSelect = @"";
        _thirdSelect = @"0";
    }else if ([_type isEqualToString:@"WorkHasApprove"]){
        _firstSelect=@"0|0";
        _secondSelect=@"";
        _ApplyPeopleTF.text=@"";
        _txf_TaskName.text=@"";
        _finishDateSTxf.text = @"";
        _finishDateETxf.text = @"";
    }else if ([_type isEqualToString:@"WorkCCTOME"]){
        _firstSelect=@"0|0";
        _secondSelect=@"";
        _ApplyPeopleTF.text=@"";
        _txf_TaskName.text=@"";
    }else if ([_type isEqualToString:@"PayMengtWaitPay"]){
        _firstSelect=@"F0000";
        _ApplyPeopleTF.text=@"";
        _txf_Branch.text = @"";
        _str_BranchId = @"";
    }else if ([_type isEqualToString:@"PayMengtHasPay"]){
        _firstSelect=@"F0000";
        _ApplyPeopleTF.text=@"";
        _txf_Branch.text = @"";
        _str_BranchId = @"";
    }else if ([_type isEqualToString:@"DocumentSearch"]){
        _firstSelect=@"F0000";
        _secondSelect=@"";
        _txf_Branch.text = @"";
        _str_BranchId = @"";
        _txf_CostCenter.text = @"";
        _str_CostCenterId = @"";
        _ApplyPeopleTF.text=@"";
        _DepartmentTF.text=@"";
        _txf_TaskName.text=@"";
        _StartAmountTF.text=@"";
        _EndAmountTF.text=@"";
    }else if ([_type isEqualToString:@"WorkWaitApprove"]){
        _firstSelect = @"F0000";
        _ApplyPeopleTF.text = @"";
        _DepartmentTF.text = @"";
        _txf_Branch.text = @"";
        _str_BranchId = @"";
    }else if ([_type isEqualToString:@"PayMengtPro"]){
        _firstSelect=@"";
    }
    [_collView reloadData];
    _SerialNoTF.text=@"";
    _startTimeTxf.text=@"";
    _endTimeTxf.text=@"";
}
//MARK:确定
-(void)sureClick:(UIButton *)btn{
    NSString *str = _firstSelect;
    if ([str isEqualToString:@"F0000"]) {
        str = @"";
    }
    if ([_type isEqualToString:@"WorkHasSubmit"]){
        //流程
       
        NSArray *arr=[str componentsSeparatedByString:@"|"];
        MyApplyFilterResultController *submitResult=[[MyApplyFilterResultController alloc]initWithType:@"1"];
        submitResult.dict_Parameters=@{
                                       @"flowGuid":arr.count > 0 ? arr[0]:@"",
                                       @"status":_secondSelect,
                                       @"paymentStatus":_thirdSelect,
                                       @"serialNo":self.SerialNoTF.text,
                                       @"startTime":self.startTimeTxf.text,
                                       @"endTime":self.endTimeTxf.text
                                       };
        [self.navigationController pushViewController:submitResult animated:YES];
    }else if ([_type isEqualToString:@"WorkHasApprove"]){
        //流程
        NSArray *arr = [str componentsSeparatedByString:@"|"];
        MyApprovalFilterController *submitResult = [[MyApprovalFilterController alloc]initWithType:1];
        submitResult.dict_Parameters=@{
                                       @"flowGuid":arr.count > 0 ? arr[0]:@"",
                                       @"status":_secondSelect,
                                       @"applyPeople":self.ApplyPeopleTF.text,
                                       @"serialNo":self.SerialNoTF.text,
                                       @"startTime":self.startTimeTxf.text,
                                       @"endTime":self.endTimeTxf.text,
                                       @"taskName":self.txf_TaskName.text,
                                       @"branchId":self.str_BranchId,
                                       @"finishDateS":self.finishDateS,
                                       @"finishDateE":self.finishDateE
                                       };
        [self.navigationController pushViewController:submitResult animated:YES];
    }else if ([_type isEqualToString:@"WorkCCTOME"]){
        NSArray *arr = [str componentsSeparatedByString:@"|"];
        MyApprovalFilterController *submitResult=[[MyApprovalFilterController alloc]initWithType:2];
        submitResult.dict_Parameters=@{
                                       @"flowGuid":arr.count > 0 ? arr[0]:@"",
                                       @"status":_secondSelect,
                                       @"applyPeople":self.ApplyPeopleTF.text,
                                       @"serialNo":self.SerialNoTF.text,
                                       @"startTime":self.startTimeTxf.text,
                                       @"endTime":self.endTimeTxf.text,
                                       @"taskName":self.txf_TaskName.text,
                                       @"branchId":self.str_BranchId
                                       };
        [self.navigationController pushViewController:submitResult animated:YES];
    }else if ([_type isEqualToString:@"PayMengtWaitPay"]){
        //流程
        NSArray *arr=[str componentsSeparatedByString:@"|"];
        MyApprovalFilterController *submitResult=[[MyApprovalFilterController alloc]initWithType:3];
        submitResult.dict_Parameters=@{
                                       @"flowGuid":arr.count > 0 ? arr[0]:@"",
                                       @"applyPeople":self.ApplyPeopleTF.text,
                                       @"serialNo":self.SerialNoTF.text,
                                       @"branchId":self.str_BranchId
                                       };
        //        submitResult.backIndex=@"1";
        [self.navigationController pushViewController:submitResult animated:YES];
    }else if ([_type isEqualToString:@"PayMengtHasPay"]){
        //流程
        NSArray *arr=[str componentsSeparatedByString:@"|"];
        MyApprovalFilterController *submitResult=[[MyApprovalFilterController alloc]initWithType:4];
        submitResult.dict_Parameters=@{
                                       @"flowGuid":arr.count > 0 ? arr[0]:@"",
                                       @"status":_secondSelect,
                                       @"applyPeople":self.ApplyPeopleTF.text,
                                       @"serialNo":self.SerialNoTF.text,
                                       @"startTime":self.startTimeTxf.text,
                                       @"endTime":self.endTimeTxf.text,
                                       @"branchId":self.str_BranchId
                                       };
//        submitResult.backIndex=@"1";
        [self.navigationController pushViewController:submitResult animated:YES];
    }else if ([_type isEqualToString:@"DocumentSearch"]){
        //流程
        NSArray *arr=[str componentsSeparatedByString:@"|"];
        NSDictionary *dict=@{
                             @"FlowGuid":arr.count > 0 ? arr[0]:@"",
                             @"Requestor":self.ApplyPeopleTF.text,
                             @"SerialNo":self.SerialNoTF.text,
                             @"RequestorDeptId":@"",
                             @"RequestorDept":self.DepartmentTF.text,
                             @"Status":_secondSelect,
                             @"RequestorFromDate":self.startTimeTxf.text,
                             @"RequestorToDate":self.endTimeTxf.text,
                             @"StartAmount":self.StartAmountTF.text,
                             @"EndAmount":self.EndAmountTF.text,
                             @"taskName":self.txf_TaskName.text,
                             @"branchId":self.str_BranchId,
                             @"costCenterId":self.str_CostCenterId
                             };
        self.block(dict);
        [self.navigationController popViewControllerAnimated:YES];
        
//        MyApprovalFilterController *submitResult=[[MyApprovalFilterController alloc]initWithType:5];
//        submitResult.dict_Parameters=@{
//                                       @"flowCode":_flowCodeString,
//                                       @"status":_statusString,
//                                       @"applyPeople":_ApplyPeople,
//                                       @"serialNo":_SerialSearchNo,
//                                       @"startTime":_StartTime,
//                                       @"endTime":_EndTime,
//                                       @"taskName":_TaskName,
//                                       @"deptId":@"",
//                                       @"dept":_RequestorDept,
//                                       @"startAmount":_StartAmount,
//                                       @"endAmount":_EndAmount
//                                       };
//        //        submitResult.backIndex=@"1";
//        [self.navigationController pushViewController:submitResult animated:YES];
    }else if ([_type isEqualToString:@"WorkWaitApprove"]){
        //流程
        NSArray *arr=[str componentsSeparatedByString:@"|"];
        MyApprovalFilterController *submitResult=[[MyApprovalFilterController alloc]initWithType:0];
        submitResult.dict_Parameters=@{
                                       @"flowGuid":arr.count > 0 ? arr[0]:@"",
                                       @"applyPeople":self.ApplyPeopleTF.text,
                                       @"serialNo":self.SerialNoTF.text,
                                       @"branchId":self.str_BranchId,
                                       @"RequestorDeptId":@"",
                                       @"RequestorDept":self.DepartmentTF.text,
                                       };
//        submitResult.backIndex=@"1";
        [self.navigationController pushViewController:submitResult animated:YES];
        
    }else if ([_type isEqualToString:@"PayMengtPro"]){
        MyApprovalFilterController *submitResult=[[MyApprovalFilterController alloc]initWithType:6];
        submitResult.dict_Parameters=@{
                                       @"status":str
                                       };
//        submitResult.backIndex=@"1";
        [self.navigationController pushViewController:submitResult animated:YES];
    }
}

//MARK:限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *pattern;
    if (_StartAmountTF == textField||_EndAmountTF == textField) {
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
    }else {
        pattern = @".";
    }
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger match = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    return match!= 0;
}

//MARK:获取数据
-(void)getShowAndDealData{
    if ([_type isEqualToString:@"WorkHasSubmit"]||[_type isEqualToString:@"WorkHasApprove"]||[_type isEqualToString:@"WorkCCTOME"]||[_type isEqualToString:@"DocumentSearch"]){
        _firstArray=[NSMutableArray arrayWithArray:self.userdatas.arr_XBOpenFlowcode];
        [_firstArray insertObject:@"F0000" atIndex:0];
        _secondArray=[NSMutableArray arrayWithArray:@[@"",@"1",@"4",@"2",@"7"]];
        _firstSelect=@"F0000";
        _secondSelect=@"";
        
    }else if ([_type isEqualToString:@"PayMengtWaitPay"]||[_type isEqualToString:@"PayMengtHasPay"]){
        
        _firstArray=[NSMutableArray array];
        for (NSString *flowKey in self.userdatas.arr_XBOpenFlowcode) {
            NSDictionary *infoDict = self.userdatas.dict_XBAllFlowInfo[flowKey];
            NSString *flowCode = infoDict[@"flowCode"];
            if ([flowCode isEqualToString:@"F0001"]||[flowCode isEqualToString:@"F0002"]||[flowCode isEqualToString:@"F0003"]||[flowCode isEqualToString:@"F0006"]||[flowCode isEqualToString:@"F0009"]||[flowCode isEqualToString:@"F0010"]) {
                [_firstArray addObject:flowKey];
            }
        }
        [_firstArray insertObject:@"F0000" atIndex:0];
        _firstSelect=@"F0000";
        
    }else if ([_type isEqualToString:@"WorkWaitApprove"]){
        _firstArray=[NSMutableArray arrayWithArray:self.userdatas.arr_XBOpenFlowcode];
        [_firstArray insertObject:@"F0000" atIndex:0];
        _firstSelect=@"F0000";
        
    }else if ([_type isEqualToString:@"PayMengtPro"]){
        _firstArray=[NSMutableArray arrayWithArray:@[@"",@"4",@"0,1,2,11,12",@"3,5,6,7,8,9,10"]];
        _firstSelect=@"";
    }
    
    if ([_type isEqualToString:@"WorkHasSubmit"]) {
        _thirdArray = [NSMutableArray arrayWithArray:@[@"0",@"1",@"2"]];
        _thirdSelect=@"0";
    }
    _collectHeight=0;
    if (_firstArray.count>0) {
        _collectHeight=_collectHeight+32+(ceilf((float)(_firstArray.count)/3))*42;
    }
    if (_secondArray.count>0) {
        _collectHeight=_collectHeight+32+(ceilf((float)(_secondArray.count)/3))*42;
    }
    if (_thirdArray.count > 0) {
        _collectHeight=_collectHeight+32+(ceilf((float)(_thirdArray.count)/3))*42;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

