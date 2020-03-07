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

#import "MyGroupAddFriendViewController.h"
#import "GlobalData.h"
#import "MyMemberModel.h"
#import "MyFriendModel.h"
#import "MyContactCell.h"
#import "NSStringEx.h"
#import "NSArray+addition.h"
#import "MyUtilty.h"
#import "MyGroupInfoModel.h"
#import "MyCommOperation.h"
#import "UIResponder+addtion.h"
#import "MyChatViewController.h"
#import "MyGroupInfoModel.h"
#import "MyChatCell.h"

@interface MyGroupAddFriendViewController()

@property (nonatomic, strong)NSMutableDictionary* contactDic;
@property (nonatomic, strong)NSMutableArray* sectionTitles;
@property (nonatomic, strong)MyGroupInfoModel* groupInfo; //进入选择页面时的群组信息（空:直接创建群组，c2c：有一个好友成员 现有群组：群成员）
@end

@implementation MyGroupAddFriendViewController

- (instancetype)initWithGroupInfo:(MyGroupInfoModel*) groupInfo{
    if (self = [super initWithNibName:nil bundle:nil]) {
        //设置tableview的相关内容
        if (groupInfo && groupInfo.groupType && [groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
            self.title = @"发起私有群";
        }
        if (groupInfo && groupInfo.groupType && [groupInfo.groupType isEqualToString:GROUP_TYPE_CHATROOM]) {
            self.title = @"发起聊天室";
        }
        if (groupInfo && groupInfo.groupType && [groupInfo.groupType isEqualToString:GROUP_TYPE_PUBLIC]) {
            self.title = @"发起公共群";
        }
        self.groupInfo = groupInfo;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                               initWithTitle:@"确定"
                               style:UIBarButtonItemStylePlain
                               target:self
                               action:@selector(didAddFriendToGroup)];
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去除多余的空隔线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    if (self.sectionTitles == nil) {
        self.sectionTitles = [NSMutableArray array];
    }
    if (self.contactDic == nil){
        self.contactDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    
    NSMutableArray* contactList = [NSMutableArray arrayWithCapacity:10];
    //设置选中状态
    for (MyFriendModel *contactModel in [[GlobalData shareInstance].friendList allValues]) {
        
        MyMemberModel* member = [MyMemberModel memberWithUserModel:contactModel];
        member.isJoined = NO;
        member.isSelected = NO;
        
        if (self.groupInfo && self.groupInfo.memberList){
            for (MyMemberModel *memberModel in self.groupInfo.memberList) {
                if ([memberModel.user isEqualToString:member.user]) {
                    member.isSelected = YES;
                    member.isJoined = NO;
                }
            }
        }
        
        [contactList addObject:member];
    }
    
    [self configureContactDataDic:contactList];
    
}


#pragma mark - DataProcess

//将通讯录好友数据按首字母区分
- (void)configureContactDataDic:(NSArray*)contactFrienArray
{
    [self.contactDic removeAllObjects];
    [self.sectionTitles removeAllObjects];
    
    for (MyMemberModel *contactModel in contactFrienArray) {
        if ([contactModel isKindOfClass:[MyMemberModel class]])
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
    
    return letterArray;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* title = [self.sectionTitles objectAtIndex:section];
    NSArray* sectionCellArray = [self.contactDic objectForKey:title];
    if (sectionCellArray != nil) {
        return [sectionCellArray count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return nil;
    }
    return [self.sectionTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CONTACT_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"ContactTableCell";
    
    NSString *title = @"";
    title = [self.sectionTitles objectAtIndex:indexPath.section];
    
    NSMutableArray *arrayWithSameTitle = [self.contactDic objectForKey:title];
    
    UITableViewCell *cell;
    
    MyContactCell* contactCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (contactCell == nil) {
        contactCell = [[MyContactCell alloc] initWithType:ContactCellType_AddGroup style:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    MyMemberModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
    [contactCell updateModel:model];
    cell = contactCell;
    
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
    if (section == 0) {
        return 10;
    }
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TDDLogVerbose(@"%s TableCell select: section:%d index:%d", __FILE__,  indexPath.section, indexPath.row);
    NSString *title = @"";
    title = [self.sectionTitles objectAtIndex:indexPath.section];
    
    NSMutableArray *arrayWithSameTitle = [self.contactDic objectForKey:title];
    
    MyMemberModel* model = [arrayWithSameTitle objectAtIndex:indexPath.row];
    
    //更新视图
    //已经在群组中的成员，不能取消掉
    if(!model.isJoined){
        model.isSelected = !model.isSelected;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    }
}

//递归计算符合规定的文本长度
- (NSString *)cutBeyondText:(NSString *)fieldText{
     size_t length = strlen([fieldText UTF8String]);
    if (length > MAX_GROUP_INFO_CONTENT_LEN) {
        fieldText = [fieldText substringToIndex:fieldText.length-1];
        return [self cutBeyondText:fieldText];
    }
    else{
        return fieldText;
    }
}

#pragma mark - search
- (void)didAddFriendToGroup{
    TDDLogVerbose(@"%s:%s", __FILE__, __FUNCTION__);
    NSMutableArray* friendArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableString* tmpGroupName = [NSMutableString stringWithCapacity:50];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    for (NSArray* array in self.contactDic.allValues) {
        for (MyMemberModel* model in array) {
            if (model.isSelected && !model.isJoined) {
                [friendArray addObject:model.user];
                model.isSelected = NO;
                model.isJoined = NO;
                if (![tmpGroupName isEqualToString:@""]) {
                    [tmpGroupName appendString:@","];
                }
                [tmpGroupName appendString:model.nickName];
            }
        }
    }
    
    if (friendArray.count == 0) {
        [self showAlert:@"提示：" andMsg:@"未选择加入群组的好友"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    if (self.groupInfo == nil) { //直接从空群组创建
        if (friendArray.count == 1) {
            //直接采用c2c会话
            MyChatViewController* chatViewController = [[MyChatViewController alloc] initWithC2C:[friendArray objectAtIndex:0]];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController pushViewController:chatViewController animated:YES];
            return;
        }
    }
    else if (self.groupInfo.type == TIM_C2C) {
        MyMemberModel* model = [self.groupInfo.memberList objectAtIndex:0];
        [friendArray insertObject:model atIndex:0];
        [tmpGroupName insertString:model.nickName atIndex:0];
    }
    
    NSString* groupName = tmpGroupName;

    if ([MyChatCell stringContainsEmoji:groupName]) {
        [self showPrompt:@"群名称不能包含表情"];
        return;
    }
    size_t length = strlen([groupName UTF8String]);
    if( length > MAX_GROUP_INFO_CONTENT_LEN){
        groupName = [self cutBeyondText:groupName];
    }
    //todo: 添加好友到群并展示聊天视图
    //创建群
    __weak MyGroupAddFriendViewController* weakSelf = self;
    void (^createGroupSucc)(NSString *groupId) = ^(NSString *groupId) {
        MyGroupInfoModel* model = [[MyGroupInfoModel alloc] init];
        model.groupId = groupId;
        model.groupTitle = groupName;
        model.memberList = friendArray;
        [[GlobalData shareInstance] addGroup:model];
        
        //更新群资料
        [[MyCommOperation shareInstance] requestGroupList];
        [[MyCommOperation shareInstance] requestGroupInfo:@[groupId]];
        [[MyCommOperation shareInstance] requestGroupMembers:groupId];
        
        //跳转到群会话
        MyChatViewController* chatViewController = [[MyChatViewController alloc] initWithGroup:groupId];
        chatViewController.hidesBottomBarWhenPushed = YES;
        
        NSArray* controllers = [NSArray arrayWithObjects:[weakSelf.navigationController.viewControllers objectAtIndex:0],
                                chatViewController,
                                nil];
        
        //                                                     [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        [weakSelf.navigationController setViewControllers:controllers animated:YES];
    };
    
    void (^inviteFriendToGroupSucc)(NSArray* members) = ^(NSArray *members) {
        MyGroupInfoModel* groupInfo = [[GlobalData shareInstance] getGroupInfo:weakSelf.groupInfo.groupId];
        if (groupInfo == nil) {
            TDDLogEvent(@"add memeber. but group is not exit. group id:%@", weakSelf.groupInfo.groupId);
            return;
        }
        
        for (TIMGroupMemberResult* member in members) {
            if (member.status != TIM_GROUP_MEMBER_STATUS_FAIL) {
                
                MyMemberModel* memberModel;
                MyUserModel* friend = [[GlobalData shareInstance]getFriendInfo:member.member];
                if (friend == nil) {
                    memberModel = [[MyMemberModel alloc] init];
                    memberModel.user = member.member;
                    memberModel.nickName = member.member;
                }
                else{
                    memberModel = [MyMemberModel memberWithUserModel:friend];
                }
                
                BOOL isJoined = NO;
                
                for (MyMemberModel* groupMember in groupInfo.memberList) {
                    if ([groupMember.user isEqualToString:member.member]) {
                        isJoined = YES;
                        break;
                    }
                }
                if (!isJoined) {
                    [groupInfo.memberList addObject:memberModel];
                }
            }else{
                TDDLogEvent(@"Add to group failed. member:%@ group:%@", member.member, groupName);
            }
            
            //跳转到群会话
            MyChatViewController* chatViewController = [[MyChatViewController alloc] initWithGroup:groupInfo.groupId];
            chatViewController.hidesBottomBarWhenPushed = YES;
            
            NSArray* controllers = [NSArray arrayWithObjects:[weakSelf.navigationController.viewControllers objectAtIndex:0], chatViewController, nil];            
            [weakSelf.navigationController setViewControllers:controllers animated:YES];
        }
    };
    
    if (self.groupInfo == nil) {
        TDDLogEvent(@"groupInfo need be inited");
    }
    else if (self.groupInfo.type == TIM_C2C
             || (self.groupInfo.groupId == nil && [self.groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE])) {
        [[MyCommOperation shareInstance] createPrivateGroup:friendArray groupName:groupName
                                                 succ:createGroupSucc
                                                 fail:^(int code, NSString *err){
                                                     weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                                                     [weakSelf.tableView reloadData];
                                                 }];
    }
    else if (self.groupInfo.groupId == nil && [self.groupInfo.groupType isEqualToString:GROUP_TYPE_CHATROOM]) {
        [[MyCommOperation shareInstance] createChatRoomGroup:friendArray groupName:groupName
                                                        succ:createGroupSucc
                                                        fail:^(int code, NSString *err){
                                                            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                                                            [weakSelf.tableView reloadData];
                                                        }];
    }
    else if (self.groupInfo.groupId == nil && [self.groupInfo.groupType isEqualToString:GROUP_TYPE_PUBLIC]) {
        [[MyCommOperation shareInstance] createPublicGroup:friendArray groupName:groupName
                                                         succ:createGroupSucc
                                                         fail:^(int code, NSString *err){
                                                             weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                                                             [weakSelf.tableView reloadData];
                                                         }];
    }
    else{
        [[MyCommOperation shareInstance] inviteGroupMember:self.groupInfo.groupId
                                                    members:friendArray
                                                       succ:inviteFriendToGroupSucc
                                                       fail:^(int code, NSString *err){
                                                           weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                                                           [weakSelf.tableView reloadData];
                                                       }];
    }
}

@end
