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

@interface MyMsgBaseModel : MyModel

@property (nonatomic, assign)TIMConversationType chatType;
@property (nonatomic, assign)BOOL     inMsg;
@property (nonatomic, strong)NSString* friendNick;
@property (nonatomic, strong)NSString* friendUserName;        //在group的时候展示姓名有用
@property (nonatomic, strong)NSDate*    sendTime;
//@property (nonatomic, assign)BOOL   failed;
@property (nonatomic, assign)TIMMessageStatus   preStatus;
@property (nonatomic, assign)TIMMessageStatus   status;
@property (nonatomic, strong)TIMConversation*  conversation;
@property (nonatomic, strong)TIMElem*   elem;
@property (nonatomic, strong)TIMMessage*   msg;


@end
