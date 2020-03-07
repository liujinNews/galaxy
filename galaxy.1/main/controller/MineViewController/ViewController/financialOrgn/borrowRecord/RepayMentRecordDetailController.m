//
//  RepayMentRecordDetailController.m
//  galaxy
//
//  Created by hfk on 2019/1/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "RepayMentRecordDetailController.h"

@interface RepayMentRecordDetailController ()<UIScrollViewDelegate,GPClientDelegate>
/**
 币种
 */
@property (nonatomic, strong) NSMutableArray *arr_CurrencyCode;
@property (nonatomic, strong) NSString *str_CurrencyCode;
@property (nonatomic, strong) NSString *str_Currency;
@property (nonatomic, strong) NSString *str_ExchangeRate;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)UIView *contentView;
/**
 * 金额视图
 */
@property(nonatomic,strong)UIView *View_Acount;
@property (nonatomic,strong)GkTextField * txf_Acount;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
/**
 /本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;

@end

@implementation RepayMentRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",self.recordDict[@"requestor"]],Custing(@"还款", nil)] WithCompare:@""] backButton:YES];
    [self getCurrency];
}
-(void)createViews{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    self.contentView = [[BottomView alloc]init];
    self.contentView.userInteractionEnabled = YES;
    self.contentView.backgroundColor = Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    
    NSString *title = self.type == 1 ? Custing(@"应还款金额", nil):Custing(@"借款金额", nil);
    UILabel *lab_recordAmount = [GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width, 60) text:[GPUtils getSelectResultWithArray:@[title,[GPUtils transformNsNumber:self.recordDict[@"amount"]]] WithCompare:@" "] font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    lab_recordAmount.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [lab_recordAmount addAttrDict:@{NSForegroundColorAttributeName: Color_GrayDark_Same_20,NSFontAttributeName: Font_Important_15_20} toStr:title];
    [self.contentView addSubview:lab_recordAmount];
    
    
    UIView *View_Reason = [[UIView alloc]init];
    View_Reason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_Reason];
    [View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab_recordAmount.bottom);
        make.right.left.equalTo(self.contentView);
        make.height.equalTo(0);
    }];
    
    
    UIView *View_Date = [[UIView alloc]init];
    View_Date.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_Date];
    [View_Date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_Reason.bottom);
        make.right.left.equalTo(self.contentView);
        make.height.equalTo(0);
    }];
    if (self.type == 2) {
        UITextField *txf_reason = [[UITextField alloc]init];
        [View_Reason addSubview:[[SubmitFormView alloc]initBaseView:View_Reason WithContent:txf_reason WithFormType:formViewShowText WithSegmentType:lineViewNone WithString:Custing(@"借款事由", nil) WithTips:nil WithInfodict:@{@"value1":self.recordDict[@"reason"]}]];
        

        [View_Date mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(60);
        }];
        
        UIView *SegmentLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        SegmentLineView.backgroundColor=Color_White_Same_20;
        [View_Date addSubview:SegmentLineView];
        
        UILabel *borrowTitle = [GPUtils createLable:CGRectMake(12, 10, XBHelper_Title_Width, 50) text:Custing(@"借款日期", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        borrowTitle.numberOfLines = 2;
        [View_Date addSubview:borrowTitle];
        
        UILabel *borrowDate = [GPUtils createLable:CGRectMake(12 + XBHelper_Title_Width, 10, Main_Screen_Width/2 - 24 - XBHelper_Title_Width, 50) text:[self convertLeaveDateFromString:self.recordDict[@"requestorDate"]] font:Font_Important_18_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
        [View_Date addSubview:borrowDate];
        [borrowDate addAttrDict:@{NSFontAttributeName: Font_Same_12_20} toStr:@"月"];
        [borrowDate addAttrDict:@{NSFontAttributeName: Font_Same_12_20} toStr:@"日"];

        UIView *middleLine = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2 - 0.5, 10, 1, 50)];
        middleLine.backgroundColor = Color_GrayLight_Same_20;
        [View_Date addSubview:middleLine];
        
        UILabel *repayTitle = [GPUtils createLable:CGRectMake(Main_Screen_Width/2 + 12, 10, XBHelper_Title_Width, 50) text:Custing(@"还款日期", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        repayTitle.numberOfLines = 2;
        [View_Date addSubview:repayTitle];
        
        UILabel *repayDate = [GPUtils createLable:CGRectMake(Main_Screen_Width/2 + 12 + XBHelper_Title_Width, 10, Main_Screen_Width/2 - 24 - XBHelper_Title_Width, 50) text:[self convertLeaveDateFromString:self.recordDict[@"repayDate"]] font:Font_Important_18_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
        [View_Date addSubview:repayDate];
        [repayDate addAttrDict:@{NSFontAttributeName: Font_Same_12_20} toStr:@"月"];
        [repayDate addAttrDict:@{NSFontAttributeName: Font_Same_12_20} toStr:@"日"];
    }
    
    
    __weak typeof(self) weakSelf = self;
    _View_Acount = [[UIView alloc]init];
    _View_Acount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Acount];
    [_View_Acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_Date.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(0);
    }];
    _txf_Acount = [[GkTextField alloc]init];
    SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:_View_Acount WithContent:_txf_Acount WithFormType:formViewEnterAmout WithSegmentType:self.type == 1 ? lineViewNone:lineViewNoneLine WithString:Custing(@"还款金额", nil) WithTips:Custing(@"请输入还款金额", nil) WithInfodict:nil];
    [view1 setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.str_ExchangeRate] ? weakSelf.str_ExchangeRate:@"1.0000")]];
    }];
    [_View_Acount addSubview:view1];

    
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Acount.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(0);
    }];
    _txf_CurrencyCode = [[UITextField alloc]init];
    SubmitFormView *view2 = [[SubmitFormView alloc]initBaseView:_View_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"币种", nil) WithTips:Custing(@"请选择币种", nil) WithInfodict:@{@"value1":self.str_Currency}];
    [view2 setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_CurrencyCode = Model.Id;
            weakSelf.str_Currency = Model.Type;
            weakSelf.txf_CurrencyCode.text = Model.Type;
            weakSelf.txf_ExchangeRate.text = Model.exchangeRate;
            weakSelf.str_ExchangeRate = Model.exchangeRate;
            weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Acount.text with:([NSString isEqualToNull:weakSelf.str_ExchangeRate] ? weakSelf.str_ExchangeRate:@"1.0000")]];
        }];
        picker.typeTitle=Custing(@"币种", nil);
        picker.DateSourceArray = self.arr_CurrencyCode;
        STOnePickModel *selectModel = [[STOnePickModel alloc]init];
        selectModel.Id = [NSString stringWithIdOnNO:self.str_CurrencyCode];
        picker.Model = selectModel;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_CurrencyCode addSubview:view2];
    
    
    _View_ExchangeRate = [[UIView alloc]init];
    _View_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExchangeRate];
    [_View_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(0);
    }];
    _txf_ExchangeRate = [[UITextField alloc]init];
    SubmitFormView *view3 = [[SubmitFormView alloc]initBaseView:_View_ExchangeRate WithContent:_txf_ExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine WithString:Custing(@"汇率", nil) WithTips:Custing(@"请输入汇率", nil) WithInfodict:@{@"value1":self.str_ExchangeRate}];
    [view3 setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.str_ExchangeRate = exchange;
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Acount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")]];
    }];
    [_View_ExchangeRate addSubview:view3];

    
    _View_LocalCyAmount = [[UIView alloc]init];
    _View_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LocalCyAmount];
    [_View_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(0);
    }];
    _txf_LocalCyAmount = [[UITextField alloc]init];
    SubmitFormView *view4 = [[SubmitFormView alloc]initBaseView:_View_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine WithString:Custing(@"本位币金额", nil) WithTips:nil WithInfodict:nil];
    [_View_LocalCyAmount addSubview:view4];

    
    
    UIButton *sureBtn = [GPUtils createButton:CGRectZero action:@selector(sureRepay:) delegate:self title:Custing(@"确定还款", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    sureBtn.backgroundColor = Color_Blue_Important_20;
    sureBtn.layer.cornerRadius = 10.0f;
    [self.contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LocalCyAmount.bottom).offset(20);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(44);
    }];
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sureBtn.bottom).offset(20);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:确认还款按钮
-(void)sureRepay:(id)sender{
    [self keyClose];
    
    if (self.txf_Acount.text.length == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入还款金额", nil) duration:1.5];
        return;
    }
    
    NSString *LocalCyAmount = [GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.str_ExchangeRate] ? self.str_ExchangeRate:@"1.0000")];
    LocalCyAmount = [GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    
    if ([[GPUtils decimalNumberSubWithString:LocalCyAmount with:self.recordDict[@"amount"]] floatValue] > 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"还款金额不能大于借款金额!", nil)];
        return;
    }
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if (self.type == 1){
        NSDictionary * dic =@{@"Id":[NSString stringWithFormat:@"%@",self.recordDict[@"id"]],
                              @"RequestorUserId":[NSString stringWithFormat:@"%@",self.recordDict[@"requestorUserId"]],
                              @"RepayAmount":LocalCyAmount,
                              @"CurrencyCode":self.str_CurrencyCode
                              };
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",USERLOANREPAYMENT] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }else if (self.type == 2){
        NSDictionary * dic =@{@"Id":[NSString stringWithFormat:@"%@",self.recordDict[@"id"]],
                              @"LoanId":[NSString stringWithFormat:@"%@",self.recordDict[@"LoanId"]],
                              @"RepayAmount":LocalCyAmount,
                              @"TaskId":self.recordDict[@"TaskId"],
                              @"FlowCode":self.recordDict[@"FlowCode"],
                              @"CurrencyCode":self.str_CurrencyCode
                              };
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",RepayByDetail] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }
}
//MARK:获取币种信息
-(void)getCurrency{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:GETCURRENCYBOX Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
                NSMutableDictionary *Currencydict = [NSMutableDictionary dictionary];
                self.arr_CurrencyCode = [NSMutableArray array];
                [STOnePickModel getCurrcyWithDate:responceDic[@"result"] WithResult:self.arr_CurrencyCode WithCurrencyDict:Currencydict];
                self.str_CurrencyCode = Currencydict[@"CurrencyCode"];
                self.str_ExchangeRate = Currencydict[@"ExchangeRate"];
                self.str_Currency = Currencydict[@"Currency"];
                [self createViews];
            }
        }
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"还款成功", nil) duration:1.0];
            __weak typeof(self) weakSelf = self;
            [self performBlock:^{
                [weakSelf Navback];
            } afterDelay:1.0];
        }
            break;
        default:
            break;
    }
}

//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(NSString *)convertLeaveDateFromString:(NSString*)uiDate{
    NSString *str = @"";
    if ([NSString isEqualToNull:uiDate] && ![uiDate isEqualToString:@"0001/01/01"]) {
        NSArray *array = [uiDate componentsSeparatedByString:@"/"];
        if (array.count == 3) {
            BOOL isCh = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage] isEqualToString:@"zh-Hans"];
            if (isCh) {
                str = [NSString stringWithFormat:@"%@月%@",array[1],array[2]];
                str = [NSString stringWithFormat:@"%@日",str];
            }else{
                str = [NSString stringWithFormat:@"%@/%@",array[1],array[2]];
            }
        }
    }
    return str;
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
