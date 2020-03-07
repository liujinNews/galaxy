//
//  MyBlackListViewController.m
//  MyDemo
//
//  Created by tomzhu on 15/6/18.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyBlackListViewController.h"
#import "MyFriendModel.h"
#import "MyNaviCellModel.h"
#import "NSStringEx.h"
#import "NSArray+addition.h"
#import "GlobalData.h"
#import "UIResponder+addtion.h"
#import "MyUtilty.h"
#import "MyCommOperation.h"
#import "MyContactCell.h"

@interface MyBlackListViewController ()

@property (nonatomic, strong)NSMutableArray* blackList;
@property (nonatomic, strong)id blackListRspObserver;

@end

@implementation MyBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"黑名单"];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    __weak MyBlackListViewController* weakSelf = self;
    self.blackListRspObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationReqBlackListResp
                                                                                   object:nil
                                                                                    queue:[NSOperationQueue mainQueue]
                                                                               usingBlock:^(NSNotification *note){
                                                                                   [weakSelf configureBlackDataDic:[[GlobalData shareInstance].blackList allValues]];
                                                                                   [weakSelf.tableView reloadData];
                                                                               } ];
    if (![GlobalData shareInstance].blackList) {
        [[MyCommOperation shareInstance] requestBlackList];
    }
    else{
        [self configureBlackDataDic:[[GlobalData shareInstance].blackList allValues]];
    }
    
    return;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    if ( self.blackListRspObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.blackListRspObserver];
    }
    self.blackListRspObserver = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.blackList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CONTACT_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"BlackContactTableCell";
    
    MyContactCell* contactCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (contactCell == nil) {
        contactCell = [[MyContactCell alloc] initWithType:ContactCellType_ContactList style:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    MyFriendModel* model = [self.blackList objectAtIndex:indexPath.row];
    [contactCell updateModel:model];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delBlack:)];
    longPressGestureRecognizer.minimumPressDuration = 1.0;
    [contactCell addGestureRecognizer:longPressGestureRecognizer];
    
    return contactCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    return  UITableViewCellEditingStyleDelete;  //返回此值时,Cell会做出响应显示Delete按键,点
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyFriendModel* blackModel;
        MyModel* model = [self.blackList objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[MyFriendModel class]]) {
            blackModel = (MyFriendModel *)model;
            //删除好友
            NSArray *delList = @[blackModel.user];
            [[MyCommOperation shareInstance] delBlackList:delList
                                                           succ:nil
                                                           fail:nil];
            
        }
    }
}

#pragma mark - Delegate<UIAlertView>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        MyFriendModel *model = [self.blackList objectAtIndex:alertView.tag];
        [[MyCommOperation shareInstance] delBlackList:@[model.user] succ:nil fail:nil];
    }
}

#pragma mark - Event Response<Delete Black>
- (void)delBlack:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil || indexPath.section > 0) {
            return ;
        }
        
        MyFriendModel *model = [self.blackList objectAtIndex:indexPath.row];
        if (!model.user) {
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否从黑名单中移除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = indexPath.row;
        [alert show];
    }
}


#pragma mark - DataProcess
- (void)configureBlackDataDic:(NSArray*)blackArray {
    [self.blackList removeAllObjects];
    self.blackList = [NSMutableArray arrayWithArray:[blackArray sortedUserModelsByNameAscend:YES]];
}

@end
