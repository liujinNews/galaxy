//
//  bwInvoiceShowViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/11/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "bwInvoiceShowViewController.h"
#import "bwInvoiceShowTableViewCell.h"
#import "EXInvoicedViewController.h"
#import "bwInvoiceListViewController.h"

@interface bwInvoiceShowViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate,chooseTravelDateViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txf_StateTime;
@property (weak, nonatomic) IBOutlet UITextField *txf_EndTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_Search;
@property (weak, nonatomic) IBOutlet UITableView *tbv_TableView;
@property (weak, nonatomic) IBOutlet UIImageView *img_Line;
@property (weak, nonatomic) IBOutlet UIImageView *img_Line1;

@property (nonatomic, strong) UIDatePicker *dap_StateTime;
@property (nonatomic, strong) chooseTravelDateView *cho_Date;

@property (nonatomic, strong) NSArray *arr_ShowData;

@end

@implementation bwInvoiceShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"电子发票", nil) backButton:YES];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"导入", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_right_Click)];
    
    [_btn_Search setTitle:Custing(@"搜索", nil) forState:UIControlStateNormal];
    if (![NSString isEqualToNull:_txf_StateTime.text]) {
        _txf_StateTime.text = [NSDate getDateNow];
    }
    if (![NSString isEqualToNull:_txf_EndTime.text]) {
        _txf_EndTime.text = [NSDate getDateNow];
    }
    _arr_ShowData = [NSArray array];
    self.view.backgroundColor = Color_White_Same_20;
    _tbv_TableView.backgroundColor = Color_White_Same_20;
    _tbv_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _arr_ShowData = [NSArray array];
    if (_tbv_TableView) {
        [_tbv_TableView reloadData];
    }
}

#pragma mark - function
-(void)Navback {
    [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-3] animated:YES];
}

-(void)btn_right_Click{
    if (_arr_ShowData.count>0) {
        bwInvoiceListViewController *bw = [[bwInvoiceListViewController alloc]init];
        bw.arr_showData = _arr_ShowData;
        bw.str_AccountNo = _str_AccountNo;
        bw.str_AccountType = _str_AccountType;
        [self.navigationController pushViewController:bw animated:YES];
    }else{
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"没有单据", nil) duration:1.5];
    }
}

-(void)createNOdataView{
    [self.view configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有电子发票哦", nil) hasData:(_arr_ShowData.count!=0) hasError:NO reloadButtonBlock:nil];
}

-(void)requestBaiWangGetInvoiceListv2{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * dict = @{@"AccessToken":_str_AccountToken,@"AccountType":_str_AccountType,@"AccountNo":_str_AccountNo,@"InvoiceTitle":@"",@"StartDate":_txf_StateTime.text,@"EndDate":_txf_EndTime.text};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",BaiWangGetInvoiceListv2] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - action
//搜索点击
- (IBAction)btn_Search_Click:(id)sender {
    if (![NSString isEqualToNull:_txf_StateTime.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入开始时间", nil) duration:1.5];
        return;
    }
    if (![NSString isEqualToNull:_txf_EndTime.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入结束时间", nil) duration:1.5];
        return;
    }
    [self requestBaiWangGetInvoiceListv2];
}
//开始时间
- (IBAction)btn_StateTime_Click:(id)sender {
    if (![NSString isEqualToNull:_txf_StateTime.text]) {
        NSDate *date = [NSDate date];
        _txf_StateTime.text = [NSString stringWithDate:date];
    }
    _txf_StateTime.text = [_txf_StateTime.text substringToIndex:10];
    _dap_StateTime = [[UIDatePicker alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *fromdate=[format dateFromString:_txf_StateTime.text];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    _dap_StateTime.date=fromDate;
    _dap_StateTime.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    _dap_StateTime.datePickerMode = UIDatePickerModeDate;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=Custing(@"日期",nil);
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    sureDataBtn.tag = 11;
    [view addSubview:sureDataBtn];
    __weak typeof(self) weakSelf = self;
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:nil delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:cancelDataBtn];
    [cancelDataBtn bk_whenTapped:^{
        [weakSelf.cho_Date remove];
        weakSelf.dap_StateTime = nil;
        weakSelf.cho_Date = nil;
    }];
    if (!_cho_Date) {
        _cho_Date = [[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, 0, _dap_StateTime.frame.size.height+40) pickerView:_dap_StateTime titleView:view];
        _cho_Date.delegate = self;
    }
    [_cho_Date showUpView:_dap_StateTime];
    [_cho_Date show];
}
//结束时间
- (IBAction)btn_EndTime_Click:(id)sender {
    if (![NSString isEqualToNull:_txf_EndTime.text]) {
        NSDate *date = [NSDate date];
        _txf_EndTime.text = [NSString stringWithDate:date];
    }
    _txf_EndTime.text = [_txf_EndTime.text substringToIndex:10];
    _dap_StateTime = [[UIDatePicker alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *fromdate=[format dateFromString:_txf_EndTime.text];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    _dap_StateTime.date=fromDate;
    _dap_StateTime.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    _dap_StateTime.datePickerMode = UIDatePickerModeDate;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=Custing(@"日期",nil);
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    sureDataBtn.tag = 12;
    [view addSubview:sureDataBtn];
    __weak typeof(self) weakSelf = self;
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:nil delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:cancelDataBtn];
    [cancelDataBtn bk_whenTapped:^{
        [weakSelf.cho_Date remove];
        weakSelf.dap_StateTime = nil;
        weakSelf.cho_Date = nil;
    }];
    if (!_cho_Date) {
        _cho_Date = [[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, 0, _dap_StateTime.frame.size.height+40) pickerView:_dap_StateTime titleView:view];
        _cho_Date.delegate = self;
    }
    [_cho_Date showUpView:_dap_StateTime];
    [_cho_Date show];
}

-(void)btn_Click:(UIButton *)btn{
    if (btn.tag == 11) {
        NSDate * pickerDate = [_dap_StateTime date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString * str = [pickerFormatter stringFromDate:pickerDate];
        
        _txf_StateTime.text = str;
        _dap_StateTime = nil;
        [_cho_Date remove];
        _cho_Date = nil;
        if ([NSString datebydays:_txf_EndTime.text date2:_txf_StateTime.text]<=0) {
            _txf_EndTime.text = _txf_StateTime.text;
        }
    }
    if (btn.tag == 12) {
        NSDate * pickerDate = [_dap_StateTime date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString * str = [pickerFormatter stringFromDate:pickerDate];
        
        _txf_EndTime.text = str;
        _dap_StateTime = nil;
        [_cho_Date remove];
        _cho_Date = nil;
        if ([NSString datebydays:_txf_EndTime.text date2:_txf_StateTime.text]<=0) {
            _txf_EndTime.text = _txf_StateTime.text;
        }
    }
}

#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        if ([NSString isEqualToNull:error]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        return;
    }
    if (serialNum == 0) {
        if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
            _arr_ShowData = responceDic[@"result"];
            if (_arr_ShowData.count>0) {
                [_tbv_TableView reloadData];
            }
            [self createNOdataView];
        }
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr_ShowData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    bwInvoiceShowTableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!Cell) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"bwInvoiceShowTableViewCell" owner:self options:nil];
        Cell = [arr lastObject];
    }
    NSDictionary *dic = _arr_ShowData[indexPath.row];
    Cell.lab_JSHJ.text = [NSString isEqualToNull:dic[@"jshj"]]?dic[@"jshj"]:@"";
    Cell.lab_kpxm.text = [NSString isEqualToNull:dic[@"kpxm"]]?dic[@"kpxm"]:@"";
    Cell.lab_XSF_MC.text = [NSString isEqualToNull:dic[@"xsF_MC"]]?dic[@"xsF_MC"]:@"";
    Cell.lab_KPRQ.text = [NSString isEqualToNull:dic[@"kprq"]]?[NSString stringWithDateBystring:dic[@"kprq"]]:@"";
    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _arr_ShowData[indexPath.row];
    EXInvoicedViewController *ex = [[EXInvoicedViewController alloc]init];
    ex.int_Type = 2;
    ex.dic_bwInvoice = dic;
    ex.str_AccountNo = _str_AccountNo;
    ex.str_AccountType = _str_AccountType;
    ex.str_fplx = dic[@"fplx"];
    [self.navigationController pushViewController:ex animated:YES];
}

-(void)dimsissPDActionView{
    _cho_Date = nil;
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
