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

#import "MyGroupInfoViewController.h"
#import "MyContactsViewController.h"
#import "MyGroupInfoModel.h"
#import "MyGroupMemberListCell.h"
#import "MyGroupInfoItemsCell.h"
#import "MyChatInfoItemModel.h"
#import "MyCommOperation.h"
#import "GlobalData.h"
#import "MyInfoItemEditViewController.h"
#import "UIResponder+addtion.h"
#import "AccountHelper.h"

#import "MyAlertView.h"
#import "AppDelegate.h"
#import "MyRecentViewController.h"
#import "MyTabBarViewController.h"

@interface MyGroupInfoViewController()

@property (nonatomic, strong)MyGroupInfoModel* groupInfo;
@property (nonatomic, assign)InfoPageSource source;
@property (nonatomic, strong)NSMutableArray* dataSource;
@property (nonatomic, strong)id groupInfoChangeObserver;
@property (nonatomic, strong)MyInfoItemEditViewController* groupNamecardEditController;
@property (nonatomic, strong)MyInfoItemEditViewController* groupTitleEditController;
@property (nonatomic, strong)MyInfoItemEditViewController* groupIntroductionEditController;
@property (nonatomic, strong)MyInfoItemEditViewController* groupNotificationEditController;

@end

@implementation MyGroupInfoViewController

- (instancetype)initWithGroupInfo:(MyGroupInfoModel*) groupInfo source:(InfoPageSource)source{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.groupInfo = groupInfo;
        self.source = source;
    }
    return self;
}

- (void)setMySelfIsAdmin:(BOOL)isAdmin
{
    _isMySelfIsAdmin = isAdmin;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    self.tableView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
    self.tableView.separatorColor = RGBACOLOR(0xd7, 0xd7, 0xcf, 1.f);
    self.tableView.backgroundView = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.tableView.sectionIndexColor = RGBACOLOR(0xa4, 0xa4, 0xa4, 1.0f);
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    __weak MyGroupInfoViewController* weakSelf = self;
    self.groupInfoChangeObserver = [[NSNotificationCenter defaultCenter]
                                    addObserverForName:kMyNotificationGroupInfoChange
                                    object:nil
                                    queue:[NSOperationQueue mainQueue]
                                    usingBlock:^(NSNotification *note){
                                      MyGroupInfoModel* srcGroupInfo = (MyGroupInfoModel *)[note.userInfo objectForKey:@"data"];
                                      //本讨论组的更新通知
                                      if (srcGroupInfo != nil && weakSelf.groupInfo != nil && [srcGroupInfo.groupId isEqualToString:(weakSelf.groupInfo.groupId)]){
                                          weakSelf.groupInfo = [[GlobalData shareInstance] getGroupInfo:weakSelf.groupInfo.groupId];
                                          [weakSelf reloadModel];
                                      }
                                  }];
    
    if (self.groupInfo != nil && self.groupInfo.memberList == nil && self.groupInfo.lastMemberListResp == 0) {
        [[MyCommOperation shareInstance] requestGroupMembers:self.groupInfo.groupId];
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (self.source == InfoPageSource_GROUP) {
        [self configGroupPage];
    }
    else{
        [self configC2CPage];
    }
    
    [self configData];
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    if (self.groupInfoChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.groupInfoChangeObserver];
        self.groupInfoChangeObserver = nil;
    }
}

- (void)configData{
    if (self.groupInfo == nil) {
        self.groupInfo = [[MyGroupInfoModel alloc] init];
    }
    
    //init data
    self.dataSource = [NSMutableArray arrayWithCapacity:2];
    [self reloadModel];
}

- (void)reloadModel{
    [self.dataSource removeAllObjects];
    
    self.title = self.groupInfo.groupTitle;
    
    [self.dataSource addObject:self.groupInfo];
    
    if (self.source == InfoPageSource_C2C) {
        
    }
    else if(self.source == InfoPageSource_GROUP){
        NSMutableArray* itemsArray = [NSMutableArray arrayWithCapacity:10];
        MyChatInfoItemModel* infoModel;
        infoModel = [[MyChatInfoItemModel alloc] init];
        infoModel.infoTitle = @"群ID";
        infoModel.infoContent = self.groupInfo.groupId;
        infoModel.type = GroupInfoItemType_Id;
        infoModel.dataModel = self.groupInfo;
        infoModel.modifyPermission = NO;
        [itemsArray addObject:infoModel];
        
        infoModel = [[MyChatInfoItemModel alloc] init];
        infoModel.infoTitle = @"群名片";
        infoModel.infoContent = self.groupInfo.nameCard;
        infoModel.type = GroupInfoItemType_Namecard;
        infoModel.dataModel = self.groupInfo;
        infoModel.modifyPermission = [self groupNamecardModifyPermission];
        [itemsArray addObject:infoModel];
        
        infoModel = [[MyChatInfoItemModel alloc] init];
        infoModel.infoTitle = @"群组名称";
        infoModel.infoContent = self.groupInfo.groupTitle;
        infoModel.type = GroupInfoItemType_Title;
        infoModel.dataModel = self.groupInfo;
        infoModel.modifyPermission = [self groupTitleModifyPermission];
        [itemsArray addObject:infoModel];
        
        infoModel = [[MyChatInfoItemModel alloc] init];
        infoModel.infoTitle = @"群创建者";
        infoModel.infoContent = self.groupInfo.owner;
        infoModel.type = GroupInfoItemType_Owner;
        infoModel.dataModel = self.groupInfo;
        infoModel.modifyPermission = NO;
        [itemsArray addObject:infoModel];
        
        infoModel = [[MyChatInfoItemModel alloc] init];
        infoModel.infoTitle = @"群简介";
        infoModel.infoContent = self.groupInfo.introduction;
        infoModel.type = GroupInfoItemType_Introduction;
        infoModel.dataModel = self.groupInfo;
        infoModel.modifyPermission = [self groupIntroductionModifyPermission];
        [itemsArray addObject:infoModel];
        
        infoModel = [[MyChatInfoItemModel alloc] init];
        infoModel.infoTitle = @"群公告";
        infoModel.infoContent = self.groupInfo.notification;
        infoModel.type = GroupInfoItemType_Notification;
        infoModel.dataModel = self.groupInfo;
        infoModel.modifyPermission = [self groupNotificationModifyPermission];
        [itemsArray addObject:infoModel];

        infoModel = [[MyChatInfoItemModel alloc] init];
        infoModel.infoTitle = @"群组人数";
        infoModel.infoContent = [NSString stringWithFormat:@"%d", self.groupInfo.memberNum];
        infoModel.type = GroupInfoItemType_MemberNum;
        infoModel.dataModel = self.groupInfo;
        infoModel.modifyPermission = NO;
        [itemsArray addObject:infoModel];
        
        [self.dataSource addObject:itemsArray];
    }
    [self.tableView reloadData];
}

#pragma mark - Interface

- (void)changeGroupNamecard{
    if (!self.groupInfo.groupId) {
        return;
    }
    self.groupNamecardEditController.orginContent = self.groupInfo.nameCard;
    self.groupNamecardEditController.content.text = self.groupInfo.nameCard;
    self.groupNamecardEditController.view.hidden = NO;
}

- (void)changeGroupTitle{
    
    if (!self.groupInfo.groupId) {
        return;
    }
    self.groupTitleEditController.orginContent = self.groupInfo.groupTitle;
    self.groupTitleEditController.content.text = self.groupInfo.groupTitle;
    self.groupTitleEditController.view.hidden = NO;
}

- (void)changeGroupIntroduction {
    if (!self.groupInfo.groupId) {
        return;
    }
    self.groupIntroductionEditController.orginContent = self.groupInfo.introduction;
    self.groupIntroductionEditController.content.text = self.groupInfo.introduction;
    self.groupIntroductionEditController.view.hidden = NO;
}

- (void)changeGroupNotification {
    if (!self.groupInfo.groupId) {
        return;
    }
    self.groupNotificationEditController.orginContent = self.groupInfo.notification;
    self.groupNotificationEditController.content.text = self.groupInfo.notification;
    self.groupNotificationEditController.view.hidden = NO;
}

#pragma mark - Delegate<UITableView>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.dataSource objectAtIndex:section] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray* array = [self.dataSource objectAtIndex:section];
        return array.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.source == InfoPageSource_GROUP) {
            return 25;
        }
        return 0;
    }
    else {
        return 5;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.source == InfoPageSource_GROUP) {
        return @"群成员管理:";
    };
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [MyGroupMemberListCell heightForModel:self.groupInfo];
    }
    else{
        return 51;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* reusedId = @"GroupMember";
    static NSString* groupInfoReusedId = @"GroupInfoItem";
    
    UITableViewCell* cell;
    MyGroupMemberListCell* memberListCell;
    MyGroupInfoItemsCell* infoItemCell;
    
    switch (indexPath.section) {
        case 0:
            memberListCell = [self.tableView dequeueReusableCellWithIdentifier:reusedId];
            if (memberListCell == nil) {
                memberListCell = [[MyGroupMemberListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
            }
            [memberListCell setContent:self.groupInfo];
            [memberListCell setMyRole:_isMySelfIsAdmin];
            cell = memberListCell;
            break;
        default:
            infoItemCell = [self.tableView dequeueReusableCellWithIdentifier:groupInfoReusedId];
            if (infoItemCell == nil) {
                infoItemCell = [[MyGroupInfoItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupInfoReusedId];
            }
            MyChatInfoItemModel* chatInfoModel;
            if ([[self.dataSource objectAtIndex:indexPath.section] isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray* array = [self.dataSource objectAtIndex:indexPath.section];
                chatInfoModel = [array objectAtIndex:indexPath.row];
            }
            else if([[self.dataSource objectAtIndex:indexPath.section] isKindOfClass:[MyChatInfoItemModel class]]){
                chatInfoModel = [self.dataSource objectAtIndex:indexPath.section];
            }
            
            infoItemCell.isAcessForChange = chatInfoModel.modifyPermission;
            [infoItemCell setContent:chatInfoModel];
            cell = infoItemCell;
            
            break;
    }
    
    return cell;
}

#pragma mark - Delegate<UIActionSheet>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *optionTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (actionSheet.tag == msgOptTag) {
        TIMGroupReceiveMessageOpt setOpt;
        if ([optionTitle isEqualToString:optRecvMessage]) {
            setOpt = TIM_GROUP_RECEIVE_MESSAGE;
        }
        else if ([optionTitle isEqualToString:optNotRecvMessage]) {
            setOpt = TIM_GROUP_NOT_RECEIVE_MESSAGE;
        }
        else if ([optionTitle isEqualToString:optNotRecvNotify]) {
            setOpt = TIM_GROUP_RECEIVE_NOT_NOTIFY_MESSAGE;
        }
        else {
            return;
        }
        [[MyCommOperation shareInstance]
         modifyReciveMessageOpt:self.groupInfo.groupId
         opt:setOpt
         succ:nil
         fail:nil];
    }
    else if (actionSheet.tag == groupOptTag) {
        TIMGroupAddOpt setOpt;
        if ([optionTitle isEqualToString:optForbid]) {
            setOpt = TIM_GROUP_ADD_FORBID;
        }
        else if ([optionTitle isEqualToString:optAuth]) {
            setOpt = TIM_GROUP_ADD_AUTH;
        }
        else if ([optionTitle isEqualToString:optAny]) {
            setOpt = TIM_GROUP_ADD_ANY;
        }
        else {
            return;
        }
        [[MyCommOperation shareInstance]
         modifyGroupAddOpt:self.groupInfo.groupId
         opt:setOpt
         succ:nil
         fail:nil];
        
    }
}

#pragma mark - Event Response<Group Operation>

- (void) exitGroup:(id)sender{
    TDDLogVerbose(@"exitGroup");
    __weak MyGroupInfoViewController* weakSelf = self;
    if (self.groupInfo && self.groupInfo.groupId && ![self.groupInfo.groupId isEqualToString:@""]) {
        
        [[MyCommOperation shareInstance] quitGroup:self.groupInfo.groupId
                                               succ:^(void){
                                                   [[GlobalData shareInstance] removeGroup:weakSelf.groupInfo];
                                                   //更新群组列表
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReqGroupListResp object:nil];
                                                   [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                               } fail:^(int code, NSString* err){
                                                   TDDLogEvent(@"quick group failed.code:%d err:%@", code, err);}];
    }
}

static NSString *optRecvMessage = @"接收所有消息";
static NSString *optNotRecvMessage = @"屏蔽所有消息";
static NSString *optNotRecvNotify = @"屏蔽推送消息";
static NSInteger msgOptTag = 100;
- (void)recvMessageOpt {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:optRecvMessage,
                                  optNotRecvMessage,
                                  optNotRecvNotify,
                                  nil];
    [actionSheet showFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
    actionSheet.tag = msgOptTag;
}

static NSString *optForbid = @"禁止加群";
static NSString *optAuth = @"需要管理员审批";
static NSString *optAny = @"任何人可以加入";
static NSInteger groupOptTag = 101;
- (void)groupOpt {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:optForbid,
                                  optAuth,
                                  optAny,
                                  nil];
    [actionSheet showFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
    actionSheet.tag = groupOptTag;
}

- (void)dissolveGroup:(id)sender {
    TDDLogVerbose(@"dissolveGroup");
    __weak MyGroupInfoViewController* weakSelf = self;
    if (self.groupInfo && self.groupInfo.groupId && ![self.groupInfo.groupId isEqualToString:@""]) {
        
        [[MyCommOperation shareInstance] deleteGroup:self.groupInfo.groupId
                                               succ:^(void){
                                                   [[GlobalData shareInstance] removeGroup:weakSelf.groupInfo];
                                                   //更新群组列表
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReqGroupListResp object:nil];
                                                   [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                               } fail:nil];
    }
}

#pragma mark - Event Response<Freind Operation>

- (void)addBlackBtnClick:(id)sender {
    MyMemberModel *friendModel = [self.groupInfo.memberList firstObject];
    __weak MyGroupInfoViewController *weakSelf = self;
    [[MyCommOperation shareInstance] addBlackList:@[friendModel.user] succ:^(NSArray *data) {
        NSArray *controllers = [NSArray arrayWithObjects:[weakSelf.navigationController.viewControllers objectAtIndex:0], nil];
        [weakSelf.navigationController setViewControllers:controllers animated:YES];
    } fail:^(int code, NSString *err) {
        
    }];
}

- (void)delFriendBtnClick:(id)sender {
    __weak MyGroupInfoViewController *weakSelf = self;
    MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"提示" message:@"确定删除该好友吗" cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
        if (buttonIndex == 0){
            MyMemberModel *friendModel = [weakSelf.groupInfo.memberList firstObject];
            [[MyCommOperation shareInstance] delFriend:friendModel.user completionHandler:^(NSArray *data, NSString *err) {
                if (err) {
                    return;
                }
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                MyTabBarViewController *tab = app.tabBarViewCntrl;
                MyRecentViewController *recentViewCtl = tab.recentViewCntlr;
                [recentViewCtl deleteConversation:friendModel.user];
                
                NSArray *controllers = [NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0], nil];
                [self.navigationController setViewControllers:controllers animated:YES];
            }];
        }
        else{
            return ;
        }
    }];
    [alert show];
}

#pragma mark - Getter

- (MyInfoItemEditViewController *)groupNamecardEditController{
    __weak MyGroupInfoViewController* weakSelf = self;
    if (_groupNamecardEditController == nil) {
        _groupNamecardEditController = [[MyInfoItemEditViewController alloc] initWithBlock:^(NSString* newNamecard){
           [[MyCommOperation shareInstance] modifyGroupNamecard:weakSelf.groupInfo.groupId userId:[GlobalData shareInstance].me nameCard:newNamecard succ:^(){
               weakSelf.groupInfo.nameCard = newNamecard;
           } fail:^(int code, NSString* err){
               //含敏感词汇
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:ERRORCODE_TO_ERRORDEC(code) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
               [alert show];
           }];
        }];
        [self.groupNamecardEditController setItemTitle:@"群名片"];
        self.groupNamecardEditController.view.frame = self.view.bounds;
        [self addChildViewController:self.groupNamecardEditController];
        [self.view addSubview:self.groupNamecardEditController.view];
    }
    return _groupNamecardEditController;
}

- (MyInfoItemEditViewController*)groupTitleEditController{
    __weak MyGroupInfoViewController* weakSelf = self;
    if (_groupTitleEditController == nil) {
        _groupTitleEditController = [[MyInfoItemEditViewController alloc] initWithBlock:^(NSString* newTitle){
            [[MyCommOperation shareInstance] modifyGroupName:weakSelf.groupInfo.groupId groupName:newTitle succ:^() {
                weakSelf.groupInfo.groupTitle = newTitle;
            }fail:^(int code, NSString* err){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:ERRORCODE_TO_ERRORDEC(code) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }];
        }];
        [self.groupTitleEditController setItemTitle:@"群组名称"];
        self.groupTitleEditController.view.frame = self.view.bounds;
        [self addChildViewController:self.groupTitleEditController];
        [self.view addSubview:self.groupTitleEditController.view];
    }
    return _groupTitleEditController;
}

- (MyInfoItemEditViewController*)groupIntroductionEditController{
    __weak MyGroupInfoViewController* weakSelf = self;
    if (_groupIntroductionEditController == nil) {
        _groupIntroductionEditController = [[MyInfoItemEditViewController alloc] initWithBlock:^(NSString* newIntroduction){
            [[MyCommOperation shareInstance] modifyGroupIntroduction:weakSelf.groupInfo.groupId introduction:newIntroduction succ:^() {
                weakSelf.groupInfo.introduction = newIntroduction;
            }fail:^(int code, NSString* err){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:ERRORCODE_TO_ERRORDEC(code) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }];
        }];
        [self.groupIntroductionEditController setItemTitle:@"群简介"];
        self.groupIntroductionEditController.view.frame = self.view.bounds;
        [self addChildViewController:self.groupIntroductionEditController];
        [self.view addSubview:self.groupIntroductionEditController.view];
    }
    return _groupIntroductionEditController;
}

- (MyInfoItemEditViewController*)groupNotificationEditController{
    __weak MyGroupInfoViewController* weakSelf = self;
    if (_groupNotificationEditController == nil) {
        _groupNotificationEditController = [[MyInfoItemEditViewController alloc] initWithBlock:^(NSString* newNotification){
            [[MyCommOperation shareInstance] modifyGroupNotification:weakSelf.groupInfo.groupId notification:newNotification succ:^() {
                weakSelf.groupInfo.notification = newNotification;
            }fail:^(int code, NSString* err){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:ERRORCODE_TO_ERRORDEC(code) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }];
        }];
        [self.groupNotificationEditController setItemTitle:@"群公告"];
        self.groupNotificationEditController.view.frame = self.view.bounds;
        [self addChildViewController:self.groupNotificationEditController];
        [self.view addSubview:self.groupNotificationEditController.view];
    }
    return _groupNotificationEditController;
}

#pragma mark - Private Method: UI Decoration<InfoPageSrource_Group, InfoPageSource_C2C>

- (void)configGroupPage {
    if (self.tableView.tableFooterView == nil) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        footView.backgroundColor = [UIColor clearColor];
        
        self.tableView.tableFooterView = footView;
        if ([self.groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE] || ![self.groupInfo.owner isEqualToString:[GlobalData shareInstance].me]) { // 如果群类型是私有群或者用户不是群主，可以选择退出群聊
            UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [exitBtn setFrame:CGRectMake(footView.bounds.size.width/2-100, 5, 200, 40)];
            [exitBtn addTarget:self action:@selector(exitGroup:) forControlEvents:UIControlEventTouchUpInside];
            
            [exitBtn setTitle:@"退出群组" forState:UIControlStateNormal];
            exitBtn.backgroundColor = [UIColor lightGrayColor];
            
            [self.tableView.tableFooterView addSubview:exitBtn];
        }
        else { // 非私有群的群主可以选择解散该群
            UIButton* dissolveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [dissolveBtn setFrame:CGRectMake(footView.bounds.size.width/2-100, 5, 200, 40)];
            [dissolveBtn addTarget:self action:@selector(dissolveGroup:) forControlEvents:UIControlEventTouchUpInside];
            
            [dissolveBtn setTitle:@"解散群组" forState:UIControlStateNormal];
            dissolveBtn.backgroundColor = [UIColor lightGrayColor];
            
            [self.tableView.tableFooterView addSubview:dissolveBtn];
        }
    }
    
    UIBarButtonItem *msgOptButtonItem = [[UIBarButtonItem alloc]
                                         initWithTitle:@"消息设置"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(recvMessageOpt)];
    if ([self.groupInfo.owner isEqualToString:[GlobalData shareInstance].me] &&
        [self.groupInfo.groupType isEqualToString:GROUP_TYPE_PUBLIC]) {
        UIBarButtonItem *groupOptButtonItem = [[UIBarButtonItem alloc]
                                               initWithTitle:@"群设置"
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(groupOpt)];
        self.navigationItem.rightBarButtonItems = @[msgOptButtonItem, groupOptButtonItem];
    }
    else {
        self.navigationItem.rightBarButtonItem = msgOptButtonItem;
    }
}

- (void)configC2CPage {
    if (self.tableView.tableFooterView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 90)];
        view.backgroundColor = [UIColor clearColor];
        [self.tableView setTableFooterView:view];
        
        UIButton *addBlackBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [addBlackBtn setFrame:CGRectMake(self.tableView.tableFooterView.bounds.size.width/2-100, 5, 200, 40)];
        [addBlackBtn addTarget:self action:@selector(addBlackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [addBlackBtn setTitle:@"加入黑名单" forState:UIControlStateNormal];
        addBlackBtn.backgroundColor = [UIColor lightGrayColor];
        [self.tableView.tableFooterView addSubview:addBlackBtn];
        
        UIButton *delFriendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [delFriendBtn setFrame:CGRectMake(self.tableView.tableFooterView.bounds.size.width/2-100, 50, 200, 40)];
        [delFriendBtn addTarget:self action:@selector(delFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [delFriendBtn setTitle:@"删除好友" forState:UIControlStateNormal];
        delFriendBtn.backgroundColor = [UIColor lightGrayColor];
        [self.tableView.tableFooterView addSubview:delFriendBtn];
    }
}

#pragma mark - Private Mtehod: GroupInfo Modify Permission
- (BOOL)groupTitleModifyPermission {
    if ([self.groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
        return YES;
    }
    else {
        return [self isManagerOrOwner];
    }
}

- (BOOL)groupNamecardModifyPermission{
    return YES;
}

- (BOOL)groupIntroductionModifyPermission {
    if ([self.groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
        return YES;
    }
    else {
        return [self isManagerOrOwner];
    }
}

- (BOOL)groupNotificationModifyPermission {
    if ([self.groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
        return YES;
    }
    else {
        return [self isManagerOrOwner];
    }
}

- (BOOL)isManagerOrOwner {
    BOOL isOwner = NO;
    BOOL isManager = NO;
    for (MyMemberModel *memberModel in self.groupInfo.memberList) {
        if (![memberModel.user isEqualToString:[GlobalData shareInstance].me]) {
            continue;
        }
        if (memberModel.role == TIM_GROUP_MEMBER_ROLE_ADMIN) {
            isManager = YES;
        }
        else if (memberModel.role == TIM_GROUP_MEMBER_ROLE_SUPER) {
            isOwner = YES;
        }
        break;
    }
    return isOwner || isManager;
}

@end
