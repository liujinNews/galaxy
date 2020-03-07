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

#import "MyContactsViewController.h"
#import "MyFriendModel.h"
#import "MyNaviCellModel.h"
#import "MyTeamModel.h"
#import "NSStringEx.h"
#import "NSArray+addition.h"
#import "MyNaviCell.h"
#import "MyContactCell.h"
#import "MyTeamCell.h"
#import "MyChatViewController.h"
#import "MyAddFriendViewController.h"
#import "GlobalData.h"
#import "UIResponder+addtion.h"
#import "MyGroupListViewController.h"
#import "MyChatroomListController.h"
#import "MyPublicGroupViewController.h"
#import "MyBlackListViewController.h"
#import "MyNewNotifyViewController.h"
#import "MyUtilty.h"
#import "MyCommOperation.h"
#import "AccountHelper.h"

#import "AppDelegate.h"
#import "MyRecentViewController.h"
#import "MyTabBarViewController.h"

#import "MyFutureFriendViewController.h"

#import "MyAlertView.h"

#define MAX_ROW_NUM 10000

@interface MyContactsViewController ()

@property (nonatomic, strong)id friendListRspObserver;

@end

@implementation MyContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"contacts_addfriend"] style:UIBarButtonItemStylePlain target:self action:@selector(showAddFriendView)]];
    
    if (self.sectionTitles == nil) { //存放每个FriendList Section对应的首字母和群组、新的朋友id
        self.sectionTitles = [NSMutableArray array];
    }
    if (self.contactDic == nil){ //存放相同首字母玩家的昵称阵列
        self.contactDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    __weak MyContactsViewController* weakSelf = self;
    
    // 请求好友列表后更新联系人名单
    self.friendListRspObserver = [[NSNotificationCenter defaultCenter]
                                  addObserverForName:kMyNotificationReqFriendListResp
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note){
                                                      [weakSelf configureContactDataDic:[[GlobalData shareInstance].friendList allValues]];
                                                      [weakSelf.tableView reloadData];
                                                  } ];
    if ([GlobalData shareInstance].friendList == nil || [GlobalData shareInstance].lastGroupListResp == 0) {
        [[MyCommOperation shareInstance] requestFriendList];
    }
    else{
        [self configureContactDataDic:[[GlobalData shareInstance].friendList allValues]];
    }
    
    return;
    
}

- (void)dealloc{
    if ( self.friendListRspObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.friendListRspObserver];
    }
    self.friendListRspObserver = nil;
}

#pragma mark- newNotify  刷新界面 

-(void)updateTable{
    [[MyCommOperation shareInstance] requestFriendList];
    [self configureContactDataDic:[[GlobalData shareInstance].friendList allValues]];
    [self.tableView reloadData];
}

#pragma mark - DataProcess

//将通讯录好友数据按首字母区分
- (void)configureContactDataDic:(NSArray*)contactFrienArray
{
    [self.contactDic removeAllObjects];
    [self.sectionTitles removeAllObjects];
    
    NSMutableDictionary *preTeamDic = self.teamDic;
    
    self.teamDic = [[NSMutableDictionary alloc] init];
    
    for (MyFriendModel *contactModel in contactFrienArray) {
        if ([contactModel isKindOfClass:[MyFriendModel class]])
        {
            NSString *firstLetter = contactModel.sortedPy;
            if ( [firstLetter length]>0 )
            {
                unichar uniLetter = [firstLetter characterAtIndex:0];
                if ( (uniLetter<'A' || uniLetter>'Z'))
                {
                    firstLetter = NOREG_STRING;
                }
            }
            else
            {
                firstLetter = NOREG_STRING;
            }
            
            MyTeamModel *model = [[MyTeamModel alloc] init];
            MyTeamModel *preModel = nil;
            if ((preModel = (MyTeamModel *)[preTeamDic objectForKey:firstLetter])) {
                model.isFold = preModel.isFold;
            }
            else {
                model.isFold = YES;
            }
            model.teamTitle = firstLetter;
            [self.teamDic setObject:model forKey:firstLetter];
            
            NSMutableArray *modelArrWithSameTitle = [self.contactDic objectForKey:firstLetter];
            if ( nil == modelArrWithSameTitle )
            {
                modelArrWithSameTitle = [NSMutableArray arrayWithObject:contactModel];
                [self.contactDic setObject:modelArrWithSameTitle forKey:firstLetter];
            }
            else
            {
                [modelArrWithSameTitle addObject:contactModel];
            }
        }
    }
    
    [preTeamDic removeAllObjects];
    
    
    //初始化headViewTitle
    NSMutableArray *sectionTitles = [NSMutableArray arrayWithCapacity:16];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[self.contactDic allKeys]];
    [sortedArray sortUsingFunction:sortObjectsByFirstLetterAscending context:nil];
    for ( NSString *key in sortedArray )
    {
        if ( [key length]>0)
        {
            //对每个首字母分组里的数据排序,英文的拍前面
            NSMutableArray *mut_array = [self.contactDic objectForKey:key];
            [mut_array sortedUserModelsByNameAscend:YES];
            if (![key isEqualToString:NOREG_STRING]) {
                [sectionTitles addObject:key];
            }
        }
    }
    //当＃的关键字里存在数据时title才加#
    NSMutableArray *modelArrWithSameTitle = [self.contactDic objectForKey:NOREG_STRING];
    if (modelArrWithSameTitle != nil && [modelArrWithSameTitle count]>0) {
        [sectionTitles addObject:NOREG_STRING];
    }
    
    //展示群聊导航栏
    [sectionTitles insertObject:@"Navi_private" atIndex:0];
    MyNaviCellModel *model = [[MyNaviCellModel alloc] init];
    model.type = NaviCellModelGroup;
    NSMutableArray *modelArray = [NSMutableArray arrayWithObject:model];
    [self.contactDic setObject:modelArray forKey:[sectionTitles objectAtIndex:0]];
    
    //展示聊天室导航栏
    [sectionTitles insertObject:@"Navi_chatroom" atIndex:0];
    model = [[MyNaviCellModel alloc] init];
    model.type = NaviCellModelGroup;
    modelArray = [NSMutableArray arrayWithObject:model];
    [self.contactDic setObject:modelArray forKey:[sectionTitles objectAtIndex:0]];

    //展示公开群导航栏
    [sectionTitles insertObject:@"Navi_public" atIndex:0];
    model = [[MyNaviCellModel alloc] init];
    model.type = NaviCellModelGroup;
    modelArray = [NSMutableArray arrayWithObject:model];
    [self.contactDic setObject:modelArray forKey:[sectionTitles objectAtIndex:0]];
    
    //展示新的朋友导航栏
    [sectionTitles insertObject:@"Navi_newNotify" atIndex:0];
    model = [[MyNaviCellModel alloc] init];
    model.type = NaviCellModelNewNotify;
    modelArray = [NSMutableArray arrayWithObject:model];
    [self.contactDic setObject:modelArray forKey:[sectionTitles objectAtIndex:0]];
    
    //展示好友推荐导航栏
    [sectionTitles insertObject:@"Navi_recommendFriend" atIndex:0];
    model = [[MyNaviCellModel alloc] init];
    model.type = NaviCellModelGroup;
    modelArray = [NSMutableArray arrayWithObject:model];
    [self.contactDic setObject:modelArray forKey:[sectionTitles objectAtIndex:0]];
    
    self.sectionTitles = sectionTitles;
}


#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSString* letter = nil;
    NSMutableArray* letterArray = [NSMutableArray array];
    
    CGFloat contentH = self.tableView.contentSize.height-44;
    CGFloat frameH = self.tableView.frame.size.height;
    
    if (contentH>frameH) {
        [letterArray addObject:UITableViewIndexSearch];
        for (char c = 'A'; c <= 'Z'; c++)
        {
            letter = [NSString stringWithFormat:@"%c",c];
            [letterArray addObject:letter];
        }
        
        letter = NOREG_STRING;
        [letterArray addObject:letter];
    }
    
    return letterArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* title = [self.sectionTitles objectAtIndex:section];
    NSArray* sectionCellArray = [self.contactDic objectForKey:title];
    if (sectionCellArray != nil) {
        MyTeamModel *model = [self.teamDic objectForKey:title];
        if (model == nil) {
            return [sectionCellArray count];
        }
        else if (model.isFold) {
            return 1;
        }
        else {
            return [sectionCellArray count] + 1;
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSInteger noTitleNum = [self firstSectionNumForFreindList];
    if (section < noTitleNum){
        return nil;
    }
    return [self.sectionTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CONTACT_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"ContactTableCell";
    static NSString *naviPrivateId = @"NaviPrivateTableCell";
    static NSString *naviChartrommId = @"NaviChartroomTableCell";
    static NSString *naviPublicId = @"NaviPublicTableCell";
    static NSString *naviNewNotifyId = @"NaviNewNotifyTableCell";
    static NSString *naviRecommendFriendId = @"NaviRecommendFriendTableCell";
    static NSString *naviTeamId = @"NaviTeamTableCell";
    
    //根据title确定是要展示新联系人还是QQ联系人还是普通联系人cell
    NSString *title = @"";
    title = [self.sectionTitles objectAtIndex:indexPath.section];
    
    NSMutableArray *arrayWithSameTitle = [self.contactDic objectForKey:title];
    
    UITableViewCell *cell;
    if ([title isEqualToString:@"Navi_private"]) {
        MyNaviCell* naviCell = [tableView dequeueReusableCellWithIdentifier:naviPrivateId];
        if (naviCell == nil) {
            naviCell = [[MyNaviCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:naviPrivateId];
        }
        MyNaviCellModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
        [naviCell updateModel:(model)];
        cell = naviCell;
    } else if ([title isEqualToString:@"Navi_chatroom"]) {
        MyNaviCell* naviCell = [tableView dequeueReusableCellWithIdentifier:naviChartrommId];
        if (naviCell == nil) {
            naviCell = [[MyNaviCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:naviChartrommId];
        }
        MyNaviCellModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
        [naviCell updateModel:(model)];
        cell = naviCell;
    } else if ([title isEqualToString:@"Navi_public"]) {
        MyNaviCell* naviCell = [tableView dequeueReusableCellWithIdentifier:naviPublicId];
        if (naviCell == nil) {
            naviCell = [[MyNaviCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:naviPublicId];
        }
        MyNaviCellModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
        [naviCell updateModel:(model)];
        cell = naviCell;
    }else if ([title isEqualToString:@"Navi_newNotify"]) {
        MyNaviCell* naviCell = [tableView dequeueReusableCellWithIdentifier:naviNewNotifyId];
        if (naviCell == nil) {
            naviCell = [[MyNaviCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:naviNewNotifyId];
        }
        MyNaviCellModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
        [naviCell updateModel:(model)];
        cell = naviCell;
    }
    else if ([title isEqualToString:@"Navi_recommendFriend"]){
        MyNaviCell* naviCell = [tableView dequeueReusableCellWithIdentifier:naviRecommendFriendId];
        if (naviCell == nil) {
            naviCell = [[MyNaviCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:naviRecommendFriendId];
        }
        MyNaviCellModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
        [naviCell updateModel:(model)];
        cell = naviCell;
    }
    else {
        if (indexPath.row == 0) {
            MyTeamCell* teamCell = [tableView dequeueReusableCellWithIdentifier:naviTeamId];
            if (teamCell == nil) {
                teamCell = [[MyTeamCell alloc] initWithType:UITableViewCellStyleDefault reuseIdentifier:naviTeamId];
            }
            
            MyTeamModel* model = [self.teamDic objectForKey:title];
            [teamCell updateModel:model];
            cell = teamCell;
        }
        else {
            MyContactCell* contactCell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (contactCell == nil) {
                contactCell = [[MyContactCell alloc] initWithType:ContactCellType_ContactList style:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            
            MyFriendModel* model = [self getFriendModelFromIndexPath:indexPath array:arrayWithSameTitle];
            [contactCell updateModel:model];
            cell = contactCell;
        }
    }
    
    return cell;
}

//设置索引条对应关系
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger sectionIndex = NSNotFound;
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        CGPoint pnt = CGPointMake(0, -tableView.contentInset.top);
        [tableView setContentOffset:pnt animated:NO];
    }
    else
    {
        if ([self.sectionTitles containsObject:title])
        {
            sectionIndex = [self.sectionTitles indexOfObject:title];
        }
    }
    return sectionIndex;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger highSectionNum = [self firstSectionNumForFreindList];
    if (section >= highSectionNum) {
        return 10;
    }
    return 2;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TDDLogVerbose(@"%s TableCell select: section:%ld index:%d", __FILE__,  indexPath.section, indexPath.row);
    NSString *title = @"";
    title = [self.sectionTitles objectAtIndex:indexPath.section];
    
    NSMutableArray *arrayWithSameTitle = [self.contactDic objectForKey:title];
    if ([title isEqualToString:@"Navi_private"]) {
//        MyNaviCellModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
        //跳转到群列表页
        MyGroupListViewController *groupListCntler = [[MyGroupListViewController alloc] init];
        groupListCntler.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupListCntler animated:YES];
    } else if ([title isEqualToString:@"Navi_chatroom"]) {
        MyChatroomListController *chatroomListCntler = [[MyChatroomListController alloc] init];
        chatroomListCntler.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatroomListCntler animated:YES];
    } else if ([title isEqualToString:@"Navi_public"]) {
        MyPublicGroupViewController *publicGroupCntler = [[MyPublicGroupViewController alloc] init];
        publicGroupCntler.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publicGroupCntler animated:YES];
    } else if ([title isEqualToString:@"Navi_newNotify"]) {
        MyNewNotifyViewController *newNotifyCntler = [[MyNewNotifyViewController alloc] init];
        newNotifyCntler.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newNotifyCntler animated:YES];
    }
//    else if ([title isEqualToString:@"Navi_newSystemNotify"]) {
//        MySystemNotifyViewController *newNotifyCntler = [[MySystemNotifyViewController alloc] init];
//        newNotifyCntler.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:newNotifyCntler animated:YES];
//    }
    else if ([title isEqualToString:@"Navi_recommendFriend"]) {
        MyFutureFriendViewController *recFriendCntler = [[MyFutureFriendViewController alloc] init];
        recFriendCntler.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recFriendCntler animated:YES];
    }
    else{
        if (indexPath.row == 0) {
            MyTeamModel *model = [self.teamDic objectForKey:title];
            model.isFold = !model.isFold;
            [self.tableView reloadData];
        }
        else {
            MyFriendModel* model = [self getFriendModelFromIndexPath:indexPath array:arrayWithSameTitle];
            
            //跳转到AIO
            MyChatViewController *chatCntler = [[MyChatViewController alloc] initWithC2C:model.user];
            
            chatCntler.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatCntler animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger noEditNum = [self firstSectionNumForFreindList];
    if (indexPath.section >= noEditNum && indexPath.row != 0) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    NSInteger noEditNum = [self firstSectionNumForFreindList];
    
    if(indexPath.section >= noEditNum && indexPath.row != 0)
        return  UITableViewCellEditingStyleDelete;  //返回此值时,Cell会做出响应显示Delete按键,点击Delete后会调用下面的函数,别给传递UITableViewCellEditingStyleDelete参数
    else
        return  UITableViewCellEditingStyleNone;   //返回此值时,Cell上不会出现Delete按键,即Cell不做任何响应
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak MyContactsViewController *weakSelf = self;
        __weak NSIndexPath *weakIndexPath = indexPath;
        MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"提示" message:@"确定删除该好友吗" cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
            if (buttonIndex == 0){
                NSString* title = [weakSelf.sectionTitles objectAtIndex:weakIndexPath.section];
                NSMutableArray *arrayWithSameTitle = [weakSelf.contactDic objectForKey:title];
                
                MyFriendModel* friendModel;
                MyModel* model = [weakSelf getFriendModelFromIndexPath:weakIndexPath array:arrayWithSameTitle];
                if ([model isKindOfClass:[MyFriendModel class]]) {
                    friendModel = (MyFriendModel *)model;
                    //删除好友
                    [[MyCommOperation shareInstance] delFriend:friendModel.user completionHandler:nil];
                    
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    MyTabBarViewController *tab = app.tabBarViewCntrl;
                    MyRecentViewController *recentViewCtl = tab.recentViewCntlr;
                    [recentViewCtl deleteConversation:friendModel.user];
                }
            }
            else{
                return ;
            }
        }];
        [alert show];
    }
}

#pragma mark - search
- (void)showAddFriendView{
    MyAddFriendViewController* addFreindCntlor = [[MyAddFriendViewController alloc] init];
    [self.navigationController pushViewController:addFreindCntlor animated:YES];
}

#pragma mark - Private Methods
- (NSInteger)firstSectionNumForFreindList {
    NSInteger sectionNum = 6;
    return sectionNum;
}

- (MyFriendModel*)getFriendModelFromIndexPath:(NSIndexPath*)indexPath array:(NSArray*)array {
    return [array objectAtIndex:indexPath.row - 1];
}
#pragma mark- newFroend
- (void)gotoChatView:(MyFriendModel*)model{
    //MyFriendModel* model = model;
    
    //跳转到AIO
    MyChatViewController *chatCntler = [[MyChatViewController alloc] initWithC2C:model.user];
    
    chatCntler.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatCntler animated:YES];
}
@end
