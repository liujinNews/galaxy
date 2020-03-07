//
//  ZFProjectMangViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/7/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "ZFProjectMangViewController.h"

@interface ZFProjectMangViewController ()<UITextFieldDelegate,UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;

@property (nonatomic, copy) NSString *str_LastCode;
@property (nonatomic, strong) UITextField *txf_no;
@property (nonatomic, strong) UITextField *txf_name;
@property (nonatomic, strong) UITextField *txf_nameEn;
@property (nonatomic, strong) UITextField *txf_type;
@property (nonatomic, strong) UITextField *txf_manger;
@property (nonatomic, strong) UITextField *txf_member;
@property (nonatomic, copy) NSString *str_memberId;
@property (nonatomic, strong) UITextField *txf_startTime;
@property (nonatomic, strong) UITextField *txf_endTime;
@property (nonatomic, strong) UITextField *txf_Funder;
@property (nonatomic, strong) UITextField *txf_CostCenter;
@property (nonatomic, strong) UITextView *txv_desc;

@end

@implementation ZFProjectMangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=Color_White_Same_20;
    if (_model) {
        [self setTitle:Custing(@"修改项目", nil) backButton:YES];
    }else{
        [self setTitle:Custing(@"新增项目", nil) backButton:YES];
    }
    [self createView];
}

-(void)createView{
    [self createMainView];
    [self checkInDate];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(projectSave:)];
}

-(void)projectSave:(UIButton *)btn{
    [self keyClose];
    if (self.codeIsSystem == 1 && self.txf_no.text.length <= 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入项目编号", nil)];
        return;
    }
    if (self.txf_name.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入项目名称", nil)];
        return;
    }
    if (self.txf_name.text.length >200) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"项目名称不超过200位", nil)];
        return;
    }
    if ([NSString isEqualToNull:self.txf_startTime.text]&&[NSString isEqualToNull:self.txf_endTime.text]) {
        NSDate *date1 =[GPUtils TimeStringTranFromData:self.txf_endTime.text WithTimeFormart:@"yyyy/MM/dd"];
        NSDate *date2 =[GPUtils TimeStringTranFromData:self.txf_startTime.text WithTimeFormart:@"yyyy/MM/dd"];
        if ([date2 timeIntervalSinceDate:date1]>=0.0){
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"开始时间不能大于等于结束时间", nil)];
            return;
        }
    }
    [self requestAddProjestName];
}
-(void)createMainView{
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
        make.bottom.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    
    __weak typeof(self) weakSelf = self;
    UIView *NoView=[[UIView alloc]init];
    NoView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:NoView];
    [NoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_no=[[UITextField alloc]init];
    [NoView addSubview:[[SubmitFormView alloc]initBaseView:NoView WithContent:_txf_no WithFormType: self.codeIsSystem == 0 ? formViewShowText:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"编号", nil) WithInfodict:nil WithTips:nil WithNumLimit:200]];
    if (self.codeIsSystem == 0) {
        _txf_no.text = Custing(@"系统自动生成", nil);
        if (!self.model) {
            [NoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
    }
    
    UIView *NameView=[[UIView alloc]init];
    NameView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:NameView];
    [NameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NoView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_name=[[UITextField alloc]init];
    [NameView addSubview:[[SubmitFormView alloc]initBaseView:NameView WithContent:_txf_name WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"名称", nil) WithInfodict:nil WithTips:Custing(@"请输入名称", nil) WithNumLimit:200]];
    
    UIView *NameEnView = [[UIView alloc]init];
    NameEnView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:NameEnView];
    [NameEnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NameView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_nameEn = [[UITextField alloc]init];
    [NameEnView addSubview:[[SubmitFormView alloc]initBaseView:NameEnView WithContent:_txf_nameEn WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"英文名称", nil) WithInfodict:nil WithTips:Custing(@"请输入英文名称", nil) WithNumLimit:200]];

    
    UIView *TypeView=[[UIView alloc]init];
    TypeView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:TypeView];
    [TypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NameEnView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:TypeView WithContent:_txf_type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"项目类型", nil) WithTips:Custing(@"请选择项目类型", nil) WithInfodict:nil];
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf onClickType];
    }];
    [TypeView addSubview:view];
    
    
    UIView *MangerView = [[UIView alloc]init];
    MangerView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:MangerView];
    [MangerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TypeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_manger=[[UITextField alloc]init];
    SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:MangerView WithContent:_txf_manger WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"负责人", nil) WithTips:Custing(@"请选择负责人", nil) WithInfodict:nil];
    [view1 setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf onClickManger];
    }];
    [MangerView addSubview:view1];

    
    UIView *MemberView = [[UIView alloc]init];
    MemberView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:MemberView];
    [MemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MangerView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_member=[[UITextField alloc]init];
    SubmitFormView *view2 = [[SubmitFormView alloc]initBaseView:MemberView WithContent:_txf_member WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"成员", nil) WithTips:Custing(@"请选择成员", nil) WithInfodict:nil];
    [view2 setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf clickMember];
    }];
    [MemberView addSubview:view2];
    
    
    UIView *StartTimeView = [[UIView alloc]init];
    StartTimeView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:StartTimeView];
    [StartTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MemberView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_startTime=[[UITextField alloc]init];
    SubmitFormView *view3 = [[SubmitFormView alloc]initBaseView:StartTimeView WithContent:_txf_startTime WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine WithString:Custing(@"开始时间", nil) WithTips:Custing(@"请选择开始时间", nil) WithInfodict:nil];
    [StartTimeView addSubview:view3];

    
    UIView *EndTimeView = [[UIView alloc]init];
    EndTimeView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:EndTimeView];
    [EndTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(StartTimeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_endTime=[[UITextField alloc]init];
    SubmitFormView *view4 = [[SubmitFormView alloc]initBaseView:EndTimeView WithContent:_txf_endTime WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine WithString:Custing(@"结束时间", nil) WithTips:Custing(@"请选择结束时间", nil) WithInfodict:nil];
    [EndTimeView addSubview:view4];
    
    
    UIView *FunderView = [[UIView alloc]init];
    FunderView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:FunderView];
    [FunderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(EndTimeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_Funder=[[UITextField alloc]init];
    [FunderView addSubview:[[SubmitFormView alloc]initBaseView:FunderView WithContent:_txf_Funder WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"资助方", nil) WithInfodict:nil WithTips:Custing(@"请输入资助方", nil) WithNumLimit:200]];

    
    UIView *CostCenterView = [[UIView alloc]init];
    CostCenterView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:CostCenterView];
    [CostCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FunderView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_CostCenter = [[UITextField alloc]init];
    SubmitFormView *view5 = [[SubmitFormView alloc]initBaseView:CostCenterView WithContent:_txf_CostCenter WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"成本中心", nil) WithTips:Custing(@"请选择成本中心", nil) WithInfodict:nil];
    [view5 setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"costCenter"];
        vc.ChooseCategoryId = self.model.costCenterId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model.costCenterId = model.Id;
            weakSelf.model.costCenter = model.costCenter;
            weakSelf.txf_CostCenter.text = model.costCenter;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [CostCenterView addSubview:view5];

    
    UIView *DescView=[[UIView alloc]init];
    DescView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:DescView];
    [DescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CostCenterView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txv_desc=[[UITextView alloc]init];
    [DescView addSubview:[[SubmitFormView alloc]initBaseView:DescView WithContent:_txv_desc WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine WithString:Custing(@"描述", nil) WithInfodict:_model ? @{@"value1":_model.Description}:nil WithTips:Custing(@"请输入描述", nil) WithNumLimit:200]];
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(DescView.bottom);
    }];
}

-(void)checkInDate{
    if (_model) {
        if (self.codeIsSystem == 1) {
            self.txf_no.text = _model.no;
        }
        self.txf_name.text = _model.projName;
        self.txf_nameEn.text = _model.projNameEn;
        self.txf_type.text = _model.projTyp;
        self.txf_manger.text = _model.projMgr;
        self.txf_member.text = _model.memberName;
        self.txf_startTime.text = _model.startTime;
        self.txf_endTime.text = _model.endTime;
        self.txf_CostCenter.text = _model.costCenter;
        self.txf_Funder.text = _model.funder;
    }else{
        _model = [[projectManagerModel alloc]init];
    }
}

- (void)onClickType{
    ChooseTypeController *vc=[[ChooseTypeController alloc]initWithType:@"projectChooseType"];
    vc.ChooseCategoryId=_model.projTypId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseCateBlock = ^(ChooseCateFreModel *model, NSString *type) {
        weakSelf.txf_type.text =model.projTyp;
        weakSelf.model.projTypId=model.Id;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onClickManger{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"6";
    contactVC.Radio = @"1";
    contactVC.menutype = 1;
    contactVC.itemType = 99;
    contactVC.universalDelegate = self;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        if (array.count>0) {
            buildCellInfo *people = array[0];
            self.txf_manger.text = people.requestor;
            weakSelf.model.projMgrUserId = [NSString stringWithFormat:@"%ld",(long)people.requestorUserId];
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

-(void)clickMember{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"3";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.model.memberId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.arrClickPeople =array;
    contactVC.menutype=2;
    contactVC.itemType = 99;
    contactVC.Radio = @"2";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        NSMutableArray *nameArr=[NSMutableArray array];
        NSMutableArray *idArr=[NSMutableArray array];
        if (array.count>0) {
            for (buildCellInfo *bul in array) {
                if ([NSString isEqualToNull:bul.requestor]) {
                    [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                }
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]]) {
                    [idArr addObject:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]];
                }
            }
        }
        weakSelf.model.memberId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.txf_member.text=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}


-(void)requestAddProjestName{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"ProjName":self.txf_name.text,
                                                                                @"ProjNameEn":self.txf_nameEn.text,
                                                                                @"ProjTyp":_txf_type.text,
                                                                                @"ProjTypId":[NSString isEqualToNull:_model.projTypId]?_model.projTypId:@"0",
                                                                                @"ProjMgr":self.txf_manger.text,
                                                                                @"ProjMgrUserId":[NSString isEqualToNull:_model.projMgrUserId]?_model.projMgrUserId:@"0",
                                                                                @"MemberId":[NSString stringIsExist:self.model.memberId],
                                                                                @"MemberName":self.txf_member.text,
                                                                                @"StartTime": [NSString isEqualToNull:self.txf_startTime.text]? self.txf_startTime.text:(id)[NSNull null],
                                                                                @"EndTime":[NSString isEqualToNull:self.txf_endTime.text]? self.txf_endTime.text:(id)[NSNull null],
                                                                                @"Funder":self.txf_Funder.text,
                                                                                @"CostCenterId":[NSString isEqualToNull:_model.costCenterId]?_model.costCenterId:@"0",
                                                                                @"Description":self.txv_desc.text
                                 }];
    if (self.codeIsSystem == 1) {
        [dict setObject:self.txf_no.text forKey:@"no"];
    }else{
        if (self.model) {
            [dict setObject:[NSString stringWithIdOnNO:self.model.funder] forKey:@"no"];
        }
    }
    if ([NSString isEqualToNull:self.model.idd]) {
        [dict setObject:self.model.companyId forKey:@"CompanyId"];
        [dict setObject:self.model.idd forKey:@"id"];
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",updateproj] Parameters:dict Delegate:self SerialNum:1 IfUserCache:NO];
    }else{
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",insertproj] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
//MARK:获取最近一条code
-(void)getLastCode{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETLASTCODE];
    NSDictionary *parameters = @{@"Table":@"Sa_Project"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"项目添加成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"项目修改成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        case 2:
        {
            self.str_LastCode=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
            [self createView];
        }
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
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
