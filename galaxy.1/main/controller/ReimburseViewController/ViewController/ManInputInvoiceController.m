//
//  ManInputInvoiceController.m
//  galaxy
//
//  Created by hfk on 2017/11/10.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ManInputInvoiceController.h"
#import "EXInvoicedViewController.h"
@interface ManInputInvoiceController ()<UIScrollViewDelegate>

/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
@property (nonatomic, strong) UITextField *txf_invoiceCode;
@property (nonatomic, strong) UITextField *txf_invoiceNumber;
@property (nonatomic, strong) UITextField *txf_billingDate;
@property (nonatomic, strong) UITextField *txf_totalAmount;
@property (nonatomic, strong) UITextField *txf_checkCode;
@end

@implementation ManInputInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"发票查验", nil) backButton:YES];
    [self createMainView];
    
    if (self.dict_Invoiceinfo) {
        _txf_invoiceCode.text = [NSString stringWithIdOnNO:self.dict_Invoiceinfo[@"invoiceCode"]];
        _txf_invoiceNumber.text = [NSString stringWithIdOnNO:self.dict_Invoiceinfo[@"invoiceNumber"]];
        _txf_billingDate.text = [NSString stringWithIdOnNO:self.dict_Invoiceinfo[@"billingDate"]];
        _txf_totalAmount.text = [NSString stringWithIdOnNO:self.dict_Invoiceinfo[@"totalAmount"]];
        _txf_checkCode.text = [NSString stringWithIdOnNO:self.dict_Invoiceinfo[@"checkCode"]];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)createMainView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    
    UIView *View_InvoiceCode=[[UIView alloc]init];
    View_InvoiceCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_InvoiceCode];
    [View_InvoiceCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_invoiceCode=[[UITextField alloc]init];
    [View_InvoiceCode addSubview:[[SubmitFormView alloc]initBaseView:View_InvoiceCode WithContent:_txf_invoiceCode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"发票代码", nil) WithTips:Custing(@"请输入发票代码", nil) WithInfodict:nil]];
    
    
    UIView *View_invoiceNumber=[[UIView alloc]init];
    View_invoiceNumber.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_invoiceNumber];
    [View_invoiceNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_InvoiceCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_invoiceNumber=[[UITextField alloc]init];
    [View_invoiceNumber addSubview:[[SubmitFormView alloc]initBaseView:View_invoiceNumber WithContent:_txf_invoiceNumber WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"发票号码", nil) WithTips:Custing(@"请输入发票号码", nil) WithInfodict:nil]];
    
    
    UIView *View_billingDate=[[UIView alloc]init];
    View_billingDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_billingDate];
    [View_billingDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_invoiceNumber.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_billingDate=[[UITextField alloc]init];
    [View_billingDate addSubview:[[SubmitFormView alloc]initBaseView:View_billingDate WithContent:_txf_billingDate WithFormType:formViewSelectDate WithSegmentType:lineViewOnlyLine WithString:Custing(@"开票日期", nil) WithTips:Custing(@"请选择开票日期", nil) WithInfodict:nil]];
    
    
    
    
    UIView *View_totalAmount=[[UIView alloc]init];
    View_totalAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_totalAmount];
    [View_totalAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_billingDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_totalAmount=[[UITextField alloc]init];
    [View_totalAmount addSubview:[[SubmitFormView alloc]initBaseView:View_totalAmount WithContent:_txf_totalAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine WithString:Custing(@"不含税金额", nil) WithTips:Custing(@"请输入不含税金额", nil) WithInfodict:nil]];
    
    
    UIView *View_checkCode=[[UIView alloc]init];
    View_checkCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:View_checkCode];
    [View_checkCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_totalAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_checkCode=[[UITextField alloc]init];
    [View_checkCode addSubview:[[SubmitFormView alloc]initBaseView:View_checkCode WithContent:_txf_checkCode WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"校验码后6位", nil) WithInfodict:nil WithTips:Custing(@"请输入检验码后6位", nil) WithNumLimit:6]];
    
    
    UIView *View_Check=[[UIView alloc]init];
    View_Check.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:View_Check];
    [View_Check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(View_checkCode.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@150);
    }];
    UIButton * importBtn = [GPUtils createButton:CGRectMake(15, 15, Main_Screen_Width-30, 45) action:@selector(InputInvoice:) delegate:self title:Custing(@"查询", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [importBtn setBackgroundColor:Color_Blue_Important_20];
    importBtn.layer.cornerRadius = 15.0f;
    [View_Check addSubview:importBtn];
    
    if (self.dict_Invoiceinfo&&self.str_code) {
        UILabel *labSub=[GPUtils createLable:CGRectMake(12, 70, Main_Screen_Width-24, 30) text:nil font:Font_Same_12_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentCenter];
        labSub.numberOfLines=0;
        [View_Check addSubview:labSub];

        if ([self.str_code isEqualToString:@"1000"]) {
            labSub.text = Custing(@"拍照不清晰，没有识别出来，通过手工查验试试", nil);
        }else{
            labSub.text = Custing(@"识别数据不完整，手动调整一下发票信息在查验", nil);
        }
    }else{
        UILabel *labSub=[GPUtils createLable:CGRectMake(0, 60, Main_Screen_Width, 35) text:Custing(@"发票信息会延迟一天", nil) font:[UIFont systemFontOfSize:13.0] textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentCenter];
        [View_Check addSubview:labSub];

    }

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(View_Check.bottom);
    }];

}
-(void)InputInvoice:(UIButton *)btn{
    if (_txf_invoiceCode.text.length==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入发票代码", nil)  duration:1.0];
        return;
    }else if (_txf_invoiceNumber.text.length==0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入发票号码", nil)  duration:1.0];
        return;
    }else if (_txf_billingDate.text.length==0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择开票日期", nil)  duration:1.0];
        return;
    }else if (_txf_totalAmount.text.length==0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入不含税金额", nil)  duration:1.0];
        return;
    }
//    else if (_txf_checkCode.text.length==0){
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入校验码后6位", nil)  duration:1.0];
//        return;
//    }
    
    NSArray *array=@[@"0",@"1",_txf_invoiceCode.text,_txf_invoiceNumber.text,_txf_totalAmount.text,
         [([_txf_billingDate.text stringByReplacingOccurrencesOfString:@"/" withString:@""]) stringByReplacingOccurrencesOfString:@"-" withString:@""],_txf_checkCode.text];
    EXInvoicedViewController *ex = [[EXInvoicedViewController alloc]init];
    ex.str_result =[GPUtils getSelectResultWithArray:array WithCompare:@","];
    ex.int_Type = 1;
    ex.backIndex=@"0";
    [self.navigationController pushViewController:ex animated:YES];

    
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
