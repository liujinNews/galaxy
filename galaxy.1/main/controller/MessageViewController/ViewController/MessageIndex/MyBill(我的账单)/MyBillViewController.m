//
//  MyBillViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MyBillViewController.h"
#import "MyBillTableViewCell.h"
#import "BillBorrowingViewController.h"
#import "BillPayViewController.h"

@interface MyBillViewController ()<GPClientDelegate>

@property (strong, nonatomic)  UIView *view_borrowing;

@property (strong, nonatomic)  UIView *view_pay;


@property (strong, nonatomic)  UIScrollView *scr_scrollview;

@property (nonatomic, strong) NSDictionary *dic_borrowing;
@property (nonatomic, strong) NSDictionary *dic_pay;

@property (nonatomic, assign) NSInteger height;

@end

@implementation MyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"我的账单", nil) backButton:YES];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self addmainview];
    [self requestGetMyLoanList];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - function
//创建视图
-(void)addmainview
{
    _scr_scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    _scr_scrollview.backgroundColor = Color_White_Same_20;
    [self.view addSubview: _scr_scrollview];
}

-(void)updateBorrowingView
{
    _view_borrowing = [[UIView alloc]initWithFrame:CGRectMake(15, 10, Main_Screen_Width-30, 90)];
    _view_borrowing.backgroundColor = Color_form_TextFieldBackgroundColor;
    _view_borrowing.layer.shadowOffset = CGSizeMake(0, 1);
    _view_borrowing.layer.shadowOpacity = 0.25;
    _view_borrowing.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    _view_borrowing.layer.shadowOffset = CGSizeMake(2, 2);
    _view_borrowing.layer.cornerRadius = 15;
    
    UIImageView *borrowicon = [GPUtils createImageViewFrame:CGRectMake(15, 17.5, 4, 15) imageName:@"Approve_blue"];
    [_view_borrowing addSubview:borrowicon];
    
    UILabel *lab_titlename = [GPUtils createLable:CGRectMake(28, 15, 200, 20) text:Custing(@"我的借款", nil)  font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_view_borrowing addSubview:lab_titlename];
    
    _view_dateview = [[UIView alloc]initWithFrame:CGRectMake(8, 45, Main_Screen_Width-46, 0)];
    
    NSArray *array = _dic_borrowing[@"result"][@"loanList"];
    _height = -16;
    NSString *text;
//    for (int i = 0; i<array.count; i++) {
//        NSDictionary *dic = array[i];
//        if (i==0) {
//            text = [NSString stringWithFormat:@"%@%@%@%@%@",Custing(@"小主,您",nil),dic[@"requestorDate"],Custing(@"日从公司预支",nil),[GPUtils transformNsNumber:dic[@"amount"]],Custing(@"元_",nil)];
//        }
//        else
//        {
//            text = [NSString stringWithFormat:@"%@%@%@%@",Custing(@"你的",nil),[GPUtils transformNsNumber:dic[@"amount"]],Custing(@"元款项预支在",nil) ,dic[@"requestorDate"]];
//        }
//        UILabel *lab = [GPUtils createLable:CGRectMake(8, _height, Main_Screen_Width-60, 14) text:text font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//        [_view_dateview addSubview:lab];
//        _height = _height+22;
//    }
    if (array.count>0) {
        _height = 0;
        NSDictionary *dic = array[0];
        text = [NSString stringWithFormat:@"%@%@%@%@%@",Custing(@"您",nil),dic[@"requestorDate"],Custing(@"日从公司预支",nil),[GPUtils transformNsNumber:dic[@"amount"]],Custing(@"元_",nil)];
        UILabel *lab = [GPUtils createLable:CGRectMake(8, _height, Main_Screen_Width-60, 18) text:text font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [_view_dateview addSubview:lab];
    }
    
    
    [_view_borrowing addSubview:_view_dateview];
    _view_dateview.frame = CGRectMake(X(_view_dateview), Y(_view_dateview), WIDTH(_view_dateview), _height);
    
    UILabel *lab_moneycound = [GPUtils createLable:CGRectMake(16, _height+60, Main_Screen_Width-60, 30) text:[NSString stringWithFormat:@"%@",Custing(@"没有待还借款", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_view_borrowing addSubview:lab_moneycound];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dic_borrowing[@"result"][@"debtAmount"]]]) {
        if ([_dic_borrowing[@"result"][@"debtAmount"] intValue]==0) {
            lab_moneycound.text = [NSString stringWithFormat:@"%@",Custing(@"没有待还借款", nil)];
        }
        else
        {
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",Custing(@"合计应还", nil),[GPUtils transformNsNumber:_dic_borrowing[@"result"][@"debtAmount"]],Custing(@"元，请及时归还给财务", nil)]];
            NSString *hai = Custing(@"合计应还", nil);
            NSString *yuan = Custing(@"元，请及时归还给财务", nil);
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:Color_Blue_Important_20 range:NSMakeRange(hai.length, AttributedStr.length-yuan.length - hai.length)];
            lab_moneycound.attributedText = AttributedStr;
        }
    }
    
    UIImageView *img_ling = [[UIImageView alloc]initWithFrame:CGRectMake(15, _height+100 , Main_Screen_Width-60, 0.5)];
    img_ling.backgroundColor = Color_GrayLight_Same_20;
    [_view_borrowing addSubview:img_ling];
    
    UILabel *lab_content = [GPUtils createLable:CGRectMake(15, _height+112, Main_Screen_Width-60, 20) text:Custing(@"查看详情", nil) font:Font_Important_15_20 textColor: Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_view_borrowing addSubview:lab_content];
    
    UIImageView *borrowicons = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-60, _height+112, 10, 16) imageName:@"ApproveRemind_Right"];
    [_view_borrowing addSubview:borrowicons];
    
    _view_borrowing.frame = CGRectMake(X(_view_borrowing), Y(_view_borrowing), WIDTH(_view_borrowing), 145+_height);
    [_scr_scrollview addSubview:_view_borrowing];
    
    UIButton *btn = [GPUtils createButton:_view_borrowing.frame action:@selector(btn_borrowing_click:) delegate:self];
    [_scr_scrollview addSubview:btn];
}

-(void)updatePayView
{
    _view_pay = [[UIView alloc]initWithFrame:CGRectMake(15, 170+_height, Main_Screen_Width-30, 170)];
    // 我的支出圆角
    _view_pay.layer.shadowOffset = CGSizeMake(0, 1);
    _view_pay.layer.shadowOpacity = 0.25;
    _view_pay.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    _view_pay.layer.shadowOffset = CGSizeMake(2, 2);
    _view_pay.layer.cornerRadius = 15;
    _view_pay.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UIImageView *borrowicons = [GPUtils createImageViewFrame:CGRectMake(15, 17.5, 4, 15) imageName:@"Approve_yellow"];
    [_view_pay addSubview:borrowicons];
    
    UILabel *lab_titlename = [GPUtils createLable:CGRectMake(28, 15, 200, 20) text:Custing(@"我的支出", nil)  font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_view_pay addSubview:lab_titlename];
    
    NSDate *Date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:Date];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSString *last = [NSString stringWithFormat:@"%@ %@ %@",Custing(@"小主，你的", nil),[NSString stringWithMonth:lastMonth],Custing(@"月份账单来啦！", nil)];
    if (![last isEqualToString:@"10"]) {
        last = [last stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    
    _lab_billtitle = [GPUtils createLable:CGRectMake(15, 45, Main_Screen_Width-60, 18) text:last font:Font_Important_15_20 textColor: Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_view_pay addSubview:_lab_billtitle];
    
    _lab_billdate = [GPUtils createLable:CGRectMake(15, 70, Main_Screen_Width-60, 15) text:[NSString stringWithFormat:@"%@01",[[NSString stringWithDate:[NSDate date]] substringToIndex:8]] font:Font_Same_12_20 textColor: Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_view_pay addSubview:_lab_billdate];
    
    CGSize size_money = [NSString sizeWithText:[NSString stringWithFormat:@"%@：",Custing(@"费用总额", nil)] font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *lab_moneytitle= [GPUtils createLable:CGRectMake(15, 97, size_money.width, 20) text:[NSString stringWithFormat:@"%@：",Custing(@"费用总额", nil)] font:Font_Important_15_20 textColor: Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_view_pay addSubview:lab_moneytitle];
    
    _lab_moneycound = [GPUtils createLable:CGRectMake(20+size_money.width, 97, Main_Screen_Width-60, 20) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:_dic_pay[@"result"][@"totalAmount"]]] font:Font_Important_15_20 textColor: Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
    [_view_pay addSubview:_lab_moneycound];
    
    UIImageView *img_ling = [[UIImageView alloc]initWithFrame:CGRectMake(15, 125, Main_Screen_Width-60, 0.5)];
    img_ling.backgroundColor = Color_GrayLight_Same_20;
    [_view_pay addSubview:img_ling];
    
    UILabel *lab_content = [GPUtils createLable:CGRectMake(15, 137, Main_Screen_Width-60, 20) text:Custing(@"查看详情", nil) font:Font_Important_15_20 textColor: Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_view_pay addSubview:lab_content];
    
    UIImageView *borrowicon = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-60, 137, 10, 16) imageName:@"ApproveRemind_Right"];
    [_view_pay addSubview:borrowicon];
    
    [_scr_scrollview addSubview:_view_pay];
    
    UIButton *btn = [GPUtils createButton:_view_pay.frame action:@selector(btn_pay_click:) delegate:self];
    [_scr_scrollview addSubview:btn];
    
    _scr_scrollview.contentSize = CGSizeMake(Main_Screen_Width, _height+150+220);
}

//获取借款单据
-(void)requestGetMyLoanList
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetMyLoanList] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取费用账单
-(void)requestGetMyCostByMonth
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetMyCostByMonth] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}

#pragma mark - action
//借款点击
- (void)btn_borrowing_click:(id)sender {
    NSLog(@"借款点击");
    BillBorrowingViewController *bill = [[BillBorrowingViewController alloc]init];
    [self.navigationController pushViewController:bill animated:YES];
}

//支出点击
- (void)btn_pay_click:(id)sender {
    NSLog(@"支出点击");
    BillPayViewController *pay = [[BillPayViewController alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}


#pragma mark - 代理
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        [YXSpritesLoadingView dismiss];
        return;
    }
    if (serialNum == 0) {
        _dic_borrowing = responceDic;
        [self updateBorrowingView];
        [self requestGetMyCostByMonth];
        
    }else if (serialNum == 1) {
        _dic_pay = responceDic;
        [self updatePayView];
        [YXSpritesLoadingView dismiss];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
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
