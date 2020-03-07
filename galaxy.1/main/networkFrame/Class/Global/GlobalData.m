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

#import "GlobalData.h"
#import "MyGroupInfoModel.h"


static GlobalData* instance;

@implementation GlobalData

+ (GlobalData *)shareInstance{
    if (instance == nil) {
        instance = [[GlobalData alloc] init];
    }
    return instance;
}

+ (void)removeInstance {
    instance = nil;
}

- (instancetype)init{
    if (self =[super init]) {
        self.accountType = [NSString stringWithFormat:@"%d", kSdkAccountType];
        self.sdkAppid = kSdkAppId;
        self.friendList = [NSMutableDictionary dictionaryWithCapacity:20];
        _blackList = [NSMutableDictionary dictionaryWithCapacity:5];
        self.groupList = [NSMutableDictionary dictionaryWithCapacity:10];
        self.groupApplyList = [NSMutableArray arrayWithCapacity:5];
        self.friendApplyList = [NSMutableArray arrayWithCapacity:5];
        self.systemNotifyList = [NSMutableArray arrayWithCapacity:20];
        self.connStatus = ConnStatusNO;
//        self.preConnStatus = ConnStatusNO;
    }
    return self;
}


- (MyGroupInfoModel*)getGroupInfo:(NSString *)groupId{
    return [self.groupList objectForKey:groupId];
}

- (MyFriendModel*)getFriendInfo:(NSString *)userName{
    return [self.friendList objectForKey:userName];
}

- (MyFriendModel*)getBlackInfo:(NSString *)userName{
    return [self.blackList objectForKey:userName];
}

- (void)setGroups:(NSArray *)groups{
    [self.groupList removeAllObjects];
    for (MyGroupInfoModel* groupInfo in groups) {
        [self.groupList setValue:groupInfo forKey:groupInfo.groupId];
    }
}

- (void)setFriends:(NSArray *)friendlist{
    [self.friendList removeAllObjects];
    for (MyFriendModel* friendInfo in friendlist) {
        [self.friendList setValue:friendInfo forKey:friendInfo.user];
    }
}

- (void)insertSystemNotify:(MySystemNotifyModel *)recordModel {
    [self.systemNotifyList insertObject:recordModel atIndex:0];
}

- (void)addSystemNotify:(MySystemNotifyModel *)recordModel {
    [self.systemNotifyList addObject:recordModel];
}

- (void)setBlackList:(NSArray *)blackList{
    [self.blackList removeAllObjects];
    for (MyFriendModel* userInfo in blackList) {
        [self.blackList setValue:userInfo forKey:userInfo.user];
    }
}

- (void)addGroup:(MyGroupInfoModel *)group{
    [self.groupList setObject:group forKey:group.groupId];
}

- (void)removeGroup:(MyGroupInfoModel *)group{
    [self.groupList removeObjectForKey:group.groupId];
}


- (void)removeFriend:(NSString *)userName{
    [self.friendList removeObjectForKey:userName];
}

- (void)removeBlack:(NSString *)userName {
    [self.blackList removeObjectForKey:userName];
}
@end
