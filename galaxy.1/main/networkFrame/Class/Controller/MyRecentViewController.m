//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <ImSDK/ImSDK.h>
#import "MyRecentViewController.h"
#import "MyChatCell.h"
#import "MyChatModel.h"
#import "TIMMessageListenerImpl.h"
#import "MyChatViewController.h"
#import "GlobalData.h"
#import "MyGroupInfoModel.h"
#import "MyCommOperation.h"
#import "MyUnknownChatManager.h"
#import "MessageIndexCellModel.h"
#import "MessageIndexTableViewCell.h"

#import "PeopleIndexViewController.h"
//#import "TestSpeedViewController.h"
//通知跳转
#import "ApproveRemindViewController.h"
#import "NoticeOrderViewController.h"
#import "NewPeopleReportViewController.h"
#import "MyBillViewController.h"
#import "BroadcastViewController.h"

static MyRecentViewController* gCurrentMyRecentViewController;

@interface MyRecentViewController ()<GPClientDelegate>

@property (nonatomic, strong) NSMutableArray *arr_request;

@property (nonatomic, strong) NSMutableArray *Arr_MessageIndex;

@property (nonatomic, strong) NSDictionary *requsetDic;

@end

@implementation MyRecentViewController

+(MyRecentViewController*)current{
    return gCurrentMyRecentViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMessage_Arr];
    
    self.recentChatList = [NSMutableArray arrayWithCapacity:50];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.rowHeight = 59;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Color_White_Same_20;
    self.tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 49);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecentList) name:kMyNotificationReccentListViewUpdate object:nil];
    
    [self requestGetMessageList];
    [self reloadRecentList];
}

- (void)viewWillAppear:(BOOL)animated{
    [YXSpritesLoadingView showWithText:@"光速加载中..." andShimmering:NO andBlurEffect:NO];
    [super viewWillAppear:animated];
    gCurrentMyRecentViewController = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    gCurrentMyRecentViewController = nil;
}

-(void)keyClose
{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyNotificationReccentListViewUpdate object:nil];
    [_recentChatList removeAllObjects];
    _recentChatList = nil;
}

//添加顶部数组数据
-(void)addMessage_Arr
{
    if (_Arr_MessageIndex==nil) {
        _Arr_MessageIndex = [[NSMutableArray alloc]init];
        
        NSDictionary *index1 = @{@"TitleImage":@"Message_Approve",@"TitleLable":@"审批提醒",@"Content":@"",@"RedNumber":@"0"};
        MessageIndexCellModel *model1 = [[MessageIndexCellModel alloc]initWithDict:index1];
        [_Arr_MessageIndex addObject:model1];
        
        NSDictionary *index3 = @{@"TitleImage":@"Message_NewPeople",@"TitleLable":@"新人报到",@"Content":@"",@"RedNumber":@"0"};
        MessageIndexCellModel *model3 = [[MessageIndexCellModel alloc]initWithDict:index3];
        [_Arr_MessageIndex addObject:model3];
        
        NSDictionary *index4 = @{@"TitleImage":@"Message_Bill",@"TitleLable":@"我的账单",@"Content":@"",@"RedNumber":@"0"};
        MessageIndexCellModel *model4 = [[MessageIndexCellModel alloc]initWithDict:index4];
        [_Arr_MessageIndex addObject:model4];
        
        NSDictionary *index5 = @{@"TitleImage":@"Message_xique",@"TitleLable":@"小喜鹊播报",@"Content":@"",@"RedNumber":@"0"};
        MessageIndexCellModel *model5 = [[MessageIndexCellModel alloc]initWithDict:index5];
        [_Arr_MessageIndex addObject:model5];
    }
    
    
}

- (MyChatModel *)modelFromConversation:(TIMConversation*)conversation{
    MyChatModel *model = [[MyChatModel alloc] init];

    model.unreadCount = [conversation getUnReadMessageNum];
    model.type = [conversation getType];
    if (model.type == TIM_C2C) {
        model.user = [conversation getReceiver];
    }
    model.chatId = [conversation getReceiver];
    
    if (model.type == TIM_GROUP){
        MyGroupInfoModel* group = [[GlobalData shareInstance] getGroupInfo:model.chatId];
        model.title = group.groupTitle;
    }
    else {
        MyFriendModel *friend = [[GlobalData shareInstance] getFriendInfo:model.user];
        model.title = friend.nickName;
    }
    //递归获取最近一条未被删除的消息
    int getMessageNum=1;
    [self getDetailInfo:conversation getMessageNum:getMessageNum lastMsg:nil ChatModel:model];
    return model;
}

//第一次打开表单和保存后打开表单接口
-(void)requestGetMessageList{
    NSString *url=[NSString stringWithFormat:@"%@%@",kServer,GetMessageList];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *date = [userDefaults objectForKey:@"MessageDate"];
    if (date==nil) {
        date = [NSDate date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSDictionary *parameters = @{@"Date":[dateFormatter stringFromDate:date]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}


- (void)getDetailInfo:(TIMConversation*)conversation getMessageNum:(int)getMsgNum lastMsg:(TIMMessage*)last ChatModel:(MyChatModel *)model {
    __weak MyChatModel *wm = model;
    __weak MyRecentViewController *ws = self;
        [conversation getMessage:getMsgNum last:last succ:^(NSArray* msglist){
            if (msglist.count > 0) {
                TIMMessage* msg = (TIMMessage *)[msglist objectAtIndex:0];
                TIMElem* elem = [msg getElem:msg.elemCount-1];
                wm.latestTimestamp = msg.timestamp;
                if ( msg.status ==  TIM_MSG_STATUS_HAS_DELETED) {
                    [self getDetailInfo:conversation getMessageNum:getMsgNum lastMsg:msg ChatModel:wm];
                    return ;
                }
                else if ([elem isKindOfClass:[TIMTextElem class]]) {
                    wm.detailInfo = ((TIMTextElem *)elem).text;
                }
                else if ([elem isKindOfClass:[TIMImageElem class]]){
                    wm.detailInfo = @"[图片]";
                }
                else if ([elem isKindOfClass:[TIMFileElem class]]){
                    wm.detailInfo = @"[文件]";
                }
                else if ([elem isKindOfClass:[TIMSoundElem class]]){
                    wm.detailInfo = @"[语音]";
                }
                else if ([elem isKindOfClass:[TIMLocationElem class]]){
                    wm.detailInfo = @"[位置]";
                }
                else if ([elem isKindOfClass:[TIMGroupTipsElem class]]){
                    wm.detailInfo = @"[群提示消息]";
                }
                else if ([elem isKindOfClass:[TIMVideoElem class]]){
                    wm.detailInfo = @"[视频]";
                }
                [ws.tableView reloadData];
            }
        } fail:^(int code, NSString* faile){
            TDDLogEvent(@"get last msg failed");
        }];
}

-(void)dataReload
{
    NSDictionary *remind = _requsetDic[@"result"][@"remind"];
    MessageIndexCellModel *model_remind = _Arr_MessageIndex[0];
    model_remind.Content = [NSString isEqualToNull:remind[@"content"]]?remind[@"content"]:@"暂无审批提醒";
    model_remind.RedNumber = [NSString stringWithFormat:@"%@",remind[@"count"]];
    _Arr_MessageIndex[0] = model_remind;
    
    NSDictionary *bill = _requsetDic[@"result"][@"bill"];
    MessageIndexCellModel *model_bill = _Arr_MessageIndex[2];
    model_bill.Content = [NSString isEqualToNull:bill[@"content"]]?bill[@"content"]:@"暂无我的账单";
    model_bill.RedNumber = [NSString stringWithFormat:@"%@",bill[@"count"]];
    _Arr_MessageIndex[2] = model_bill;
    
    NSDictionary *message = _requsetDic[@"result"][@"message"];
    MessageIndexCellModel *model_message = _Arr_MessageIndex[3];
    model_message.Content = [NSString isEqualToNull:message[@"content"]]?message[@"content"]:@"暂无播报";
    model_message.RedNumber = [NSString stringWithFormat:@"%@",message[@"count"]];
    //    model_message.RedNumber = @"1";
    _Arr_MessageIndex[3] = model_message;
    
    NSDictionary *report = _requsetDic[@"result"][@"report"];
    if ([NSString isEqualToNull:report[@"title"]]) {
        MessageIndexCellModel *model_report = _Arr_MessageIndex[1];
        model_report.Content = [NSString isEqualToNull:report[@"content"]]?report[@"content"]:@"暂无新人报道";
        model_report.RedNumber = [NSString stringWithFormat:@"%@",report[@"count"]];
        _Arr_MessageIndex[1] = model_report;
    }
    else
    {
        [_Arr_MessageIndex removeObjectAtIndex:1];
    }
    
    [self.tableView reloadData];
    [YXSpritesLoadingView dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate<UITableView>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _Arr_MessageIndex.count;
    }
    return self.recentChatList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == _Arr_MessageIndex.count-1) {
            return 79;
        }
        return 69;
    }
    return CONTACT_CELL_H;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    if (indexPath.section == 0)
    {
        static NSString *check = @"cell";
        MessageIndexTableViewCell *messcell = (MessageIndexTableViewCell *)[tableView dequeueReusableCellWithIdentifier:check];
        if (!messcell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageIndexTableViewCell" owner:self options:nil];
            messcell = [nib lastObject];
        }
        if (indexPath.row != _Arr_MessageIndex.count - 1) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 68, Main_Screen_Width-15, 0.5)];
            image.backgroundColor = Color_GrayLight_Same_20;
            [messcell addSubview:image];
        }
        else
        {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68, Main_Screen_Width, 0.5)];
            image.backgroundColor = Color_GrayLight_Same_20;
            [messcell addSubview:image];
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69, Main_Screen_Width, 10)];
            imageview.backgroundColor = Color_White_Same_20;
            [messcell addSubview:imageview];
            
//            UIImageView *imageline = [[UIImageView alloc]initWithFrame:CGRectMake(0, 78, Main_Screen_Width, 0.5)];
//            imageline.backgroundColor = Color_GrayLight_Same_20;
//            [messcell addSubview:imageline];
        }
        messcell.model = _Arr_MessageIndex[indexPath.row];
        messcell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = messcell;
        return cell;
    }
    else
    {
        static NSString* chatCellId = @"Chat";
        
        NSLog(@"%s TableCell select: section:%ld index:%ld", __FILE__,  (long)indexPath.section, (long)indexPath.row);
        
        MyChatCell* chatCell = [tableView dequeueReusableCellWithIdentifier:chatCellId];
        if (chatCell == nil) {
            chatCell = [[MyChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCellId];
//            chatCell.frame = CGRectMake(0, 0, Main_Screen_Width, 59);
        }
        
        if (self.recentChatList.count > indexPath.row) {
            MyChatModel* model = [self.recentChatList objectAtIndex:indexPath.row];
            [chatCell updateModel:model];
            
            if (_arr_request.count>0) {
                if (indexPath.row <= _arr_request.count-1) {
                    NSDictionary *dics = _arr_request[indexPath.row];
                    if ([NSString isEqualToNull:dics[@"photoGraph"]]) {
                        NSDictionary * dic = [GPUtils transformToDictionaryFromString:dics[@"photoGraph"]];
                        NSString *file = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                        if ([NSString isEqualToNull:file])
                        {
                            [chatCell.HeadImage sd_setImageWithURL:[NSURL URLWithString:file]];
                        }
                    }
                    chatCell.lab_Name.text = dics[@"userDspName"];
                }
            }
            cell = chatCell;
        }
        UIImageView *cellLing;
        if (indexPath.row == self.recentChatList.count-1) {
            cellLing = [[UIImageView alloc]initWithFrame:CGRectMake(0, 58, Main_Screen_Width, 1)];
        }
        else
        {
            cellLing = [[UIImageView alloc]initWithFrame:CGRectMake(71, 58, Main_Screen_Width, 1)];
        }
        cellLing.backgroundColor = Color_GrayLight_Same_20;
        [cell addSubview:cellLing];
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    RDVTabBarController *nav = window.rootViewController;
    UINavigationController *navi = nav.viewControllers[0];
    
    if (indexPath.section == 0) {
        if (_Arr_MessageIndex.count==4) {
            MessageIndexCellModel *model = _Arr_MessageIndex[indexPath.row];
            model.RedNumber = @"0";
            _Arr_MessageIndex[indexPath.row] = model;
            [self.tableView reloadData];
            
            if (indexPath.row == 0) {
                ApproveRemindViewController *approve = [[ApproveRemindViewController alloc]init];
                [navi pushViewController:approve animated:YES];
            }
            if (indexPath.row == 1) {
                NewPeopleReportViewController *newpeople = [[NewPeopleReportViewController alloc]init];
                [navi pushViewController:newpeople animated:YES];
            }
            if (indexPath.row == 2) {
                MyBillViewController *mybill = [[MyBillViewController alloc]init];
                [navi pushViewController:mybill animated:YES];
            }
            if (indexPath.row == 3) {
                BroadcastViewController *broadcast = [[BroadcastViewController alloc]init];
                [navi pushViewController:broadcast animated:YES];
            }
        }
        else
        {
            MessageIndexCellModel *model = _Arr_MessageIndex[indexPath.row];
            model.RedNumber = @"0";
            _Arr_MessageIndex[indexPath.row] = model;
            [self.tableView reloadData];
            
            if (indexPath.row == 0) {
                ApproveRemindViewController *approve = [[ApproveRemindViewController alloc]init];
                [navi pushViewController:approve animated:YES];
            }
            if (indexPath.row == 1) {
                MyBillViewController *mybill = [[MyBillViewController alloc]init];
                [navi pushViewController:mybill animated:YES];
            }
            if (indexPath.row == 2) {
                BroadcastViewController *broadcast = [[BroadcastViewController alloc]init];
                [navi pushViewController:broadcast animated:YES];
            }
        }
        
    }
    else
    {
        NSLog(@"%s TableCell select: section:%ld index:%ld", __FILE__,  (long)indexPath.section, (long)indexPath.row);
        MyChatModel* model = [_recentChatList objectAtIndex:indexPath.row];
        //跳转到AIO
        MyChatViewController *chatCntler;
        if (model.type == TIM_C2C) {
            chatCntler = [[MyChatViewController alloc] initWithC2C:model.user];
        }else{
            chatCntler = [[MyChatViewController alloc] initWithGroup:model.chatId];
        }
        if (_arr_request.count>0 ) {
            if (_arr_request.count<=indexPath.row) {
                NSDictionary *dics = _arr_request[indexPath.row];
                chatCntler.friendInfo = dics[@"userDspName"];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"photoGraph"]] forKey:@"userHeader"];
                [userDefaults synchronize];
            }
        }
        chatCntler.hidesBottomBarWhenPushed = YES;
        
        [navi pushViewController:chatCntler animated:YES];
    }
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    if (indexPath.section != 0) {
        return  UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyChatModel* model = [_recentChatList objectAtIndex:indexPath.row];
        BOOL isDeleted = [[TIMManager sharedInstance] deleteConversationAndMessages:model.type  receiver:model.chatId];
        [_recentChatList removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source.
        if (isDeleted) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)reloadRecentList{
    //get all converstations
    [self.recentChatList removeAllObjects];
    int cnt = [[TIMManager sharedInstance] ConversationCount];
    NSString *string = @"";
    for (int index = 0; index < cnt; index++) {
        TIMConversation* conversation = [[TIMManager sharedInstance] getConversationByIndex:index];
        
        if ([conversation getType] == TIM_SYSTEM)
            continue;
        
        MyChatModel* model = [self modelFromConversation:conversation];
        [self.recentChatList addObject:model];
        [self.tableView reloadData];
        if (!_arr_request) {
            if (![NSString isEqualToNull:string]) {
                if (model.chatId.length >11) {
                    string = [model.chatId componentsSeparatedByString:@"_"][0];
                    
                }
                else
                {
                    string = model.chatId;
                }
                
            }
            else
            {
                if (model.chatId.length >11) {
                    string = [NSString stringWithFormat:@"%@,%@",string,[model.chatId componentsSeparatedByString:@"_"][0]];
                }
                else
                {
                    string = [NSString stringWithFormat:@"%@,%@",string,model.chatId];

                }
            }
        }
        if (conversation.getType == TIM_C2C) {
            [[MyUnknownChatManager sharedInstance]checkUnknownC2CChat:[conversation getReceiver]];
        }
        else{
            [[MyUnknownChatManager sharedInstance]checkUnknownGroupChat:[conversation getReceiver]];
        }
    }
    if ([NSString isEqualToNull:string]&&!_arr_request) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@%@",kServer,GetUserInfoList] Parameters:@{@"UserIdList":string} Delegate:self SerialNum:1 IfUserCache:NO];
    }
    else
    {
        [YXSpritesLoadingView dismiss];
    }
}

#pragma mark - 接口返回
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"MessageDate"];
    
    if (responceDic[@"success"] == 0 ) {
        [YXSpritesLoadingView dismiss];
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 1) {
        NSArray *arr = responceDic[@"result"];
        
        if ([arr isEqual:[NSNull null]]) {
            _arr_request = [[NSMutableArray alloc]init];
        }
        else
        {
            _arr_request = [NSMutableArray arrayWithArray:arr];
        }
        
        //存储到NSUserDefaults
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"dic":_arr_request}];
        
        NSString *str = [NSString stringWithJson:dic];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:str forKey:@"dic"];
        
        [defaults synchronize];
    }
    if (serialNum == 0) {
        _requsetDic = responceDic;
        if (![_requsetDic[@"result"] isEqual:[NSNull null]]) {
            [self dataReload];
        }
        else
        {
            NSLog(@"meiyoushitu");
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"请求失败，请重试！"]];
    self.view = [[UIView alloc]init];
    [YXSpritesLoadingView dismiss];
}

-(void)deleteConversation:(NSString*)identifier{
    [[TIMManager sharedInstance] deleteConversationAndMessages:TIM_C2C receiver:identifier];
    [self reloadRecentList];
}
@end
