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

#import "TDDCustomLogFileManager.h"

static NSString* LOGGER_FILE_PREFIX = @"MyDemo_";

TDDCustomLogFileManager* __manager;

@implementation TDDCustomLogFileManager

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        __manager = [[TDDCustomLogFileManager alloc] init];
    });
    return __manager;
}



- (NSString *)newLogFileName{
    NSDateFormatter *format = [self logFileDateFormatter];
    
    NSDate *newNow = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:newNow];
    
    NSString* logFileName = [NSString stringWithFormat:@"%@%@.log", LOGGER_FILE_PREFIX, dateString];
    
    return logFileName;
}

- (NSDateFormatter *)logFileDateFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread]
                                       threadDictionary];
    NSString *dateFormat = @"yyyy'-'MM'-'dd'";
    NSString *key = [NSString stringWithFormat:@"logFileDateFormatter.%@", dateFormat];
    NSDateFormatter *dateFormatter = dictionary[key];
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormat];
        
        dictionary[key] = dateFormatter;
    }
    
    return dateFormatter;
}

- (BOOL)isLogFile:(NSString *)fileName{
    
    BOOL hasProperPrefix = [fileName hasPrefix:LOGGER_FILE_PREFIX];
    BOOL hasProperSuffix = [fileName hasSuffix:@".log"];
    BOOL hasProperDate = NO;
    
    if (hasProperPrefix && hasProperSuffix) {
        NSUInteger lengthOfMiddle = fileName.length - LOGGER_FILE_PREFIX.length - @".log".length;
        //"yyyy-MM-dd"
        if (lengthOfMiddle>=10) {
            
            NSRange range = NSMakeRange(LOGGER_FILE_PREFIX.length, lengthOfMiddle);
            
            NSString *dateString = [fileName substringWithRange:range];
            
            NSDateFormatter *dateFormatter = [self logFileDateFormatter];
            
            NSDate *date = [dateFormatter dateFromString:dateString];
            
            if (date) {
                hasProperDate = YES;
            }
        }
    }
    return hasProperPrefix&&hasProperPrefix&&hasProperDate;
    
}


@end
