//
//  MyPublicGroupViewController.m
//  MyDemo
//
//  Created by tomzhu on 15/6/16.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyPublicGroupViewController.h"
#import "GlobalData.h"
#import "MyCommOperation.h"
#import "MyChatViewController.h"
#import "GlobalData.h"
#import "MyGroupInfoModel.h"
#import "MyGroupAddFriendViewController.h"
#import "JoinGroupViewController.h"

@interface MyPublicGroupViewController ()

@property (nonatomic, strong)NSMutableArray* dataSource;  //公共群列表
@property (nonatomic, strong)id publicGroupListRspObserver;
@property (nonatomic, strong)id publicGroupInfoRspObserver;
//@property (nonatomic, weak)UIButton *createPublicGroupBtn;
//@property (nonatomic, weak)UIButton *searchPublicGroupBtn;
//@property (nonatomic, weak)UIButton *handleApplyBtn;
@end

@implementation MyPublicGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公共群列表";
    
//    UIView *headerView = [UIView new];
//    headerView.backgroundColor = [UIColor clearColor];
//    headerView.frame = CGRectMake(0, 0, 330, 30);
    
//    _createPublicGroupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _createPublicGroupBtn.frame = CGRectMake(50, 5, 120, 20);
//    [_createPublicGroupBtn setTitle:@"创建公共群" forState:UIControlStateNormal];
//    [_createPublicGroupBtn addTarget:self action:@selector(creatPublicGroup:) forControlEvents:UIControlEventTouchUpInside];
//    
//    _searchPublicGroupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _searchPublicGroupBtn.frame = CGRectMake(210, 5, 120, 20);
//    [_searchPublicGroupBtn setTitle:@"搜索公共群" forState:UIControlStateNormal];
//    [_searchPublicGroupBtn addTarget:self action:@selector(searchPublicGroup:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [headerView addSubview:self.createPublicGroupBtn];
//    [headerView addSubview:self.searchPublicGroupBtn];
    
//    [self.tableView setTableHeaderView:headerView];
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(creatPublicGroup:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchPublicGroup:)],
                                                ];

    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:7];
    
    __weak MyPublicGroupViewController* weakSelf = self;
    self.publicGroupListRspObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationReqGroupListResp
                                                                                     object:nil
                                                                                      queue:[NSOperationQueue mainQueue]
                                                                                 usingBlock:^(NSNotification *note){
                                                                                     weakSelf.dataSource = [NSMutableArray arrayWithArray:[[GlobalData shareInstance].groupList allValues] ];
                                                                                     [weakSelf.tableView reloadData];
                                                                                 } ];
    
    self.publicGroupInfoRspObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationGroupInfoChange
                                                                                     object:nil
                                                                                      queue:[NSOperationQueue mainQueue]
                                                                                 usingBlock:^(NSNotification *note){
                                                                                     weakSelf.dataSource = [NSMutableArray arrayWithArray:[[GlobalData shareInstance].groupList allValues] ];
                                                                                     [weakSelf.tableView reloadData];
                                                                                 } ];
    //    self.tableView.backgroundColor = [UIColor clearColor];
    
    if ([GlobalData shareInstance].groupList == nil || [GlobalData shareInstance].lastGroupListResp == 0) {
        [[MyCommOperation shareInstance] requestGroupList];
    }
    else{
        self.dataSource = [NSMutableArray arrayWithArray:[[GlobalData shareInstance].groupList allValues] ];
    }
    return;
}

- (void)dealloc{
    if (self.publicGroupListRspObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.publicGroupListRspObserver];
        [[NSNotificationCenter defaultCenter] removeObserver:self.publicGroupInfoRspObserver];
        self.publicGroupListRspObserver = nil;
        self.publicGroupInfoRspObserver = nil;
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
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_PUBLIC]) {
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
        //        cell.contentView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
    }
    
    MyGroupInfoModel* model = nil;
    NSInteger count = -1;
    for (MyGroupInfoModel *groupInfo in self.dataSource) {
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_PUBLIC]) {
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
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_PUBLIC]) {
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
- (void)creatPublicGroup:(id)sender{
    TDDLogVerbose(@"%s:%s", __FILE__, __FUNCTION__);
    MyGroupInfoModel *grouInfoModel = [[MyGroupInfoModel alloc] init];
    grouInfoModel.groupType = GROUP_TYPE_PUBLIC;
    MyGroupAddFriendViewController* controller = [[MyGroupAddFriendViewController alloc] initWithGroupInfo:grouInfoModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchPublicGroup:(id)sender{
    JoinGroupViewController *joinGroupController = [[JoinGroupViewController alloc] init];
    [joinGroupController initConfig:@"查找公开群" placeholder:@"请输入群ID/群名称"];
    [self.navigationController pushViewController:joinGroupController animated:YES];
}

@end
