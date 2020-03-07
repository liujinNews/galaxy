//
//  AccruedReqDetailHasController.m
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "AccruedReqDetailHasController.h"

@interface AccruedReqDetailHasController ()

@end

@implementation AccruedReqDetailHasController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"费用明细", nil) backButton:YES];
//    [self initData];
    [self createScrollView];
    [self createMainView];
    [self updateMainView];
}
//-(void)initData{
//    if (!self.AccruedReqDetail) {
//        self.AccruedReqDetail = [[AccruedReqDetail alloc]init];
//    }
//    self.arr_imagesArray = [NSMutableArray array];
//    self.arr_totalFileArray = [NSMutableArray array];
////    if ([NSString isEqualToNull:self.AccruedReqDetail.Attachments]) {
////        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",self.AccruedReqDetail.Attachments]];
////        for (NSDictionary *dict in array) {
////            [self.arr_totalFileArray addObject:dict];
////        }
////        [GPUtils updateImageDataWithTotalArray:self.arr_totalFileArray WithImageArray:self.arr_imagesArray WithMaxCount:5];
////    }
//}
//MARK:创建scrollView
-(void)createScrollView{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

//MARK:创建主视图
-(void)createMainView{
    //预提月份
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
        make.top.equalTo(self.View_AccruedMonth);
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
    //供应商
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
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
    
    //是否材料支持
    _View_IsSupportMaterials = [[UIView alloc]init];
    _View_IsSupportMaterials.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsSupportMaterials];
    [_View_IsSupportMaterials mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmountExclTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
     //类型
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
     //是否政府相关
    _View_Government = [[UIView alloc]init];
    _View_Government.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Government];
    [_View_Government mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsAccruedaccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContName = [[UIView alloc]init];
    _View_ContName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContName];
    [_View_ContName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Government.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //成本中心
    _View_CostCenter = [[UIView alloc]init];
    _View_CostCenter.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CostCenter];
    [_View_CostCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //关联费用申请单
    _View_FeeAppNumber=[[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0012"];
    _View_FeeAppNumber.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FeeAppNumber];
    [_View_FeeAppNumber makeConstraints:^(MASConstraintMaker *make) {
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
    //辅助核算金额
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
    //辅助核算金额2
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
    //辅助核算金额3
    _View_AccountItemAmount3 = [[UIView alloc]init];
    _View_AccountItemAmount3.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccountItemAmount3];
    [_View_AccountItemAmount3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItem3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Overseas = [[UIView alloc]init];
    _View_Overseas.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Overseas];
    [_View_Overseas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItemAmount3.bottom);
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
    
    
    _View_ExpenseDesc = [[UIView alloc]init];
    _View_ExpenseDesc.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpenseDesc];
    [_View_ExpenseDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HandmadePaper.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
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
        if ([model.fieldName isEqualToString:@"AccruedMonth"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccruedMonthViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateExpenseDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"InvoiceNo"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvoiceNoViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateCateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Amount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAmountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateSupplierViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"AccruedType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAccruedTypeViewWithModel:model];
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
        }else if ([model.fieldName isEqualToString:@"InvPmtAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvPmtAmountView:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsVAT"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsVATViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"InvoiceType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvoiceTypeViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"TaxRate"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//                if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//                    if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//                        [self updateTaxRateViewWithModel:model];
//                    }
//                }else{
//                    [self updateTaxRateViewWithModel:model];
//                }
//            }
        }else if ([model.fieldName isEqualToString:@"Tax"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//                if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//                    if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//                        [self updateTaxViewWithModel:model];
//                    }
//                }else{
//                    [self updateTaxViewWithModel:model];
//                }
//            }
        }else if ([model.fieldName isEqualToString:@"ExclTax"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//                if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
//                    if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//                        [self updateExclTaxViewWithModel:model];
//                    }
//                }else{
//                    [self updateExclTaxViewWithModel:model];
//                }
//            }
        }else if ([model.fieldName isEqualToString:@"InvPmtTax"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//                [self updateInvPmtTaxViewWithModel:model];
//            }
        }else if ([model.fieldName isEqualToString:@"InvPmtAmountExclTax"]){
//            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"]) {
//                [self updateInvPmtAmountExclTaxViewWithModel:model];
//            }
        }else if ([model.fieldName isEqualToString:@"IsSupportMaterials"]){//类型
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsSupportMaterialsViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"CostType"]){//类型
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateCostTypeViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsStorage"]){//是否入库
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsStorageViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsPrepay"]){//是否预付
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsPrepayViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"PrepayStartDate"]){//预付期间开始时间
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updatePrepayStartDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"PrepayEndDate"]){//预付期间结束时间
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updatePrepayEndDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsAccruedaccount"]){//是否预提
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsAccruedaccountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Government"]){//是否与政府相关
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateGovernmentViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ContractName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateContractNameViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateProjectViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"CostCenterId"]){//成本中心
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateCostCenterViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"FeeAppNumber"]){//关联费用申请单
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateFeeAppNumberViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsSettlement"]){//是否已结项
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateIsSettlementViewWithModel:model];
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
        }else if ([model.fieldName isEqualToString:@"Overseas"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateOverseasViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateExpenseDescViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Remark"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateRemarkViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Attachments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateAttachImgViewWithModel:model];
            }
        }
    }
    
    //更新机票和燃油附加费合计
//    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",self.AccruedReqDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.AccruedReqDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
//        [self updateAirlineFuelFeeView];
//    }
    
    [self updateContentView];
}
//MARK:更新预提月份
-(void)updateAccruedMonthViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.AccruedMonth];
    [_View_AccruedMonth addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AccruedMonth updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新日期
-(void)updateExpenseDateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.ExpenseDate];
    [_View_ExpenseDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_ExpenseDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票号码
-(void)updateInvoiceNoViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.InvoiceNo];
    [_View_InvoiceNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_InvoiceNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新费用类别
-(void)updateCateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [GPUtils getSelectResultWithArray:@[self.AccruedReqDetail.ExpenseCat,self.AccruedReqDetail.ExpenseType]];
    [_View_Cate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Cate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新借款金额
-(void)updateAmountViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票金额", nil);
    }
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.Amount];
    [_View_Amount addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_Amount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新供应商
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.AccruedReqDetail.SupplierName]?[NSString stringWithFormat:@"%@",self.AccruedReqDetail.SupplierName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新预提类型
-(void)updateAccruedTypeViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.AccruedReqDetail.AccruedType;
    [_View_AccruedType addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AccruedType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新币种视图
-(void)updateCurrencyCodeView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票币种", nil);
    }
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.Currency];
    [_View_CurrencyCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_CurrencyCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新汇率视图
-(void)updateExchangeRateView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"付款汇率", nil);
    }
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.ExchangeRate];
    [_View_ExchangeRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:2 block:^(NSInteger height) {
        [self.View_ExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新本位币金额视图
-(void)updateLocalCyAmountView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"付款金额", nil);
    }
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.LocalCyAmount];
    [_View_LocalCyAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_LocalCyAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票币种对支付币种汇率视图
-(void)updateInvCyPmtExchangeRateView:(MyProcurementModel *)model{
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.InvCyPmtExchangeRate];
    [_View_InvCyPmtExchangeRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:2 block:^(NSInteger height) {
        [self.View_InvCyPmtExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额视图
-(void)updateInvPmtAmountView:(MyProcurementModel *)model{
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.InvPmtAmount];
    [_View_InvPmtAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvPmtAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新是否专票视图
-(void)updateIsVATViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.AccruedReqDetail.IsVAT;
    [_View_IsVAT addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_IsVAT updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票类型视图
-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.InvoiceTypeName;
    [_View_InvoiceType addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新机票和燃油附加费合计视图
-(void)updateAirlineFuelFeeView{
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"机票和燃油附加费合计", nil);
    model.isShow = @1;
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.AirlineFuelFee];
    [_View_AirlineFuelFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    
    MyProcurementModel *model1 = [[MyProcurementModel alloc]init];
    model1.Description = Custing(@"票价", nil);
    model1.isShow = @1;
//    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.AirTicketPrice];
    [_View_AirTicketPrice addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model2 = [[MyProcurementModel alloc]init];
    model2.Description = Custing(@"民航发展基金", nil);
    model2.isShow = @1;
//    model2.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.DevelopmentFund];
    [_View_DevelopmentFund addSubview:[XBHepler creation_Lable:[UILabel new] model:model2 Y:0 block:^(NSInteger height) {
        [self.View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model3 = [[MyProcurementModel alloc]init];
    model3.Description = Custing(@"燃油费附加费", nil);
    model3.isShow = @1;
//    model3.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.FuelSurcharge];
    [_View_FuelSurcharge addSubview:[XBHepler creation_Lable:[UILabel new] model:model3 Y:0 block:^(NSInteger height) {
        [self.View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model4 = [[MyProcurementModel alloc]init];
    model4.Description = Custing(@"其他税费", nil);
    model4.isShow = @1;
//    model4.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.OtherTaxes];
    [_View_OtherTaxes addSubview:[XBHepler creation_Lable:[UILabel new] model:model4 Y:0 block:^(NSInteger height) {
        [self.View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税率视图
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.TaxRate];
    [_View_TaxRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:2 block:^(NSInteger height) {
        [self.View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税额视图
-(void)updateTaxViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.Tax];
    [_View_Tax addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_Tax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新不含税金额视图
-(void)updateExclTaxViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.ExclTax];
    [_View_ExclTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额税额视图
-(void)updateInvPmtTaxViewWithModel:(MyProcurementModel *)model{
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.InvPmtTax];
    [_View_InvPmtTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额不含税金额视图
-(void)updateInvPmtAmountExclTaxViewWithModel:(MyProcurementModel *)model{
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.InvPmtAmountExclTax];
    [_View_InvPmtAmountExclTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新是否材料支持视图
-(void)updateIsSupportMaterialsViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.AccruedReqDetail.IsSupportMaterials;
    [_View_IsSupportMaterials addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_IsSupportMaterials updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:类型 View_CostType
-(void)updateCostTypeViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.CostType;
    [_View_CostType addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_CostType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否已入库 View_IsStorage
-(void)updateIsStorageViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.IsStorage;
    [_View_IsStorage addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_IsStorage updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否预付 View_IsPrepay
-(void)updateIsPrepayViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.IsPrepay;
    [_View_IsPrepay addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_IsPrepay updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:预付开始时间 View_PrepayStartDate
-(void)updatePrepayStartDateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.PrepayStartDate;
    [_View_PrepayStartDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_PrepayStartDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:预付结束时间 View_PrepayEndDate
-(void)updatePrepayEndDateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.PrepayEndDate;
    [_View_PrepayEndDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_PrepayEndDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否预提 View_IsAccruedaccount
-(void)updateIsAccruedaccountViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.IsAccruedaccount;
    [_View_IsAccruedaccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_IsAccruedaccount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否政府相关 View_Government
-(void)updateGovernmentViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.Government;
    [_View_Government addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Government updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同名称
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.ContractName;
    [_View_ContName addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_ContName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.AccruedReqDetail.ProjName;
    [_View_Project addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Project updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:成本中心 View_CostCenter
-(void)updateCostCenterViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.CostCenter;
    [_View_CostCenter addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_CostCenter updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:关联费用申请单 View_FeeAppNumber
-(void)updateFeeAppNumberViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.AccruedReqDetail.FeeAppNumber;
    [_View_FeeAppNumber addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_FeeAppNumber updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否已结项 View_IsSettlement
-(void)updateIsSettlementViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.IsSettlement;
    [_View_IsSettlement addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_IsSettlement updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:辅助核算项 View_AccountItem
-(void)updateAccountItemViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.AccruedReqDetail.AccountItem;
    [_View_AccountItem addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AccountItem updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:辅助核算金额 View_AccountItemAmount
-(void)updateAccountItemAmountViewWithModel:(MyProcurementModel *)model{
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.AccountItemAmount];
    [_View_AccountItemAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_AccountItemAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:辅助核算项2 View_AccountItem2
-(void)updateAccountItem2ViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.AccountItem2;
    [_View_AccountItem2 addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AccountItem2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:辅助核算金额2 View_AccountItemAmount2
-(void)updateAccountItemAmount2ViewWithModel:(MyProcurementModel *)model{
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.AccountItemAmount2];
    [_View_AccountItemAmount2 addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_AccountItemAmount2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:辅助核算项3 View_AccountItem3
-(void)updateAccountItem3ViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.AccountItem3;
    [_View_AccountItem3 addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AccountItem3 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:辅助核算金额3 View_AccountItemAmount3
-(void)updateAccountItemAmount3ViewWithModel:(MyProcurementModel *)model{
//    model.fieldValue = [NSString stringWithIdOnNO:self.AccruedReqDetail.AccountItemAmount3];
    [_View_AccountItemAmount3 addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_AccountItemAmount3 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否境外
-(void)updateOverseasViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.Overseas]isEqualToString:@"1"]) {
        model1.fieldValue = Custing(@"是", nil);
//    }else{
//        model1.fieldValue = Custing(@"否", nil);
//    }
//    [_View_Overseas addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
//        [self.View_Overseas updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(height);
//        }];
//    }]];
}
//MARK:国别
-(void)updateNationalityViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.Nationality;
    [_View_Nationality addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Nationality updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:交易代码
-(void)updateTransactionCodeViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.TransactionCode;
    [_View_TransactionCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_TransactionCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否手工票据
-(void)updateHandmadePaperViewWithModel:(MyProcurementModel *)model{
//    MyProcurementModel *model1 = [model copy];
//    if ([[NSString stringWithFormat:@"%@",self.AccruedReqDetail.HandmadePaper]isEqualToString:@"1"]) {
//        model1.fieldValue = Custing(@"是", nil);
//    }else{
//        model1.fieldValue = Custing(@"否", nil);
//    }
//    [_View_HandmadePaper addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
//        [self.View_HandmadePaper updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(height);
//        }];
//    }]];
}
//MARK:更新描述视图
-(void)updateExpenseDescViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.AccruedReqDetail.ExpenseDesc;
    [_View_ExpenseDesc addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_ExpenseDesc updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
//    model1.fieldValue = self.AccruedReqDetail.Remark;

    [_View_Remark addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Remark updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:2 withModel:model];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
