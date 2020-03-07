//
//  MyRecommendFriendViewController.m
//  MyDemo
//
//  Created by wilderliao on 15/9/9.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//


#import "NSStringEx.h"
#import "UIResponder+addtion.h"
#import "MyCommOperation.h"
#import "GlobalData.h"

#import <ImSDK/TIMFriendshipManager.h>

#import "AppDelegate.h"
#import "MyContactsViewController.h"
#import "MyTabBarViewController.h"

#import "MyFutureFriendCell.h"
#import "MyFutureFriendViewController.h"

#import "MyFutureFriendModel.h"

@interface MyFutureFriendViewController ()
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)id SNSSystemNotifyListChangeObserver;

@property (nonatomic, assign)NSIndexPath *curCellIndex;

//@property (strong, nonatomic) MyNewFriendCell *myNewFriednCell;

@end

@implementation MyFutureFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"推荐朋友"];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self reloadData];
}
- (void)reloadData{
    __weak MyFutureFriendViewController* weakSelf = self;
    
    TIMFriendshipManager *friendshipMgr = [[TIMFriendshipManager alloc] init];
    TIMFriendFutureMeta *meta = [[TIMFriendFutureMeta alloc] init];

    [friendshipMgr GetFutureFriends:TIM_PROFILE_FLAG_REMARK futureFlag:TIM_FUTURE_FRIEND_RECOMMEND_TYPE custom:nil meta:meta
                               succ:^(TIMFriendFutureMeta * meta, NSArray * items){
                                   //测试数据
//                                      TIMFriendFutureItem *item = [[TIMFriendFutureItem alloc] init];
//                                   item.type = TIM_FUTURE_FRIEND_RECOMMEND_TYPE;
//                                   item.identifier = @"wilder11";
//                                   item.addWording = @"test";
//                                   NSArray *tetsitems = [[NSArray alloc] initWithObjects:item, nil];
//                                   self.dataSource = [NSMutableArray arrayWithArray:tetsitems];
//                                   [weakSelf.tableView reloadData];

                                   self.dataSource = [NSMutableArray arrayWithArray:items];
                                   [weakSelf.tableView reloadData];
                               }
                               fail:^(int code, NSString *err){
                                   NSString *showInfo = [[NSString alloc] initWithFormat:@"拉取推荐好友失败，错误码:%d,失败描述%@",code,err];
                                   [self showAlert:@"提示" andMsg:showInfo];
                               }];
}
/*
 tinyid: 144115197088777548
 sdkappid: 1400001533
 备注信息: tets_wilder1
 
 tinyid:  144115198104625915
 sdkappid: 1400001533
 备注信息: tets_wilder3
 
 tinyid:  144115198103316780
 sdkappid: 1400001533
 备注信息: tets_wilder4

 tinyid:  144115197092170400
 sdkappid: 1400001533
 备注信息: tets_wilder5
 
 主号：
 tinyid:   144115197088382872
 sdkappid: 1400001533
 备注信息: tets_wilder2
 */
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

static NSString *friendUser = nil;
static MyFutureFriendCell *curCell;
static MyFutureFriendModel *curModel;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView resignFirstResponder];
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[MyCommOperation shareInstance]
             addFriend:friendUser
             applyWord:[alertView textFieldAtIndex:0].text succ:^{
                 curModel.futureFriendType = FUTURE_FRIEND_PENDENCY_OUT_TYPE;
                 [curCell updateModel:curModel];
                 [self showAlert:@"提示" andMsg:@"成功发送好友申请"];
                 
                 //更新联系人
                 AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 MyTabBarViewController *tab = app.tabBarViewCntrl;
                 MyContactsViewController *contactsViewCtl = tab.contactsViewCntlr;
                 [contactsViewCtl updateTable];
             } fail:^(NSString *err) {
                 [self showPrompt:err];
             }];
            friendUser = nil;
        }
    }
    
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            TIMFriendFutureItem * item = [self.dataSource objectAtIndex:_curCellIndex.row];
            NSArray * users = [[NSArray alloc] initWithObjects:item.identifier, nil];
            [[MyCommOperation shareInstance] deleteRecommend:users succ:^(NSArray *users){
                [self.dataSource removeObjectAtIndex:_curCellIndex.row];
                [self.tableView reloadData];
                _curCellIndex = nil;
            }
            fail:^(int code, NSString *errDetail){
                _curCellIndex = nil;
            }];
            
        }
    }
    return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *kRecFriendCellId = @"futureFriendId";

    MyFutureFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:kRecFriendCellId];
    if (cell == nil) {
        cell = [[MyFutureFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRecFriendCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id obj = [self.dataSource objectAtIndex:indexPath.row];
    TIMFriendFutureItem *item = (TIMFriendFutureItem*)obj;
    MyFutureFriendModel *futureFriendModel = [[MyFutureFriendModel alloc] init];
    futureFriendModel.user = item.identifier;
    futureFriendModel.remarkInfo = [item.recommendTags objectForKey:@"Recommend_Type_First"];
    futureFriendModel.futureFriendType = (FutureFriendType)item.type;

    [cell updateModel:futureFriendModel];
    
    //__weak MyFutureFriendCell *weakCell = cell;
    cell.addBtnAction = ^(MyFutureFriendModel *model){
        if (!model) {
            return;
        }
        if ([[GlobalData shareInstance] getBlackInfo:model.user]) {
            [self showAlert:@"提示" andMsg:@"用户已在黑名单中，请移除黑名单后再添加好友"];
            return;
        }
        //[weakCell.addBtnAction resignFirstResponder];
        friendUser = model.user;
        curCell = cell;
        curModel = model;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入验证信息"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert becomeFirstResponder];
        alert.tag = 1;
        [alert show];
    };
    cell.acceptBtnAction = ^(MyFutureFriendModel *model){
        [[MyCommOperation shareInstance]
         acceptFriendApply:model.user
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
    return cell;
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
        _curCellIndex = indexPath;
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除该推荐好友吗" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
        alert.tag = 2;
        [alert show];
    }
}

#pragma mark - Private Methods
- (void)configureDataSource:(NSArray *)dataSource {
    [self.dataSource removeAllObjects];
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
}
@end
