//
//  AccruedReqDetailNewController.m
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "AccruedReqDetailNewController.h"

@interface AccruedReqDetailNewController ()

/**
 是否数组
 */
@property (nonatomic, strong) NSMutableArray *arr_IsOrNot;

//预提明细信息
@property (nonatomic, copy) NSString *str_accuredInfo;
@property (nonatomic, copy) NSString *str_taskId;
@property (nonatomic, copy) NSString *str_accruedTypeId;
@property (nonatomic, copy) NSString *str_accruedType;
@property (nonatomic, copy) NSString *str_accruedGridOrder;
@property (nonatomic, copy) NSString *str_accruedName;


@property (nonatomic, copy) NSString *str_AccruedStatus;// 出差申请单请求参数(0审批完成 1审批中审批完成)
@property (nonatomic, strong) NSMutableArray *accruedArr;//关联预提明细数组

@end

@implementation AccruedReqDetailNewController
- (NSMutableArray *)accruedArr{
    if (!_accruedArr) {
        _accruedArr = [NSMutableArray array];
    }
    return _accruedArr;
}
-(NSMutableArray *)arr_IsOrNot{
    if (_arr_IsOrNot == nil) {
        _arr_IsOrNot = [NSMutableArray array];
        NSArray *type = @[Custing(@"是", nil),Custing(@"否", nil)];
        NSArray *code = @[@"1",@"0"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_IsOrNot addObject:model];
        }
    }
    return _arr_IsOrNot;
}
//类型
-(NSMutableArray *)arr_CostType{
    if (_arr_CostType == nil) {
        _arr_CostType = [NSMutableArray array];
        NSArray *type = @[Custing(@"资本性支出", nil),Custing(@"费用", nil)];
        NSArray *code = @[@"0",@"1"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_CostType addObject:model];
        }
    }
    return _arr_CostType;
}
//预提类型
-(NSMutableArray *)arr_AccruedType{
    if (_arr_AccruedType == nil) {
        _arr_AccruedType = [NSMutableArray array];
        NSArray *type = @[Custing(@"新增", nil),Custing(@"修改", nil)];
        NSArray *code = @[@"0",@"1"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_AccruedType addObject:model];
        }
    }
    return _arr_AccruedType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"预提明细", nil) backButton:YES];
//    [self initData];
    _isOpenGener = NO;
    [self requestChooseCostCategry];
}
//-(void)initData{
//    if (!self.AccruedReqDetail) {
//        self.AccruedReqDetail = [[AccruedReqDetail alloc]init];
//    }
//    if (![NSString isEqualToNull:self.AccruedReqDetail.CurrencyCode]) {
//        self.AccruedReqDetail.CurrencyCode = self.dict_CurrencyCode[@"CurrencyCode"];
//        self.AccruedReqDetail.ExchangeRate = self.dict_CurrencyCode[@"ExchangeRate"];
//        self.AccruedReqDetail.Currency = self.dict_CurrencyCode[@"Currency"];
//    }
//    self.arr_imagesArray = [NSMutableArray array];
//    self.arr_totalFileArray = [NSMutableArray array];
//    if ([NSString isEqualToNull:self.AccruedReqDetail.Attachments]) {
//        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",self.AccruedReqDetail.Attachments]];
//        for (NSDictionary *dict in array) {
//            [self.arr_totalFileArray addObject:dict];
//        }
//        [GPUtils updateImageDataWithTotalArray:self.arr_totalFileArray WithImageArray:self.arr_imagesArray WithMaxCount:5];
//    }
//}
//MARK:再次获取类别选择中的类别
-(void)requestChooseCostCategry{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters=@{@"Type":@"4"};
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    switch (serialNum) {
        case 0:
            [self dealWithType];
            [self createScrollView];
            [self createMainView];
            [self updateMainView];
            break;
        default:
            break;
    }
    
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:费用类型数据处理
-(void)dealWithType{
    _categoryArr=[NSMutableArray array];
    NSDictionary *parDict= [CostCateNewModel getCostCateByDict:_resultDict array:_categoryArr withType:1];
    _CateLevel=parDict[@"CateLevel"];
    _categoryRows=[parDict[@"categoryRows"]integerValue];
}

//MARK:创建scrollView
-(void)createScrollView{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
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
    
    self.dockView = [[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled = YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf saveData];
        }
    };
}

//MARK:创建主视图
-(void)createMainView{
    //归属月份
    _View_AccruedMonth = [[UIView alloc]init];
    _View_AccruedMonth.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccruedMonth];
    [_View_AccruedMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_ExpenseDate = [[UIView alloc]init];
    _View_ExpenseDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpenseDate];
    [_View_ExpenseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccruedMonth.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceNo = [[UIView alloc]init];
    _View_InvoiceNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceNo];
    [_View_InvoiceNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExpenseDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Cate = [[UIView alloc]init];
    _View_Cate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceNo.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CategoryView = [[UIView alloc]init];
    _CategoryView.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_CategoryView];
    [_CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CategoryLayOut = [[UICollectionViewFlowLayout alloc] init];
    _CategoryLayOut.minimumInteritemSpacing = 1;
    _CategoryLayOut.minimumLineSpacing = 1;
    _CategoryCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_CategoryLayOut];
    _CategoryCollectView.delegate = self;
    _CategoryCollectView.dataSource = self;
    _CategoryCollectView.backgroundColor = Color_White_Same_20;
    _CategoryCollectView.scrollEnabled = NO;
    [_CategoryCollectView registerClass:[CategoryCollectCell class] forCellWithReuseIdentifier:@"CategoryCollectCell"];
    [_CategoryView addSubview:_CategoryCollectView];
    [_CategoryCollectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView);
        make.left.right.equalTo(self.contentView);
    }];
    //供应商
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //预提类型
    _View_AccruedType = [[UIView alloc]init];
    _View_AccruedType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccruedType];
    [_View_AccruedType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Amount = [[UIView alloc]init];
    _View_Amount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Amount];
    [_View_Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccruedType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Amount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExchangeRate = [[UIView alloc]init];
    _View_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExchangeRate];
    [_View_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LocalCyAmount = [[UIView alloc]init];
    _View_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LocalCyAmount];
    [_View_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvCyPmtExchangeRate = [[UIView alloc]init];
    _View_InvCyPmtExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvCyPmtExchangeRate];
    [_View_InvCyPmtExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvPmtAmount = [[UIView alloc]init];
    _View_InvPmtAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvPmtAmount];
    [_View_InvPmtAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvCyPmtExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //是否专票
    _View_IsVAT = [[UIView alloc]init];
    _View_IsVAT.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsVAT];
    [_View_IsVAT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceType = [[UIView alloc]init];
    _View_InvoiceType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceType];
    [_View_InvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsVAT.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AirTicketPrice = [[UIView alloc]init];
    _View_AirTicketPrice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AirTicketPrice];
    [_View_AirTicketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DevelopmentFund = [[UIView alloc]init];
    _View_DevelopmentFund.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_DevelopmentFund];
    [_View_DevelopmentFund mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AirTicketPrice.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FuelSurcharge = [[UIView alloc]init];
    _View_FuelSurcharge.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FuelSurcharge];
    [_View_FuelSurcharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DevelopmentFund.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OtherTaxes = [[UIView alloc]init];
    _View_OtherTaxes.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OtherTaxes];
    [_View_OtherTaxes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FuelSurcharge.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AirlineFuelFee = [[UIView alloc]init];
    _View_AirlineFuelFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AirlineFuelFee];
    [_View_AirlineFuelFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherTaxes.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TaxRate = [[UIView alloc]init];
    _View_TaxRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TaxRate];
    [_View_TaxRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AirlineFuelFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Tax = [[UIView alloc]init];
    _View_Tax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Tax];
    [_View_Tax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TaxRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExclTax = [[UIView alloc]init];
    _View_ExclTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExclTax];
    [_View_ExclTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Tax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvPmtTax = [[UIView alloc]init];
    _View_InvPmtTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvPmtTax];
    [_View_InvPmtTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExclTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvPmtAmountExclTax = [[UIView alloc]init];
    _View_InvPmtAmountExclTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvPmtAmountExclTax];
    [_View_InvPmtAmountExclTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContName = [[UIView alloc]init];
    _View_ContName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContName];
    [_View_ContName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmountExclTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //是否材料支持
    _View_IsSupportMaterials = [[UIView alloc]init];
    _View_IsSupportMaterials.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsSupportMaterials];
    [_View_IsSupportMaterials mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    // 类型
    _View_CostType = [[UIView alloc]init];
    _View_CostType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CostType];
    [_View_CostType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsSupportMaterials.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //是否已入库
    _View_IsStorage = [[UIView alloc]init];
    _View_IsStorage.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsStorage];
    [_View_IsStorage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CostType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
     //是否预付
    _View_IsPrepay = [[UIView alloc]init];
    _View_IsPrepay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsPrepay];
    [_View_IsPrepay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsStorage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //预付开始时间
    _View_PrepayStartDate = [[UIView alloc]init];
    _View_PrepayStartDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PrepayStartDate];
    [_View_PrepayStartDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsPrepay.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //预付结束时间
    _View_PrepayEndDate = [[UIView alloc]init];
    _View_PrepayEndDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PrepayEndDate];
    [_View_PrepayEndDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PrepayStartDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //是否预提
    _View_IsAccruedaccount = [[UIView alloc]init];
    _View_IsAccruedaccount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsAccruedaccount];
    [_View_IsAccruedaccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PrepayEndDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //预提明细列表视图
    _View_AccruedForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0001"];
    _View_AccruedForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccruedForm];
    [_View_AccruedForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsAccruedaccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //是否政府相关
    _View_Government = [[UIView alloc]init];
    _View_Government.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Government];
    [_View_Government mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccruedForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Overseas = [[UIView alloc]init];
    _View_Overseas.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Overseas];
    [_View_Overseas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Government.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Nationality = [[UIView alloc]init];
    _View_Nationality.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Nationality];
    [_View_Nationality mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Overseas.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TransactionCode = [[UIView alloc]init];
    _View_TransactionCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TransactionCode];
    [_View_TransactionCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Nationality.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_HandmadePaper = [[UIView alloc]init];
    _View_HandmadePaper.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_HandmadePaper];
    [_View_HandmadePaper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TransactionCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //成本中心
    _View_CostCenter = [[UIView alloc]init];
    _View_CostCenter.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CostCenter];
    [_View_CostCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HandmadePaper.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //关联费用申请单
    _View_FeeAppNumber=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0012"];
    _View_FeeAppNumber.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FeeAppNumber];
    [_View_FeeAppNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CostCenter.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //是否已结项
    _View_IsSettlement = [[UIView alloc]init];
    _View_IsSettlement.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsSettlement];
    [_View_IsSettlement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FeeAppNumber.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //辅助核算项
    _View_AccountItem = [[UIView alloc]init];
    _View_AccountItem.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccountItem];
    [_View_AccountItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsSettlement.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _View_AccountItemAmount = [[UIView alloc]init];
    _View_AccountItemAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccountItemAmount];
    [_View_AccountItemAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItem.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //辅助核算项2
    _View_AccountItem2 = [[UIView alloc]init];
    _View_AccountItem2.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccountItem2];
    [_View_AccountItem2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItemAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _View_AccountItemAmount2 = [[UIView alloc]init];
    _View_AccountItemAmount2.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccountItemAmount2];
    [_View_AccountItemAmount2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItem2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //辅助核算项3
    _View_AccountItem3 = [[UIView alloc]init];
    _View_AccountItem3.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccountItem3];
    [_View_AccountItem3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItemAmount2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _View_AccountItemAmount3 = [[UIView alloc]init];
    _View_AccountItemAmount3.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccountItemAmount3];
    [_View_AccountItemAmount3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItem3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _View_ExpenseDesc = [[UIView alloc]init];
    _View_ExpenseDesc.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpenseDesc];
    [_View_ExpenseDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItemAmount3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExpenseDesc.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}

-(void)updateMainView{
    for (MyProcurementModel *model in self.arr_show) {
    
        if (self.type == 4) {
            model.isOnlyRead = @"1";
            if ([model.fieldName isEqualToString:@"Amount"]
                || [model.fieldName isEqualToString:@"ExchangeRate"]
                || [model.fieldName isEqualToString:@"TaxRate"]
                || [model.fieldName isEqualToString:@"Tax"]
                || [model.fieldName isEqualToString:@"InvCyPmtExchangeRate"]
                || (([model.fieldName isEqualToString:@"ExpenseCode"] || [model.fieldName isEqualToString:@"InvoiceType"]) && self.FormDatas.bool_IsAllowModCostCgyOrInvAmt)){
                model.isOnlyRead = @"0";
            }
        }
        if ([model.fieldName isEqualToString:@"AccruedMonth"]){//归属月份
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccruedMonthViewWithModel:model];
            }
        }
//        else if ([model.fieldName isEqualToString:@"ExpenseDate"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [self updateExpenseDateViewWithModel:model];
//            }
//        }else if ([model.fieldName isEqualToString:@"InvoiceNo"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [self updateInvoiceNoViewWithModel:model];
//            }
//        }
        else if ([model.fieldName isEqualToString:@"ExpenseCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateCateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierId"]){//供应商
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateSupplierViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccruedType"]){//预提类型
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccruedTypeViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccruedName"]){//预提明细
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateSa_Sa_AccruedReqDetailRelevanceAccruedExpDetailViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Amount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAmountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateCurrencyCodeView:model];
            }
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateExchangeRateView:model];
            }
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateLocalCyAmountView:model];
            }
        }else if ([model.fieldName isEqualToString:@"InvCyPmtExchangeRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvCyPmtExchangeRateView:model];
            }
        }
//        else if ([model.fieldName isEqualToString:@"InvPmtAmount"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [self updateInvPmtAmountView:model];
//            }
//        }
        else if ([model.fieldName isEqualToString:@"IsVAT"]){//是否专票
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsVATViewWithModel:model];
            }
        }
//        else if ([model.fieldName isEqualToString:@"InvoiceType"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [self updateInvoiceTypeViewWithModel:model];
//            }
//        }
        else if ([model.fieldName isEqualToString:@"TaxRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTaxRateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Tax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTaxViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ExclTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateExclTaxViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"InvPmtTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvPmtTaxViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"InvPmtAmountExclTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvPmtAmountExclTaxViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ContractName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateContractNameViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateProjectViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsSupportMaterials"]){//是否材料支持
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsSupportMaterialsViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"CostCenterId"]){//成本中心
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateCostCenterViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"FeeAppNumber"]){//关联费用申请单
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateFeeAppNumberViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccountItem"]){//辅助核算项
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccountItemViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccountItemAmount"]){//辅助核算金额
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccountItemAmountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccountItem2"]){//辅助核算项2
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccountItem2ViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccountItemAmount2"]){//辅助核算金额2
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccountItemAmount2ViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccountItem3"]){//辅助核算项3
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccountItem3ViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccountItemAmount3"]){//辅助核算金额3
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccountItemAmount3ViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateExpenseDescViewWithModel:model];
            }
        }
//        else if ([model.fieldName isEqualToString:@"Remark"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
//                [self updateRemarkViewWithModel:model];
//            }
//        }
        else if ([model.fieldName isEqualToString:@"Attachments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAttachImgViewWithModel:model];
            }
        }
    }
    //是否境外视图相关更新
    [self updateOverseasSubViews];
    //更新机票和燃油附加费合计
    [self updateAirlineFuelFeeView];
    
    [self updateTaxRelectViewWithType:1];
    
    [self updateContentView];
}
//MARK:更新归属月份
-(void)updateAccruedMonthViewWithModel:(MyProcurementModel *)model{
    _txf_AccruedMonth = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccruedMonth WithContent:_txf_AccruedMonth WithFormType:formViewSelectMonthDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.AccruedMonth}];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.AccruedReqDetail.AccruedMonth = selectTime;
//        [weakSelf updateTaxRelectViewWithType:2];
    }];
    [_View_AccruedMonth addSubview:view];
}
//MARK:更新日期
//-(void)updateExpenseDateViewWithModel:(MyProcurementModel *)model{
//    _txf_ExpenseDate = [[UITextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExpenseDate WithContent:_txf_ExpenseDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.ExpenseDate}];
//    __weak typeof(self) weakSelf = self;
//    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
//        weakSelf.AccruedReqDetail.ExpenseDate = selectTime;
//        [weakSelf updateTaxRelectViewWithType:2];
//    }];
//    [_View_ExpenseDate addSubview:view];
//}
//MARK:更新发票号码
//-(void)updateInvoiceNoViewWithModel:(MyProcurementModel *)model{
//    _txf_InvoiceNo = [[UITextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceNo WithContent:_txf_InvoiceNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.InvoiceNo}];
//    [_View_InvoiceNo addSubview:view];
//}
//MARK:更新费用类别
-(void)updateCateViewWithModel:(MyProcurementModel *)model{
    _txf_Cate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.AccruedReqDetail.ExpenseCat,self.AccruedReqDetail.ExpenseType]]}];
    __weak typeof(self) weakSelf = self;
    [view setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.categoryImage=image;
        [weakSelf CateBtnClick:nil];
    }];
    [_View_Cate addSubview:view];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.AccruedReqDetail.ExpenseCode]]&&![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.ExpenseCode] isEqualToString:@"0"]) {
        [view setCateImg:self.AccruedReqDetail.ExpenseIcon];
    }
}
//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.SupplierName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SupplierClick];
    }];
    [_View_Supplier addSubview:view];
}
//MARK:修改供应商
-(void)SupplierClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Supplier"];
    vc.ChooseCategoryId = self.AccruedReqDetail.SupplierId;
//    vc.dict_otherPars = @{@"DateType":self.AccruedReqDetail.str_SupplierParam};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.AccruedReqDetail.SupplierId = model.Id;
        weakSelf.AccruedReqDetail.SupplierName =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Supplier.text = weakSelf.AccruedReqDetail.SupplierName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:更新预提类型undone
-(void)updateAccruedTypeViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.AccruedType]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"修改", nil);
        self.AccruedReqDetail.AccruedType = @"1";
    }else{
        model.fieldValue = Custing(@"新增", nil);
        self.AccruedReqDetail.AccruedType = @"0";
    }
    _txf_AccruedType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_AccruedType WithContent:_txf_AccruedType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.AccruedType] isEqualToString:Model.Id]) {
                weakSelf.AccruedReqDetail.AccruedType = Model.Id;
                weakSelf.txf_AccruedType.text = Model.Type;
            }
        }];
        picker.typeTitle = Custing(@"预提类型", nil);
        picker.DateSourceArray = weakSelf.arr_AccruedType;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.AccruedReqDetail.AccruedType;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    };
    [_View_AccruedType addSubview:view];
}
//MARK:更新借款金额
-(void)updateAmountViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票金额", nil);
    }
    _txf_Amount = [[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Amount WithContent:_txf_Amount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.Amount}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        NSString *local = [GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.ExchangeRate]?weakSelf.AccruedReqDetail.ExchangeRate:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
        
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
//        NSString *payLoc = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.InvCyPmtExchangeRate]?weakSelf.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")] afterPoint:2];
//        NSString *airLoc1 = payLoc;
//        if ([[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
//            airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
//        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
        
//        weakSelf.txf_InvPmtAmount.text = [GPUtils transformNsNumber:payLoc];
//        weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
//        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];

    }];
    [_View_Amount addSubview:view];
}
//MARK:更新币种视图
-(void)updateCurrencyCodeView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票币种", nil);
    }
    _txf_CurrencyCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.Currency}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf changeCurrency];
    }];
    [_View_CurrencyCode addSubview:view];
}
//MARK:更新汇率视图
-(void)updateExchangeRateView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"付款汇率", nil);
    }
    _txf_ExchangeRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ExchangeRate WithContent:_txf_ExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.ExchangeRate}];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.AccruedReqDetail.ExchangeRate = exchange;
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];

        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
//        NSString *payLoc = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.InvCyPmtExchangeRate]?weakSelf.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")] afterPoint:2];
//        NSString *airLoc1 = payLoc;
//        if ([[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
//            airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
//        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
        
//        weakSelf.txf_InvPmtAmount.text = [GPUtils transformNsNumber:payLoc];
//        weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
//        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];

    }];
    [_View_ExchangeRate addSubview:view];
}
//MARK:更新本位币金额视图
-(void)updateLocalCyAmountView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"付款金额", nil);
    }
    _txf_LocalCyAmount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.LocalCyAmount}];
    [_View_LocalCyAmount addSubview:view];
}
//MARK:更新发票币种对支付币种汇率视图
-(void)updateInvCyPmtExchangeRateView:(MyProcurementModel *)model{
    _txf_InvCyPmtExchangeRate = [[UITextField alloc]init];
//    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvCyPmtExchangeRate WithContent:_txf_InvCyPmtExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.InvCyPmtExchangeRate}];
//    __weak typeof(self) weakSelf = self;
//    [view setExchangeChangedBlock:^(NSString *exchange){
//        weakSelf.AccruedReqDetail.InvCyPmtExchangeRate = exchange;
//        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")];
//        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
//        weakSelf.txf_InvPmtAmount.text = [GPUtils transformNsNumber:local];
//        weakSelf.txf_InvPmtTax.text = [NSString countTax:local taxrate:[NSString isEqualToNull:self.txf_TaxRate.text] ? self.txf_TaxRate.text:@"0"];
//        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_InvPmtTax.text]];
//    }];
//    [_View_InvCyPmtExchangeRate addSubview:view];
}
//MARK:更新付款金额视图
//-(void)updateInvPmtAmountView:(MyProcurementModel *)model{
//    _txf_InvPmtAmount = [[GkTextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvPmtAmount WithContent:_txf_InvPmtAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.InvPmtAmount}];
//    [_View_InvPmtAmount addSubview:view];
//}
//MARK:是否专票
-(void)updateIsVATViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.IsVAT]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
        self.AccruedReqDetail.IsVAT = @"1";
    }else{
        model.fieldValue = Custing(@"否", nil);
        self.AccruedReqDetail.IsVAT = @"0";
    }
    _txf_IsVAT = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_IsVAT WithContent:_txf_IsVAT WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.IsVAT] isEqualToString:Model.Id]) {
                weakSelf.AccruedReqDetail.IsVAT = Model.Id;
                weakSelf.txf_IsVAT.text = Model.Type;
            }
        }];
        picker.typeTitle = Custing(@"是否专票", nil);
        picker.DateSourceArray = weakSelf.arr_IsOrNot;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.AccruedReqDetail.IsVAT;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    };
    [_View_IsVAT addSubview:view];
}
//MARK:更新发票类型视图
//-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
//    _txf_InvoiceType=[[UITextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceType WithContent:_txf_InvoiceType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.InvoiceTypeName}];
//    __weak typeof(self) weakSelf = self;
//    [view setFormClickedBlock:^(MyProcurementModel *model){
//        STOnePickView *picker = [[STOnePickView alloc]init];
//        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
//            if (![[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode] isEqualToString:Model.Id]) {
//                weakSelf.AccruedReqDetail.InvoiceType = Model.invoiceType;
//                weakSelf.AccruedReqDetail.InvoiceTypeCode = Model.Id;
//                weakSelf.AccruedReqDetail.InvoiceTypeName = Model.Type;
//                weakSelf.txf_InvoiceType.text = Model.Type;
//                [weakSelf updateTaxRelectViewWithType:2];
//            }
//        }];
//        picker.typeTitle = Custing(@"发票类型", nil);
//        picker.DateSourceArray = weakSelf.arr_New_InvoiceTypes;
//        STOnePickModel *model1 = [[STOnePickModel alloc]init];
//        model1.Id = [NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode];
//        picker.Model = model1;
//        [picker UpdatePickUI];
//        [picker setContentMode:STPickerContentModeBottom];
//        [picker show];
//    }];
//    [_View_InvoiceType addSubview:view];
//}
//MARK:更新机票和燃油附加费合计视图
-(void)updateAirlineFuelFeeView{
    __weak typeof(self) weakSelf = self;

    NSString *isOnlyRead = @"0";
    if (self.type == 4 && !self.FormDatas.bool_IsAllowModCostCgyOrInvAmt) {
        isOnlyRead = @"1";
    }
    
    _txf_AirlineFuelFee = [[GkTextField alloc]init];
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"机票和燃油附加费合计", nil);
    model.isShow = @1;
    model.isOnlyRead = isOnlyRead;
    model.tips = Custing(@"请输入机票和燃油附加费合计", nil);
//    model.fieldValue = self.AccruedReqDetail.AirlineFuelFee;
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_AirlineFuelFee WithContent:_txf_AirlineFuelFee WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_AirlineFuelFee addSubview:view];
    
    
    _txf_AirTicketPrice = [[GkTextField alloc]init];
    MyProcurementModel *model1 = [[MyProcurementModel alloc]init];
    model1.Description = Custing(@"票价", nil);
    model1.isShow = @1;
    model1.isOnlyRead = isOnlyRead;
    model1.tips = Custing(@"请输入票价(必填)", nil);
//    model1.fieldValue = self.AccruedReqDetail.AirTicketPrice;
    SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:_View_AirTicketPrice WithContent:_txf_AirTicketPrice WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model1 WithInfodict:nil];
    view1.AmountChangedBlock = ^(NSString *amount) {
        weakSelf.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:amount with:weakSelf.txf_FuelSurcharge.text] afterPoint:2];
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.ExchangeRate]?weakSelf.AccruedReqDetail.ExchangeRate:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
//        NSString *payLoc = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.InvCyPmtExchangeRate]?weakSelf.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")] afterPoint:2];
//        NSString *airLoc1 = payLoc;
//        if ([[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
//            airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
//        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
        
//        weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
//        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];
    };
    [_View_AirTicketPrice addSubview:view1];
    
    
    _txf_DevelopmentFund = [[GkTextField alloc]init];
    MyProcurementModel *model2 = [[MyProcurementModel alloc]init];
    model2.Description = Custing(@"民航发展基金", nil);
    model2.isShow = @1;
    model2.isOnlyRead = isOnlyRead;
    model2.tips = Custing(@"请输入民航发展基金(必填)", nil);
//    model2.fieldValue = self.AccruedReqDetail.DevelopmentFund;
    SubmitFormView *view2 = [[SubmitFormView alloc]initBaseView:_View_DevelopmentFund WithContent:_txf_DevelopmentFund WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model2 WithInfodict:nil];
    [_View_DevelopmentFund addSubview:view2];
    
    
    _txf_FuelSurcharge = [[GkTextField alloc]init];
    MyProcurementModel *model3 = [[MyProcurementModel alloc]init];
    model3.Description = Custing(@"燃油费附加费", nil);
    model3.isShow = @1;
    model3.isOnlyRead = isOnlyRead;
    model3.tips = Custing(@"请输入燃油费附加费(必填)", nil);
//    model3.fieldValue = self.AccruedReqDetail.FuelSurcharge;
    SubmitFormView *view3 = [[SubmitFormView alloc]initBaseView:_View_FuelSurcharge WithContent:_txf_FuelSurcharge WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model3 WithInfodict:nil];
    view3.AmountChangedBlock = ^(NSString *amount) {
        weakSelf.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:amount with:weakSelf.txf_AirTicketPrice.text] afterPoint:2];
        
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.ExchangeRate]?weakSelf.AccruedReqDetail.ExchangeRate:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
//        NSString *payLoc = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.InvCyPmtExchangeRate]?weakSelf.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")] afterPoint:2];
//        NSString *airLoc1 = payLoc;
//        if ([[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
//            airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
//        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
        
//        weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
//        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];
    };
    [_View_FuelSurcharge addSubview:view3];
    
    
    _txf_OtherTaxes = [[GkTextField alloc]init];
    MyProcurementModel *model4 = [[MyProcurementModel alloc]init];
    model4.Description = Custing(@"其他税费", nil);
    model4.isShow = @1;
    model4.isOnlyRead = isOnlyRead;
    model4.tips = Custing(@"请输入其他税费(必填)", nil);
//    model4.fieldValue = self.AccruedReqDetail.OtherTaxes;
    SubmitFormView *view4 = [[SubmitFormView alloc]initBaseView:_View_OtherTaxes WithContent:_txf_OtherTaxes WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model4 WithInfodict:nil];
    [_View_OtherTaxes addSubview:view4];
    
}

//MARK:更新税率视图
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    _txf_TaxRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TaxRate WithContent:_txf_TaxRate WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.TaxRate}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.AccruedReqDetail.TaxRate = [NSString stringWithIdOnNO:Model.Type];
            weakSelf.txf_TaxRate.text = weakSelf.AccruedReqDetail.TaxRate;
            NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.ExchangeRate] ? weakSelf.AccruedReqDetail.ExchangeRate:@"1.0000")];
            local = [GPUtils getRoundingOffNumber:local afterPoint:2];
            
//            NSString *airLoc = [NSString stringWithFormat:@"%@",local];
//            NSString *payLoc = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.InvCyPmtExchangeRate]?weakSelf.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")] afterPoint:2];
//            NSString *airLoc1 = payLoc;
//            if ([[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//                airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
//                airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
//            }
//            weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
            weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
            
//            weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
//            weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];

        }];
        picker.typeTitle = Custing(@"税率(%)", nil);
        picker.DateSourceArray = weakSelf.arr_TaxRates;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_TaxRate addSubview:view];
    
//    if (![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//        [_View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//        _txf_TaxRate.text=@"";
//    }else{
//        if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//            if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//                _View_TaxRate.userInteractionEnabled = NO;
//            }else{
//                [_View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0);
//                }];
//                _txf_TaxRate.text=@"";
//            }
//        }
//    }
}
//MARK:更新税额视图
-(void)updateTaxViewWithModel:(MyProcurementModel *)model{
    _txf_Tax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Tax WithContent:_txf_Tax WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.Tax}];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.ExchangeRate]?weakSelf.AccruedReqDetail.ExchangeRate:@"1.0000")];
        weakSelf.txf_ExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:amount]];
    }];
    [_View_Tax addSubview:view];
    
//    if (![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//        [_View_Tax updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//        _txf_Tax.text=@"";
//    }else{
//        if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//            if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] < 0) {
//                [_View_Tax updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0);
//                }];
//                _txf_Tax.text=@"";
//            }
//        }
//    }
}
//MARK:更新不含税金额视图
-(void)updateExclTaxViewWithModel:(MyProcurementModel *)model{
    _txf_ExclTax=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExclTax WithContent:_txf_ExclTax WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.ExclTax}];
    [_View_ExclTax addSubview:view];
//    if (![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//        [_View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//        _txf_ExclTax.text=@"";
//    }else{
//        if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//            if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] < 0) {
//                [_View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0);
//                }];
//                _txf_ExclTax.text=@"";
//            }
//        }
//    }
}

//MARK:更新付款金额税额视图
-(void)updateInvPmtTaxViewWithModel:(MyProcurementModel *)model{
    _txf_InvPmtTax = [[GkTextField alloc]init];
//    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvPmtTax WithContent:_txf_InvPmtTax WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.InvPmtTax}];
//    __weak typeof(self) weakSelf = self;
//    [view setAmountChangedBlock:^(NSString *amount) {
//        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.InvCyPmtExchangeRate]?weakSelf.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")];
//        weakSelf.txf_InvPmtAmountExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:amount]];
//    }];
//    [_View_InvPmtTax addSubview:view];
//
//    if (![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//        [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//        _txf_InvPmtTax.text=@"";
//    }else{
//        if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//            if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] < 0) {
//                [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0);
//                }];
//                _txf_InvPmtTax.text=@"";
//            }
//        }
//    }
}
//MARK:更新付款金额不含税金额视图
-(void)updateInvPmtAmountExclTaxViewWithModel:(MyProcurementModel *)model{
//    _txf_InvPmtAmountExclTax = [[GkTextField alloc]init];
//    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvPmtAmountExclTax WithContent:_txf_InvPmtAmountExclTax WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.InvPmtAmountExclTax}];
//    [_View_InvPmtAmountExclTax addSubview:view];
//
//    if (![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//        [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//        _txf_InvPmtAmountExclTax.text=@"";
//    }else{
//        if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//            if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] < 0) {
//                [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0);
//                }];
//                _txf_InvPmtAmountExclTax.text=@"";
//            }
//        }
//    }
}
-(void)updateTaxRelectViewWithType:(NSInteger)type{
    _View_TaxRate.userInteractionEnabled = YES;
    NSInteger height = 0;
    NSInteger heightAir = 0;
//    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//        if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//            _View_TaxRate.userInteractionEnabled = NO;
////            if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] < 0) {
////                height = 0;
////                _txf_TaxRate.text = @"";
////                _txf_Tax.text = @"";
////                _txf_ExclTax.text = @"";
////                _txf_AirlineFuelFee.text = @"";
////                _txf_AirTicketPrice.text = @"";
////                _txf_DevelopmentFund.text = @"";
////                _txf_FuelSurcharge.text = @"";
////                _txf_OtherTaxes.text = @"";
////
////                _txf_InvPmtTax.text = @"";
////                _txf_InvPmtAmountExclTax.text = @"";
////            }else
//            {
//                height = 60;
////                if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]) {
////                    heightAir = 60;
////                }
////                else{
////                    self.txf_AirlineFuelFee.text = @"";
////                    self.txf_AirTicketPrice.text = @"";
////                    self.txf_DevelopmentFund.text = @"";
////                    self.txf_FuelSurcharge.text = @"";
////                    self.txf_OtherTaxes.text = @"";
////                }
//                if (type == 1) {
//                    NSString *local = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.AccruedReqDetail.ExchangeRate] ? self.AccruedReqDetail.ExchangeRate:@"1.0000")];
//                    self.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:self.txf_Tax.text]];
//                }else{
////                    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", [NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] ];
////                    NSArray *filterArray1 = [self.arr_New_InvoiceTypes filteredArrayUsingPredicate:pred1];
////                    if (filterArray1.count > 0) {
////                        STOnePickModel *model = filterArray1[0];
////                        self.AccruedReqDetail.TaxRate = model.taxRate;
////                        self.txf_TaxRate.text = model.taxRate;
////                        NSString *local = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.AccruedReqDetail.ExchangeRate] ? self.AccruedReqDetail.ExchangeRate:@"1.0000")];
////                        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
////                        self.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:self.txf_AirTicketPrice.text with:self.txf_FuelSurcharge.text] afterPoint:2];
////
////                        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
//////                        NSString *payLoc = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.AccruedReqDetail.InvCyPmtExchangeRate]?self.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")] afterPoint:2];
//////                        NSString *airLoc1 = payLoc;
//////                        if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//////                            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
//////                            airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
//////                        }
////                        self.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:self.txf_TaxRate.text]?self.txf_TaxRate.text:@"0"];
////                        self.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:self.txf_Tax.text]];
////
//////                        self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
//////                        self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
////
////                    }
//
//                }
//            }
//        }else{
//            height = 60;
//            NSString *local = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.AccruedReqDetail.ExchangeRate]?self.AccruedReqDetail.ExchangeRate:@"1.0000")];
//            self.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:self.txf_Tax.text]];
//
////            NSString *local1 = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.AccruedReqDetail.InvCyPmtExchangeRate]?self.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")];
////            self.txf_InvPmtAmountExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local1 with:self.txf_InvPmtTax.text]];
//        }
//    }else
    {
        height = 0;
        _txf_TaxRate.text = @"";
        _txf_Tax.text = @"";
        _txf_ExclTax.text = @"";
        _txf_AirlineFuelFee.text = @"";
        _txf_AirTicketPrice.text = @"";
        _txf_DevelopmentFund.text = @"";
        _txf_FuelSurcharge.text = @"";
        _txf_OtherTaxes.text = @"";

        _txf_InvPmtTax.text = @"";
        _txf_InvPmtAmountExclTax.text = @"";
    }
    
    [_View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    
    if (_txf_TaxRate) {
        [_View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (_txf_Tax) {
        [_View_Tax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (_txf_ExclTax) {
        [_View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    
    if (_txf_InvPmtTax) {
        [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (_txf_InvPmtAmountExclTax) {
        [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
}
//MARK:更新合同名称
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    _txf_ContName = [[UITextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContName WithContent:_txf_ContName WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.ContractName}];
//    __weak typeof(self) weakSelf = self;
//    [view setFormClickedBlock:^(MyProcurementModel *model){
//        [weakSelf keyClose];
////        if (weakSelf.isContractPaymentMethod == 1) {
////            ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ContractsIs"];
////            vc.ChooseCategoryId = weakSelf.AccruedReqDetail.ContractAppNumber;
////            vc.dict_otherPars=@{@"Type":@"2",@"FlowGuid":self.str_flowGuid};
////            vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
////                ChooseCateFreModel *model = array[0];
////                weakSelf.AccruedReqDetail.ContractAppNumber = model.taskId;
////                weakSelf.AccruedReqDetail.ContractNo = model.contractNo;
////                weakSelf.AccruedReqDetail.ContractName = [GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName]];
////                weakSelf.txf_ContName.text = weakSelf.AccruedReqDetail.ContractName;
////            };
////            [weakSelf.navigationController pushViewController:vc animated:YES];
////        }else{
////            ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Contracts"];
////            vc.ChooseCategoryId = weakSelf.AccruedReqDetail.ContractAppNumber;
////            vc.dict_otherPars=@{@"Type":@"2",@"FlowGuid":self.str_flowGuid};
////            vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
////                ChooseCateFreModel *model = array[0];
////                weakSelf.AccruedReqDetail.ContractAppNumber = model.taskId;
////                weakSelf.AccruedReqDetail.ContractNo = model.serialNo;
////                weakSelf.AccruedReqDetail.ContractName = [GPUtils getSelectResultWithArray:@[model.contractNo,model.contractName]];
////                weakSelf.txf_ContName.text = weakSelf.AccruedReqDetail.ContractName;
////            };
////            [weakSelf.navigationController pushViewController:vc animated:YES];
////        }
//        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ContractsV3"];
//        vc.ChooseCategoryId = weakSelf.AccruedReqDetail.ContractAppNumber;
//        vc.dict_otherPars=@{@"Type":@"2",@"FlowGuid":self.str_flowGuid};
//        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
//            ChooseCateFreModel *model = array[0];
//            weakSelf.AccruedReqDetail.ContractAppNumber = model.taskId;
////            weakSelf.AccruedReqDetail.ContractNo = model.serialNo;
//            weakSelf.AccruedReqDetail.ContractName = [GPUtils getSelectResultWithArray:@[model.contractNo,model.contractName]];
////            weakSelf.txf_ContName.text = weakSelf.AccruedReqDetail.ContractName;
//        };
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//    [_View_ContName addSubview:view];
}

//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.ProjName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_View_Project addSubview:view];
}
//MARK:是否有支持材料
-(void)updateIsSupportMaterialsViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.IsSupportMaterials]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
        self.AccruedReqDetail.IsSupportMaterials = @"1";
    }else{
        model.fieldValue = Custing(@"否", nil);
        self.AccruedReqDetail.IsSupportMaterials = @"0";
    }
    _txf_IsSupportMaterials = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_IsSupportMaterials WithContent:_txf_IsSupportMaterials WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.IsSupportMaterials] isEqualToString:Model.Id]) {
                weakSelf.AccruedReqDetail.IsSupportMaterials = Model.Id;
                weakSelf.txf_IsSupportMaterials.text = Model.Type;
            }
        }];
        picker.typeTitle = Custing(@"是否有支持材料", nil);
        picker.DateSourceArray = weakSelf.arr_IsOrNot;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.AccruedReqDetail.IsSupportMaterials;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    };
    [_View_IsSupportMaterials addSubview:view];
}


//MARK:更新预提明细表
-(void)updateSa_Sa_AccruedReqDetailRelevanceAccruedExpDetailViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.str_taskId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.str_accuredInfo=@"";
        self.str_taskId=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.str_taskId],
                           @"Value":[NSString stringWithIdOnNO:self.str_accuredInfo],
                           @"Model":model
                           };
    [_View_AccruedForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_AccruedForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf accruedFormClick];
    };
}

//MARK:更新成本中心
-(void)updateCostCenterViewWithModel:(MyProcurementModel *)model{
    _txf_CostCenter = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CostCenter WithContent:_txf_CostCenter WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 8;
        [weakSelf clickCostCenter];
    }];
    [_View_CostCenter addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
//        self.AccruedReqDetail.CostCenterId = model.fieldValue;
    }
}
//点击成本中心
- (void)clickCostCenter{
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"costCenter"];
//    vc.ChooseCategoryId = self.AccruedReqDetail.CostCenterId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
//        if (![[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.CostCenterId] isEqualToString:model.Id]) {
//            weakSelf.AccruedReqDetail.CostCenterId = model.Id;
//            weakSelf.str_CostCenterMgr = model.costCenterMgr;
//            weakSelf.str_CostCenterMgrUserId = model.costCenterMgrUserId;
            weakSelf.txf_CostCenter.text = model.costCenter;
//            weakSelf.AccruedReqDetail.CostCenter = model.costCenter;
//            if (self.Type != 3) {
//                weakSelf.img_ExpenseCode.image = nil;
//                weakSelf.txf_ExpenseCode.text = @"";
//                weakSelf.str_expenseDesc = @"";
//                weakSelf.str_expenseCode = @"";
//                weakSelf.str_expenseIcon = @"";
//                weakSelf.str_ExpenseCat = @"";
//                weakSelf.str_ExpenseCatCode = @"";
//                weakSelf.str_accountItemCode = @"";
//                weakSelf.str_accountItem = @"";
//                weakSelf.sub_Expense.img_cate.image = nil;
//                weakSelf.str_expenseCode_tag = @"";
//                [self cleanData];
//                [self requestGetTyps];
//                [self updateCateGoryView];
//                [self clearCateData];
//                [self update_View_ExpenseCode_Click_First:@""];
//            }
//        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:更新费用申请单
-(void)updateFeeAppNumberViewWithModel:(MyProcurementModel *)model{
    if (![NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",self.AccruedReqDetail.FeeAppInfo]]) {
        self.AccruedReqDetail.FeeAppInfo=@"";
        self.AccruedReqDetail.FeeAppNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.AccruedReqDetail.FeeAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.AccruedReqDetail.FeeAppInfo],
                           @"Model":model
                           };
    [_View_FeeAppNumber updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_FeeAppNumber.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf FeeFormClick];
    };
}

-(void)FeeFormClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"FeeAppForms"];
    vc.ChooseCategoryId=self.AccruedReqDetail.FeeAppNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        weakSelf.FormDatas.str_EstimatedAmount = @"0";
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
//            weakSelf.FormDatas.str_EstimatedAmount = [GPUtils decimalNumberAddWithString:model.localCyAmount with:weakSelf.FormDatas.str_EstimatedAmount];
        }
        weakSelf.AccruedReqDetail.FeeAppInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.AccruedReqDetail.FeeAppNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
//        weakSelf.txf_Estimated.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_EstimatedAmount];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.AccruedReqDetail.FeeAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.AccruedReqDetail.FeeAppInfo]        };
        [weakSelf.View_FeeAppNumber updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:辅助核算项
-(void)updateAccountItemViewWithModel:(MyProcurementModel *)model{
    _txf_AccountItem = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccountItem WithContent:_txf_AccountItem WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.AccountItem}];
    [_View_AccountItem addSubview:view];
}
//MARK:辅助核算金额
-(void)updateAccountItemAmountViewWithModel:(MyProcurementModel *)model{
//    _txf_AccountItemAmount = [[UITextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccountItemAmount WithContent:_txf_AccountItemAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.AccountItemAmount}];
//    [_View_AccountItemAmount addSubview:view];
}
//MARK:辅助核算项2
-(void)updateAccountItem2ViewWithModel:(MyProcurementModel *)model{
    _txf_AccountItem2 = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccountItem2 WithContent:_txf_AccountItem2 WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.AccountItem}];
    [_View_AccountItem2 addSubview:view];
}
//MARK:辅助核算金额2
-(void)updateAccountItemAmount2ViewWithModel:(MyProcurementModel *)model{
//    _txf_AccountItemAmount2 = [[UITextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccountItemAmount2 WithContent:_txf_AccountItemAmount2 WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.AccountItemAmount2}];
//    [_View_AccountItemAmount2 addSubview:view];
}
//MARK:辅助核算项3
-(void)updateAccountItem3ViewWithModel:(MyProcurementModel *)model{
    _txf_AccountItem = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccountItem3 WithContent:_txf_AccountItem3 WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.AccountItem}];
    [_View_AccountItem3 addSubview:view];
}
//MARK:辅助核算金额3
-(void)updateAccountItemAmount3ViewWithModel:(MyProcurementModel *)model{
//    _txf_AccountItemAmount3 = [[UITextField alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccountItemAmount3 WithContent:_txf_AccountItemAmount3 WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.AccountItemAmount3}];
//    [_View_AccountItemAmount3 addSubview:view];
}

//MARK:更新是否外币相关视图
-(void)updateOverseasSubViews{
    NSInteger height = 0;
//    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.Overseas] isEqualToString:@"1"]) {
//        height = 60;
//    }
    if (_txf_Nationality) {
        [_View_Nationality updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (_txf_TransactionCode) {
        [_View_TransactionCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (_txf_HandmadePaper) {
        [_View_HandmadePaper updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
//    if (height == 0) {
//        self.AccruedReqDetail.Nationality = @"";
//        self.AccruedReqDetail.NationalityId = @"0";
//        self.AccruedReqDetail.TransactionCode = @"";
//        self.AccruedReqDetail.TransactionCodeId = @"";
//        self.AccruedReqDetail.HandmadePaper = @"0";
//    }
}

//MARK:更新描述视图
-(void)updateExpenseDescViewWithModel:(MyProcurementModel *)model{
    _txv_ExpenseDesc = [[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExpenseDesc WithContent:_txv_ExpenseDesc WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.ExpenseDesc}];
    [_View_ExpenseDesc addSubview:view];
}
////MARK:更新备注视图
//-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
//    _txv_Remark = [[UITextView alloc]init];
//    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.AccruedReqDetail.Remark}];
//    view.iflyRecognizerView=_iflyRecognizerView;
//    [_View_Remark addSubview:view];
//}
//MARK:更新图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.arr_totalFileArray WithImgArray:self.arr_imagesArray];
}
//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_AttachImg.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}

//MARK:费用类别点击
-(void)CateBtnClick:(UIButton *)btn{
    [self keyClose];
    if (!self.categoryArr || self.categoryArr.count==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
    if ([_CateLevel isEqualToString:@"1"]) {
        [self updateCateGoryView];
    }else if ([_CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray = self.categoryArr;
        CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
        model.expenseCode= self.AccruedReqDetail.ExpenseCode;
        pickerArea.CateModel = model;
        [pickerArea UpdatePickUI];
        [pickerArea setContentMode:STPickerContentModeBottom];
        pickerArea.str_flowCode = @"F0009";
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            [weakSelf keyClose];
            if (![secondModel.expenseType isEqualToString:weakSelf.AccruedReqDetail.ExpenseType]) {
                weakSelf.categoryImage.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.AccruedReqDetail.ExpenseType = [NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.AccruedReqDetail.ExpenseCode = secondModel.expenseCode;
                weakSelf.AccruedReqDetail.ExpenseIcon = secondModel.expenseIcon;
                weakSelf.AccruedReqDetail.ExpenseCat = secondModel.expenseCat;
                weakSelf.AccruedReqDetail.ExpenseCatCode = secondModel.expenseCatCode;
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
            }
        }];
        [pickerArea show];
    }else if([_CateLevel isEqualToString:@"3"]){
        ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
        ex.arr_DataList = _categoryArr;
        ex.str_CateLevel = _CateLevel;
        __weak typeof(self) weakSelf = self;
        ex.CellClick = ^(CostCateNewSubModel *model) {
            if (![model.expenseType isEqualToString:weakSelf.AccruedReqDetail.ExpenseType]) {
                weakSelf.categoryImage.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.AccruedReqDetail.ExpenseType = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.AccruedReqDetail.ExpenseCode = model.expenseCode;
                weakSelf.AccruedReqDetail.ExpenseIcon = model.expenseIcon;
                weakSelf.AccruedReqDetail.ExpenseCat = model.expenseCat;
                weakSelf.AccruedReqDetail.ExpenseCatCode = model.expenseCatCode;
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
}
-(void)updateCateGoryView{
    if (_isOpenGener==YES) {
        _isOpenGener=NO;
        [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else if(_isOpenGener==NO){
        _isOpenGener=YES;
        if (_categoryRows==0) {
            [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }else{
            [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.categoryRows)+10));
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.categoryRows)+10));
            }];
        }
        [_CategoryCollectView reloadData];
    }
}
//MARK:修改币种
-(void)changeCurrency{
    [self keyClose];
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.AccruedReqDetail.CurrencyCode = Model.Id;
        weakSelf.AccruedReqDetail.Currency = Model.Type;
        weakSelf.txf_CurrencyCode.text = Model.Type;
        weakSelf.txf_ExchangeRate.text = Model.exchangeRate;
        weakSelf.AccruedReqDetail.ExchangeRate = Model.exchangeRate;
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.ExchangeRate]?weakSelf.AccruedReqDetail.ExchangeRate:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
//        weakSelf.AccruedReqDetail.InvCyPmtExchangeRate = Model.exchangeRate;
        weakSelf.txf_InvCyPmtExchangeRate.text = Model.exchangeRate;

        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
//        NSString *payLoc = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.AccruedReqDetail.InvCyPmtExchangeRate]?weakSelf.AccruedReqDetail.InvCyPmtExchangeRate:@"1.0000")] afterPoint:2];
//        NSString *airLoc1 = payLoc;
//        if ([[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",weakSelf.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
//            airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
//        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
        
//        weakSelf.txf_InvPmtAmount.text = [GPUtils transformNsNumber:payLoc];
//        weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
//        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];
    }];
    picker.typeTitle = Custing(@"币种", nil);
    picker.DateSourceArray = self.arr_CurrencyCode;
    STOnePickModel *model = [[STOnePickModel alloc]init];
    model.Id = [NSString isEqualToNull: self.AccruedReqDetail.CurrencyCode] ? self.AccruedReqDetail.CurrencyCode:@"";
    picker.Model = model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:修改项目
-(void)ProjectClick{
    __weak typeof(self) weakSelf = self;
    [weakSelf keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId = self.AccruedReqDetail.ProjId;
    vc.dict_otherPars = @{@"CostCenterId":self.dict_parameter[@"CostCenterId"] ? self.dict_parameter[@"CostCenterId"]:@"0"};
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.AccruedReqDetail.ProjId = model.Id;
        weakSelf.AccruedReqDetail.ProjName = [GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.AccruedReqDetail.ProjMgrUserId = model.projMgrUserId;
        weakSelf.AccruedReqDetail.ProjMgr = model.projMgr;
        weakSelf.txf_Project.text = weakSelf.AccruedReqDetail.ProjName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:关联预提明细
- (void)accruedFormClick{
    [self keyClose];
    AccruedDetailViewController *vc = [[AccruedDetailViewController alloc]initWithType:@"accrued"];
    vc.ChooseCategoryId = self.str_taskId;
    vc.isMultiSelect = NO;
    vc.dict_otherPars = @{@"Type":self.str_AccruedStatus,@"UserId":self.FormDatas.personalData.RequestorUserId,@"FlowGuid":self.FormDatas.str_flowGuid};
    __weak typeof(self) weakSelf = self;
    vc.ChooseAccruedBackBlock = ^(NSMutableArray * _Nonnull array, NSString * _Nonnull type) {
        NSMutableArray *nameArr = [NSMutableArray array];
        NSMutableArray *idArr = [NSMutableArray array];
        
        for (AccruedDetailModel *model in array) {
//            [nameArr addObject:model.accruedDetailInfo];
//            [idArr addObject:model.accruedTaskId];
//            model.paymentOrderNo = self.AccruedReqDetail.PaymentOrderNo;
//            [weakSelf.accruedArr addObject:model];
            [nameArr addObject:[NSString stringWithFormat:@"%@/%@-%@",model.serialNo,model.reason,model.gridOrder]];
            [idArr addObject:model.taskId];
            weakSelf.str_accruedName = model.accruedName;
            weakSelf.str_accruedType = model.accruedType;
            weakSelf.str_accruedTypeId = model.accruedTypeId;
            weakSelf.str_accruedGridOrder = model.accruedGridOrder;
        }
        weakSelf.str_accuredInfo = [GPUtils getSelectResultWithArray:nameArr WithCompare:@"⊕"];
        weakSelf.str_taskId = [GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.str_taskId],@"Value":[NSString stringWithIdOnNO:self.str_accuredInfo]};
        [weakSelf.View_AccruedForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width/5, 65);
    }else{
        return CGSizeMake(70, 70);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==_CategoryCollectView) {
        return 0;
    }else{
        if (Main_Screen_Width==320) {
            return 3;
        }else{
            return 5;
        }
    }
}
#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView==_CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width, 20);
    }
    return CGSizeZero;
}
#pragma mark - CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.categoryArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectCell" forIndexPath:indexPath];
    [self.cell configWithArray:_categoryArr withRow:indexPath.row];
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CostCateNewModel *model=_categoryArr[indexPath.row];
    if (![model.expenseType isEqualToString:@""]) {
        _categoryImage.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
        self.AccruedReqDetail.ExpenseType = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
        self.AccruedReqDetail.ExpenseCode = model.expenseCode;
        self.AccruedReqDetail.ExpenseIcon = model.expenseIcon;
        self.AccruedReqDetail.ExpenseCat = model.expenseCat;
        self.AccruedReqDetail.ExpenseCatCode = model.expenseCatCode;
        _txf_Cate.text=[GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
        [self updateCateGoryView];
    }else{
        [self updateCateGoryView];
    }
}

-(void)saveData{
    //liuj_add_S
//    //成本中心
//    self.AccruedReqDetail.CostCenterId = [NSString isEqualToNull:self.AccruedReqDetail.CostCenterId]?self.AccruedReqDetail.CostCenterId:@"";
//    self.AccruedReqDetail.CostCenter = [NSString isEqualToNull:_txf_CostCenter.text]?_txf_CostCenter.text:@"";
    //费用申请单
    self.AccruedReqDetail.FeeAppNumber = [NSString isEqualToNull:self.AccruedReqDetail.FeeAppNumber]?self.AccruedReqDetail.FeeAppNumber:@"";
    self.AccruedReqDetail.FeeAppInfo = [NSString isEqualToNull:self.AccruedReqDetail.FeeAppInfo]?self.AccruedReqDetail.FeeAppInfo:@"";

    //辅助核算项
    self.AccruedReqDetail.AccountItem = [NSString isEqualToNull:_txf_AccountItem.text]?_txf_AccountItem.text:@"";

    //辅助核算金额
//    self.AccruedReqDetail.AccountItemAmount = [NSString isEqualToNull:_txf_AccountItemAmount.text] ? _txf_AccountItemAmount.text:@"";

    //辅助核算项2
//    self.AccruedReqDetail.AccountItem2 = [NSString isEqualToNull:_txf_AccountItem2.text]?_txf_AccountItem2.text:@"";

    //辅助核算金额2
//    self.AccruedReqDetail.AccountItemAmount2 = [NSString isEqualToNull:_txf_AccountItemAmount2.text] ? _txf_AccountItemAmount2.text:@"";

    //辅助核算项3
//    self.AccruedReqDetail.AccountItem3 = [NSString isEqualToNull:_txf_AccountItem3.text]?_txf_AccountItem3.text:@"";
    //辅助核算金额3
//    self.AccruedReqDetail.AccountItemAmount3 = [NSString isEqualToNull:_txf_AccountItemAmount3.text] ? _txf_AccountItemAmount3.text:@"";
//    self.AccruedReqDetail.ContractGridOrder = [NSString isEqualToNull:self.AccruedReqDetail.ContractGridOrder]?self.AccruedReqDetail.ContractGridOrder:@"";
    //预提单
    self.AccruedReqDetail.AccruedTypeId = self.str_accruedTypeId;
    self.AccruedReqDetail.AccruedType = self.str_accruedType;
    self.AccruedReqDetail.AccruedGridOrder = self.str_accruedGridOrder;
    self.AccruedReqDetail.AccruedName = self.str_accruedName;
    //liuj_add_E
    
//    self.AccruedReqDetail.ExpenseDate = self.txf_ExpenseDate.text;
//    self.AccruedReqDetail.InvoiceNo = self.txf_InvoiceNo.text;
    self.AccruedReqDetail.Amount = [NSString isEqualToNull:_txf_Amount.text] ? _txf_Amount.text:@"";
    NSString *LocalCyAmount = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.AccruedReqDetail.ExchangeRate] ? self.AccruedReqDetail.ExchangeRate:@"1.0000")];
    LocalCyAmount=[GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    self.AccruedReqDetail.LocalCyAmount = [NSString isEqualToNull:LocalCyAmount] ? LocalCyAmount:@"0.00";
//    CGFloat InvoiceTypeHight = self.View_InvoiceType.zl_height;
//    if (InvoiceTypeHight == 0) {
//        self.AccruedReqDetail.InvoiceType = @"0";
//        self.AccruedReqDetail.InvoiceTypeName = @"";
//        self.AccruedReqDetail.InvoiceTypeCode = @"0";
//    }

    self.AccruedReqDetail.TaxRate = (_View_TaxRate.zl_height > 0 && [NSString isEqualToNull:_txf_TaxRate.text])?_txf_TaxRate.text:@"";
    if (_View_Tax.zl_height > 0 && self.txf_Tax) {
        self.AccruedReqDetail.Tax = self.txf_Tax.text;
    }else{
        self.AccruedReqDetail.Tax = [NSString countTax:LocalCyAmount taxrate:self.AccruedReqDetail.TaxRate];
    }
    self.AccruedReqDetail.ExclTax = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:LocalCyAmount with:self.AccruedReqDetail.Tax] afterPoint:2];

    self.AccruedReqDetail.ExpenseDesc = _txv_ExpenseDesc.text;
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isShow = 1 && isRequired = 1"];
//    NSArray *filterArray = [self.arr_show filteredArrayUsingPredicate:pred];
//    for (MyProcurementModel *model in filterArray) {
//        NSMutableString *fieldName = [NSMutableString stringWithFormat:@"%@",model.fieldName];
//        if ([fieldName isEqualToString:@"LocalCyAmount"]||[fieldName isEqualToString:@"ExclTax"]||[fieldName isEqualToString:@"TaxRate"]||[fieldName isEqualToString:@"Tax"]||[fieldName isEqualToString:@"AccountItem"]) {
//            continue;
//        }
////        if (([fieldName isEqualToString:@"Nationality"]||[fieldName isEqualToString:@"TransactionCode"])&&![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.Overseas] isEqualToString:@"1"]) {
////            continue;
////        }
////        if (([fieldName isEqualToString:@"TaxRate"]||[fieldName isEqualToString:@"Tax"])&&![[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
////            continue;
////        }
////        if ([fieldName isEqualToString:@"InvoiceType"] && ![NSString isEqualToNull:self.AccruedReqDetail.InvoiceTypeCode]) {
////            [[GPAlertView sharedAlertView]showAlertText:self WithText:model.tips duration:2.0];
////            return;
////        }
//
//        if (![fieldName isEqualToString:@"InvoiceType"] && ![NSString isEqualToNull:[self.AccruedReqDetail valueForKey:fieldName]]) {
//            if ([fieldName isEqualToString:@"Attachments"]) {
//                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择附件", nil) duration:2.0];
//            }else{
//                [[GPAlertView sharedAlertView]showAlertText:self WithText:model.tips duration:2.0];
//            }
//            return;
//        }
//    }
    
//    if ([NSString isEqualToNull:self.AccruedReqDetail.ProjName]) {//有项目时
////        if (![NSString isEqualToNull:self.AccruedReqDetail.ContractName]&&![NSString isEqualToNull:self.AccruedReqDetail.FeeAppInfo]) {
//            NSString *message = Custing(@"请选择合同申请单或者费用申请单", nil);
//            [[GPAlertView sharedAlertView]showAlertText:self WithText:message duration:2.0];
////            return;
////        }
//    }else{
////        if (![NSString isEqualToNull:self.AccruedReqDetail.CostCenter]) {//没有项目时
//           NSString *message = Custing(@"请选择成本中心", nil);
//           [[GPAlertView sharedAlertView]showAlertText:self WithText:message duration:2.0];
////            return;
////        }
//    }
    
    
//    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
//    __weak typeof(self) weakSelf = self;
//    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.arr_totalFileArray WithUrl:travelImgLoad WithBlock:^(id data, BOOL hasError) {
//        [YXSpritesLoadingView dismiss];
//        if (hasError) {
//            weakSelf.dockView.userInteractionEnabled=YES;
//            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:1.0];
//            return;
//        }else{
////            weakSelf.AccruedReqDetail.Attachments = data;
//            [weakSelf readySave];
//        }
//    }];
    [self readySave];
}
-(void)readySave{
    if (self.AccruedReqDetailAddEditBlock) {
        self.AccruedReqDetailAddEditBlock(self.AccruedReqDetail, self.type,self.accruedArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
