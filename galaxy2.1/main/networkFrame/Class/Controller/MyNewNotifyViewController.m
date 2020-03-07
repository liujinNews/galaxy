//
//  MyNewFriendViewController.m
//  MyDemo
//
//  Created by tomzhu on 15/7/6.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyNewNotifyViewController.h"
#import "MySystemNotifyModel.h"
#import "NSStringEx.h"
#import "MyNewFriendCell.h"
#import "MyGroupSystemNotifyCell.h"
#import "UIResponder+addtion.h"
#import "MyCommOperation.h"
#import "GlobalData.h"
#import "MyFriendApplyViewController.h"
#import "MyChatViewController.h"

#import <ImSDK/TIMFriendshipManager.h>

#import "AppDelegate.h"
#import "MyContactsViewController.h"
#import "MyTabBarViewController.h"

@interface MyNewNotifyViewController ()
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)id SNSSystemNotifyListChangeObserver;
@property (strong, nonatomic) MyFriendApplyViewController *myFriendApplyViewController;


@end

@implementation MyNewNotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"新的朋友"];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self reloadData];
}
- (void)reloadData{
    
    __weak MyNewNotifyViewController* weakSelf = self;
    
    TIMFriendshipManager *friendshipMgr = [[TIMFriendshipManager alloc] init];
    TIMFriendPendencyMeta *meta = [[TIMFriendPendencyMeta alloc] init];
    meta.seq = 0;
    meta.numPerPage = 10;
    [friendshipMgr GetPendencyFromServer:meta type:TIM_PENDENCY_GET_COME_IN
                                    succ:^(TIMFriendPendencyMeta * meta, NSArray * pendencies){
                                        self.dataSource = [NSMutableArray arrayWithArray:pendencies];
                                        [weakSelf.tableView reloadData];
                                    }
                                    fail:^(int code, NSString *err){
                                        NSString *showInfo = [[NSString alloc] initWithFormat:@"拉取新通知失败，错误码:%d,失败描述%@",code,err];
                                        [self showAlert:@"提示" andMsg:showInfo];
                                    }];
    
}
- (void)dealloc{
    if ( self.SNSSystemNotifyListChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.SNSSystemNotifyListChangeObserver];
    }
    self.SNSSystemNotifyListChangeObserver = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CONTACT_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *kSNSCellId = @"SNSSystemNotify";
    NSString *kGroupCellId = @"GroupSystemNotify";
    TIMFriendPendencyItem *item = [self.dataSource objectAtIndex:indexPath.row];
    MySystemNotifyModel *notifyModel = [[MySystemNotifyModel alloc] init];
    notifyModel.user = item.identifier;
    notifyModel.wording = item.addWording;
    MyNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kSNSCellId];
        
    if (cell == nil) {
        cell = [[MyNewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSNSCellId];
        cell.acceptBtnAction = ^(NSString *user){
            if (!user) {
                return;
            }
            [[MyCommOperation shareInstance]
             acceptFriendApply:user
             succ:^(NSArray *data){
                 //删除本条新消息
                 [self.tableView beginUpdates];
                 
                 [self reloadData];
                 
                 [self.tableView endUpdates];
                 
                 //更新联系人
                 AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 MyTabBarViewController *tab = app.tabBarViewCntrl;
                 MyContactsViewController *contactsViewCtl = tab.contactsViewCntlr;
                 [contactsViewCtl updateTable];
                 
                 [self showAlert:@"提示" andMsg:@"添加成功"];
             }
             fail:^(int code, NSString *err){
                 [self showAlert:@"提示" andMsg:@"添加失败"];
             }];
        };
    }
    [cell updateModel:notifyModel];
    return cell;
}

#pragma mark - Private Methods
- (void)configureDataSource:(NSArray *)dataSource {
    [self.dataSource removeAllObjects];
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
}

#pragma mark- cellView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didselect");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyNewFriendCell *myNewFriednCell = (MyNewFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    MySystemNotifyModel *cellModel = [myNewFriednCell getModel];
    
    self.myFriendApplyViewController = [[MyFriendApplyViewController alloc] init];
    [self.myFriendApplyViewController initModel:cellModel];
    [self.myFriendApplyViewController setDelegate:self];
    [self.navigationController pushViewController:_myFriendApplyViewController animated:YES];
}

#pragma mark DeleteCell
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TIMFriendPendencyItem * item = [self.dataSource objectAtIndex:indexPath.row];;
        NSArray * users = [[NSArray alloc] initWithObjects:item.identifier, nil];
        [[MyCommOperation shareInstance] deletePendency:TIM_PENDENCY_GET_COME_IN users:users succ:^(NSArray *users){
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } fail:^(int code, NSString *errDetail){
            
        }];
    }
}

@end
