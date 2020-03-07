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

#import "MyModel.h"
#import "MyMemberModel.h"


@interface MyGroupInfoModel : MyModel

@property (nonatomic, strong)NSMutableArray* memberList;
@property (nonatomic, strong)NSString* owner;
@property (nonatomic, strong)NSString* groupId;
@property (nonatomic, strong)NSString* nameCard;
@property (nonatomic, strong)NSString* groupTitle;
@property (nonatomic, strong)NSString* groupType;
@property (nonatomic, strong)NSString* introduction;
@property (nonatomic, strong)NSString* notification;
@property (nonatomic, assign)BOOL isBlocked;
@property (nonatomic, assign)TIMConversationType type;
@property (atomic, assign)NSTimeInterval lastMemberListResp;
@property(nonatomic,assign) uint32_t createTime;
@property(nonatomic,assign) uint32_t lastInfoTime;
@property(nonatomic,assign) uint32_t lastMsgTime;
@property(nonatomic,assign) uint32_t memberNum;

@end
