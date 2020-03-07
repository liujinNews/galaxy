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

#import "MyCommOperation.h"
#import "MyFriendModel.h"
#import "MyGroupInfoModel.h"
#import "MyMemberModel.h"
#import "NSStringEx.h"
#import "GlobalData.h"
#import "MyUnknownChatManager.h"
#import "FriendshipManager.h"
#import "UIResponder+addtion.h"
#import "MySystemNotifyModel.h"

static MyCommOperation* instance;

@implementation MyCommOperation

+ (instancetype)shareInstance{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^(void){
        if (instance == nil) {
            instance = [[MyCommOperation alloc] init];
        }
    });
    return instance;
}

#pragma mark - Auto Login
- (void)autoLogin:(TIMLoginParam *)param succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMManager sharedInstance] login:param succ:^{
        TDDLogEvent(@"Auto Login Succ");
        
        if (succ) {
            succ();
        }
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"Auto Login Failed: code=%d err=%@", code, err);
        if (fail) {
            fail(code, ERRORCODE_TO_ERRORDEC(code));
        }
    }];
}

- (void)getLogLevel{
    [GlobalData shareInstance].logLevel = [[TIMManager sharedInstance] getLogLevel];
}

#pragma mark - User Profile
-(void)getSelfProfile {
    [[TIMFriendshipManager sharedInstance] GetSelfProfile:^(TIMUserProfile *selfProfile) {
        TDDLogEvent(@"Get Self Profile Succ");
        if (!selfProfile || [selfProfile.nickname length] == 0) {
            [GlobalData shareInstance].nickName = [GlobalData shareInstance].me;
        }
        else {
            [GlobalData shareInstance].nickName = selfProfile.nickname;
        }
        [GlobalData shareInstance].friendApplyOpt = selfProfile.allowType;
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"Get Self Profile Failed: code=%d err=%@", code, err);
    }];
}

-(void)setNickName:(NSString*)nick succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMFriendshipManager sharedInstance]
     SetNickname:nick
     succ:^{
         TDDLogEvent(@"Set Nick Name Succ");
         [self getSelfProfile];
         succ();
     }
     fail:^(int code, NSString *err){
         TDDLogEvent(@"Set Nick Name Failed: code=%d err=%@", code, err);
         fail(code, ERRORCODE_TO_ERRORDEC(code));
     }];
}

# pragma mark - Friendship Operation
- (void)requestFriendList{
    if (fabs([[NSDate date] timeIntervalSince1970] - [GlobalData shareInstance].curFriendListReqTime) < 30) {
        TDDLogEvent(@"ReqFriendList Frequence Limit");
        return;
    }
    
    [GlobalData shareInstance].curFriendListReqTime = [[NSDate date] timeIntervalSince1970];
    
    FriendshipManager *friendshipManager = [GlobalData shareInstance].friendshipManager;
    [friendshipManager requestFriendList:[GlobalData shareInstance].me completionHandler:^(NSArray *data, NSString *err) {
        [GlobalData shareInstance].curFriendListReqTime = 0;
        if (err != nil) {
            TDDLogEvent(@"Request Friendlist Failed: %@", err);
            return;
        }
        [GlobalData shareInstance].lastFriendListResp = [[NSDate date] timeIntervalSince1970];
        
        NSMutableArray* friendList = [[NSMutableArray alloc] init];
        for (TIMUserProfile *profile in data) {

            MyFriendModel* model = [[MyFriendModel alloc] init];
            if([profile.identifier isEqual:[NSNull null]]){
                TDDLogEvent(@"return friend is null");
                continue;
            }
            model.user = profile.identifier;
            NSString *nickName = profile.nickname;
            if (!nickName || [nickName length] == 0) {
                model.nickName = model.user;
            }
            else {
                model.nickName = nickName;
            }
            model.birthDay =nil;
            model.sex = 0;
            model.signature = nil;
            
            model.sortedPy = [model.nickName sortedCharacter];
            [friendList addObject:model];
        }

        //重新加载数据与视图
        [[GlobalData shareInstance] setFriends:friendList];
        [[MyUnknownChatManager sharedInstance] updateAllC2CUnkownChat];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil]; //获得好友列表后，更新会话名称
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReqFriendListResp object:nil];
    }];
}

- (void)search:(NSString *)userName completionHandler:(void (^)(NSDictionary *))handler failHandler:(void (^)(int code, NSString *err)) fail{
    FriendshipManager *friendshipManager = [GlobalData shareInstance].friendshipManager;
    [friendshipManager search:userName completionHandler:handler failHandler:fail];
    
}

- (void)addFriend:(NSString *) friendName applyWord:(NSString *)applyWord succ:(TIMSucc)succ fail:(void (^)(NSString *err))fail {
    __weak MyCommOperation *weakSelf = self;
    FriendshipManager *friendshipManager = [GlobalData shareInstance].friendshipManager;
    [friendshipManager addFriend:friendName byUser:[GlobalData shareInstance].me applyWord:applyWord completionHandler:^(NSArray *data, NSString *err) {
        if (err != nil) {
            TDDLogEvent(@"AddFriend Failed: %@", err);
            if (fail) {
                fail(err);
            }
            return;
        }
        
        //重新加载好友列表
        [weakSelf requestFriendList];
        
        if (succ) {
            succ();
        }
    }];
    friendName = nil;
}

- (void)delFriend:(NSString*)userName completionHandler:(void (^)(NSArray*data,NSString*))completionHandler {
    
    NSString *actUserName = [GlobalData shareInstance].me;
    FriendshipManager *friendshipManager = [GlobalData shareInstance].friendshipManager;
    [friendshipManager delFriend:userName byUser:actUserName completionHandler:^(NSArray *data, NSString *err) {
        if (err != nil) {
            TDDLogEvent(@"Request Friendlist Failed: %@", err);
            if (completionHandler) {
                completionHandler(nil, nil);
            }
            return;
        }
        TDDLogEvent(@"DelFriend Succ");
        [[GlobalData shareInstance] removeFriend:userName];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReqFriendListResp object:nil];
        if (completionHandler) {
            completionHandler(nil, nil);
        }
    }];
}

- (void)requestBlackList {
    [[FriendshipManager sharedInstance] requestBlackList:^(NSArray *data) {
        NSMutableArray *models = [[NSMutableArray alloc] init];
        for (NSString *user in data) {
            MyFriendModel *model = [[MyFriendModel alloc] init];
            model.user = user;
            model.nickName = user;
            [models addObject:model];
        }
        [[GlobalData shareInstance] setBlackList:models];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReqBlackListResp object:nil];
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"Request BlackList Failed: code=%d err=%@", code, err);
    }];
}

- (void)addBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation* weakSelf = self;
    [[GlobalData shareInstance].friendshipManager addBlackList:users
                                                          succ:^(NSArray *data) {
                                                              TDDLogEvent(@"Add BlackList Succ");
                                                              [weakSelf showAlert:@"提示" andMsg:@"成功添加黑名单"];
                                                              //重新加载黑名单列表
                                                              [[MyCommOperation shareInstance] requestBlackList];
                                                              [[MyCommOperation shareInstance] requestFriendList];
                                                              if (succ) {succ(data);}
                                                          }
                                                          fail:^(int code, NSString *err) {
                                                              TDDLogEvent(@"Add BlackList Failed: code=%d err=%@", code, err);
                                                              if (fail) {fail(code, ERRORCODE_TO_ERRORDEC(code));}
                                                          }];
}

- (void)delBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail {
    [[GlobalData shareInstance].friendshipManager delBlackList:users
                                                          succ:^(NSArray *data) {
                                                              TDDLogEvent(@"Delete %@ From BlackList Succ", users);
                                                              [[MyCommOperation shareInstance] requestBlackList];
                                                              if (succ) {succ(data);}
                                                          }
                                                          fail:^(int code, NSString *err) {
                                                              TDDLogEvent(@"Delete %@ From BlackList Failed: code=%d err=%@", users, code, err);
                                                              fail(code ,ERRORCODE_TO_ERRORDEC(code));
                                                          }];
}

- (void) setAllowType:(TIMFriendAllowType)allowType succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[GlobalData shareInstance].friendshipManager setAllowType:allowType
                                                          succ:^{
                                                              [self getSelfProfile];
                                                              [self showPrompt:@"设置成功"];
                                                              if (succ) {succ(allowType);}
                                                          }
                                                          fail:^(int code, NSString *err) {
                                                              [self showPrompt:@"设置失败"];
                                                              if (fail) {fail(code, ERRORCODE_TO_ERRORDEC(code));}
                                                          }];
}

- (void)doResponse:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[GlobalData shareInstance].friendshipManager doResponse:users
                                                        succ:^(NSArray *data) {
                                                            TDDLogEvent(@"Handle %@ Apply Friend Succ", users);
                                                            
                                                            // 一般来讲，接受好友申请后会推送加好友的系统消息，现在只是临时的做法来同步好友列表
                                                            [weakSelf requestFriendList];
                                                            if (succ) {succ(data);}
                                                        }
                                                        fail:^(int code, NSString *err) {
                                                            TDDLogEvent(@"Handle %@ Apply Friend Failed: code=%d err=%@", users, code, err);
                                                            if (fail) {fail(code, ERRORCODE_TO_ERRORDEC(code));}
                                                        }];
    
}

- (void)acceptFriendApply:user succ:(TIMFriendSucc)succ fail:(TIMFail)fail{
    TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
    response.identifier = user;
    response.responseType = TIM_FRIEND_RESPONSE_AGREE_AND_ADD;
    __weak MyCommOperation *weakSelf = self;
    [self doResponse:@[response]
                succ:^(NSArray *data){
                    [weakSelf requestFriendList];
                    if (succ) {
                        succ(data);
                    }
                }
                fail:fail];
}

#pragma mark - Group Operation

- (void)requestGroupList{
    
    if (fabs([[NSDate date] timeIntervalSince1970] - [GlobalData shareInstance].curGroupListReqTime) < 30) {
        TDDLogEvent(@"ReqGroupList Frequence Limit");
        return;
    }
    [GlobalData shareInstance].curGroupListReqTime = [[NSDate date] timeIntervalSince1970];
    
    [[TIMGroupManager sharedInstance] GetGroupList:^(NSArray * list) {
        [GlobalData shareInstance].curGroupListReqTime = 0;
        [GlobalData shareInstance].lastGroupListResp = [[NSDate date] timeIntervalSince1970];
        NSMutableArray* groupList = [NSMutableArray arrayWithCapacity:5];
        NSMutableArray* groupIdList = [NSMutableArray arrayWithCapacity:5];
        for (TIMGroupInfo* groupInfo in list) {
            MyGroupInfoModel* model = [[MyGroupInfoModel alloc] init];
            model.groupId = groupInfo.group;
            model.groupTitle = groupInfo.groupName;
            model.groupType = groupInfo.groupType;
            model.introduction = groupInfo.introduction;
            model.notification = groupInfo.notification;
            model.createTime = groupInfo.createTime;
            model.lastMsgTime = groupInfo.lastMsgTime;
            model.memberNum = groupInfo.memberNum;
            model.lastInfoTime = groupInfo.lastInfoTime;  //这个时间戳用来做是否需要更新群成员列表
            model.owner = groupInfo.owner;
            [groupList addObject:model];
            [groupIdList addObject:model.groupId];
        }
        
        [[GlobalData shareInstance] setGroups:groupList];
        //更新群组资料
        [self requestGroupInfo:groupIdList];
        
        [[MyUnknownChatManager sharedInstance] updateAllGroupUnkownChat];
        
        //重新加载数据和视图
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil]; // 获得群组列表后，更新会话名称
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReqGroupListResp object:nil];
                
    } fail:^(int code, NSString* err) {
        [GlobalData shareInstance].curGroupListReqTime = 0;
        TDDLogEvent(@"failed code: %d %@", code, err);
    }];
}

- (void)requestGroupMembers:(NSString*)groupId{
    
    MyGroupInfoModel* groupInfo = [[GlobalData shareInstance] getGroupInfo:groupId];
    if (groupInfo == nil) {
        TDDLogEvent(@"self have such group.%@", groupId);
        return;
    }
    
    TDDLogEvent(@"Get GroupMebers List|groupId:%@", groupId);
    
    [[TIMGroupManager sharedInstance] GetGroupMembers:groupId succ:^(NSArray* list) {
        TDDLogEvent(@"Get GroupMebers List Success|groupId:%@ | member:%lu", groupId, (unsigned long)list.count);
        if (groupInfo.memberList) {
            [groupInfo.memberList removeAllObjects];
        }
        else{
            groupInfo.memberList = [[NSMutableArray alloc] initWithCapacity:10];
        }
        groupInfo.lastMemberListResp = [[NSDate date] timeIntervalSince1970];
        for (TIMGroupMemberInfo* memberInfo in list) {
            MyMemberModel* member = [[MyMemberModel alloc] init];
            member.user = memberInfo.member;
            if ([[GlobalData shareInstance] getFriendInfo:memberInfo.member]) {
                member.nickName = [[GlobalData shareInstance] getFriendInfo:memberInfo.member].nickName;
            }
            else if ([memberInfo.member isEqualToString:[GlobalData shareInstance].me]
                     && [GlobalData shareInstance].nickName) {
                member.nickName = [GlobalData shareInstance].nickName;
            }
            else {
                member.nickName = memberInfo.member;
            }
            member.role = memberInfo.role;
            if ([memberInfo.member isEqualToString:[GlobalData shareInstance].me]) {
                groupInfo.nameCard = memberInfo.nameCard;
            }
            member.nameCard = memberInfo.nameCard;
            [groupInfo.memberList addObject:member];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationGroupInfoChange object:nil userInfo:@{@"data":groupInfo}];
        }
    } fail:^(int code, NSString * err) {
        TDDLogEvent(@"failed code: %d %@", code, err);
    }];
}

//imsdk里面获取群信息，每次获取上限是50条，这里实现分段获取，每次获取45条
- (void)requestGroupInfo:(NSArray*)groupIds{
    if (groupIds.count >= 50) {
        int lowIndex = 0;
        int length = 45;
        BOOL isEnd = FALSE;
        while (TRUE){
            if (lowIndex+length>=groupIds.count) {
                length = (int)groupIds.count - lowIndex;
                isEnd = TRUE;
            }
            NSArray *subGroupIds = [groupIds subarrayWithRange:NSMakeRange(lowIndex, length)];
            [self getGroupInfo:subGroupIds];
            lowIndex += length;
            if (isEnd) {
                break;
            }
        }
    }
    else{
        [self getGroupInfo:groupIds];
    }
}

- (void)getGroupInfo:(NSArray *)groupIds{
    [[TIMGroupManager sharedInstance]
     GetGroupInfo:groupIds
     succ:^(NSArray* groups){
         for (TIMGroupInfo* groupInfo in groups) {
             MyGroupInfoModel* model = [[GlobalData shareInstance] getGroupInfo:groupInfo.group];
             if (model == nil) {
                 TDDLogEvent(@"%s:%s get GroupInfo not in GroupInfo List. %@ %@", __FILE__, __FUNCTION__, groupInfo.group, groupInfo.groupName);
                 return;
             }
             
//             if (model.lastInfoTime!=groupInfo.lastInfoTime || model.memberList.count != groupInfo.memberNum)
//             {
             
                 TDDLogEvent(@"Update GroupMebers Info|groupId:%@|local:%d|svr:%d", groupInfo.group, model.lastInfoTime, groupInfo.lastInfoTime);
                 model.groupTitle = groupInfo.groupName;
                 model.groupId = groupInfo.group;
                 //                                                          model.groupType = groupInfo.groupType;
                 model.introduction = groupInfo.introduction;
                 model.notification = groupInfo.notification;
                 model.lastInfoTime = groupInfo.lastInfoTime;
                 model.lastMsgTime = groupInfo.lastMsgTime;
                 model.memberNum = groupInfo.memberNum;
                 model.createTime = groupInfo.createTime;
                 model.owner = groupInfo.owner;
                 [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationGroupInfoChange object:nil userInfo:@{@"data":model}];
                 
                 [self requestGroupMembers:groupInfo.group];
//             }
         }
     }
     fail:^(int code, NSString * err){
         TDDLogEvent(@"GetGroupInfo failed code: %d %@", code, err);
     }];
}

- (void)getGroupPublicInfo:(NSString *)group succ:(TIMGroupListSucc)succ fail:(TIMFail)fail {
    NSArray *groups = @[group];
    [[TIMGroupManager sharedInstance] GetGroupPublicInfo:groups succ:^(NSArray *data) {
        TDDLogEvent(@"Get GroupInfo Succ");
        if (succ) {
            succ(data);
        }
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"Get GroupInfo Failed: code=%d err=%@", code, err);
        if (fail) {
            fail(code, err);
        }
    }];
}

- (void)joinGroup:(NSString*)group msg:(NSString*)msg succ:(TIMSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[TIMGroupManager sharedInstance] JoinGroup:group msg:msg succ:^{
        [weakSelf showAlert:@"提示" andMsg:@"申请入组成功"];
        [[MyCommOperation shareInstance] requestGroupList];
        if (succ) {if (succ) {succ();}}
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"Join Group %@ Failed: code=%d err=%@", group, code, err);
        [weakSelf showPrompt:[MyErrorTable ErrorDescription:code]];
        if (fail) {if (fail) {fail(code, err);}}
    }];

}

- (void)quitGroup:(NSString*)group succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMManager sharedInstance] deleteConversationAndMessages:TIM_GROUP receiver:group];
    [[TIMGroupManager sharedInstance] QuitGroup:group
                                           succ:^(void){
                                               //更新会话列表
                                               [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil];
                                               if (succ) {succ();}
                                           } fail:^(int code, NSString* err){
                                               TDDLogEvent(@"quick group failed.code:%d err:%@", code, err);
                                               if (fail) {if (fail) {fail(code, err);}}
                                           }];
}

- (void)createPrivateGroup:(NSArray*)members groupName:(NSString*)groupName succ:(TIMCreateGroupSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[TIMGroupManager sharedInstance] CreatePrivateGroup:members groupName:groupName
                                                    succ:succ
                                                    fail:^(int code, NSString *err){
                                                        TDDLogEvent(@"Create Private Group Failed. groupName:%@ code:%d err:%@", groupName, code, err);
                                                        [weakSelf showAlert:@"提示：" andMsg:@"创建私有群失败"];
                                                        if (fail) {fail(code, err);}
                                                    }];
}

- (void)createChatRoomGroup:(NSArray*)members groupName:(NSString*)groupName succ:(TIMCreateGroupSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[TIMGroupManager sharedInstance] CreateChatRoomGroup:members groupName:groupName
                                                     succ:succ
                                                     fail:^(int code, NSString *err){
                                                         TDDLogEvent(@"Create Chatroom Group Failed. groupName:%@ code:%d err:%@", groupName, code, err);
                                                         [weakSelf showAlert:@"提示：" andMsg:@"创建聊天室失败"];
                                                         if (fail) {fail(code, err);}
                                                     }];
}

- (void)createPublicGroup:(NSArray*)members groupName:(NSString*)groupName succ:(TIMCreateGroupSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[TIMGroupManager sharedInstance] CreatePublicGroup:members groupName:groupName
                                                   succ:succ
                                                   fail:^(int code, NSString *err){
                                                       TDDLogEvent(@"Create Public Group Failed. groupName:%@ code:%d err:%@", groupName, code, err);
                                                       [weakSelf showAlert:@"提示：" andMsg:@"创建公开群失败"];
                                                       if (fail) {fail(code, err);}
                                                   }];
}

- (void)inviteGroupMember:(NSString*)group members:(NSArray*)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[TIMGroupManager sharedInstance] InviteGroupMember:group
                                                members:members
                                                   succ:^(NSArray *data){
                                                       [self requestGroupInfo:@[group]];
                                                       if (succ) {
                                                           succ(data);
                                                       }}
                                                   fail:^(int code, NSString *err){
                                                       TDDLogEvent(@"Invide To Group Failed. code:%d err:%@", code, err);
                                                       [weakSelf showAlert:@"提示：" andMsg:@"添加好友至群组失败"];
                                                       if (fail) {fail(code, err);}
                                                   }];
}

- (void)deleteGroup:(NSString*)group succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMManager sharedInstance] deleteConversationAndMessages:TIM_GROUP receiver:group];
    [[TIMGroupManager sharedInstance] DeleteGroup:group
                                             succ:^(void){
                                                 //更新会话列表
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil];
                                                 if (succ) {succ();}
                                             } fail:^(int code, NSString* err){
                                                 TDDLogEvent(@"dissolve group failed.code:%d err:%@", code, err);
                                                 if (fail) {fail(code, err);}
                                             }];
}

- (void)deleteGroupMember:(NSString*)group members:(NSArray*)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail {
    [[TIMGroupManager sharedInstance] DeleteGroupMember:group members:members succ:^(NSArray* list){
        MyGroupInfoModel* groupInfo = [[GlobalData shareInstance] getGroupInfo:group];
        if (groupInfo) {
            for (TIMGroupMemberResult* memberResult in list) {
                if (memberResult.status != TIM_GROUP_MEMBER_STATUS_FAIL) {
                    TDDLogEvent(@"delete member sucessful. gorupid:%@ member:%@", group, memberResult.member);
                    continue;
                }
                TDDLogEvent(@"user %@ status %ld", memberResult.member, (long)memberResult.status);
            }
        }

        [[MyCommOperation shareInstance] requestGroupInfo:@[group]];
        if (succ) {succ(list);}
    } fail:^(int code, NSString* err){
        TDDLogEvent(@"delete member failed: code:%d err:%@ group:%@ name:%@", code, err, group, members);
        [self showPrompt:@"删除群成员失败"];
        if (fail) {fail(code, err);}
    }];
}

- (void)modifyReciveMessageOpt:(NSString*)group opt:(TIMGroupReceiveMessageOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[TIMGroupManager sharedInstance]
     ModifyReciveMessageOpt:group
     opt:opt
     succ:^{
         TDDLogEvent(@"%@ Set Group %@ RecvMessage Succ", [GlobalData shareInstance].me, group);
         [weakSelf showAlert:@"提示" andMsg:@"设置成功"];
         if (succ) {succ();}
     } fail:^(int code, NSString *err) {
         TDDLogEvent(@"%@ Set Group %@ RecvMessage Failed: code=%d err=%@", [GlobalData shareInstance].me, group, code, err);
         if (fail) {fail(code, err);}
     }];
}

- (void)modifyGroupAddOpt:(NSString*)group opt:(TIMGroupAddOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail {
    __weak MyCommOperation *weakSelf = self;
    [[TIMGroupManager sharedInstance]
     ModifyGroupAddOpt:group
     opt:opt
     succ:^{
         TDDLogEvent(@"%@ Set Group %@ AddOption Succ", [GlobalData shareInstance].me, group);
         [weakSelf showAlert:@"提示" andMsg:@"设置成功"];
         if (succ) {succ();}
     } fail:^(int code, NSString *err) {
         TDDLogEvent(@"%@ Set Group %@ AddOption Failed: code=%d err=%@", [GlobalData shareInstance].me, group, code, err);
         if (fail) {fail(code, err);}
     }];
}

- (void)modifyGroupNamecard:(NSString*)group userId:(NSString*)userId nameCard:(NSString*)nameCard succ:(TIMSucc)succ fail:(TIMFail)fail{
    [[TIMGroupManager sharedInstance] ModifyGroupMemberInfoSetNameCard:group user:userId nameCard:nameCard succ:^(){
        TDDLogEvent(@"modify group namecard succ");
        [[MyCommOperation shareInstance] requestGroupInfo:@[group]];
        if (succ) {succ();}
    } fail:^(int code, NSString* err){
        TDDLogEvent(@"failed code: %d %@", code, err);
        if (fail) {fail(code, err);}
    }];
    
}

- (void)modifyGroupName:(NSString*)group groupName:(NSString*)groupName succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMGroupManager sharedInstance] ModifyGroupName:group groupName:groupName succ:^() {
        TDDLogEvent(@"modify group name succ");
        [[MyCommOperation shareInstance] requestGroupInfo:@[group]];
        if (succ) {succ();}
    }fail:^(int code, NSString* err) {
        TDDLogEvent(@"failed code: %d %@", code, err);
        if (fail) {fail(code, err);}
    }];
}

- (void)modifyGroupIntroduction:(NSString*)group introduction:(NSString*)introduction succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMGroupManager sharedInstance] ModifyGroupIntroduction:group introduction:introduction succ:^() {
        TDDLogEvent(@"modify group introduction succ");
        [[MyCommOperation shareInstance] requestGroupInfo:@[group]];
        if (succ) {succ();}
    }fail:^(int code, NSString* err) {
        TDDLogEvent(@"failed code: %d %@", code, err);
        if (fail) {fail(code, err);}
    }];
}

- (void)modifyGroupNotification:(NSString*)group notification:(NSString*)notification succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMGroupManager sharedInstance] ModifyGroupNotification:group notification:notification succ:^() {
        TDDLogEvent(@"modify group notification succ");
        [[MyCommOperation shareInstance] requestGroupInfo:@[group]];
        if (succ) {succ();}
    }fail:^(int code, NSString* err) {
        TDDLogEvent(@"failed code: %d %@", code, err);
        if (fail) {fail(code, err);}
    }];

}

- (void)modifyGroupMemberInfoSetRole:(NSString*)group user:(NSString*)identifier role:(TIMGroupMemberRole)role succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMGroupManager sharedInstance]
     ModifyGroupMemberInfoSetRole:group
                              user:identifier
                              role:role
                              succ:^{
                                  TDDLogEvent(@"Group %@ Set %@ As Manager Succ", group, identifier);
                                  [[MyCommOperation shareInstance] requestGroupInfo:@[group]];
                                  if (succ) {succ();}
                              }
                              fail:^(int code, NSString *err) {
                                  TDDLogEvent(@"Group %@ Set %@ As Manager Failed: code=%d err=%@", group, identifier, code, err);
                                  if (fail) {fail(code, err);}
                              }];
}

- (void)modifyGroupMemberInfoSetSilence:(NSString*)group user:(NSString*)identifier stime:(uint32_t)stime succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMGroupManager sharedInstance]
     ModifyGroupMemberInfoSetSilence:group
                                 user:identifier
                                stime:stime
                                 succ:^{
                                     TDDLogEvent(@"Group %@ Set %@ Silence Succ", group, identifier);
                                     if (stime == 0) {
                                         [self showAlert:@"提示" andMsg:@"取消禁言成功"];
                                     }
                                     else {
                                         [self showAlert:@"提示" andMsg:[NSString stringWithFormat:@"禁言%ds成功", stime]];
                                     }
                                     if (succ) {succ();}
                                 } fail:^(int code, NSString *err) {
                                     TDDLogEvent(@"Group %@ Set %@ Silence Failed: code=%d err=%@", group, identifier, code, err);
                                     if (fail) {fail(code, err);}
                                 }];

}

#pragma mark - Message Operation

- (int)calUnreadCount{
    int unReadCount = 0;
    int cnt = [[TIMManager sharedInstance] ConversationCount];
    for (int i = 0; i < cnt; i++) {
        TIMConversation * conversation = [[TIMManager sharedInstance] getConversationByIndex:i];
        if ([conversation getType] == TIM_SYSTEM) {
            continue;
        }
        unReadCount += [conversation getUnReadMessageNum];
    }
    if (unReadCount > 99) {
        unReadCount = 99;
    }
    return unReadCount;
}

#pragma mark - private methods
- (void)showAlert:(NSString*)title andMsg:(NSString*)msg{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)showPrompt:(NSString*)msg{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.backgroundColor = RGBACOLOR(0xAA, 0xAA, 0xAA, 0.5);
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dissmissPrompt:) userInfo:alert repeats:NO];
    [alert show];
}

- (void)dissmissPrompt:(NSTimer *)timer{
    UIAlertView* alert = (UIAlertView *)timer.userInfo;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    alert = nil;
}

- (NSMutableArray *)systemNotifyModelArrayFromElem:(TIMElem *)elem Message:(TIMMessage *)msg {
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:20];
    SystemNotifyType notifyType=0;
    if ([elem isKindOfClass:[TIMSNSSystemElem class]]) {
        TIMSNSSystemElem *snsSystemElem = (TIMSNSSystemElem *) elem;
        if (snsSystemElem.type == TIM_SNS_SYSTEM_ADD_FRIEND) {
            notifyType = SNSSystemNotifyType_AddFriend;
        }
        else if (snsSystemElem.type == TIM_SNS_SYSTEM_ADD_FRIEND_REQ) {
            notifyType = SNSSystemNotifyType_addFriendReq;
        }
        else {
            return nil;
        }
        for (TIMSNSChangeInfo *user in snsSystemElem.users) {
            MySystemNotifyModel *model = [[MySystemNotifyModel alloc] init];
            model.user = user.identifier;
            model.wording = user.wording;
            model.notifyType = notifyType;
            [modelArray addObject:model];
        }
    }
    else if ([elem isKindOfClass:[TIMGroupSystemElem class]]) {
        TIMGroupSystemElem *groupSystemElem = (TIMGroupSystemElem *) elem;
        if (groupSystemElem.type == TIM_GROUP_SYSTEM_ADD_GROUP_REQUEST_TYPE) {
            notifyType = GroupSystemNotifyType_JoinGroupReq;
        }
        MySystemNotifyModel *model = [[MySystemNotifyModel alloc] init];
        model.user = groupSystemElem.user;
        model.wording = groupSystemElem.msg;
        model.notifyType = notifyType;
        model.elem = elem;
        [modelArray addObject:model];
    }
    return modelArray;
}
- (void)deletePendency:(TIMPendencyGetType)type users:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail{
    [[TIMFriendshipManager sharedInstance] DeletePendency:type users:users succ:^(NSArray *users){
        succ(users);
    } fail:^(int code, NSString *errDetail){
        fail(code,errDetail);
    }];
}

- (int)deleteRecommend:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail{
    [[TIMFriendshipManager sharedInstance] DeleteRecommend:users succ:^(NSArray *users){
        succ(users);
    } fail:^(int code, NSString *errDetail){
        fail(code,errDetail);
    }];
    return 0;
}
@end
