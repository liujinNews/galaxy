//
//  InvoiceMangerDetailController.m
//  galaxy
//
//  Created by hfk on 2017/11/23.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "InvoiceMangerDetailController.h"

@interface InvoiceMangerDetailController ()

@end

@implementation InvoiceMangerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"发票明细", nil) backButton:YES];
    [self createScrollView];
    [self createMainView];
    [self updateEXInvoiceView];
//    if ([NSString isEqualToNull:_model_InvoiceDetail.expenseType]) {
    [self updateExpenseCodeView];
//    }
    if ([NSString isEqualToNull:_model_InvoiceDetail.pdF_URL]&&[_model_InvoiceDetail.invoiceType floatValue]==3) {
        [self updatePDFLinK];
    }
    if ([NSString isEqualToNull:_model_InvoiceDetail.taskId]&&[NSString isEqualToNull:_model_InvoiceDetail.flowCode]) {
        [self updateFormLink];
    }
    [self updateSourceView];
    
    [self updateBottomView];
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
}
//MARK:创建主视图
-(void)createMainView{
    _exv_view = [[[NSBundle mainBundle] loadNibNamed:@"EXInvoiceView" owner:self options:nil]lastObject];
    [self.contentView addSubview:_exv_view];
    [_exv_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@410);
    }];
    
    _View_Cate=[[UIView alloc]init];
    _View_Cate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exv_view.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Pdf=[[UIView alloc]init];
    _View_Pdf.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Pdf];
    [_View_Pdf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_linkForm=[[UIView alloc]init];
    _view_linkForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_view_linkForm];
    [_view_linkForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Pdf.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _lab_source = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    _lab_source.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_lab_source];
    [_lab_source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_linkForm.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
}

-(void)updateEXInvoiceView{
    
    _exv_view.lab_title_shoupiaofang.text = Custing(@"收票方", nil);
    _exv_view.lab_purchaserName.text =[NSString stringWithIdOnNO:_model_InvoiceDetail.purchaserName];

    _exv_view.lab_title_shoupiaofangshibiema.text = Custing(@"收票方识别码", nil);
    _exv_view.lab_purchaserTaxNo.text =[NSString stringWithIdOnNO:_model_InvoiceDetail.purchaserTaxNo];
    
    _exv_view.lab_title_kaipiaofang.text = Custing(@"开票方", nil);
    _exv_view.lab_salesName.text =[NSString stringWithIdOnNO:_model_InvoiceDetail.salesName];

    _exv_view.lab_title_kaipiaojiner.text = Custing(@"价税合计", nil);
    _exv_view.lab_totalAmount.text = [GPUtils transformNsNumber:_model_InvoiceDetail.amountTax];
    
    _exv_view.lab_title_shuier.text = Custing(@"税额", nil);
    _exv_view.lab_shuier.text = [GPUtils transformNsNumber:_model_InvoiceDetail.totalTax];
    
    
    _exv_view.lab_title_fapiaoriqi.text = Custing(@"开票日期", nil);
    _exv_view.lab_billingDate.text = [NSString stringWithIdOnNO:_model_InvoiceDetail.billingDate];

    _exv_view.lab_title_fapiaodaima.text = Custing(@"发票代码", nil);
    _exv_view.lab_invoiceCode.text = [NSString stringWithIdOnNO:_model_InvoiceDetail.invoiceCode];

    _exv_view.lab_title_fapiaohaoma.text = Custing(@"发票号码", nil);
    _exv_view.lab_invoiceNumber.text = [NSString stringWithIdOnNO:_model_InvoiceDetail.invoiceNumber];

    
    if ([_model_InvoiceDetail.invoiceType floatValue]==1) {
        _exv_view.lab_invoice_type.text = Custing(@"增值税普通发票", nil);
    }else if ([_model_InvoiceDetail.invoiceType floatValue]==2){
        _exv_view.lab_invoice_type.text = Custing(@"增值税专用发票", nil);
    }else if ([_model_InvoiceDetail.invoiceType floatValue]==3){
        _exv_view.lab_invoice_type.text = Custing(@"增值税电子普通发票", nil);
    }else if ([_model_InvoiceDetail.invoiceType floatValue]==4){
        _exv_view.lab_invoice_type.text = Custing(@"其他", nil);
    }
    
    _exv_view.img_state_img.image=nil;

}

//MARK:更新费用类别
-(void)updateExpenseCodeView{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"费用类别Add", nil);
    model.isOnlyRead=@"1";
    _txf_Cate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewShowCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[_model_InvoiceDetail.expenseCat,_model_InvoiceDetail.expenseType]]}];
    [_View_Cate addSubview:view];
    if ([NSString isEqualToNull:_model_InvoiceDetail.expenseIcon]&&![[NSString stringWithFormat:@"%@",_model_InvoiceDetail.expenseIcon] isEqualToString:@"0"]) {
        [view setCateImg:_model_InvoiceDetail.expenseIcon];
    }
}
-(void)updatePDFLinK{
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Pdf WithContent:nil WithFormType:formViewOnlySelect WithSegmentType:lineViewNoneLine WithString:Custing(@"电子发票pdf文件", nil)  WithTips:nil WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf pushPdfView];
    }];
    [_View_Pdf addSubview:view];
}

-(void)updateFormLink{
    NSString *str;
    NSInteger pushType=0;
    if ([[NSString stringWithIdOnNO:_model_InvoiceDetail.flowCode]isEqualToString:@"F0002"]) {
        str=Custing(@"差旅报销单", nil);
        pushType=2;
    }else if ([[NSString stringWithIdOnNO:_model_InvoiceDetail.flowCode]isEqualToString:@"F0003"]){
        str=Custing(@"日常报销单", nil);
        pushType=3;
    }else if ([[NSString stringWithIdOnNO:_model_InvoiceDetail.flowCode]isEqualToString:@"F0009"]){
        str=Custing(@"付款单", nil);
        pushType=9;
    }else if ([[NSString stringWithIdOnNO:_model_InvoiceDetail.flowCode]isEqualToString:@"F0010"]){
        str=Custing(@"专项报销单", nil);
        pushType=10;
    }
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_linkForm WithContent:nil WithFormType:formViewOnlySelect WithSegmentType:lineViewNoneLine WithString:str WithTips:[NSString stringWithFormat:@"%@ %@",Custing(@"请选择", nil),str] WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf pushLinkForm:pushType];
    }];
    [_view_linkForm addSubview:view];
}

-(void)updateSourceView{
    
    if ([[NSString stringWithFormat:@"%@",_model_InvoiceDetail.source]isEqualToString:@"12"]) {
        _lab_source.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"百望电子", nil)];
    }else if ([[NSString stringWithFormat:@"%@",_model_InvoiceDetail.source]isEqualToString:@"15"]){
        _lab_source.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"发票扫描", nil)];
    }else if ([[NSString stringWithFormat:@"%@",_model_InvoiceDetail.source]isEqualToString:@"16"]){
        _lab_source.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"微信卡包", nil)];
    }else if ([[NSString stringWithFormat:@"%@",_model_InvoiceDetail.source]isEqualToString:@"18"]){
        _lab_source.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"发票拍照", nil)];
    }
}
-(void)updateBottomView{
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lab_source.bottom);
    }];
}

-(void)pushPdfView{
    if ([_model_InvoiceDetail.source floatValue]==16) {
        //    GETWECHATPDF
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
        NSString *url=[NSString stringWithFormat:@"%@",GETWECHATPDF];
        NSDictionary *parameters=@{
                                   @"InvoiceCode":[NSString stringWithIdOnNO:_model_InvoiceDetail.invoiceNumber],
                                   @"InvoiceNumber":[NSString stringWithIdOnNO:_model_InvoiceDetail.invoiceCode],
                                   };
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    }else{
        PdfReadViewController *vc=[[PdfReadViewController alloc]init];
        vc.PdfUrl =[NSString stringWithIdOnNO:_model_InvoiceDetail.pdF_URL];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)pushLinkForm:(NSInteger)type{
    NSString *controller;
    switch (type) {
        case 2:
            controller=@"travelHasSubmitController";
            break;
        case 3:
            controller=@"dailyHasSumitViewController";
            break;
        case 9:
            controller=@"MyPaymentHasController";
            break;
        case 10:
            controller=@"OtherReimHasViewController";
            break;
        default:
            break;
    }
    
    Class cls = NSClassFromString(controller);
    UIViewController *vc = [[cls alloc] init];
    vc.pushTaskId=[NSString isEqualToNull:_model_InvoiceDetail.taskId]?[NSString stringWithFormat:@"%@",_model_InvoiceDetail.taskId]:@"0";
    vc.pushProcId=@"0";
    vc.pushUserId=@"0";
    vc.pushComeStatus=@"5";
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([NSString isEqualToNull:responceDic[@"result"]]) {
                PdfReadViewController *vc=[[PdfReadViewController alloc]init];
                vc.PdfUrl =[NSString stringWithFormat:@"%@",responceDic[@"result"]];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
//MARK:数据请求失败
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
