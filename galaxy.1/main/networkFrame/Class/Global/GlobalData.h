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

#import <Foundation/Foundation.h>
#import "MyFriendModel.h"
#import "MySystemNotifyModel.h"

#define kTLSAppid     1400001533
#define kSdkAppId       1400001533
#define kSdkAccountType    792
#define kQQAccountType  1
#define kWXAccountType  2

#define kUserSvrIP      @"203.195.198.121"

/**
 * QQ和微信sdk参数配置
 */

#define QQ_APP_ID @"222222"
#define QQ_OPEN_SCHEMA @"tencent222222"

#define WX_APP_ID @"wx65f71c2ea2b122da"
#define WX_OPEN_KEY @"69aed8b3fd41ed72efcfbdbca1e99a27"

//demo暂不提供微博登录
//#define WB_APPKEY @"3832679363"

#define GROUP_TYPE_PRIVATE @"Private"
#define GROUP_TYPE_PUBLIC @"Public"
#define GROUP_TYPE_CHATROOM @"ChatRoom"
#define kLoginParam @"loginParam"
#define kSaveSigTime @"saveSigTime"

typedef NS_ENUM(NSUInteger, ConnStatus){
    ConnStatusNO,               //程序初始化时，未设置状态
    ConnStatusConnected,
    ConnStatusDisConnected,
};

@class MyGroupInfoModel;
@class MyMemberModel;



@interface GlobalData : NSObject

@property (nonatomic, strong)NSString* me;
@property (nonatomic, strong)NSString* nickName;
@property (nonatomic, assign)NSInteger logLevel;
@property (nonatomic, assign)NSInteger friendApplyOpt;
//@property (nonatomic, strong)NSString* myUserName;
@property (nonatomic, strong)NSString* accountType;
@property (nonatomic, assign)NSInteger sdkAppid;
@property (nonatomic, assign)BOOL isLogined;
@property (nonatomic, weak)id accountHelper;
@property (nonatomic ,weak)id friendshipManager;
@property (nonatomic, strong)NSMutableDictionary* friendList;
@property (nonatomic, strong)NSMutableDictionary* blackList;
@property (nonatomic, strong)NSMutableDictionary* groupList;
@property (nonatomic, strong)NSMutableArray* groupApplyList;
@property (nonatomic, strong)NSMutableArray* friendApplyList;
@property (nonatomic, strong)NSMutableArray* systemNotifyList;
@property (atomic, assign)NSTimeInterval curFriendListReqTime;
@property (atomic, assign)NSTimeInterval lastFriendListResp;
@property (atomic, assign)NSTimeInterval curGroupListReqTime;
@property (atomic, assign)NSTimeInterval lastGroupListResp;

@property (nonatomic, assign)ConnStatus connStatus;
//@property (nonatomic, assign)ConnStatus preConnStatus;


+ (GlobalData*)shareInstance;
+ (void)removeInstance;

- (MyGroupInfoModel*)getGroupInfo:(NSString *)groupId;
- (MyFriendModel*)getFriendInfo:(NSString *)userName;
- (MyFriendModel*)getBlackInfo:(NSString *)userName;
- (void)setGroups:(NSArray *)groups;
- (void)setFriends:(NSArray *)friendlist;
- (void)removeFriend:(NSString *)userName;
- (void)addSystemNotify:(MySystemNotifyModel *)recordModel;
- (void)insertSystemNotify:(MySystemNotifyModel *)recordModel;
- (void)removeBlack:(NSString *)userName;

- (void)addGroup:(MyGroupInfoModel *)group;
- (void)removeGroup:(MyGroupInfoModel *)group;

@end

