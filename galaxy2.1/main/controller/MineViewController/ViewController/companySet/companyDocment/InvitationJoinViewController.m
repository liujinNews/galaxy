//
//  InvitationJoinViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/28.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import<MessageUI/MessageUI.h>

#import "editCompanyData.h"
#import "InvitationJoinViewController.h"
#import "JQScanWrapper.h"
@interface InvitationJoinViewController ()<GPClientDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic,strong)NSMutableArray * messageArray;
@property (nonatomic,strong)NSString * InvitationStr;
@property (nonatomic,strong)NSString * InvitationUrl;
@property (nonatomic,strong)NSString * status;

@end

@implementation InvitationJoinViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
    }
    
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    if ([self.status isEqualToString:@"coSuccess"]) {
        self.navigationController.navigationBar.hidden = YES;
    }
    
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestInvitationJoin];
    [self setTitle:Custing(@"邀请同事加入", nil) backButton:YES];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton * weixinBtn = [GPUtils createButton:CGRectMake(0, 0, WIDTH(self.view)/2, 110) action:@selector(weixinInvitation:) delegate:self normalImage:nil highlightedImage:nil];
    weixinBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:weixinBtn];
    
    UIImageView * wxImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/4-21, 34, 42, 42)];
    wxImage.image = GPImage(@"my_invitationWX");
    [weixinBtn addSubview:wxImage];
    
    UILabel * weixinLa = [GPUtils createLable:CGRectMake(0, 80, WIDTH(self.view)/2, 25) text:Custing(@"微信", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    weixinLa.backgroundColor = [UIColor clearColor];
    [weixinBtn addSubview:weixinLa];

    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH(weixinBtn)-1, 30, 1, 50)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [weixinBtn addSubview:lineView];
    
    UIButton * duanxinBtn = [GPUtils createButton:CGRectMake(WIDTH(self.view)/2, 0, WIDTH(self.view)/2, 110) action:@selector(duanxinInvitation:) delegate:self normalImage:nil highlightedImage:nil];
    duanxinBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:duanxinBtn];
    
    UIImageView * dxImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/4-21, 34, 42, 42)];
    dxImage.image = GPImage(@"my_invitationDX");
    [duanxinBtn addSubview:dxImage];
    
    UILabel * duanxinLa = [GPUtils createLable:CGRectMake(0, 80, WIDTH(self.view)/2, 25) text:Custing(@"短信", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    duanxinLa.backgroundColor = [UIColor clearColor];
    [duanxinBtn addSubview:duanxinLa];
    // Do any additional setup after loading the view.
}

-(void)weixinInvitation:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    for (editCompanyData *model in self.messageArray) {
        if ([model.messageType isEqualToString:@"2"]) {
            self.InvitationStr = model.messageContent;
            self.InvitationUrl = model.messageUrl;
        }
    }
    
}

-(void)duanxinInvitation:(UIButton *)btn{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    for (editCompanyData *model in self.messageArray) {
        if ([model.messageType isEqualToString:@"1"]) {
            self.InvitationStr = model.messageContent;
        }
    }
    
    [GPUtils sendSMSMessageWithDelegate:self AndMessages:self.InvitationStr AndPhoneNum:nil];
}


-(void)requestInvitationJoin{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",invite] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
     [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    self.messageArray = [NSMutableArray array];
    if (serialNum ==1) {
        NSArray * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }
        for (NSDictionary * listDic in result) {
            editCompanyData * data = [[editCompanyData alloc]init];
            data.messageType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"type"]];
            data.messageUrl = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"url"]];
            data.messageContent = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"content"]];
            [self.messageArray addObject:data];
        }
        
    }
    
    switch (serialNum) {
        case 0://
            break;
        case 1:
            [self createInviteCode];
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch(result){
        caseMessageComposeResultSent:
            //信息传送成功
            break;
        caseMessageComposeResultFailed:
            //信息传送失败
            break;
        caseMessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}

//MARK:创建二维码
-(void)createInviteCode{
    NSLog(@"%@",self.messageArray);
    editCompanyData * data =self.messageArray[0];
    
    UIImage *qrImg = [JQScanWrapper createQRWithString:data.messageUrl size:CGSizeMake(150, 150)];
    qrImg=[JQScanWrapper imageBlackToTransparent:qrImg withRed:2 andGreen:173 andBlue:252];

    UIImageView *qrImageView = [[UIImageView alloc]initWithImage:qrImg];
    qrImageView.backgroundColor = Color_form_TextFieldBackgroundColor;
    qrImageView.center = self.view.center;
    [self.view addSubview:qrImageView];
    
    
    UILabel *codeTitle=[GPUtils createLable:CGRectMake(0, 0, 150, 30) text:Custing(@"扫码加入公司", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    codeTitle.center=CGPointMake(Main_Screen_Width/2, Y(qrImageView)+HEIGHT(qrImageView)+10);
    [self.view addSubview:codeTitle];
    
    
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
