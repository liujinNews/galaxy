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

#import "MyUtilty.h"


NSInteger sortObjectsByFirstLetterAscending(id obj1, id obj2, void *context)
{
    NSString* str_1 = (NSString*)obj1;
    NSString* str_2 = (NSString*)obj2;
    
    if(str_1 == nil
       ||str_1.length < 1)
    {
        return NSOrderedAscending;
    }
    
    if(str_2 == nil
       ||str_2.length < 1)
    {
        return NSOrderedDescending;
    }
    
    char c1 = [str_1 characterAtIndex:0];
    char c2 = [str_2 characterAtIndex:0];
    
    if ( ((c1 >= 'A' && c1 <= 'Z') || (c1 >= 'a' && c1 <= 'z')) && ((c2 >= 'A' && c2 <= 'Z') || (c2 >= 'a' && c2 <= 'z')) )
    {
        return c1 - c2;
    }
    else if (c1 < 'A' || (c1 > 'Z' && c1 < 'a') || c1 > 'z')
    {
        return NSOrderedDescending;
    }
    else if (c2 < 'A' || (c2 > 'Z' && c2 < 'a') || c2 > 'z')
    {
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedSame;
    }
}


@implementation TIMLoginParam (addtion_NSCoding)

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.accountType forKey:@"kAccountType"];
    [coder encodeObject:self.identifier forKey:@"kIdentifier"];
    [coder encodeObject:self.userSig forKey:@"kUserSig"];
    [coder encodeObject:self.appidAt3rd forKey:@"kAppidAt3rd"];
    [coder encodeObject:[NSNumber numberWithInteger:self.sdkAppId] forKey:@"kSdkAppId"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.accountType = [coder decodeObjectForKey:@"kAccountType"];
        self.identifier = [coder decodeObjectForKey:@"kIdentifier"];
        self.userSig = [coder decodeObjectForKey:@"kUserSig"];
        self.appidAt3rd = [coder decodeObjectForKey:@"kAppidAt3rd"];
        self.sdkAppId = (int) [[coder decodeObjectForKey:@"kSdkAppId"] integerValue];
    }
    return self;
}

@end