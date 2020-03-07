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

@interface MySearchModel : MyModel
@property (nonatomic, strong) NSString *userName;
//@property (nonatomic) QCUinType uinType;
@property (nonatomic, strong) NSArray *shownStrings;    //匹配结果和文字显示
@property (nonatomic, strong) MyModel *sourceModel;
@property (nonatomic, strong) Class filterClass;
@end

@class MySearchRecordModel;

@interface MySearchResultModel : MySearchModel
@property (nonatomic) int highlightIndex;   //匹配结果和文字显示
@property (nonatomic) NSRange matchRange;   //匹配结果和文字显示
//排序, 限filter内部，通过sort_priority_original或sort_priority_pinyin计算
@property (nonatomic) unsigned sortPriority;
@end

#ifdef __cplusplus
extern "C" {
#endif
    int get_sort_priority_original(NSString *matchedText, int textOrdinal, NSRange matchedRange);
    int get_sort_priority_pinyin(int textOrdinal);
#ifdef __cplusplus
}
#endif

@interface MySearchRecordModel : MySearchModel
@property (nonatomic) int recordTimes;
@property (nonatomic) double lastRecordTime;
+ (instancetype)searchRecordFromSearchResult:(MySearchResultModel*)model;

@end