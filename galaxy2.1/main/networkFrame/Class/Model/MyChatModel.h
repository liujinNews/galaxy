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

@interface MyChatModel : MyModel{
}

@property (nonatomic, strong)NSString* user;       //c2c会话对方
@property (nonatomic, strong)NSString* chatId;    //会话id
@property (nonatomic, strong)NSString* title;     //会话标题
@property (nonatomic, strong)NSString* detailInfo; //会话最后一条消息
@property (nonatomic, assign)NSInteger type;    //会话类型
@property (nonatomic, assign)NSUInteger unreadCount;    //未读消息数
@property (nonatomic, strong)id chatInfo;   //model数据
@property (nonatomic, strong)NSDate* latestTimestamp;

@end
