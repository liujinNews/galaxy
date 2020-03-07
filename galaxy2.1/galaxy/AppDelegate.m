//
//  AppDelegate.m
//  galaxy
//
//  Created by 赵碚 on 15/7/22.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#define request_version   @"version"              //检查更新协议
#import "iflyMSC/IFlyMSC.h"

#import <UMSocialCore/UMSocialCore.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "userData.h"

#import "MainLoginViewController.h"
#import "StartViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import "RootTabViewController.h"
//#import "NewAddCostViewController.h"
#import "ApproveRemindViewController.h"
#import "MyUncaughtExceptionHandler.h"
#import "MyApproveViewController.h"
#import "MyApplyViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "AnnouncementLookController.h"
#import "TravelReqFormController.h"
#import "AFNetworkActivityIndicatorManager.h"




#define ISFISTRINSTALL @"ISFISTRINSTALL"

@interface AppDelegate ()<GPClientDelegate,UNUserNotificationCenterDelegate>

@property (strong,nonatomic)userData * datas;
@property (nonatomic,strong) NSDictionary *dic;

@property (nonatomic, copy)NSString *touchType;

//声明通知跳转事项
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *flowCode;
@property(nonatomic,strong)NSString *taskId;
@property(nonatomic,strong)NSString *procId;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *module;
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong)NSString *flowGuid;
@property(nonatomic,strong)NSString *pushController;//跳转未完成
@property(nonatomic,strong)NSString *pushHasController;//跳转已完成
@property(nonatomic,strong)NSString *pushAppoverEditController;//跳转已完成编辑

@property(nonatomic,strong)NSString *ApproveOrPay;//跳转审批或支付编辑页面


@end

@implementation AppDelegate

+(AppDelegate *)appDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}//

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    
    if (self.window == nil) {
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    userData *userdatas = [userData shareUserData];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    __block UIView *_view_Company = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.window addSubview:_view_Company];
    UIImageView *img = [[UIImageView alloc]initWithFrame:_view_Company.frame];
    [img setImage:[UIImage imageNamed:@"login_vector"]];
    [_view_Company addSubview:img];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-60, Main_Screen_Height/4-70, 120, 120)];
    image.contentMode = UIViewContentModeScaleAspectFit;
    if ([NSString isEqualToNull:userdatas.companyLogo]){
        NSDictionary *dic = [NSString dictionaryWithJsonString:userdatas.companyLogo];
        if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
        }
    }
    [_view_Company addSubview:image];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(15, Y(image)+150, Main_Screen_Width-30, 60) text:[NSString isEqualToNull:userdatas.company]?userdatas.company:Custing(@"全流程费用管控", nil) font:[NSString returnStringWidth:[NSString isEqualToNull:userdatas.company]?userdatas.company:Custing(@"全流程费用管控", nil) font:[UIFont systemFontOfSize:30.f]]>Main_Screen_Width-30?[UIFont systemFontOfSize:22.f]:[UIFont systemFontOfSize:30.f] textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentCenter];
    lab.numberOfLines = 0;
    [_view_Company addSubview:lab];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self isFirstInstall]) {
            [_view_Company removeFromSuperview];
            StartViewController *startVc = [[StartViewController alloc]init];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:@"aa" forKey:ISFISTRINSTALL];
            [userDef synchronize];
//            weakSelf.window.rootViewController = startVc;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:startVc];
            weakSelf.window.rootViewController = nav;
            //            [weakSelf.window makeKeyAndVisible];
        }else{
            [_view_Company removeFromSuperview];
            MainLoginViewController *vc=[[MainLoginViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
            weakSelf.window.rootViewController = nav;
            
        }
        
        self->_dic = [[NSDictionary alloc]init];
        if (launchOptions) {
            self->_dic =launchOptions[@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        }
        
        //网络
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        //友盟推送
        [UMConfigure setLogEnabled:YES];
        [UMConfigure initWithAppkey:(NSString *)UmengKey channel:nil];
        [UMessage openDebugMode:YES];
        //         Push's basic setting
        UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionAlert;
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
        [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        
        //注册SonicURLProtocol
        [NSURLProtocol registerClass:[SonicURLProtocol class]];
        
        
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:Color_White_Same_20] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        
        //MARK:导航页设置
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        //CFShow((__bridge CFTypeRef)(infoDic));
        NSString *curVer=[infoDic objectForKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@%@",@"TravelFirst",curVer]];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@%@",@"ReimburseFirst",curVer]];
    });
    return YES;
}

-(void)registerInfo{
    
    //友盟分享
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:(NSString *)UmengKey];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:(NSString *)WeChatKey appSecret:(NSString *)WeChatSecret redirectURL:@"http://a.xibaoxiao.com/share/"];
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:(NSString *)QQKey  appSecret:(NSString *)QQSecret redirectURL:@"http://a.xibaoxiao.com/share/"];
    //设置新浪的appKey和appSecret
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:(NSString *)SinaKey  appSecret:(NSString *)SinaSecret redirectURL:@"http://a.xibaoxiao.com/share/"];
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",(NSString *)IFlyKey];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
#pragma mark IM注册
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    preferredLang = [preferredLang substringToIndex:2];
    NSString * str;
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage];
    if (![NSString isEqualToNull:language]) {
        if ([preferredLang isEqualToString:@"zh-Hans-US"]||[preferredLang isEqualToString:@"zh-Hans"]||[preferredLang isEqualToString:@"zh-Hant-US"]||[preferredLang isEqualToString:@"zh-TW"]||[preferredLang isEqualToString:@"zh-HK"]||[preferredLang isEqualToString:@"zh-Hans-CN"]||[preferredLang isEqualToString:@"zh"]) {
            str = @"zh-Hans";
        }else{
            str = @"en";
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",str] forKey:AppLanguage];
        [NSUserDefaults standardUserDefaults];
    }
    
    //#pragma mark -- 崩溃日志
    //    [MyUncaughtExceptionHandler setDefaultHandler];
    //    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    //    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    //    if (data != nil) {
    //        [self sendExceptionLogWithData:data path:dataPath];
    //    }
    
#pragma mark -- 高德地图Key
    [AMapServices sharedServices].apiKey = (NSString *)AMapKey;
    
#pragma mark -- 微信发票
    //向微信注册
    [WXApi registerApp:(NSString *)WeChatKey enableMTA:YES];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    [WXApi registerAppSupportContentFlag:typeFlag];
    
}

// app 进前台时配置
- (void)configOnAppEnterForeground
{
    [UIApplication.sharedApplication.windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *w, NSUInteger idx, BOOL *stop) {
        if (!w.opaque && [NSStringFromClass(w.class) hasPrefix:@"UIText"]) {
            // The keyboard sometimes disables interaction. This brings it back to normal.
            BOOL wasHidden = w.hidden;
            w.hidden = YES;
            w.hidden = wasHidden;
            *stop = YES;
        }
    }];
}

//判断是否第一次安装
- (BOOL)isFirstInstall
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:ISFISTRINSTALL] == nil) {
        return YES;
    }
    return NO;
}
/*
 获取到用户对应当前应用程序的deviceToken时就会调用
 */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    if (![deviceToken isKindOfClass:[NSData class]]){
        return;
    }
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
//    [UMessage registerDeviceToken:deviceToken];
    
}
#pragma mark - 通知代理
/**
 *  当从APNs获取deviceToken失败的时候会回调该方法
 *  @param application 应用
 *  @param error       错误
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        [self dealNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        [self dealNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个

    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self dealNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}
-(void)dealNotification:(NSDictionary *)userInfo{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        return;
    }else{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            RootTabViewController*con = (RootTabViewController *)self.window.rootViewController;
            UINavigationController *view = con.childViewControllers[0];
            if (view != nil) {
                [self pushView:userInfo];
            }else{
                NSUserDefaults *userdefa = [NSUserDefaults standardUserDefaults];
                [userdefa setObject:userInfo forKey:@"push"];
                [userdefa synchronize];
            }
        }
    }
}
-(void)pushView:(NSDictionary *)userInfo{
    _status = @"0";
    _flowCode = @"0";
    _taskId = @"0";
    _procId = @"0";
    _userId = @"0";
    _companyId = @"0";
    _module=@"";
    _flowGuid = @"";
    
    _status = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"status"]];
    _flowCode = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"flowcode"]];
    _taskId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"taskid"]];
    _procId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"procid"]];
    _userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"userid"]];
    _module = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"module"]];
    _companyId =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"companyid"]]]?[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"companyid"]]:@"0";
    _flowGuid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"flowGuid"]];
    NSUserDefaults *userdefa = [NSUserDefaults standardUserDefaults];
    [userdefa removeObjectForKey:@"push"];
    NSDictionary *dict=@{@"status":_status,
                         @"flowCode":_flowCode,
                         @"taskId":_taskId,
                         @"procId":_procId,
                         @"userId":_userId,
                         @"module":_module,
                         @"companyId":_companyId,
                         @"flowGuid":_flowGuid,
                         };
    [self pushControllerByMess:dict];
}

-(void)pushControllerByMess:(NSDictionary *)dict{
    userData *userdatas = [userData shareUserData];
    if (![NSString isEqualToNull:userdatas.companyId]) {
        return;
    }
    NSString* status = [NSString stringWithFormat:@"%@",dict[@"status"]];
    NSString* flowCode = [NSString stringWithFormat:@"%@",dict[@"flowCode"]];
    NSString* taskId =[NSString stringWithFormat:@"%@",dict[@"taskId"]];
    NSString* procId = [NSString stringWithFormat:@"%@",dict[@"procId"]];
    NSString* userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
    NSString* module = [NSString stringWithFormat:@"%@",dict[@"module"]];
    NSString* companyId = [NSString stringWithFormat:@"%@",dict[@"companyId"]];
    NSString* flowGuid = [NSString stringWithFormat:@"%@",dict[@"flowGuid"]];
    NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:flowGuid][@"Title"];
    RootTabViewController*con =  (RootTabViewController *)self.window.rootViewController;
    UINavigationController *view = con.childViewControllers[0];
    if (view!=nil) {
        if ([view class]==[UINavigationController class]) {
            
            if ([[NSString stringWithFormat:@"%@",userdatas.companyId]isEqualToString:companyId]||![NSString isEqualToNullAndZero:companyId]) {
                if ([module isEqualToString:@"repayment"]) {
                    ApproveRemindViewController *approve = [[ApproveRemindViewController alloc]init];
                    [view pushViewController:approve animated:YES];
                }else if ([module isEqualToString:@"notices"]) {
                    AnnouncementLookController *vc=[[AnnouncementLookController alloc]init];
                    vc.str_LookId=[NSString isEqualToNull:taskId]?[NSString stringWithFormat:@"%@",taskId]:@"";
                    [view pushViewController:vc animated:YES];
                }else if ([module isEqualToString:@"demand"]) {
                    TravelReqFormController *vc=[[TravelReqFormController alloc]init];
                    [view pushViewController:vc animated:YES];
                }else{
                    if ([module isEqualToString:@"invoice"]) {
                        status=@"4";
                    }
                    NSDictionary *dict=[[VoiceDataManger sharedManager]getControllerNameWithFlowCode:flowCode];
                    _pushController=dict[@"pushController"];
                    _pushHasController=dict[@"pushHasController"];
                    _pushAppoverEditController=dict[@"pushAppoverEditController"];
                    if ([status isEqualToString:@"1"]||[status isEqualToString:@"100"]) {
                        _ApproveOrPay=status;
                        [self requestJudgeAppoverEditWithTaskId:taskId WithProcId:procId];
                    }else if ([status isEqualToString:@"2"]){
                        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:flowCode]) {
                            NSDictionary *dict1 = @{@"flowGuid":@"",@"taskId":taskId,@"procId":procId,@"token":userdatas.token,@"flowName":flowName,@"userId":userdatas.userId,@"pageType":@3};
                            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],_pushController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                            vc.str_flowCode = flowCode;
                            [view pushViewController:vc animated:YES];
                        }else{
                            Class cls = NSClassFromString(_pushController);
                            UIViewController *vc = [[cls alloc] init];
                            vc.pushTaskId=taskId;
                            vc.pushProcId=procId;
                            vc.pushFlowCode=flowCode;
                            vc.pushUserId=userId;
                            vc.pushComeStatus=@"3";
                            [view pushViewController:vc animated:YES];
                        }
                    }else{
                        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:flowCode]) {
                            NSDictionary *dict1 = @{@"cid":userdatas.companyId,@"token":userdatas.token,@"flowName":flowName,@"userId":userdatas.userId,@"rowData":@{@"taskId":taskId,@"procId":procId,@"flowGuid":@"",@"flowCode":flowCode,@"pageType":@1,@"canUrge":@0}};
                            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],_pushHasController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                            vc.str_flowCode = flowCode;
                            [view pushViewController:vc animated:YES];
                        }else{
                            Class cls = NSClassFromString(_pushHasController);
                            UIViewController *vc = [[cls alloc] init];
                            vc.pushTaskId=taskId;
                            vc.pushProcId=procId;
                            vc.pushFlowCode=flowCode;
                            vc.pushUserId=userId;
                            vc.pushComeStatus=@"5";
                            [view pushViewController:vc animated:YES];
                        }
                    }
                }
            }else{
                ApproveRemindViewController *approve = [[ApproveRemindViewController alloc]init];
                userdatas.multCompanyId=companyId;
                [view pushViewController:approve animated:YES];
            }
        }
    }
}

//MARK:审批人是否能编辑页面
-(void)requestJudgeAppoverEditWithTaskId:(NSString *)taskId WithProcId:(NSString *)procid{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",ApproverEdit];
    NSDictionary *parameters = @{@"ProcId":procid,@"TaskId": taskId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}


//MARK:发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSDictionary *parameters=@{@"ModuleName":@"IOS",@"Message":result};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_UploadError Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    switch (serialNum) {
        case 0://
        {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
            NSFileManager *fileManger = [NSFileManager defaultManager];
            [fileManger removeItemAtPath:dataPath error:nil];
        }
            break;
        case 4://
        {
            [self dealWithAppoverEditPay:[NSString isEqualToNull:responceDic[@"result"]]?[NSString stringWithFormat:@"%@",responceDic[@"result"]]:@"0" WithStatus: [_ApproveOrPay isEqualToString:@"1"]?1:2];
            
        }
            break;
        default:
            break;
    }
    
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    
}

//审批支付是否能编辑跳转
-(void)dealWithAppoverEditPay:(NSString *)comeEditType WithStatus:(NSInteger)ApprovePay{
    //isEdit   0不可编辑  1可编辑      //ApprovePay 1待审批  2待支付
    userData *userdatas = [userData shareUserData];
    RootTabViewController*con =  (RootTabViewController *)self.window.rootViewController;
    UINavigationController *view = con.childViewControllers[0];
    if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:_flowCode]) {
        NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:_flowGuid][@"Title"];
        
        NSDictionary *dict1 = @{@"cid":userdatas.companyId,@"token":userdatas.token,@"flowName":flowName,@"userId":userdatas.userId,@"rowData":@{@"taskId":_taskId,@"procId":_procId,@"flowGuid":@"",@"flowCode":_flowCode,@"pageType":ApprovePay == 1 ? @3:@4,@"canUrge":@0,@"isEditType":[NSNumber numberWithInteger:[comeEditType integerValue]]}};
        RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5Has],self.pushHasController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        vc.str_flowCode = _flowCode;
        [view.navigationController pushViewController:vc animated:YES];
        
    }else{
        Class cls;
        if ([comeEditType isEqualToString:@"1"]||[comeEditType isEqualToString:@"2"]||[comeEditType isEqualToString:@"3"]) {
            cls = NSClassFromString(self.pushAppoverEditController);
        }else{
            cls = NSClassFromString(self.pushHasController);
        }
        UIViewController *vc = [[cls alloc] init];
        vc.pushTaskId=_taskId;
        vc.pushProcId=_procId;
        vc.pushFlowCode=_flowCode;
        vc.pushUserId=_userId;
        vc.pushComeStatus=ApprovePay==1?@"3":@"4";
        vc.pushComeEditType=comeEditType;
        [view pushViewController:vc animated:YES];
    }
}


//#warning delete
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
    
    
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0){
    if ([url.host isEqualToString:@"apmqpdispatch"]) {
        [AFServiceCenter handleResponseURL:url withCompletion:^(AFServiceResponse *response) {
            if (AFResSuccess == response.responseCode) {
                NSLog(@"%@", response.result);
            }
        }];
        
    }else{
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        if (!result) {
            [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }
    return YES;
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    //    [BMKMapView willBackGround];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [YXSpritesLoadingView dismiss];
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return;
    }
    [[UnReadManager shareManager]updateUnRead];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    userData *data=[userData shareUserData];
    data.SystemType=0;
    data.SystemToken=@"";
    data.SystemUserId=@"";
    data.SystemRequestor = @"";
    data.SystemRequestorDept = @"";
    [data storeUserInfo];
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "BPM.galaxy" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"galaxy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"galaxy.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark - 3d tocuh

- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    self.touchType = shortcutItem.type;
    NSUserDefaults *userdefa = [NSUserDefaults standardUserDefaults];
    [userdefa setObject:shortcutItem.type forKey:@"3dtouch"];
    [userdefa synchronize];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        RootTabViewController*con = (RootTabViewController *)self.window.rootViewController;
        UINavigationController *view = con.childViewControllers[0];
        
        if (view!=nil) {
            if ([view class]==[UINavigationController class]) {
                NSString *touchtype = [[NSUserDefaults standardUserDefaults]objectForKey:@"3dtouch"];
                if ([NSString isEqualToNull:touchtype]) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"3dtouch"];
                    if ([touchtype isEqualToString:@"icon_1"]) {
                        //#warning NewAddCostViewController
                        //                        AddCostViewController * add = [[AddCostViewController alloc]initWithType:nil with:@"1" withPlace:@"home"];
                        NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
                        add.Action = 1;
                        add.Type = 1;
                        [view pushViewController:add animated:YES];
                    }else if ([touchtype isEqualToString:@"icon_3"]) {
                        MyApproveViewController * approval = [[MyApproveViewController alloc]initWithType:@"0"];
                        [view pushViewController:approval animated:YES];
                    }else if ([touchtype isEqualToString:@"icon_4"]) {
                        //我的申请
                        MyApplyViewController * myV = [[MyApplyViewController alloc]initWithType:@"1"];
                        [view pushViewController:myV animated:YES];
                    }
                }
            }
            
        }
    }
}

- (void)PushTo3d
{
    NSUserDefaults *userdefa = [NSUserDefaults standardUserDefaults];
    self.touchType = [userdefa objectForKey:@"3dtouch"];
    if ([NSString isEqualToNull:_touchType]) {
        UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
        RDVTabBarController *nav = (RDVTabBarController *)window.rootViewController;
        UINavigationController *view = nav.viewControllers[2];
        
        //        [[UIAlertView bk_alertViewWithTitle:[NSString stringWithFormat:@"%@",[window.rootViewController class]] message:[NSString stringWithFormat:@"%@",nav.viewControllers]]show];
        if (view!=nil) {
            if ([view class]==[UINavigationController class]) {
                NSString *touchtype = [[NSUserDefaults standardUserDefaults]objectForKey:@"3dtouch"];
                if ([NSString isEqualToNull:touchtype]) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"3dtouch"];
                    if ([touchtype isEqualToString:@"icon_1"]) {
                        NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
                        add.Action = 1;
                        add.Type = 1;
                        [view pushViewController:add animated:YES];
                    }else if ([touchtype isEqualToString:@"icon_3"]) {
                        MyApproveViewController * approval = [[MyApproveViewController alloc]initWithType:@"0"];
                        [view pushViewController:approval animated:YES];
                    }else if ([touchtype isEqualToString:@"icon_4"]) {
                        //我的申请
                        MyApplyViewController * myV = [[MyApplyViewController alloc]initWithType:@"1"];
                        [view pushViewController:myV animated:YES];
                    }
                }
            }
        }
    }
}

//禁止横屏
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)setupTabViewController{
    RootTabViewController *rootVC = [[RootTabViewController alloc] init];
    rootVC.tabBar.translucent =YES;
    [self.window setRootViewController:rootVC];
}




- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    }
    else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    else{
        UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
        RootTabViewController *nav = (RootTabViewController *)window.rootViewController;
        if ([[nav class]isEqual:[RootTabViewController class]]) {
            UINavigationController *navi = nav.childViewControllers[0];
            if ([[navi class]isEqual:[UINavigationController class]]) {
                return navi;
            }
        }
        
    }
    return nil;
}

- (UIViewController *)topViewController
{
    UINavigationController *nav = [self navigationViewController];
    return nav.topViewController;
}

-(void)AppTokenInvalid{
    MainLoginViewController * login = [[MainLoginViewController alloc]init];
    login.isGoLoginView = 1;
    login.isTokenInvalid = YES;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}



- (void)didReceiveMemoryWarning {
    NSLog(@"Dispose of any resources that can be recreated.");
    // Dispose of any resources that can be recreated.
}
@end
