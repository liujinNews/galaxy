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

#import "MyGroupListViewController.h"
#import "MyGroupInfoModel.h"
#import "MyGroupInfoViewController.h"
#import "MyGroupAddFriendViewController.h"
#import "GlobalData.h"
#import "MyCommOperation.h"
#import "MyChatViewController.h"

@interface MyGroupListViewController()

@property (nonatomic, strong)NSMutableArray* dataSource;  //群列表
@property (nonatomic, strong)id groupListRspObserver;
@property (nonatomic, strong)id groupInfoRspObserver;
@end


@implementation MyGroupListViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"群列表";
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_icon_group_create"] style:UIBarButtonItemStylePlain target:self action:@selector(creatGroup:)];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:7];
    
    __weak MyGroupListViewController* weakSelf = self;
    self.groupListRspObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationReqGroupListResp
                                                                                   object:nil
                                                                                    queue:[NSOperationQueue mainQueue]
                                                                               usingBlock:^(NSNotification *note){
                                                                                   weakSelf.dataSource = [NSMutableArray arrayWithArray:[[GlobalData shareInstance].groupList allValues] ];
                                                                                   [weakSelf.tableView reloadData];
                                                                               } ];
    
    self.groupInfoRspObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationGroupInfoChange
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
    if (self.groupListRspObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.groupListRspObserver];
        [[NSNotificationCenter defaultCenter] removeObserver:self.groupInfoRspObserver];
        self.groupListRspObserver = nil;
        self.groupInfoRspObserver = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger retCount = 0;
    for (MyGroupInfoModel *groupInfo in self.dataSource) {
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
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
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
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
        if ([groupInfo.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
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


#pragma mark- navi
- (void)creatGroup:(id)sender{
    TDDLogVerbose(@"%s:%s", __FILE__, __FUNCTION__);
    MyGroupInfoModel *grouInfoModel = [[MyGroupInfoModel alloc] init];
    grouInfoModel.groupType = GROUP_TYPE_PRIVATE;
    MyGroupAddFriendViewController* controller = [[MyGroupAddFriendViewController alloc] initWithGroupInfo:grouInfoModel];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
