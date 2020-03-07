//
//  MySNSSystemMessageObserver.m
//  MyDemo
//
//  Created by tomzhu on 15/6/25.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MySNSSystemMessageObserver.h"
#import "GlobalData.h"
#import "MyFriendSystemNotificationModel.h"
#import "MyCommOperation.h"

@interface MySNSSystemMessageObserver ()

@property (nonatomic, strong)id friendApplyListChangeObserver;
@property (nonatomic, strong)NSMutableDictionary* friendApplyList;

@end


@implementation MySNSSystemMessageObserver

- (instancetype)init {
    self = [super init];
    
    __weak MySNSSystemMessageObserver *weakSelf = self;
    self.friendApplyListChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kMyNotificationFriendApplyListChange
                                                                                           object:nil
                                                                                            queue:[NSOperationQueue mainQueue]
                                                                                       usingBlock:^(NSNotification *note) {
                                                                    [weakSelf notifyFriendApplyChange];
                                                                                       }];
    
    self.friendApplyList = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    return self;
}

- (void)dealloc {
    if (self.friendApplyListChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.friendApplyListChangeObserver];
        self.friendApplyListChangeObserver = nil;
    }
}

#pragma mark - delegate<UIAlertView>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"好友申请"]) {
        [self handleFriendApply:alertView clickedButtonAtIndex:(NSInteger)buttonIndex];
    }
    return;
}

#pragma mark - private methods
- (void)notifyFriendApplyChange {
    for (MyFriendSystemNotificationModel *model in [GlobalData shareInstance].friendApplyList) {
        for (TIMSNSChangeInfo *info in model.users) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友申请"
                                                            message:[NSString stringWithFormat:@"用户%@申请添加好友:\n添加理由:%@", info.identifier, info.wording]
                                                           delegate:self
                                                  cancelButtonTitle:@"拒绝"
                                                  otherButtonTitles:@"同意", @"忽略", nil];
            [self.friendApplyList setObject:info forKey:[NSString stringWithFormat:@"%lu",(unsigned long)alert.hash]];
            [alert show];
        }
    }
    [[GlobalData shareInstance].friendApplyList removeAllObjects];
}

- (void)handleFriendApply:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    TIMSNSChangeInfo *info = [self.friendApplyList objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)alertView.hash]];
    TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
    response.identifier = info.identifier;
    
    [self.friendApplyList removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)alertView.hash]];
    
    if (buttonIndex == 1) {
        response.responseType = TIM_FRIEND_RESPONSE_AGREE_AND_ADD;
    }
    else if(buttonIndex == 0) {
        response.responseType = TIM_FRIEND_RESPONSE_REJECT;
    }
    else {
        return;
    }
    [[MyCommOperation shareInstance] doResponse:@[response]
                                           succ:nil
                                           fail:nil];
}

@end
