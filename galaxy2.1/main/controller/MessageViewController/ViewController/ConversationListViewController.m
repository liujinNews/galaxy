//
//  ConversationListViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/2/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ConversationListViewController.h"
#import "MessageIndexCellModel.h"
//#import "ConversationListTableViewCell.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "MessageIndexTableViewCell.h"
//通知跳转
#import "ApproveRemindViewController.h"
#import "NoticeOrderViewController.h"
#import "NewPeopleReportViewController.h"
#import "MyBillViewController.h"
#import "BroadcastViewController.h"
#import "CompanyAllNoticeViewController.h"

@interface ConversationListViewController ()<GPClientDelegate>

@property (nonatomic, strong) NSMutableArray *arr_request;

@property (nonatomic, strong) NSMutableArray *Arr_MessageIndex;

@property (nonatomic, strong) NSDictionary *requsetDic;

@property (nonatomic, assign) BOOL isRequst;

@end

@implementation ConversationListViewController

- (void)dealloc{
    [self.KVOController unobserveAll];
}
- (void)addHeaderView{

}
- (void)addFooterView{
    
}
- (BOOL)hasData{
    BOOL has = _conversationList.count != 0;
    return has;
}
- (void)addRefreshScrollView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] init];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = Color_form_TextFieldBackgroundColor;
    _tableView.scrollsToTop = YES;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
    self.refreshScrollView.contentSize = CGSizeMake(Main_Screen_Height , Main_Screen_Height);
}

- (void)viewDidLoad{
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string =[defaults objectForKey:@"dic"];
    NSDictionary *dic_people_request = [NSString dictionaryWithJsonString:string];
    _arr_request = dic_people_request[@"dic"];
    
    _Arr_MessageIndex = [[NSMutableArray alloc]init];
//    [self requestGetMessageList];
    _isRequst = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRelogin) name:kIMAMSG_ReloginNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userdatas.multCompanyId=@"0";
    self.view.frame=CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-(iPhoneX ? 83:49));
//    [[IMAPlatform sharedInstance].conversationMgr releaseChattingConversation];
    if (_isRequst) {
        [self requestGetMessageList];
    }
    _isRequst=YES;
}

- (void)onRelogin{
    [self.KVOController unobserveAll];
    [self configOwnViews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[IMAPlatform sharedInstance].conversationMgr releaseChattingConversation];
}

- (void)addSearchController{
}

- (void)configOwnViews{
    
    __weak ConversationListViewController *ws = self;
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [ws onUnReadMessag];
}

//第一次打开表单和保存后打开表单接口
-(void)requestGetMessageList{
    NSString *url=[NSString stringWithFormat:@"%@",GetMessageList];
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

-(void)dataReload{
    
    [_Arr_MessageIndex removeAllObjects];
    if ([_requsetDic[@"result"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *result=_requsetDic[@"result"];
        if ([result[@"reminds"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"reminds"]) {
                MessageIndexCellModel *model=[[MessageIndexCellModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                //Message_Approve
                model.Type=1;
                if (![NSString isEqualToNull:model.content]) {
                    model.content=Custing(@"暂无消息提醒", nil);
                }
                [_Arr_MessageIndex addObject:model];
            }
        }
        if ([result[@"proclamation"] isKindOfClass:[NSDictionary class]]&&![result[@"proclamation"][@"title"] isKindOfClass:[NSNull class]]) {
            MessageIndexCellModel *model=[[MessageIndexCellModel alloc]init];
            [model setValuesForKeysWithDictionary:result[@"proclamation"]];
            model.logo=@"Message_Notice";
            model.Type=4;
            if (![NSString isEqualToNullAndZero:model.content]) {
                model.content=Custing(@"暂无公告",nil);
            }
            [_Arr_MessageIndex addObject:model];
        }
        if ([result[@"report"] isKindOfClass:[NSDictionary class]]&&![result[@"report"][@"title"] isKindOfClass:[NSNull class]]) {
            MessageIndexCellModel *model=[[MessageIndexCellModel alloc]init];
            [model setValuesForKeysWithDictionary:result[@"report"]];
            model.logo=@"Message_NewPeople";
            model.Type=2;
            if (![NSString isEqualToNull:model.content]) {
                model.content=Custing(@"暂无新人报到",nil);
            }
            [_Arr_MessageIndex addObject:model];
        }
        if ([result[@"bill"] isKindOfClass:[NSDictionary class]]&&![result[@"bill"][@"title"] isKindOfClass:[NSNull class]]) {
            MessageIndexCellModel *model=[[MessageIndexCellModel alloc]init];
            [model setValuesForKeysWithDictionary:result[@"bill"]];
            model.logo=@"Message_Bill";
            model.Type=3;
            if (![NSString isEqualToNull:model.content]) {
                model.content=Custing(@"你还没有我的账单哦", nil);
            }
            [_Arr_MessageIndex addObject:model];

        }
       
    }
    [self pinHeaderView];
    [self.tableView reloadData];
    
    [YXSpritesLoadingView dismiss];
}

#pragma mark - 接口返回
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"MessageDate"];

    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
//        [YXSpritesLoadingView dismiss];
        return;
    }
    if (serialNum == 0) {
        _requsetDic = responceDic;
        if (![_requsetDic[@"result"] isEqual:[NSNull null]]) {
            [self dataReload];
        }
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
        NSString *str = [NSString transformToJson:dic];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:str forKey:@"dic"];
        [defaults synchronize];
        [self reloadData];
    }
   
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
//    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    self.view = [[UIView alloc]init];
}

- (void)onUnReadMessag
{
////    NSInteger unRead = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
//
//    NSString *badge = nil;
//    if (unRead > 0 && unRead <= 99)
//    {
//        badge = [NSString stringWithFormat:@"%d", (int)unRead];
//    }
//    else if (unRead > 99)
//    {
//        badge = @"99";
//    }
//    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
//    RDVTabBarController *nav = (RDVTabBarController *)window.rootViewController;
//    UIViewController *navi = nav.viewControllers[0];
//    [[navi rdv_tabBarItem] setBadgeValue:badge];
}


//- (void)onConversationChanged:(IMAConversationChangedNotifyItem *)item
//{
//    switch (item.type)
//    {
//        case EIMAConversation_SyncLocalConversation:
//        {
//            NSIndexPath *index ;
//
//            if (!item.index) {
//                item.index = 0;
//            }
//            if (item.index>100) {
//                item.index = 0;
//            }
//            if (self.tableView.numberOfSections==2) {
//                if (!item.index) {
////                    index = [NSIndexPath indexPathForRow:0 inSection:1];
//                }else{
//                    [self.tableView beginUpdates];
//                    index = [NSIndexPath indexPathForRow:item.index inSection:1];
//                    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//                    [self.tableView endUpdates];
//                }
//            }
//        }
//
//            break;
//        case EIMAConversation_BecomeActiveTop:
//        {
//            [self.tableView beginUpdates];
//            [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:item.index inSection:1] toIndexPath:[NSIndexPath indexPathForRow:item.toIndex inSection:1]];
//            [self.tableView endUpdates];
//        }
//            break;
//        case EIMAConversation_NewConversation:
//        {
//
//            NSIndexPath *index;
////            NSInteger a ;
////            if (!a) {
////
////                NSLog(@"www");
////            }
//            if (!item.index) {
//                item.index = 0;
//            }
//            if (item.index>100) {
//                item.index = 0;
//            }
//            if (self.tableView.numberOfSections==2) {
//                if (!item.index) {
////                    index = [NSIndexPath indexPathForRow:0 inSection:1];
//                }else{
//                    [self.tableView beginUpdates];
//                    index = [NSIndexPath indexPathForRow:item.index inSection:1];
//                    [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//                    [self.tableView endUpdates];
//                }
//            }
//            else
//            {
//                if (!item.index) {
////                    index = [NSIndexPath indexPathForRow:0 inSection:0];
//                }else{
//                    [self.tableView beginUpdates];
//                    index = [NSIndexPath indexPathForRow:item.index inSection:0];
//                    [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//                    [self.tableView endUpdates];
//                }
//            }
//
//        }
//            break;
//        case EIMAConversation_DeleteConversation:
//        {
//            [self.tableView beginUpdates];
//            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:1];
//            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView endUpdates];
//        }
//            break;
//        case EIMAConversation_Connected:
//        {
//            [self.tableView beginUpdates];
//            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:1];
//            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView endUpdates];
//        }
//            break;
//        case EIMAConversation_DisConnected:
//        {
//            [self.tableView beginUpdates];
//            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:1];
//            [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView endUpdates];
//        }
//            break;
//        case EIMAConversation_ConversationChanged:
//        {
//            [self.tableView beginUpdates];
//            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:1];
//            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//
//            [self.tableView endUpdates];
//        }
//            break;
//        default:
//
//            break;
//    }
//    [self configOwnViews];
//}
- (void)onRefresh{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self reloadData];
    //    });
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        if (indexPath.row == _Arr_MessageIndex.count-1) {
//            return 79;
//        }
        return 69;
    }
    return 0;
//    id<IMAConversationShowAble> conv = [_conversationList objectAtIndex:indexPath.row];
//    return [conv showHeight];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.userdatas.SystemType == 1) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _Arr_MessageIndex.count;
    }
    return [_conversationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *check = @"cell";
        MessageIndexTableViewCell *messcell = (MessageIndexTableViewCell *)[tableView dequeueReusableCellWithIdentifier:check];
        if (!messcell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageIndexTableViewCell" owner:self options:nil];
            messcell = [nib lastObject];
        }
        if (indexPath.row != _Arr_MessageIndex.count - 1) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(68, 68.5, Main_Screen_Width-68, 0.5)];
            image.backgroundColor = Color_GrayLight_Same_20;
            [messcell addSubview:image];
        }else{
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68.5, Main_Screen_Width, 0.5)];
            image.backgroundColor = Color_GrayLight_Same_20;
            [messcell addSubview:image];
        }
        messcell.model = _Arr_MessageIndex[indexPath.row];
        messcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return messcell;
    }
    return [UITableViewCell new];
//    id<IMAConversationShowAble> conv = [_conversationList objectAtIndex:indexPath.row];
//    NSString *reuseidentifier = [conv showReuseIndentifier];
//    ConversationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
//    if (!cell)
//    {
//        cell = [[[conv showCellClass] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
//    }
////    [cell configCellWith:conv];
////    id a = [_conversationList objectAtIndex:indexPath.row];
//    if ([NSString isEqualToNull:[conv lastMsgTime]]) {
//        cell.lastMsgTime.text = [NSString isEqualToNull:[conv lastMsgTime]]?[conv lastMsgTime]:@"";
//    }
//    if ([NSString isEqualToNull:[conv lastMsg]]) {
//        cell.lastMsg.attributedText = [conv lastAttributedMsg];
//        cell.lastMsg.text = [conv lastMsg];
//    }
//    if ([conv unReadCount]>0) {
//        [cell.unReadBadge setTitle:[NSString stringWithFormat:@"%ld",(long)[conv unReadCount]] forState:UIControlStateNormal];
//        [cell.unReadBadge setHidden:NO];
//    }
//    else
//    {
//        if ([[cell class]isEqual:[ConversationListTableViewCell class] ]) {
//            if (cell.unReadBadge != nil) {
//                [cell.unReadBadge setHidden:YES];
//            }
//        }
//    }
//    if ([conv conversationType]!=TIM_GROUP) {
//        for (int a = 0; a<_arr_request.count; a++) {
//            NSDictionary *dic = _arr_request[a];
//            if ([[conv showTitle] isEqualToString:[NSString stringWithFormat:@"%@_%@",dic[@"userId"],@"xibao"]]) {
//                cell.conversationName.text = dic[@"userDspName"];
//                if ([NSString isEqualToNull:dic[@"photoGraph"]]) {
//                    NSDictionary * dics = (NSDictionary *)[NSString transformToObj:dic[@"photoGraph"]];
//                    if ([NSString isEqualToNull:[dics objectForKey:@"filepath"]]) {
//                        NSString *str=[NSString stringWithFormat:@"%@",[dics objectForKey:@"filepath"]];
//                        UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
//                        [cell.conversationIcon setImage:image forState:UIControlStateNormal];
//                    }
//
//                }
//            }
//        }
//    }else{
//        [cell configCellWith:conv];
////        __weak ConversationListTableViewCell *ws = cell;
//        [self.KVOController observe:conv keyPath:@"lastMessage.status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//            cell.conversationName.text = [conv showTitle];
//        }];
//    }
    
//    if ([FestivalStyle isEqualToString:@"1"]) {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 30, 30)];
//        image.image = [UIImage imageNamed:@"Message_Christmas"];
//        [cell addSubview:image];
//    }
//
//    if (indexPath.row != _conversationList.count - 1) {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(68, [conv showHeight], Main_Screen_Width-68, 0.5)];
//        image.backgroundColor = Color_GrayLight_Same_20;
//        [cell addSubview:image];
//    }
//    else
//    {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, [conv showHeight], Main_Screen_Width, 0.5)];
//        image.backgroundColor = Color_GrayLight_Same_20;
//        [cell addSubview:image];
//    }
//    if (indexPath.row == 0) {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
//        image.backgroundColor = Color_GrayLight_Same_20;
//        [cell addSubview:image];
//    }
//    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    IMAConversation *conv = [_conversationList objectAtIndex:indexPath.row];
//    [[IMAPlatform sharedInstance].conversationMgr deleteConversation:conv needUIRefresh:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    if (indexPath.section == 0) {
        return  UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    RDVTabBarController *nav = (RDVTabBarController *)window.rootViewController;
    UINavigationController *navi = nav.viewControllers[0];
    if (indexPath.section == 0) {
        MessageIndexCellModel *model = _Arr_MessageIndex[indexPath.row];
        if (model.Type==1) {
            ApproveRemindViewController *approve = [[ApproveRemindViewController alloc]init];
            self.userdatas.multCompanyId=[NSString stringWithIdOnNO:model.companyId];
            approve.str_Title=model.coName;
            [navi pushViewController:approve animated:YES];
        }else if (model.Type==2){
            NewPeopleReportViewController *newpeople = [[NewPeopleReportViewController alloc]init];
            [navi pushViewController:newpeople animated:YES];
        }else if (model.Type==3){
            MyBillViewController *mybill = [[MyBillViewController alloc]init];
            [navi pushViewController:mybill animated:YES];
        }else if (model.Type==4){
            CompanyAllNoticeViewController *vc = [[CompanyAllNoticeViewController alloc]init];
            [navi pushViewController:vc animated:YES];
        }
    }
}


@end
