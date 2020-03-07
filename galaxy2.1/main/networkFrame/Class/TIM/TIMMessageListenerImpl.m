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

#import "TIMMessageListenerImpl.h"
#import "AppDelegate.h"
#import "MyTabBarViewController.h"
#import "MyRecentViewController.h"
#import "GlobalData.h"
#import "MyGroupSystemNotificationModel.h"
#import "MyFriendSystemNotificationModel.h"
#import "MyCommOperation.h"
#import "MyGroupSystemMessageObserver.h"
#import "MySNSSystemMessageObserver.h"
#import "MyGroupSystemNotificationModel.h"
#import "MyFriendSystemNotificationModel.h"

#import "MyRecentViewController.h"
#import "MyChatViewController.h"

@interface TIMMessageListenerImpl ()
@property (nonatomic, strong)MyGroupSystemMessageObserver* groupSystemMessageObserver;
@property (nonatomic, strong)MySNSSystemMessageObserver* snsSystemMessageObserver;
@end

@implementation TIMMessageListenerImpl

- (instancetype)init {
    self = [super init];
    
    self.groupSystemMessageObserver = [[MyGroupSystemMessageObserver alloc] init];
    self.snsSystemMessageObserver = [[MySNSSystemMessageObserver alloc] init];
    
    return self;
}

- (void)dealloc {
    if (self.groupSystemMessageObserver) {
        self.groupSystemMessageObserver = nil;
        self.snsSystemMessageObserver = nil;
    }
}

#pragma mark - delegate<TIMMessageListener>
- (void)onNewMessage:(NSArray*) msgs{
        BOOL isUpdateChatViewMessage = NO; //是否包含展示到聊天窗口的消息
        BOOL isGroupApply = NO;
        BOOL isFriendApply = NO;
        for (TIMMessage *msg in msgs) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[TIMManager sharedInstance] log:TIM_LOG_DEBUG tag:@"Duplicate Msg Check" msg:[NSString stringWithFormat:@"OnNewMessage: msg_id=%@", [msg msgId]]];
            });
            
            TIMConversation * conversation = [msg getConversation];
            TIMConversationType type = [conversation getType];

            // C2C类型消息
            if (type == TIM_C2C && !msg.isSelf) {
                isUpdateChatViewMessage = YES;
            }
            
            // 群组类型消息
            if (type == TIM_GROUP && !msg.isSelf) {
                isUpdateChatViewMessage = YES;
                
                TIMElem *elem = [msg getElem:0];
                if ([elem isKindOfClass:[TIMGroupTipsElem class]]) {
                    //更新群组资料
                    [[MyCommOperation shareInstance] requestGroupList];
                    //如果是邀请进群的消息，就不发送消息了。因为聊天界面会自己刷新，如果在此发送消息，会导致出现两条邀请信息
                    if (((TIMGroupTipsElem*)elem).type == TIM_GROUP_TIPS_TYPE_INVITE) {
                        isUpdateChatViewMessage = NO;
                    }
                }
            }
            
            //TIM_SYSTEM类型消息只推送一次，不需手动设置已读，目前不支持拉取未处理申请
            if (type == TIM_SYSTEM) {
                int elemCount = [msg elemCount];
                for (int i = 0; i < elemCount; i++)  {
                    TIMElem* elem = [msg getElem:i];
                    if ([elem isKindOfClass:[TIMGroupSystemElem class]]) {
                        TIM_GROUP_SYSTEM_TYPE type = ((TIMGroupSystemElem *)elem).type;
                        if (type == TIM_GROUP_SYSTEM_ADD_GROUP_REQUEST_TYPE) {
                            MyGroupSystemNotificationModel *model = [self groupSystemNotificationModelFromElem:(TIMGroupSystemElem *)elem];
                            [[GlobalData shareInstance].groupApplyList addObject:model];
                            isGroupApply = YES;
                        }
                        else {
                            [[MyCommOperation shareInstance] requestGroupList];
                            isUpdateChatViewMessage = YES;
                        }
                    }
                    else if ([elem isKindOfClass:[TIMSNSSystemElem class]]) {
                        TIM_SNS_SYSTEM_TYPE type = ((TIMSNSSystemElem *)elem).type;
                        if (type == TIM_SNS_SYSTEM_ADD_FRIEND || type == TIM_SNS_SYSTEM_DEL_FRIEND) {
                            [[MyCommOperation shareInstance] requestFriendList];
                        }
                        else if (type == TIM_SNS_SYSTEM_ADD_FRIEND_REQ) {
                            if (!msg.isSelf) {
                                MyFriendSystemNotificationModel *model = [self friendSystemNotificationModelFromElem:(TIMSNSSystemElem *)elem];
                                [[GlobalData shareInstance].friendApplyList addObject:model];
                                isFriendApply = YES;
                            }
                        }
                    }
                }
            }
        }
        if (isUpdateChatViewMessage) {
            //刷新聊天界面
            if ([MyChatViewController current]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationChatViewMessageUpdate object:nil userInfo:@{@"msgs":msgs}];
            }
            //刷新消息会话列表
            if ([MyRecentViewController current]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil userInfo:nil];
            }
        }
        if (isGroupApply) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationGroupApplyListChange object:nil];
        }
        if (isFriendApply) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationFriendApplyListChange object:nil];
        }
}

#pragma mark - Private Methods
- (MyGroupSystemNotificationModel *)groupSystemNotificationModelFromElem:(TIMGroupSystemElem*)elem {
    MyGroupSystemNotificationModel *model = [[MyGroupSystemNotificationModel alloc] init];
    model.title = [NSString stringWithFormat:@"%@申请加入%@", elem.user, elem.group];
    model.group = elem.group;
    model.user = elem.user;
    model.msg = elem.msg;
    model.type = elem.type;
    model.notifElem = elem;
    return model;
}

- (MyFriendSystemNotificationModel *)friendSystemNotificationModelFromElem:(TIMSNSSystemElem*)elem {
    MyFriendSystemNotificationModel *model = [[MyFriendSystemNotificationModel alloc] init];
    model.type = elem.type;
    model.users = elem.users;
    model.notifElem = elem;
    return model;
}


@end
