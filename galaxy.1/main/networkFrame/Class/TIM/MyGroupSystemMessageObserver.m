//
//  MyGroupSystemMessageObserver.m
//  MyDemo
//
//  Created by tomzhu on 15/6/25.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyGroupSystemMessageObserver.h"
#import "GlobalData.h"
#import "MyGroupSystemNotificationModel.h"
#import "MyCommOperation.h"

@interface MyGroupSystemMessageObserver ()

@property (nonatomic, strong)id groupApplyListChangeObserver;
@property (nonatomic, strong)NSMutableDictionary* groupApplyList;

@end

@implementation MyGroupSystemMessageObserver

- (instancetype)init {
    self = [super init];
    
    __weak MyGroupSystemMessageObserver* weakSelf = self;
    self.groupApplyListChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationGroupApplyListChange                                                                                          object:nil
         queue:[NSOperationQueue mainQueue]
    usingBlock:^(NSNotification *note) {
        [weakSelf notifyGroupApplyChange];
    }];
    
    self.groupApplyList = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    return self;
}

- (void)dealloc {
    if (self.groupApplyListChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.groupApplyListChangeObserver];
        self.groupApplyListChangeObserver = nil;
    }
}

#pragma mark - delegate<UIAlertView>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"入群申请"]) {
        [self handleGroupApply:alertView clickedButtonAtIndex:buttonIndex];
    }
    return;
}

#pragma mark - private methods
- (void)notifyGroupApplyChange {
    for (MyGroupSystemNotificationModel *model in [GlobalData shareInstance].groupApplyList) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"入群申请"
                                                        message:model.title
                                                       delegate:self
                                              cancelButtonTitle:@"拒绝"
                                              otherButtonTitles:@"同意", @"忽略", nil];
        [self.groupApplyList setObject:model forKey:[NSString stringWithFormat:@"%lu",(unsigned long)alert.hash]];
        [alert show];
    }
    [[GlobalData shareInstance].groupApplyList removeAllObjects];
}

- (void)handleGroupApply:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    MyGroupSystemNotificationModel *model = [self.groupApplyList objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)alertView.hash]];
    TIMGroupSystemElem *elem = model.notifElem;
    if (buttonIndex == 1) {
        [elem accept:@"同意" succ:^{
            TDDLogEvent(@"Accept %@ Join Group %@ Succ", elem.user, elem.group);
            [[MyCommOperation shareInstance] requestGroupInfo:@[elem.group]];
        } fail:^(int code, NSString *err) {
            TDDLogEvent(@"Accept %@ Join Group %@ Failed: code=%d err=%@", elem.user, elem.group, code, err);
        }];
    }
    else if (buttonIndex == 0){
        [elem refuse:@"拒绝" succ:^{
            TDDLogEvent(@"Refuse %@ Join Group %@ Succ", elem.user, elem.group);
        } fail:^(int code, NSString *err) {
            TDDLogEvent(@"Refuse %@ Join Group %@ Failed: code=%d err=%@", elem.user, elem.group, code, err);
        }];
    }
    [self.groupApplyList removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)alertView.hash]];
}

@end
