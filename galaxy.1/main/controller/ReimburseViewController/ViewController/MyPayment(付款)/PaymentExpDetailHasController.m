//
//  PaymentExpDetailHasController.m
//  galaxy
//
//  Created by hfk on 2018/11/13.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PaymentExpDetailHasController.h"

@interface PaymentExpDetailHasController ()

@end

@implementation PaymentExpDetailHasController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"费用明细", nil) backButton:YES];
    [self initData];
    [self createScrollView];
    [self createMainView];
    [self updateMainView];
}
-(void)initData{
    if (!self.PaymentExpDetail) {
        self.PaymentExpDetail = [[PaymentExpDetail alloc]init];
    }
    self.arr_imagesArray = [NSMutableArray array];
    self.arr_totalFileArray = [NSMutableArray array];
    if ([NSString isEqualToNull:self.PaymentExpDetail.Attachments]) {
        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",self.PaymentExpDetail.Attachments]];
        for (NSDictionary *dict in array) {
            [self.arr_totalFileArray addObject:dict];
        }
        [GPUtils updateImageDataWithTotalArray:self.arr_totalFileArray WithImageArray:self.arr_imagesArray WithMaxCount:5];
    }
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
    
    _View_ExpenseDate = [[UIView alloc]init];
    _View_ExpenseDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpenseDate];
    [_View_ExpenseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
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
    
    _View_Amount = [[UIView alloc]init];
    _View_Amount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Amount];
    [_View_Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
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

    
    _View_InvoiceType = [[UIView alloc]init];
    _View_InvoiceType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceType];
    [_View_InvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmount.bottom);
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
    
    _View_Overseas = [[UIView alloc]init];
    _View_Overseas.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Overseas];
    [_View_Overseas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
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
        if ([model.fieldName isEqualToString:@"ExpenseDate"]){
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
        }else if ([model.fieldName isEqualToString:@"InvoiceType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvoiceTypeViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"TaxRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceType] isEqualToString:@"1"]) {
                if ([[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
                    if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.PaymentExpDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                        [self updateTaxRateViewWithModel:model];
                    }
                }else{
                    [self updateTaxRateViewWithModel:model];
                }
            }
        }else if ([model.fieldName isEqualToString:@"Tax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceType] isEqualToString:@"1"]) {
                if ([[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
                    if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.PaymentExpDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                        [self updateTaxViewWithModel:model];
                    }
                }else{
                    [self updateTaxViewWithModel:model];
                }
            }
        }else if ([model.fieldName isEqualToString:@"ExclTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceType] isEqualToString:@"1"]) {
                if ([[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1003"]||[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1004"]||[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1005"]) {
                    if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.PaymentExpDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                        [self updateExclTaxViewWithModel:model];
                    }
                }else{
                    [self updateExclTaxViewWithModel:model];
                }
            }
        }else if ([model.fieldName isEqualToString:@"InvPmtTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceType] isEqualToString:@"1"]) {
                [self updateInvPmtTaxViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"InvPmtAmountExclTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceType] isEqualToString:@"1"]) {
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
        }else if ([model.fieldName isEqualToString:@"Overseas"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateOverseasViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Nationality"] && [[NSString stringWithFormat:@"%@",self.PaymentExpDetail.Overseas]isEqualToString:@"1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateNationalityViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"TransactionCode"] && [[NSString stringWithFormat:@"%@",self.PaymentExpDetail.Overseas]isEqualToString:@"1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTransactionCodeViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"HandmadePaper"] && [[NSString stringWithFormat:@"%@",self.PaymentExpDetail.Overseas]isEqualToString:@"1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateHandmadePaperViewWithModel:model];
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
    if ([[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceType] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",self.PaymentExpDetail.InvoiceTypeCode] isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.PaymentExpDetail.ExpenseDate]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
        [self updateAirlineFuelFeeView];
    }
    
    [self updateContentView];
}
//MARK:更新日期
-(void)updateExpenseDateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.ExpenseDate];
    [_View_ExpenseDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_ExpenseDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票号码
-(void)updateInvoiceNoViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.InvoiceNo];
    [_View_InvoiceNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_InvoiceNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新费用类别
-(void)updateCateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [GPUtils getSelectResultWithArray:@[self.PaymentExpDetail.ExpenseCat,self.PaymentExpDetail.ExpenseType]];
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
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.Amount];
    [_View_Amount addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_Amount updateConstraints:^(MASConstraintMaker *make) {
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
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.Currency];
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
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.ExchangeRate];
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
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.LocalCyAmount];
    [_View_LocalCyAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_LocalCyAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票币种对支付币种汇率视图
-(void)updateInvCyPmtExchangeRateView:(MyProcurementModel *)model{
    model.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.InvCyPmtExchangeRate];
    [_View_InvCyPmtExchangeRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:2 block:^(NSInteger height) {
        [self.View_InvCyPmtExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额视图
-(void)updateInvPmtAmountView:(MyProcurementModel *)model{
    model.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.InvPmtAmount];
    [_View_InvPmtAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvPmtAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票类型视图
-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.PaymentExpDetail.InvoiceTypeName;
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
    model.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.AirlineFuelFee];
    [_View_AirlineFuelFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    
    MyProcurementModel *model1 = [[MyProcurementModel alloc]init];
    model1.Description = Custing(@"票价", nil);
    model1.isShow = @1;
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.AirTicketPrice];
    [_View_AirTicketPrice addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model2 = [[MyProcurementModel alloc]init];
    model2.Description = Custing(@"民航发展基金", nil);
    model2.isShow = @1;
    model2.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.DevelopmentFund];
    [_View_DevelopmentFund addSubview:[XBHepler creation_Lable:[UILabel new] model:model2 Y:0 block:^(NSInteger height) {
        [self.View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model3 = [[MyProcurementModel alloc]init];
    model3.Description = Custing(@"燃油费附加费", nil);
    model3.isShow = @1;
    model3.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.FuelSurcharge];
    [_View_FuelSurcharge addSubview:[XBHepler creation_Lable:[UILabel new] model:model3 Y:0 block:^(NSInteger height) {
        [self.View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model4 = [[MyProcurementModel alloc]init];
    model4.Description = Custing(@"其他税费", nil);
    model4.isShow = @1;
    model4.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.OtherTaxes];
    [_View_OtherTaxes addSubview:[XBHepler creation_Lable:[UILabel new] model:model4 Y:0 block:^(NSInteger height) {
        [self.View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税率视图
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.TaxRate];
    [_View_TaxRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:2 block:^(NSInteger height) {
        [self.View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税额视图
-(void)updateTaxViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.Tax];
    [_View_Tax addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_Tax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新不含税金额视图
-(void)updateExclTaxViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.ExclTax];
    [_View_ExclTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额税额视图
-(void)updateInvPmtTaxViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.InvPmtTax];
    [_View_InvPmtTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额不含税金额视图
-(void)updateInvPmtAmountExclTaxViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString stringWithIdOnNO:self.PaymentExpDetail.InvPmtAmountExclTax];
    [_View_InvPmtAmountExclTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同名称
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.PaymentExpDetail.ContractName;
    [_View_ContName addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_ContName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.PaymentExpDetail.ProjName;
    [_View_Project addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Project updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否境外
-(void)updateOverseasViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    if ([[NSString stringWithFormat:@"%@",self.PaymentExpDetail.Overseas]isEqualToString:@"1"]) {
        model1.fieldValue = Custing(@"是", nil);
    }else{
        model1.fieldValue = Custing(@"否", nil);
    }
    [_View_Overseas addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Overseas updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:国别
-(void)updateNationalityViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.PaymentExpDetail.Nationality;
    [_View_Nationality addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_Nationality updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:交易代码
-(void)updateTransactionCodeViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.PaymentExpDetail.TransactionCode;
    [_View_TransactionCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_TransactionCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否手工票据
-(void)updateHandmadePaperViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    if ([[NSString stringWithFormat:@"%@",self.PaymentExpDetail.HandmadePaper]isEqualToString:@"1"]) {
        model1.fieldValue = Custing(@"是", nil);
    }else{
        model1.fieldValue = Custing(@"否", nil);
    }
    [_View_HandmadePaper addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_HandmadePaper updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新描述视图
-(void)updateExpenseDescViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.PaymentExpDetail.ExpenseDesc;
    [_View_ExpenseDesc addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_ExpenseDesc updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    MyProcurementModel *model1 = [model copy];
    model1.fieldValue = self.PaymentExpDetail.Remark;

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
