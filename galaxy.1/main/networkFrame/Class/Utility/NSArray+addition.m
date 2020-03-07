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

#import "NSArray+addition.h"
#import "MyUserModel.h"
#import "NSStringEx.h"

@implementation NSArray (addition)

- (NSArray *)sortedUserModelsByNameAscend:(BOOL)flag
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [self innerSortModel1:obj1 model2:obj2 ascend:flag];
    }];;
}

- (NSComparisonResult)innerSortModel1:(id)obj1 model2:(id)obj2 ascend:(BOOL)flag
{
    MyUserModel *model1 = (MyUserModel*)obj1;
    MyUserModel *model2 = (MyUserModel*)obj2;
    
    NSString *nick1 = model1.user;
    NSString *nick2 = model2.user;
    
    if (model1.sortedPy.length == 0) {
        model1.sortedPy = [nick1 pinyinFullString];
    }
    
    if (model2.sortedPy.length == 0) {
        model2.sortedPy = [nick2 pinyinFullString];
    }
    
    NSString *name1 = model1.sortedPy;
    NSString *name2 = model2.sortedPy;
    
    if (name1.length == 0 || name2.length == 0) {
        return NSOrderedSame;
    }
    
    BOOL isEnglishName1 = isOrEnglishName(nick1);
    BOOL isEnglishName2 = isOrEnglishName(nick2);
    
    
    if (isEnglishName1 != isEnglishName2 && [name1 characterAtIndex:0] == [name2 characterAtIndex:0]) {
        return isEnglishName1 && flag ? NSOrderedAscending : NSOrderedDescending;
    }else{
        return flag?[nick1 localizedCaseInsensitiveCompare:nick2]:[nick2 localizedCaseInsensitiveCompare:nick1];
    }
}

BOOL isOrEnglishName(NSString *nick)
{
    if ( nick && [nick length]>0 )
    {
        unichar first_letter = [nick characterAtIndex:0];
        if ( (first_letter>='A' && first_letter<='Z') || (first_letter>='a' && first_letter<='z') )
        {
            return YES;
        }
    }
    
    return NO;
}


@end

@implementation NSMutableArray (addition)

- (void)sortedUserModelsByNameAscend:(BOOL)flag
{
    [self sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [self innerSortModel1:obj1 model2:obj2 ascend:flag];
    }];
}

@end