//
//  WeChatinvoiceViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/9/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "WeChatinvoiceViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WXApi.h"

@interface WeChatinvoiceViewController ()<WXApiManagerDelegate,GPClientDelegate>
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *api_ticket;

@end

@implementation WeChatinvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"微信发票" backButton:YES];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"微信", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(rightBtn_Click)];
    [WXApiManager sharedManager].delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}
-(void)rightBtn_Click{
    
    if ([WXApi isWXAppInstalled]) {
        [self getAccessToken];
    }else{
        [UIAlertView bk_showAlertViewWithTitle:@"请安装微信" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
    
}
-(void)getAccessToken{
    NSString *url=@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential";
    NSDictionary *parameters = @{@"appid":(NSString *)WeChatKey,@"secret":(NSString *)WeChatSecret};
    [[GPClient shareGPClient]REquestByGetWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
-(void)getApiTicket{
    NSString *url=@"https://api.weixin.qq.com/cgi-bin/ticket/getticket?type=wx_card";
    NSDictionary *parameters = @{@"access_token":_access_token};
    [[GPClient shareGPClient]REquestByGetWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    if ([NSString isEqualToNullAndZero:responceDic[@"errcode"]]){
        if (responceDic[@"errmsg"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",responceDic[@"errmsg"]] duration:2.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([NSString isEqualToNull:responceDic[@"access_token"]]){
                _access_token=[NSString stringWithFormat:@"%@",responceDic[@"access_token"]];
                [self getApiTicket];
            }
        }
            break;
        case 1:
        {
            if ([NSString isEqualToNull:responceDic[@"ticket"]]){
                _api_ticket=[NSString stringWithFormat:@"%@",responceDic[@"ticket"]];
                [self gotoWeChat];
            }
        }
            break;
            
        default:
            break;
    }
    
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}

-(void)gotoWeChat{
    NSString *nonceStr=@"LrVEbFwVXE0Rprb6";
    NSString *cardType=@"INVOICE";
    UInt32 timestamps=[[GPUtils getTimeStamp] intValue];
    NSLog(@"%@",[NSString stringWithFormat:@"%u%@%@%@%@",(unsigned int)timestamps,cardType,_api_ticket,nonceStr,(NSString *)WeChatKey]);
    NSString *cardSign=[GPUtils sha1:[NSString stringWithFormat:@"%u%@%@%@%@",(unsigned int)timestamps,cardType,_api_ticket,nonceStr,(NSString *)WeChatKey]];
    [WXApiRequestHandler chooseInvoice:(NSString *)WeChatKey
                              cardSign:cardSign
                              nonceStr:nonceStr
                              signType:@"SHA1"
                             timestamp:timestamps];
}
- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXInvoiceItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@, encryptCode:%@, appId:%@\n",cardItem.cardId,cardItem.encryptCode,cardItem.appID]];
    }
    [UIAlertView bk_showAlertViewWithTitle:@"choose invoice resp" message:cardStr cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {

    }];

    WXInvoiceItem* cardItem=response.cardAry[0];
    NSString *url=[NSString stringWithFormat:@"%@?access_token=%@",@"https://api.weixin.qq.com/card/invoice/reimburse/getinvoiceinfo",_access_token];
    NSDictionary *par=@{@"card_id":cardItem.cardId,@"encrypt_code":cardItem.encryptCode};
    [[GPClient shareGPClient]RequestByPostWithPath:url Parameters:par Delegate:self SerialNum:5 IfUserCache:NO];

    
}

//- (void)managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)response
//{
//    NSString *strTitle = [NSString stringWithFormat:@"LaunchMiniProgram结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"errMsg:%@,errcode:%d", response.extMsg, response.errCode];
//    [UIAlertView bk_showAlertViewWithTitle:strTitle message:strMsg cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        
//    }];
//}

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
