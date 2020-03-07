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
#import "MyModel.h"


typedef NS_ENUM(NSUInteger, GroupInfoItemType){
    GroupInfoItemType_Id,
    GroupInfoItemType_Title,
    GroupInfoItemType_Mynick,
    GroupInfoItemType_Namecard,
    GroupInfoItemType_Owner,
    GroupInfoItemType_Introduction,
    GroupInfoItemType_Notification,
    GroupInfoItemType_MemberNum,
};

@interface MyChatInfoItemModel : MyModel

@property (nonatomic, strong)NSString* infoTitle;
@property (nonatomic, strong)NSString* infoContent;
@property (nonatomic, strong)id dataModel;
@property (nonatomic, assign)GroupInfoItemType type;
@property (nonatomic, assign)BOOL modifyPermission;

@end
