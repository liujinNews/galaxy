//
//  JoinInvitationViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import <UMSocialCore/UMSocialCore.h>
#import "BulkImportViewController.h"
#import <MessageUI/MessageUI.h>
#import "editCompanyData.h"
#import "JoinInvitationViewController.h"

@interface JoinInvitationViewController ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * JoinArray;
@property (nonatomic,strong)UIView * footView;
@property (nonatomic,strong)NSString * InvitationStr;
@property (nonatomic,strong)NSString * InvitationUrl;
@property (nonatomic,strong)NSMutableArray * messageArray;

@end

@implementation JoinInvitationViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestInvitationJoin];
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.JoinArray=@[
                     @{@"companyImage":@"my_company_Bulk",@"companyType":Custing(@"批量导入成员", nil)},
                     @{@"companyImage":@"my_company_Add",@"companyType":Custing(@"填写企业号加入", nil)},
                     @{@"companyImage":@"my_Invitation_Wei",@"companyType":Custing(@"微信邀请", nil)},
                     @{@"companyImage":@"my_Invitation_Duan",@"companyType":Custing(@"短信邀请", nil)},
                     @{@"companyImage":@"my_Invitation_Sao",@"companyType":Custing(@"面对面扫码加入", nil)}
                     ];
    [self setTitle:Custing(@"邀请同事加入", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.JoinArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
//        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView * helpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 20, 20)];
        helpImage.image = GPImage([self.JoinArray[indexPath.row] objectForKey:@"companyImage"]);
        [cell.contentView addSubview:helpImage];
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15, 18, 18)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-90, 48) text:[self.JoinArray[indexPath.row] objectForKey:@"companyType"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        
        if (indexPath.row<self.JoinArray.count-1) {
            UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(54, 47.5, Main_Screen_Width-54, 0.5)];
            lineView.backgroundColor = Color_GrayLight_Same_20;
            [cell.contentView addSubview:lineView];
        }
        
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.JoinArray[indexPath.row][@"companyType"];
    if ([name isEqualToString:Custing(@"批量导入成员", nil)]) {
        BulkImportViewController * bulk = [[BulkImportViewController alloc]initWithType:@"Bulk"];
        bulk.JoinStr = [UrlKeyManager getHelpURL:XB_ImportStaff];
        [self.navigationController pushViewController:bulk animated:YES];
    }else if ([name isEqualToString:Custing(@"填写企业号加入", nil)]){
        BulkImportViewController * Add = [[BulkImportViewController alloc]initWithType:@"Add"];
        Add.JoinStr = [UrlKeyManager getHelpURL:XB_JoinByCId];
        Add.corpId = [NSString stringWithFormat:@"%@",self.corpId];
        [self.navigationController pushViewController:Add animated:YES];
    }else if ([name isEqualToString:Custing(@"微信邀请", nil)]){
        [self weixinInvitation];
    }else if ([name isEqualToString:Custing(@"短信邀请", nil)]){
        [self duanxinInvitation];
    }else if ([name isEqualToString:Custing(@"面对面扫码加入", nil)]){
        editCompanyData * data =self.messageArray[0];
        BulkImportViewController *exp = [[BulkImportViewController alloc]initWithType:@"Join"];
        exp.JoinStr = data.messageUrl;
        [self.navigationController pushViewController:exp animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)requestInvitationJoin{
    
    if ([self.accountInvite isEqualToString:@"createCom"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"account/invite"] Parameters:@{@"CompanyId":self.corpId} Delegate:self SerialNum:1 IfUserCache:NO];
    }else {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",invite] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
    }
    
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
    
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)weixinInvitation {
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
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"" descr:self.InvitationStr thumImage:GPImage(@"shareAvatar.png")];
    //设置网页地址
    shareObject.webpageUrl = self.InvitationUrl;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
    
}




-(void)duanxinInvitation {
    
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
