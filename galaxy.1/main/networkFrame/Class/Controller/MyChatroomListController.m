//
//  MyChatroomListController.m
//  MyDemo
//
//  Created by tomzhu on 15/6/10.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyChatroomListController.h"
#import "GlobalData.h"
#import "MyCommOperation.h"
#import "MyChatViewController.h"
#import "GlobalData.h"
#import "MyGroupInfoModel.h"
#import "MyGroupAddFriendViewController.h"
#import "JoinGroupViewController.h"

@interface MyChatroomListController ()
@property (nonatomic, strong)NSMutableArray* dataSource;  //聊天室列表
@property (nonatomic, strong)id chatroomListRspObserver;
@property (nonatomic, strong)id chatroomInfoRspObserver;

@end

@implementation MyChatroomListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天室列表";
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(creatChatroom:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchChatroom:)],
                                                ];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:7];
    
    __weak MyChatroomListController* weakSelf = self;
    self.chatroomListRspObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationReqGroupListResp
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note){
                                                                                  self.dataSource = [NSMutableArray arrayWithArray:[[GlobalData shareInstance].groupList allValues] ];
                                                                                  [weakSelf.tableView reloadData];
                                                                              } ];
    
    self.chatroomInfoRspObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationGroupInfoChange
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note){
                                                                                  self.dataSource = [NSMutableArray arrayWithArray:[[GlobalData shareInstance].groupList allValues] ];
                                                                                  [weakSelf.tableView reloadData];
                                                                              } ];
    
    if ([GlobalData shareInstance].groupList == nil || [GlobalData shareInstance].lastGroupListResp == 0) {
        [[MyCommOperation shareInstance] requestGroupList];
    }
    else{
        self.dataSource = [NSMutableArray arrayWithArray:[[GlobalData shareInstance].groupList allValues] ];
    }
    return;
}

- (void)dealloc{
    if (self.chatroomListRspObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.chatroomListRspObserver];
        [[NSNotificationCenter defaultCenter] removeObserver:self.chatroomInfoRspObserver];
        self.chatroomListRspObserver = nil;
        self.chatroomInfoRspObserver = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger retCount = 0;
    for (MyGroupInfoModel *groupInfo in self.dataSource) {
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_CHATROOM]) {
            retCount ++;
        }
    }
    return retCount;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* kReusedId = @"GroupInfoCellId";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:kReusedId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReusedId];
    }
    
    MyGroupInfoModel* model = nil;
    NSInteger count = -1;
    for (MyGroupInfoModel *groupInfo in self.dataSource) {
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_CHATROOM]) {
            count ++;
        }
        if (count >= indexPath.row) {
            model = groupInfo;
            break;
        }
    }
    
    cell.imageView.image = [UIImage imageNamed:@"contacts_nav_group"];
    cell.textLabel.text = model.groupTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyGroupInfoModel* model = nil;
    NSInteger count = -1;
    for (MyGroupInfoModel *groupInfo in self.dataSource) {
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_CHATROOM]) {
            count ++;
        }
        if (count >= indexPath.row) {
            model = groupInfo;
            break;
        }
    }
    MyChatViewController* controller = [[MyChatViewController alloc] initWithGroup:model.groupId];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - private methods
- (void)creatChatroom:(id)sender{
    TDDLogVerbose(@"%s:%s", __FILE__, __FUNCTION__);
    MyGroupInfoModel *grouInfoModel = [[MyGroupInfoModel alloc] init];
    grouInfoModel.groupType = GROUP_TYPE_CHATROOM;
    MyGroupAddFriendViewController* controller = [[MyGroupAddFriendViewController alloc] initWithGroupInfo:grouInfoModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchChatroom:(id)sender{
    JoinGroupViewController *joinGroupController = [[JoinGroupViewController alloc] init];
    [joinGroupController initConfig:@"查找聊天室" placeholder:@"请输入聊天室ID/名称"];
    [self.navigationController pushViewController:joinGroupController animated:YES];
}

@end
