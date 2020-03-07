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

#import "MyUserModel.h"

@implementation MyUserModel

//- (id) copyWithZone:(NSZone *)zone{
//    MyUserModel* data = [[[self class] alloc] init];
//    data.userName = self.userName;
//    data.sortedPy = self.sortedPy;
//    data.nickName = self.nickName;
//    return data;
//}

- (BOOL) isEqual:(id)object{
    if (object == nil) {
        return NO;
    }
    
    if(object == self){
        return YES;
    }
    
    if(![object isKindOfClass:[MyUserModel class]]){
        return NO;
    }
    
    MyUserModel* user = (MyUserModel*)object;
    return [user.user isEqualToString:self.user];
}


- (NSUInteger) hash{
    return [self.user hash];
}

@end
