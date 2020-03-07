//
//  AttendanceInfoViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendanceInfoViewController.h"

@interface AttendanceInfoViewController ()<GPClientDelegate>

@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UILabel *lab_late;
@property (nonatomic, strong) UILabel *lab_absent;
@property (nonatomic, strong) UILabel *lab_missing;
@property (nonatomic, strong) UILabel *lab_leaveEarly;
@property (nonatomic, strong) UILabel *lab_days;
@property (nonatomic, strong) NSDictionary *dic_request;

@end

@implementation AttendanceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"我的考勤", nil) backButton:YES];
    self.view.backgroundColor = Color_White_Same_20;
    [self requestAttendanceGetAttendanceRpt];
    [self createMainView];
}

#pragma mark - function
-(void)createMainView{
    _lab_date = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-60, 0, 120, 44) text:[NSString stringWithYearOnMonth:[NSDate date]] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_lab_date];
    __weak typeof(self) weakSelf = self;
    UIButton *btn = [GPUtils createButton:CGRectMake(Main_Screen_Width/2-90, 13, 18, 18) action:nil delegate:nil normalImage:[UIImage imageNamed:@"skipImage_against"] highlightedImage:nil];
    [btn bk_whenTapped:^{
        weakSelf.lab_date.text = [NSString stringWithStringYearOnMonth:weakSelf.lab_date.text];
        [weakSelf requestAttendanceGetAttendanceRpt];
    }];
    [self.view addSubview:btn];
    
    UIButton *btn_right = [GPUtils createButton:CGRectMake(Main_Screen_Width/2+72, 13, 18, 18) action:nil delegate:nil normalImage:[UIImage imageNamed:@"skipImage"] highlightedImage:nil];
    [btn_right bk_whenTapped:^{
        weakSelf.lab_date.text = [NSString stringWithAddStringYearOnMonth:weakSelf.lab_date.text];
        [weakSelf requestAttendanceGetAttendanceRpt];
    }];
    [self.view addSubview:btn_right];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, Main_Screen_Width, 275)];
    view.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view];
    
    UIImageView *img_back = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width/2-86, 50, 172, 90) imageName:@"Attendance_Statement"];
    [view addSubview:img_back];
    
    _lab_days = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-60, 80, 120, 30) text:@"0" font:Font_Amount_21_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:_lab_days];
    
    UILabel *lab_title = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-60, 110, 120, 30) text:Custing(@"出勤(天)", nil) font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab_title];
    
    [view addSubview:[self createLineViewOfHeight:190]];
    
    _lab_late = [GPUtils createLable:CGRectMake(0, 205, Main_Screen_Width/3, 30) text:@"0" font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:_lab_late];
    UILabel *lab_late_title = [GPUtils createLable:CGRectMake(0, 235, Main_Screen_Width/3, 25) text:Custing(@"迟到", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab_late_title];
    
    _lab_leaveEarly = [GPUtils createLable:CGRectMake(Main_Screen_Width/3, 205, Main_Screen_Width/3, 30) text:@"0" font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:_lab_leaveEarly];
    UILabel *lab_leaveEarly_title = [GPUtils createLable:CGRectMake(Main_Screen_Width/3, 235, Main_Screen_Width/3, 25) text:Custing(@"早退", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab_leaveEarly_title];
    
    _lab_missing = [GPUtils createLable:CGRectMake(Main_Screen_Width/3*2, 205, Main_Screen_Width/3, 30) text:@"0" font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:_lab_missing];
    UILabel *lab_missing_title = [GPUtils createLable:CGRectMake(Main_Screen_Width/3*2, 235, Main_Screen_Width/3, 25) text:Custing(@"缺卡", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab_missing_title];
    
//    _lab_absent = [GPUtils createLable:CGRectMake(Main_Screen_Width/4*3, 205, Main_Screen_Width/4, 30) text:@"0" font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
//    [view addSubview:_lab_absent];
//    UILabel *lab_absent_title = [GPUtils createLable:CGRectMake(Main_Screen_Width/4*3, 235, Main_Screen_Width/4, 25) text:Custing(@"旷工", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
//    [view addSubview:lab_absent_title];
}

-(void)updateViewData{
    _lab_days.text = [NSString stringWithIdOnNO:_dic_request[@"result"][@"days"]];
    _lab_late.text = [NSString stringWithIdOnNO:_dic_request[@"result"][@"late"]];
//    _lab_absent.text = [NSString stringWithIdOnNO:_dic_request[@"result"][@"absent"]];
    _lab_missing.text = [NSString stringWithIdOnNO:_dic_request[@"result"][@"missing"]];
    _lab_leaveEarly.text = [NSString stringWithIdOnNO:_dic_request[@"result"][@"leaveEarly"]];
    if ([_lab_late.text isEqualToString:@"0"]) {
        _lab_late.textColor = Color_LineGray_Same_20;
    }else{
        _lab_late.textColor = Color_Orange_Weak_20;
    }
//    if ([_lab_absent.text isEqualToString:@"0"]) {
//        _lab_absent.textColor = Color_LineGray_Same_20;
//    }else{
//        _lab_absent.textColor = Color_Orange_Weak_20;
//    }
    if ([_lab_missing.text isEqualToString:@"0"]) {
        _lab_missing.textColor = Color_LineGray_Same_20;
    }else{
        _lab_missing.textColor = Color_Orange_Weak_20;
    }
    if ([_lab_leaveEarly.text isEqualToString:@"0"]) {
        _lab_leaveEarly.textColor = Color_LineGray_Same_20;
    }else{
        _lab_leaveEarly.textColor = Color_Orange_Weak_20;
    }
}

#pragma mark  data
- (void)initializeData{
    _dic_request = [NSDictionary dictionary];
}

#pragma mark network
-(void)requestAttendanceGetAttendanceRpt{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",AttendanceGetAttendanceRpt];
    NSDictionary *parameters = @{@"TimeCardDate":_lab_date.text};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}



#pragma mark - Delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:error]?error:Custing(@"网络请求失败", nil) duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self updateViewData];
    }
//    if (serialNum == 1) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"打卡成功", nil) duration:1.5];
//        [self performBlock:^{
//            [self requestAttendanceGetAttendance];
//        } afterDelay:1.5];
//    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
