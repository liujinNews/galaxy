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

@interface MyCommOperation : NSObject

@property (nonatomic, copy)TIMGroupListSucc groupListSucc;
@property (nonatomic, copy)TIMGroupListSucc groupInfoSucc;
@property (nonatomic, copy)TIMGroupMemberSucc groupMemberSucc;

+ (instancetype)shareInstance;

- (void)getLogLevel;

- (void)autoLogin:(TIMLoginParam *)param succ:(TIMSucc)succ fail:(TIMFail)fail;

-(void)getSelfProfile;

-(void)setNickName:(NSString*)nick succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)requestFriendList;

- (void)delFriend:(NSString*) userName completionHandler:(void (^)(NSArray*data,NSString*))completionHandler;

- (void)addFriend:(NSString *) friendName applyWord:(NSString *)applyWord succ:(TIMSucc)succ fail:(void (^)(NSString *err))fail;

- (void)search:(NSString *)userName completionHandler:(void (^)(NSDictionary *))handler failHandler:(void (^)(int code, NSString *err)) fail;

- (void)requestBlackList;

- (void)addBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)delBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)setAllowType:(TIMFriendAllowType)allowType succ:(TIMSucc)succ fail:(TIMFail)fail;


- (void)acceptFriendApply:user succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)doResponse:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)requestGroupList;

- (void)requestGroupMembers:(NSString*)groupId;

- (void)requestGroupInfo:(NSArray*)groupIds;

- (void)getGroupPublicInfo:(NSString*)group succ:(TIMGroupListSucc)succ fail:(TIMFail)fail;

- (void)joinGroup:(NSString*)group msg:(NSString*)msg succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)quitGroup:(NSString*)group succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)createPrivateGroup:(NSArray*)members groupName:(NSString*)groupName succ:(TIMCreateGroupSucc)succ fail:(TIMFail)fail;

- (void)createChatRoomGroup:(NSArray*)members groupName:(NSString*)groupName succ:(TIMCreateGroupSucc)succ fail:(TIMFail)fail;

- (void)createPublicGroup:(NSArray*)members groupName:(NSString*)groupName succ:(TIMCreateGroupSucc)succ fail:(TIMFail)fail;

- (void)inviteGroupMember:(NSString*)group members:(NSArray*)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail;

- (void)deleteGroup:(NSString*)group succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)deleteGroupMember:(NSString*)group members:(NSArray*)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail;

- (void)modifyReciveMessageOpt:(NSString*)group opt:(TIMGroupReceiveMessageOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)modifyGroupAddOpt:(NSString*)group opt:(TIMGroupAddOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)modifyGroupNamecard:(NSString*)group userId:(NSString*)userId nameCard:(NSString*)nameCard succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)modifyGroupName:(NSString*)group groupName:(NSString*)groupName succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)modifyGroupIntroduction:(NSString*)group introduction:(NSString*)introduction succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)modifyGroupNotification:(NSString*)group notification:(NSString*)notification succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)modifyGroupMemberInfoSetRole:(NSString*)group user:(NSString*)identifier role:(TIMGroupMemberRole)role succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)modifyGroupMemberInfoSetSilence:(NSString*)group user:(NSString*)identifier stime:(uint32_t)stime succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)deletePendency:(TIMPendencyGetType)type users:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (int)deleteRecommend:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (int)calUnreadCount;

@end
