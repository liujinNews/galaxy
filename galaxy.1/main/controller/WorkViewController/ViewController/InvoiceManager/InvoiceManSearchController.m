//
//  InvoiceManSearchController.m
//  galaxy
//
//  Created by hfk on 2017/11/17.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "InvoiceManSearchController.h"
#import "STOnePickView.h"
@interface InvoiceManSearchController ()<UIScrollViewDelegate,GPClientDelegate>
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView * dockView;

/**
 *  开始日期
 */
@property (nonatomic, strong) UITextField *txf_StartDate;
/**
 *  结束日期
 */
@property (nonatomic, strong) UITextField *txf_EndDate;
/**
 *  发票类型
 */
@property (nonatomic, strong) UITextField *txf_InvoiceType;
/**
 发票类型Code
 */
@property (nonatomic, strong) NSString *str_InvoiceTypeCode;
/**
 发票类型数组
 */
@property (nonatomic, strong) NSMutableArray *arr_InvoiceType;
/**
 *  发票状态
 */
@property (nonatomic, strong) UITextField *txf_InvoiceStatus;
/**
 发票状态Code
 */
@property (nonatomic, strong) NSString *str_InvoiceStatus;
/**
 发票状态数组
 */
@property (nonatomic, strong) NSMutableArray *arr_InvoiceStatus;
/**
 *  费用类别txf
 */
@property (nonatomic,strong)UITextField * txf_Cate;
/**
 *  费用类别图片
 */
@property(nonatomic,strong)UIImageView * categoryImage;
/**
 *  费用类别
 */
@property(nonatomic,strong)NSMutableArray * categoryArr;
/**
 费用类别相关数据
 */
@property(nonatomic,copy)NSString *ExpenseCode;
@property(nonatomic,copy)NSString *ExpenseType;
@property(nonatomic,copy)NSString *ExpenseIcon;
@property(nonatomic,copy)NSString *ExpenseCatCode;
@property(nonatomic,copy)NSString *ExpenseCat;
/**
 *  发票代码
 */
@property (nonatomic, strong) UITextField *txf_invoiceCode;
/**
 *  发票号码
 */
@property (nonatomic, strong) UITextField *txf_invoiceNumber;
/**
 *  开票方
 */
@property (nonatomic, strong) UITextField *txf_invoiceKai;
/**
 *  收票方
 */
@property (nonatomic, strong) UITextField *txf_invoiceShou;
/**
 发票来源
 */
@property (nonatomic, strong) UITextField *txf_source;
@property (nonatomic, strong) NSString *str_source;
@property (nonatomic, strong) NSMutableArray *arr_Source;

@end

@implementation InvoiceManSearchController
-(NSMutableArray *)arr_InvoiceType{
    if (!_arr_InvoiceType) {
        _arr_InvoiceType=[NSMutableArray array];
        NSArray *type=@[Custing(@"增值税普通发票", nil),Custing(@"增值税专用发票", nil),Custing(@"增值税电子普通发票", nil),Custing(@"其他", nil)];
        NSArray *code=@[@"1",@"2",@"3",@"4"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_InvoiceType addObject:model];
        }
    }
    return _arr_InvoiceType;
}
-(NSMutableArray *)arr_InvoiceStatus{
    if (!_arr_InvoiceStatus) {
        _arr_InvoiceStatus=[NSMutableArray array];
        NSArray *type=@[Custing(@"未报销", nil),Custing(@"审批中", nil),Custing(@"审批完成", nil),Custing(@"已支付", nil)];
        NSArray *code=@[@"1",@"2",@"3",@"4"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_InvoiceStatus addObject:model];
        }
    }
    return _arr_InvoiceStatus;
}

-(NSMutableArray *)arr_Source{
    if (!_arr_Source) {
        _arr_Source=[NSMutableArray array];
        NSArray *type=@[Custing(@"百望电子", nil),Custing(@"发票扫描", nil),Custing(@"微信卡包", nil),Custing(@"发票拍照", nil)];
        NSArray *code=@[@"12",@"15",@"16",@"18"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_Source addObject:model];
        }
    }
    return _arr_Source;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"发票查询", nil) backButton:YES];
    [self requestCate];
}
//MARK:获取费用类别
-(void)requestCate{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETCATEList];
    NSDictionary *parameters = @{@"Type":@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    
    switch (serialNum) {
        case 0:
        {
            [self dealWithCate];
            [self createMainView];
            [self updateMainView];
            
        }
            break;
        default:
            break;
    }
}


//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}

//MARK:处理费用类别
-(void)dealWithCate{
    _categoryArr=[NSMutableArray array];
    [CostCateNewModel getCostCateByDict:_resultDict array:_categoryArr withType:2];
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
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"查询", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf SearchClick];
        }
    };
}
-(void)updateMainView{
    __weak typeof(self) weakSelf = self;
    
    UIView *View_StartDate=[[UIView alloc]init];
    View_StartDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_StartDate];
    [View_StartDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_StartDate=[[UITextField alloc]init];
    [View_StartDate addSubview:[[SubmitFormView alloc]initBaseView:View_StartDate WithContent:_txf_StartDate WithFormType:formViewSelectDate WithSegmentType:lineViewNone WithString:Custing(@"开始日期", nil) WithTips:Custing(@"请选择开始日期", nil) WithInfodict:nil]];
    
    
    UIView *View_EndDate=[[UIView alloc]init];
    View_EndDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_EndDate];
    [View_EndDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_StartDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_EndDate=[[UITextField alloc]init];
    [View_EndDate addSubview:[[SubmitFormView alloc]initBaseView:View_EndDate WithContent:_txf_EndDate WithFormType:formViewSelectDate WithSegmentType:lineViewOnlyLine WithString:Custing(@"结束日期", nil) WithTips:Custing(@"请选择结束日期", nil) WithInfodict:nil]];
    
    
    UIView *View_InvoiceType=[[UIView alloc]init];
    View_InvoiceType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_InvoiceType];
    [View_InvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_EndDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_InvoiceType=[[UITextField alloc]init];
    SubmitFormView *viewType=[[SubmitFormView alloc]initBaseView:View_InvoiceType WithContent:_txf_InvoiceType WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"发票类型", nil) WithTips:Custing(@"请选择发票类型", nil) WithInfodict:nil];
    [viewType setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf InvoiceTypeClick];
    }];
    [View_InvoiceType addSubview:viewType];
    
    
    
    
    UIView *View_InvoiceStatus=[[UIView alloc]init];
    View_InvoiceStatus.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_InvoiceStatus];
    [View_InvoiceStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_InvoiceType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_InvoiceStatus=[[UITextField alloc]init];
    SubmitFormView *viewStatus=[[SubmitFormView alloc]initBaseView:View_InvoiceStatus WithContent:_txf_InvoiceStatus WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"发票状态", nil) WithTips:Custing(@"请选择发票状态", nil) WithInfodict:nil];
    [viewStatus setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf InvoiceStatusClick];
    }];
    [View_InvoiceStatus addSubview:viewStatus];
    
    
    
    UIView *View_Cate=[[UIView alloc]init];
    View_Cate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_Cate];
    [View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_InvoiceStatus.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_Cate=[[UITextField alloc]init];
    SubmitFormView *viewCate=[[SubmitFormView alloc]initBaseView:View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewOnlyLine WithString:Custing(@"费用类别", nil) WithTips:Custing(@"请选择费用类别", nil) WithInfodict:nil];
    [viewCate setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.categoryImage=image;
        [weakSelf CateBtnClick];
    }];
    [View_Cate addSubview:viewCate];
    
    
    
    UIView *View_invoiceCode=[[UIView alloc]init];
    View_invoiceCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_invoiceCode];
    [View_invoiceCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_Cate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_invoiceCode=[[UITextField alloc]init];
    [View_invoiceCode addSubview:[[SubmitFormView alloc]initBaseView:View_invoiceCode WithContent:_txf_invoiceCode WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"发票代码", nil) WithTips:Custing(@"请输入发票代码", nil) WithInfodict:nil]];
    
    
    
    UIView *View_invoiceNumber=[[UIView alloc]init];
    View_invoiceNumber.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_invoiceNumber];
    [View_invoiceNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_invoiceCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_invoiceNumber=[[UITextField alloc]init];
    [View_invoiceNumber addSubview:[[SubmitFormView alloc]initBaseView:View_invoiceNumber WithContent:_txf_invoiceNumber WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"发票号码", nil) WithTips:Custing(@"请输入发票号码", nil) WithInfodict:nil]];
    
    
    
    UIView *View_invoiceKai=[[UIView alloc]init];
    View_invoiceKai.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_invoiceKai];
    [View_invoiceKai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_invoiceNumber.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_invoiceKai=[[UITextField alloc]init];
    [View_invoiceKai addSubview:[[SubmitFormView alloc]initBaseView:View_invoiceKai WithContent:_txf_invoiceKai WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"开票方", nil) WithTips:Custing(@"请输入开票方", nil) WithInfodict:nil]];
    
    
    UIView *View_invoiceShou=[[UIView alloc]init];
    View_invoiceShou.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_invoiceShou];
    [View_invoiceShou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_invoiceKai.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_invoiceShou=[[UITextField alloc]init];
    [View_invoiceShou addSubview:[[SubmitFormView alloc]initBaseView:View_invoiceShou WithContent:_txf_invoiceShou WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"收票方", nil) WithTips:Custing(@"请输入收票方", nil) WithInfodict:nil]];
    
    UIView *View_Source=[[UIView alloc]init];
    View_Source.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_Source];
    [View_Source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_invoiceShou.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_source=[[UITextField alloc]init];
    SubmitFormView *viewSource=[[SubmitFormView alloc]initBaseView:View_Source WithContent:_txf_source WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"发票来源", nil) WithTips:Custing(@"请选择发票来源", nil) WithInfodict:nil];
    [viewSource setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf InvoiceSource];
    }];
    [View_Source addSubview:viewSource];
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(View_Source.bottom);
    }];
    
}
//MARK:发票类型
-(void)InvoiceTypeClick{
    [self keyClose];
    __weak typeof(self) weakSelf = self;
    STOnePickView *picker = [[STOnePickView alloc]init];
    picker.typeTitle=Custing(@"发票类型", nil);
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.str_InvoiceTypeCode=Model.Id;
        weakSelf.txf_InvoiceType.text=Model.Type;
    }];
    picker.DateSourceArray=[NSMutableArray arrayWithArray:self.arr_InvoiceType];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[NSString isEqualToNull:_str_InvoiceTypeCode]?_str_InvoiceTypeCode:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:发票状态
-(void)InvoiceStatusClick{
    [self keyClose];
    __weak typeof(self) weakSelf = self;
    STOnePickView *picker = [[STOnePickView alloc]init];
    picker.typeTitle=Custing(@"发票状态", nil);
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.str_InvoiceStatus=Model.Id;
        weakSelf.txf_InvoiceStatus.text=Model.Type;
    }];
    picker.DateSourceArray=[NSMutableArray arrayWithArray:self.arr_InvoiceStatus];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[NSString isEqualToNull: _str_InvoiceStatus]?_str_InvoiceStatus:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:费用类别
-(void)CateBtnClick{
    [self keyClose];
    STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
    pickerArea.typeTitle=Custing(@"费用类别", nil);
    pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:_categoryArr];
    CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
    model.expenseCode=_ExpenseCode;
    pickerArea.CateModel=model;
    [pickerArea UpdatePickUI];
    [pickerArea setContentMode:STPickerContentModeBottom];
    __weak typeof(self) weakSelf = self;
    [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
        if (![secondModel.expenseCode isEqualToString:weakSelf.ExpenseCode]) {
            weakSelf.categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
            weakSelf.ExpenseType=[NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
            weakSelf.ExpenseCode=secondModel.expenseCode;
            weakSelf.ExpenseIcon=secondModel.expenseIcon;
            weakSelf.ExpenseCat=secondModel.expenseCat;
            weakSelf.ExpenseCatCode=secondModel.expenseCatCode;
            weakSelf.txf_Cate.text=[GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
        }
    }];
    [pickerArea show];
}
-(void)InvoiceSource{
    __weak typeof(self) weakSelf = self;
    STOnePickView *picker = [[STOnePickView alloc]init];
    picker.typeTitle=Custing(@"发票来源", nil);
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.str_source = Model.Id;
        weakSelf.txf_source.text = Model.Type;
    }];
    picker.DateSourceArray=[NSMutableArray arrayWithArray:self.arr_Source];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[NSString isEqualToNull: _str_source]?_str_source:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:查询
-(void)SearchClick{
    if ([NSString isEqualToNull:_txf_StartDate.text]&&[NSString isEqualToNull:_txf_EndDate.text]) {
        NSDate *date1 = [GPUtils convertLeaveDateFromStrings:_txf_StartDate.text];
        NSDate *date2 = [GPUtils convertLeaveDateFromStrings:_txf_EndDate.text];
        if ([date2 timeIntervalSinceDate:date1]<0.0){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"结束日期必须大于开始日期", nil) duration:2.0];
            return;
        }
    }
    NSDictionary *dict=@{ @"StartTime":[NSString isEqualToNull:_txf_StartDate.text]?_txf_StartDate.text:@"",
                        @"EndTime":[NSString isEqualToNull:_txf_EndDate.text]?_txf_EndDate.text:@"",
                        @"InvoiceCode":[NSString isEqualToNull:_txf_invoiceCode.text]?_txf_invoiceCode.text:@"",
                        @"InvoiceNumber":[NSString isEqualToNull:_txf_invoiceNumber.text]?_txf_invoiceNumber.text:@"",
                        @"PurchaserName":[NSString isEqualToNull:_txf_invoiceShou.text]?_txf_invoiceShou.text:@"",
                        @"SalesName":[NSString isEqualToNull:_txf_invoiceKai.text]?_txf_invoiceKai.text:@"",
                        @"InvoiceType":[NSString isEqualToNull:_str_InvoiceTypeCode]?_str_InvoiceTypeCode:@"0",
                        @"Status":[NSString isEqualToNull:_str_InvoiceStatus]?_str_InvoiceStatus:@"0",
                        @"ExpenseCode":[NSString isEqualToNull:_ExpenseCode]?_ExpenseCode:@"",
                        @"Source":[NSString isEqualToNull:_str_source]?_str_source:@""
                         };
    if (self.SearchClickedBlock) {
        self.SearchClickedBlock(dict);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
