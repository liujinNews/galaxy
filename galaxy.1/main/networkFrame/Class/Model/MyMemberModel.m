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

#import "MyMemberModel.h"

@implementation MyMemberModel

+ (MyMemberModel*)memberWithUserModel:(MyUserModel *)userModel{
    MyMemberModel* memberModel = [[MyMemberModel alloc] init];
    memberModel.user  = userModel.user;
    memberModel.nickName = userModel.nickName;
    memberModel.sortedPy = userModel.sortedPy;
    memberModel.sex = userModel.sex;
    memberModel.birthDay = userModel.birthDay;
    memberModel.signature = userModel.signature;
    return memberModel;
}

@end
