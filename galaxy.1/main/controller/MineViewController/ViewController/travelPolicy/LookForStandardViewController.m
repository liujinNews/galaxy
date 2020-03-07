//
//  LookForStandardViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/7/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "LookForStandardViewController.h"

@interface LookForStandardViewController ()<GPClientDelegate>

@property (nonatomic, strong) NSString *str_stdType;
@property (nonatomic, strong) NSString *str_expenseCode;
@property (nonatomic, strong) NSDictionary *dic_request;

@end

@implementation LookForStandardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setTitle:_dic[@"expenseType"] backButton:YES];
    if (_dic!= nil) {
        _str_stdType = _dic[@"stdType"];
        _str_expenseCode = _dic[@"expenseCode"];
    }else{
        _str_stdType = @"";
        _str_expenseCode = @"";
    }
    
    [self requestGetStd];
}

-(void)createMainView:(NSInteger)number{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    scroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:scroll];
    NSInteger height = 0;
    if (number == 1) {
        NSDictionary *dic = _dic_request[@"result"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:[self createLineViewOfHeight:49.5]];
        UILabel *lab_content = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"标准费用%@元/公里",dic[@"amount"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:lab_content];
        [scroll addSubview:view];
        height = height + 50;
    }else{
        //飞机
        if (number == 3) {
            NSArray *arr = _dic_request[@"result"];
            for (int i =0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 50)];
                view.backgroundColor = [UIColor whiteColor];
                [view addSubview:[self createLineViewOfHeight:49.5]];
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab];
                UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@%@%@",Custing(@"最高",nil),[dic[@"class2"] integerValue] == 1?Custing(@"经济舱",nil):[dic[@"class2"] integerValue] ==2?Custing(@"商务舱",nil):Custing(@"头等舱",nil),Custing(@"折扣",nil),dic[@"discount"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab_content];
                [scroll addSubview:view];
                height = height + 50;
            }
        }else if (number == 2)
        {
            if ([NSString isEqualToNull:_dic_request[@"result"][@"basis"]]&&[_dic_request[@"result"][@"basis"] integerValue]==1) {
                NSArray *arr = _dic_request[@"result"][@"list"];
                for (int i =0; i<arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 50)];
                    view.backgroundColor = [UIColor whiteColor];
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab];
                    UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@/%@",Custing(@"最高",nil),dic[@"amount"],Custing(@"元",nil),dic[@"unitStr"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab_content];
                    [scroll addSubview:view];
                    height = height + 50;
                }
            }else{
                NSArray *arr = _dic_request[@"result"][@"list"];
                for (int i =0; i<arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 50)];
                        view.backgroundColor = [UIColor whiteColor];
                        [view addSubview:[self createLineViewOfHeight:49.5]];
                        UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab];
                        if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"所有城市，最高",nil),dic[@"housePrice1"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content];
                        }else{
                            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content];
                        }
                        [scroll addSubview:view];
                        height = height + 50;
                    }else{
                        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 150)];
                        view.backgroundColor = [UIColor whiteColor];
                        [view addSubview:[self createLineViewOfHeight:149.5]];
                        UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab];
                        if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"一线城市，最高",nil),dic[@"housePrice0"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content];
                            UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"二线城市，最高",nil),dic[@"housePrice2"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content1];
                            UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"三线城市，最高",nil),dic[@"housePrice3"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content2];
                            UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 90, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"港澳台，最高",nil),dic[@"housePrice4"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content3];
                            UILabel *lab_content4 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 120, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"国际城市，最高",nil),dic[@"housePrice5"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content4];
                        }else{
                            UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                            [view addSubview:lab_content];
                        }
                        [scroll addSubview:view];
                        height = height + 150;
                    }
                }
            }
        }else if (number == 0){
            NSArray *arr = _dic_request[@"result"];
            for (int i =0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                if ([NSString isEqualToNull:dic[@"standard"]]&&[dic[@"standard"] integerValue]==0) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 50)];
                    view.backgroundColor = [UIColor whiteColor];
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"所有城市，最高", nil),dic[@"housePrice1"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }
                    [scroll addSubview:view];
                    height = height + 50;
                }else{
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 150)];
                    view.backgroundColor = [UIColor whiteColor];
                    [view addSubview:[self createLineViewOfHeight:149.5]];
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"一线城市，最高",nil),dic[@"housePrice0"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                        UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"二线城市，最高",nil),dic[@"housePrice2"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content1];
                        UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"三线城市，最高",nil),dic[@"housePrice3"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content2];
                        UILabel *lab_content3 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 90, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"港澳台，最高",nil),dic[@"housePrice4"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content3];
                        UILabel *lab_content4 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 120, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"国际城市，最高",nil),dic[@"housePrice5"],Custing(@"元",nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content4];
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }
                    [scroll addSubview:view];
                    height = height + 150;
                }
            }
        }else if (number == 5){
            NSArray *arr = _dic_request[@"result"];
            for (int i =0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 50)];
                view.backgroundColor = [UIColor whiteColor];
                [view addSubview:[self createLineViewOfHeight:49.5]];
                UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab];
                UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@/%@",Custing(@"最高", nil),dic[@"amount"],Custing(@"元", nil),dic[@"unit"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                [view addSubview:lab_content];
                [scroll addSubview:view];
                height = height + 50;
            }
        }else if (number == 4){
            NSArray *arr = _dic_request[@"result"];
            for (int i =0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                if ([NSString isEqualToNull:dic[@"amount"]]&&[dic[@"amount"] integerValue]!=0) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 50)];
                    view.backgroundColor = [UIColor whiteColor];
                    [view addSubview:[self createLineViewOfHeight:49.5]];
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"全天最高", nil),dic[@"amount"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }
                    [scroll addSubview:view];
                    height = height + 50;
                }else{
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, Main_Screen_Width, 90)];
                    view.backgroundColor = [UIColor whiteColor];
                    [view addSubview:[self createLineViewOfHeight:89.5]];
                    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 30) text:Custing(dic[@"userLevel"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                    [view addSubview:lab];
                    if ([NSString isEqualToNull:dic[@"isLimit"]]&&[dic[@"isLimit"] integerValue]==1) {
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"早餐最高", nil),dic[@"amount1"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                        UILabel *lab_content1 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 30, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"午餐最高", nil),dic[@"amount2"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content1];
                        UILabel *lab_content2 = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 60, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"晚餐最高", nil),dic[@"amount3"],Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content2];
                    }else{
                        UILabel *lab_content = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 30) text:Custing(@"无限制", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                        [view addSubview:lab_content];
                    }
                    [scroll addSubview:view];
                    height = height + 90;
                }
                
            }
        }
        
    }
    scroll.contentSize = CGSizeMake(Main_Screen_Width, height);
}

-(void)requestGetStd {
    if ([_str_stdType isEqualToString:@"Hotel"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetHotelStandardUserLevel] Parameters:@{@"ExpCode":_str_expenseCode,@"StdType":_str_stdType} Delegate:self SerialNum:0 IfUserCache:NO];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    }else if ([_str_stdType isEqualToString:@"SelfDrive"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetStdSelfDrive] Parameters:@{@"ExpCode":_str_expenseCode,@"StdType":_str_stdType} Delegate:self SerialNum:1 IfUserCache:NO];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    }else if ([_str_stdType isEqualToString:@"Allowance"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetStdAllowanceList] Parameters:@{@"ExpCode":_str_expenseCode,@"StdType":_str_stdType} Delegate:self SerialNum:2 IfUserCache:NO];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    }else{
        if ([_str_stdType isEqualToString:@"Flight"]) {
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetStd] Parameters:@{@"ExpCode":_str_expenseCode,@"StdType":_str_stdType,@"Type":@1} Delegate:self SerialNum:3 IfUserCache:NO];
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        }else  if ([_str_stdType isEqualToString:@"Meals"]) {
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetStd] Parameters:@{@"ExpCode":_str_expenseCode,@"StdType":_str_stdType,@"Type":@2} Delegate:self SerialNum:4 IfUserCache:NO];
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        }else{
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetStd] Parameters:@{@"ExpCode":_str_expenseCode,@"StdType":_str_stdType,@"Type":@0} Delegate:self SerialNum:5 IfUserCache:NO];
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        }
    }
}

#define mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }else{
        _dic_request = responceDic;
        [self createMainView:serialNum];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
