//
//  MineViewController.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#define Color_yellow          [GPUtils colorHString:@"#ffb960"]//黄色
#define Color_blue          [GPUtils colorHString:@"#49d4ff"]//蓝色
#import "JoinInvitationViewController.h"
#import "switchCompanyViewController.h"
#import "normalComViewController.h"
#import "personDocViewController.h"
#import "companyAdSetViewController.h"
#import "financialOrgnViewController.h"
#import "accountAndSafeViewController.h"
#import "helpAndFeedbackViewController.h"
#import "MainLoginViewController.h"
#import "aboutViewController.h"
#import <UShareUI/UShareUI.h>
#import "mineTVCell.h"
#import "mineModel.h"
#import "MineViewController.h"
#import "LookBillInfoViewController.h"
#import "BillInfoListController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
//@property (nonatomic,strong)NSDictionary * persDic;
@property (nonatomic,strong)NSMutableArray * maArray;
@property (nonatomic,strong)UIView * footView;

@property(nonatomic,copy)NSString * shareTitle;    //分享标题头
@property(nonatomic,copy)NSString * shareContent;  //分享内容
@property(nonatomic,copy)NSString * shareUrl;      //分享地址

@property(nonatomic,strong)NSString * hiddenStr;
@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.hiddenStr = @"yes";
    if ([self.userdatas.RefreshStr isEqualToString:@"YES"]) {
        [self requestPower];
        [self requestPersonDocumentList];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView setContentOffset:CGPointMake(0, iPhoneX?-44:-20) animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userdatas.RefreshStr = @"YES";
    
    self.userdatas.mySystemStr = @"15";
    if (self.userdatas.SystemType == 1) {
        if (self.userdatas.source >= 11) {//第三方登录
            self.userdatas.mySystemStr = @"16";
        }else {
            self.userdatas.mySystemStr = @"12";
        }
        
    }else {
        if (self.userdatas.source >= 11) {//第三方登录
            self.userdatas.mySystemStr = @"15";
        }
    }
    
    self.maArray = [mineModel datasWithUser:self.userdatas.mySystemStr personDict:self.userdatas];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"我的", nil)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, iPhoneX? -44:-20, Main_Screen_Width, iPhoneX ? Main_Screen_Height-39:Main_Screen_Height-29)];
    
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        self.tableView.bounces = NO;
    }else {
        self.tableView.bounces = YES;
        if ([self.hiddenStr isEqualToString:@"yes"]) {
            if (scrollView.contentOffset.y  > 100.0) {
                self.navigationController.navigationBar.hidden = NO;
            }else{
                self.navigationController.navigationBar.hidden = YES;
            }
        }else {
            self.navigationController.navigationBar.hidden = NO;
        }
    }
   
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.maArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.maArray[section];
    return [itemArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==self.maArray.count-1) {
        return 0.0;
    }else{
        return 10.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == self.maArray.count-1) {
        return nil;
    }else{
        self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        self.footView.backgroundColor=[UIColor clearColor];
        return self.footView;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mineModel *cellInfo = self.maArray[indexPath.section][indexPath.row];
    return [cellInfo.height floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mineTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"mineTVCell"];
    if (cell==nil) {
        cell=[[mineTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineTVCell"];
    }
    mineModel *cellInfo = self.maArray[indexPath.section][indexPath.row];
    [cell configViewWithMineCellInfo:cellInfo];
    if (cellInfo.type == mineCellTypeInfo || cellInfo.type == mineCellTypeDelegateInfo) {
        [cell.avatorImage addTarget:self action:@selector(pushUserInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [cell.companyNameBtn addTarget:self action:@selector(pushSwitchCompany:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mineModel *cellInfo = self.maArray[indexPath.section][indexPath.row];
    if ([self respondsToSelector:cellInfo.action]) {
        [self performSelector:cellInfo.action withObject:nil afterDelay:0];
    }
    self.hiddenStr = @"no";
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//MARK:个人信息界面
-(void)pushUserInfomation:(UIButton *)btn {
    if ([self.userdatas.mySystemStr isEqualToString:@"12"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"代理模式不可进入", nil) duration:1.5];
        return;
    }
    self.hiddenStr = @"no";
    personDocViewController * person = [[personDocViewController alloc]init];
    [self.navigationController pushViewController:person animated:YES];
}

//MARK:切换公司
-(void)pushSwitchCompany:(UIButton *)btn {
    
    if ([self.userdatas.mySystemStr isEqualToString:@"12"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"代理模式不可进入", nil) duration:1.5];
        return;
    }
    self.hiddenStr = @"no";
    switchCompanyViewController * switchDic = [[switchCompanyViewController alloc]init];
    [self.navigationController pushViewController:switchDic animated:YES];
}

//MARK:企业通讯录设置
-(void)pushSetCompanyAdreesBookController{
    companyAdSetViewController * companyAd = [[companyAdSetViewController alloc]init];
//    companyAd.personDic = self.userdatas;
    [self.navigationController pushViewController:companyAd animated:YES];
}


//MARK:财务设置
-(void)pushSetFinanceController{
    financialOrgnViewController * financial = [[financialOrgnViewController alloc]init];
    [self.navigationController pushViewController:financial animated:YES];
}

-(void)pushNormalCompanyController {
    normalComViewController * normal = [[normalComViewController alloc]initWithType:@{}];
    [self.navigationController pushViewController:normal animated:YES];
    
}

-(void)pushCompanyInfo{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@", GetCoCardList];
    [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}



//分享数据
-(void)requestShareFriend{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",share] Parameters:nil Delegate:self SerialNum:5 IfUserCache:NO];
    
}

//MARK:邀请同事加入
-(void)pushInvitingColleaguesController{
    JoinInvitationViewController * invitation = [[JoinInvitationViewController alloc]init];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.userdatas.coCode]]) {
        invitation.corpId = [NSString stringWithFormat:@"%@",self.userdatas.coCode];
    }
    [self.navigationController pushViewController:invitation animated:YES];
}

//MARK:分享给好友
-(void)pushShareToFriendsController{
    [self requestShareFriend];
}


-(void)requestPushShareToFriendsController
{
    if ([self.userdatas.experience isEqualToString:@"YES"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前账号为体验账号，请登录后进行修改。", nil) duration:2.0];
        return;
    }
    if ([self.shareContent isKindOfClass:[NSNull class]] || self.shareContent == nil||!self.shareContent){
        self.shareContent = @"Hi，小伙伴们都在使用「喜报销」，简单实用的报销神器，赶快加入我们吧！";
    }
    //友盟分享
    
    self.hiddenStr = @"yes";
    self.navigationController.navigationBar.hidden = YES;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareContent thumImage:GPImage(@"shareAvatar.png")];
        //设置网页地址
        shareObject.webpageUrl = self.shareUrl;
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
             
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];
}

//MARK:帮助与反馈
-(void)pushHelpAndFeedbackController{
    
    helpAndFeedbackViewController * help = [[helpAndFeedbackViewController alloc]init];
    [self.navigationController pushViewController:help animated:YES];
}

//MARK:设置
-(void)pushTypeSetting {
    aboutViewController * aboutUs = [[aboutViewController alloc]init];
    [self.navigationController pushViewController:aboutUs animated:YES];
}


//MARK:退出登录
-(void)pushExitApplication{
    self.hiddenStr = @"yes";
    if (self.userdatas.SystemType == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:Custing(@"退出代理模式？", nil) delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:Custing(@"退出登录？", nil) delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
        [alert show];
    }
}



//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:Custing(@"确定", nil)]) {
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
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
        self.userdatas.password = @"";
        [self.userdatas storeUserInfo];
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
        }else if (![self.userdatas.experience isEqualToString:@"YES"]) {
            MainLoginViewController * login = [[MainLoginViewController alloc]init];
            login.isGoLoginView = 1;
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }else{
            MainLoginViewController *firs = [[MainLoginViewController alloc]init];
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:firs];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }
    }else if ([btnTitle isEqualToString:Custing(@"取消", nil)] ) {
//        NSLog(@"你点击了重新登录按钮");
    }
    
    
}

-(void)clearCacheSuccess
{
    //    NSLog(@"清理成功");
}


//MARK:请求权限
-(void)requestPower{
    
    NSString * systemString = [self.userdatas.userRole containsObject:@"2"] ? @"1":@"";
    NSString * financialString = [self.userdatas.userRole containsObject:@"4"] ? @"1":@"";
    if ([systemString isEqualToString:@"1"]) {
        self.userdatas.mySystemStr = @"10";
    }else if (![systemString isEqualToString:@"1"]&&[financialString isEqualToString:@"1"]){
        self.userdatas.mySystemStr = @"11";
    }else if (![systemString isEqualToString:@"1"]&&![financialString isEqualToString:@"1"]){
        self.userdatas.mySystemStr = @"13";
    }else{
        self.userdatas.mySystemStr = @"13";
    }
    [self.tableView reloadData];
}

-(void)requestPersonDocumentList{
    self.userdatas.RefreshStr = @"NO";
    
    if (self.userdatas.SystemType == 1) {
        if (self.userdatas.source >= 11) {//第三方登录
            self.userdatas.mySystemStr = @"16";
        }else {
            self.userdatas.mySystemStr = @"12";
        }
        
    }else {
        if (self.userdatas.source >= 11) {//第三方登录
            self.userdatas.mySystemStr = @"15";
        }
    }
    
    
    self.maArray = [mineModel datasWithUser:self.userdatas.mySystemStr personDict:self.userdatas];
    [self.tableView reloadData];
        
}

//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
//    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        [YXSpritesLoadingView dismiss];
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    
    if (serialNum ==5) {
        [YXSpritesLoadingView dismiss];
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }
        self.shareTitle = [NSString stringWithFormat:@"%@",[result objectForKey:@"shareTitle"]];
        self.shareContent = [NSString stringWithFormat:@"%@",[result objectForKey:@"shareContent"]];
        self.shareUrl = [NSString stringWithFormat:@"%@",[result objectForKey:@"shareTargetUrl"]];
        [self requestPushShareToFriendsController];
    }
    if (serialNum == 0) {
        if (![responceDic[@"result"] isKindOfClass:[NSNull class]]) {
            NSArray *arr=responceDic[@"result"];
            [YXSpritesLoadingView dismiss];
            if (arr.count==1) {
                NSDictionary *dict=arr[0];
                LookBillInfoViewController *look = [[LookBillInfoViewController alloc]init];
                look.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
                [self.navigationController pushViewController:look animated:YES];
            }else{
                BillInfoListController *vc=[[BillInfoListController alloc]init];
                vc.CanDeal=NO;
                vc.resultDict=responceDic;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    if (serialNum ==0) {
        
        self.userdatas.mySystemStr = @"15";
        if (self.userdatas.SystemType == 1) {
            if (self.userdatas.source >= 11) {//第三方登录
                self.userdatas.mySystemStr = @"16";
            }else {
                self.userdatas.mySystemStr = @"12";
            }
            
        }else {
            if (self.userdatas.source >= 11) {//第三方登录
                self.userdatas.mySystemStr = @"15";
            }
        }
        
        self.maArray = [mineModel datasWithUser:self.userdatas.mySystemStr personDict:self.userdatas];
        [self.tableView reloadData];
    }else{
        [YXSpritesLoadingView dismiss];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    }
    
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
