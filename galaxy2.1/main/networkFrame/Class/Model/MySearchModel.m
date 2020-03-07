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

#import "MySearchModel.h"

@implementation MySearchModel
- (BOOL)isEqual:(id)object
{
    return ([object isKindOfClass:[MySearchModel class]] && self.hash==[object hash]);
}

- (NSUInteger)hash
{
    return (self.userName.hash);
}

@end

NS_ENUM(int, Cmp_Source)
{
    Cmp_Source_Original      =101,
    Cmp_Source_Pinyin        =2000,
};

const int Cmp_Text_Step =10;
const int Cmp_Location_All =-100;
const int Cmp_Location_Step =100;

int get_sort_priority_original(NSString *matchedText, int textOrdinal, NSRange matchedRange)
{
    int val = Cmp_Source_Original+Cmp_Text_Step*textOrdinal;
    if (matchedRange.length==matchedText.length) val+=Cmp_Location_All;
    else val+=Cmp_Location_Step*matchedRange.location;
    
    return val;
}

int get_sort_priority_pinyin(int textOrdinal)
{
    return (Cmp_Source_Pinyin+Cmp_Text_Step*textOrdinal);
}

@implementation MySearchResultModel

@end


@implementation MySearchRecordModel

//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.uin forKey:@"uin"];
//    [encoder encodeInteger:self.uinType forKey:@"uinType"];
//    [encoder encodeObject:self.shownStrings forKey:@"shownStrings"];
//    [encoder encodeObject:self.sourceModel forKey:@"sourceModel"];
//    [encoder encodeObject:NSStringFromClass(self.filterClass) forKey:@"filterClass"];
//    [encoder encodeInteger:_recordTimes forKey:@"recordTimes"];
//    [encoder encodeFloat:_lastRecordTime forKey:@"lastRecordTime"];
//}

//- (instancetype)initWithCoder:(NSCoder *)decoder
//{
//    self = [super initWithCoder:decoder];
//    if (self)
//    {
//        self.uin = [decoder decodeObjectForKey:@"uin"];
//        self.uinType = [decoder decodeIntegerForKey:@"uinType"];
//        self.shownStrings = [decoder decodeObjectForKey:@"shownStrings"];
//        self.sourceModel = [decoder decodeObjectForKey:@"sourceModel"];
//        self.filterClass = NSClassFromString([decoder decodeObjectForKey:@"filterClass"]);
//        _recordTimes = [decoder decodeIntegerForKey:@"recordTimes"];
//        _lastRecordTime = [decoder decodeFloatForKey:@"lastRecordTime"];
//    }
//    return self;
//}

+ (instancetype)searchRecordFromSearchResult:(MySearchResultModel *)model
{
    MySearchRecordModel *tempModel = [MySearchRecordModel new];
    tempModel.shownStrings = model.shownStrings;
    tempModel.userName = model.userName;
    tempModel.sourceModel = model.sourceModel;
    tempModel.filterClass = model.filterClass;
    
    return tempModel;
}

@end
