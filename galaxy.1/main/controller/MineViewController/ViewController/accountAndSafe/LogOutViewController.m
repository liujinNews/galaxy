//
//  LogOutViewController.m
//  galaxy
//
//  Created by APPLE on 2020/1/17.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "LogOutViewController.h"
#import "MainLoginViewController.h"
#import "RootWebViewController.h"

@interface LogOutViewController ()<GPClientDelegate>

@end

@implementation LogOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:Custing(@"注销账户", nil) backButton:YES];

    [self createMainView];
    
}
- (void)createMainView{
    self.view.backgroundColor = Color_White_Same_20;
    float w_Ratio = Main_Screen_Width/375.0;
    
    float gap15 = 15*w_Ratio;
    float gap30 = 30*w_Ratio;
    float diameter = 60*w_Ratio;
    float gap5 = 5*w_Ratio;
    //detail
    float detail_Back_H = 0.0;
    UIView *detailBackView = [[UIView alloc] initWithFrame:CGRectMake(0, gap15, Main_Screen_Width, detail_Back_H)];
    detailBackView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:detailBackView];
    //警告视图⚠️
    UIImageView *alertImageV = [[UIImageView alloc]init];
    alertImageV.frame = CGRectMake((Main_Screen_Width - diameter)/2.0, gap30, diameter, diameter);
    alertImageV.clipsToBounds = YES;
    alertImageV.layer.cornerRadius = diameter/2.0;
    alertImageV.image = [UIImage imageNamed:@"alertMark"];
    [detailBackView addSubview:alertImageV];
    
    //lab1
    userData *userdatas=[userData shareUserData];
    NSString *numberString;
    if (userdatas.logName.length >= 8) {
        numberString = [userdatas.logName stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"****"];
        NSLog(@"%@--%@",userdatas.logName,numberString);
    }else{
        numberString = [userdatas.logName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        NSLog(@"%@--%@",userdatas.logName,numberString);
    }
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(alertImageV)+3*gap5, Main_Screen_Width, 2*gap15)];
    NSString *text1 = [NSString stringWithFormat:@"%@%@%@",Custing(@"将", nil),numberString,Custing(@"所绑定的账号注销", nil)];
    lab1.text = text1;
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:20*w_Ratio weight:10*w_Ratio];
    lab1.textColor = Color_CellDark_Same_28;
    [detailBackView addSubview:lab1];
    //lab2
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(gap15, MaxY(lab1)+gap15, Main_Screen_Width-2*gap15, 120*w_Ratio)];
    NSString *text2 = Custing(@"注销账号后将无法使用喜报销的任何服务，以下信息也将无法查看和找回:企业信息、申请单信息、审批单信息、未提交费用、单点登录至第三方服务商等功能。", nil);
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:text2];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:10*w_Ratio];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [text2 length])];
    lab2.attributedText = attributedString2;
    lab2.text = text2;
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.numberOfLines = 0;
    lab2.font = [UIFont systemFontOfSize:15*w_Ratio];
    lab2.textColor = Color_CellDark_Same_28;
    [detailBackView addSubview:lab2];
    
    detail_Back_H = MaxY(lab2) + gap15;
    detailBackView.frame = CGRectMake(0, gap15, Main_Screen_Width, detail_Back_H);
    
  //消息视图
    float new_back_H = 0.0;
    UIView *newBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(detailBackView)+gap15, Main_Screen_Width, new_back_H)];
    newBackView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:newBackView];
  //消息视图💡
    UIImageView *newImageV = [[UIImageView alloc]init];
    newImageV.frame = CGRectMake(0, 0, 2*gap5, 2.6*gap5);
    newImageV.center = CGPointMake(4*gap5, 4.5*gap5);
    newImageV.image = [UIImage imageNamed:@"prompt"];
    [newBackView addSubview:newImageV];
      
    //new_Lab1
    UILabel *new_Lab1 = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(newImageV)+gap5, gap15, 100, gap15)];
    NSString *new_Text1 = Custing(@"提示：", nil);
    new_Lab1.text = new_Text1;
    new_Lab1.textAlignment = NSTextAlignmentLeft;
    new_Lab1.font = Font_Same_12_20;
    new_Lab1.textColor = Color_GrayDark_Same_20;
    [newBackView addSubview:new_Lab1];
    //new_Lab2
    UILabel *new_Lab2 = [[UILabel alloc] initWithFrame:CGRectMake(gap15, MaxY(new_Lab1)+gap5, Main_Screen_Width-2*gap15, 2*gap30)];
    NSString *new_Text2 = Custing(@"请在注销账号前确保当前账号与公司相关信息已经处理完毕，账户删除后将无法恢复和继续处理相关任务。", nil);
    NSMutableAttributedString *new_Text2_attributedString = [[NSMutableAttributedString alloc] initWithString:new_Text2];
    NSMutableParagraphStyle *new_Text2_paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [new_Text2_paragraphStyle setLineSpacing:10*w_Ratio];
    [new_Text2_attributedString addAttribute:NSParagraphStyleAttributeName value:new_Text2_paragraphStyle range:NSMakeRange(0, [new_Text2 length])];
    new_Lab2.attributedText = new_Text2_attributedString;
    new_Lab2.text = new_Text2;
    new_Lab2.textAlignment = NSTextAlignmentLeft;
    new_Lab2.numberOfLines = 0;
    new_Lab2.font = [UIFont systemFontOfSize:12*w_Ratio];
    new_Lab2.textColor = Color_GrayDark_Same_20;
    [newBackView addSubview:new_Lab2];
      
    new_back_H = MaxY(new_Lab2) + gap15;
    newBackView.frame = CGRectMake(0, MaxY(detailBackView)+gap15, Main_Screen_Width, new_back_H);
    
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //那么导航栏+状态栏的高度
    float sta_nav_H = statusRect.size.height+navRect.size.height;
    
    //nextBtn
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextBtn setTitle:Custing(@"注销账户", nil) forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:Color_Blue_Important_20];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15.f weight:5*w_Ratio];
    [nextBtn setTitleColor:Color_White_Same_20 forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(0, Main_Screen_Height-sta_nav_H-9*gap5, Main_Screen_Width, 9*gap5)];
    [nextBtn addTarget:self action:@selector(nextStepLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}
- (void)nextStepLogout:(UIButton *)sender{

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:Custing(@"您确定要注销账户吗？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:Custing(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:Custing(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf logOutRequest];
    }];
    [alertC addAction:cancleAction];
    [alertC addAction:logoutAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
-(void)logOutRequest{
    userData *userDatas = [userData shareUserData];
    NSString *userId =[NSString isEqualToNull:userDatas.userId]?[NSString stringWithFormat:@"%@",userDatas.userId]:@"";
    NSDictionary *parameters = @{@"UserId":userId};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",logoutRequest] Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        //        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        //        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    if (serialNum == 4) {
        [self logout];
    }
    
    switch (serialNum) {
        case 0://
            
            break;
           
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

- (void)logout{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                               
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
                                 
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
            
        [UMessage removeAlias:self.userdatas.userId type:@"GalaxyPoint" response:^(id responseObject, NSError *error) {
        }];
        if (self.userdatas.SystemType==1) {
            self.userdatas.SystemType=0;
            self.userdatas.SystemUserId=@"";
            self.userdatas.SystemToken=@"";
            self.userdatas.SystemRequestor = @"";
            self.userdatas.SystemRequestorDept = @"";
            [self.userdatas storeUserInfo];
            self.userdatas.RefreshStr = @"YES";
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[self.userdatas.language isEqualToString:@"ch"]?@"zh-Hans":@"en"] forKey:AppLanguage];
            [NSUserDefaults standardUserDefaults];
                
            [ApplicationDelegate setupTabViewController];
        }else{
//            self.userdatas.sig = @"";
            self.userdatas.password = @"";
            [self.userdatas storeUserInfo];
            if (![self.userdatas.experience isEqualToString:@"YES"]) {
                MainLoginViewController * login = [[MainLoginViewController alloc]init];
                login.isGoLoginView = 1;
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            }else{
                MainLoginViewController *firs = [[MainLoginViewController alloc]init];
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:firs];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            }
        }
}
-(void)clearCacheSuccess{
    
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
