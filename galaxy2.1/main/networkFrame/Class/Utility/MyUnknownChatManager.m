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

#import "MyUnknownChatManager.h"
#import "GlobalData.h"
#import "MyCommOperation.h"

static MyUnknownChatManager* instance;

@interface UnknownChat : NSObject

@property (nonatomic, strong)NSString* chatId;              //会话id
@property (nonatomic, assign)TIMConversationType chatType;  //会话类型
//@property (nonatomic, assign)NSTimeInterval updateInfoTime;
@property (nonatomic, assign)BOOL isSureUnknown;              //是否确定不存在信息

@end

@interface UnknownC2CChat : UnknownChat

@end

@interface UnknownGroupChat : UnknownChat

@end



@implementation UnknownChat

@end


@implementation UnknownC2CChat

- (instancetype)init{
    if (self = [super init]) {
        self.chatType = TIM_C2C;
        self.isSureUnknown = NO;
    }
    return self;
}
@end


@implementation UnknownGroupChat

- (instancetype)init{
    if (self = [super init]) {
        self.chatType = TIM_GROUP;
        self.isSureUnknown = NO;
    }
    return self;
}

@end


@interface MyUnknownChatManager()

@property (nonatomic, strong)NSMutableDictionary* groupList;
@property (nonatomic, strong)NSMutableDictionary* c2cList;

@end


@implementation MyUnknownChatManager

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[MyUnknownChatManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.groupList = [[NSMutableDictionary alloc] init];
        self.c2cList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
 * 检查c2c会话是否对方是否已经在好友列表，没有则会请求更新好友列表。
 * 本类的作用在于可控制好友列表请求的频率等逻辑
 */
- (BOOL)checkUnknownC2CChat:(NSString*)fromUser{
    MyFriendModel* user = [[GlobalData shareInstance] getFriendInfo:fromUser];
    if (!user) {
        UnknownC2CChat* chat = [self.c2cList objectForKey:fromUser];
        if (chat == nil) {
            chat = [[UnknownC2CChat alloc] init];
            chat.chatId = fromUser;
            [self.c2cList setObject:chat forKey:fromUser];
        }
        if (!chat.isSureUnknown) {
            TDDLogEvent(@"chat is unkown. to update friendlist. | user:%@", fromUser);
            [[MyCommOperation shareInstance] requestFriendList];
        }
        else{
            TDDLogDebug(@"chat friend is sure.| user:%@| sure:%d | %@", fromUser, chat.isSureUnknown, user);
        }
        return YES;
    }
    return NO;
}


- (BOOL)checkUnknownGroupChat:(NSString*)groupId{
    
    MyGroupInfoModel* group = [[GlobalData shareInstance] getGroupInfo:groupId];
    if (!group) {
        UnknownGroupChat* chat = [self.groupList objectForKey:groupId];
        if (chat == nil) {
            chat = [[UnknownGroupChat alloc] init];
            [self.groupList setObject:chat forKey:groupId];
        }
        if (!chat.isSureUnknown) {
            TDDLogEvent(@"chat is unkown. to update grouplist. | group:%@", groupId);
            [[MyCommOperation shareInstance] requestGroupList];
        }
        else{
            TDDLogDebug(@"chat group is sure.| group:%@| sure:%d | %@", groupId, chat.isSureUnknown, group);
        }
        return YES;
    }
    return NO;
}


- (void)updateAllC2CUnkownChat{
    for (UnknownC2CChat* chat in [self.c2cList allValues]) {
        MyFriendModel* user = [[GlobalData shareInstance] getFriendInfo:chat.chatId];
        if (user == nil) {
            chat.isSureUnknown = YES;
        }
        else{
            [self.c2cList removeObjectForKey:chat.chatId];
        }
    }
}
- (void)updateAllGroupUnkownChat{
    for (UnknownGroupChat* chat in [self.groupList allValues]) {
        MyGroupInfoModel* group = [[GlobalData shareInstance] getGroupInfo:chat.chatId];
        if (group == nil) {
            chat.isSureUnknown = YES;
        }
        else{
            [self.groupList removeObjectForKey:chat.chatId];
        }
    }
}
@end

