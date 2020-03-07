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

#import "TDDCustomLogFormatter.h"
#import <libkern/OSAtomic.h>
#import "MyCustomLogger.h"


static TDDCustomLogFormatter* __formatter;

@interface TDDCustomLogFormatter()
{
    NSString *_dateFormatString;
    
    int32_t _atomicLoggerCount;
    NSDateFormatter *_threadUnsafeDateFormatter; // Use [self stringFromDate]
}
@end

@implementation TDDCustomLogFormatter

- (id)init {
    if ((self = [super init])) {
        _dateFormatString = @"yyyy-MM-dd HH:mm:ss:SSS";
        
        _atomicLoggerCount = 0;
        _threadUnsafeDateFormatter = nil;
    }
    
    return self;
}


+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        __formatter = [[TDDCustomLogFormatter alloc] init];
    });
    return __formatter;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark DDLogFormatter
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &_atomicLoggerCount);
    
    NSString *calendarIdentifier = nil;
    
#if defined(__IPHONE_8_0) || defined(__MAC_10_10)
    calendarIdentifier = NSCalendarIdentifierGregorian;
#else
    calendarIdentifier = NSGregorianCalendar;
#endif
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        
        if (_threadUnsafeDateFormatter == nil) {
            _threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [_threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [_threadUnsafeDateFormatter setDateFormat:_dateFormatString];
        }
        
        [_threadUnsafeDateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:calendarIdentifier]];
        return [_threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"DispatchQueueLogFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = threadDictionary[key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormatter setDateFormat:_dateFormatString];
            
            threadDictionary[key] = dateFormatter;
        }
        
        [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:calendarIdentifier]];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString*)getLogLevelDes:(int)logLevel
{
    switch (logLevel) {
        case DDLogFlagDebug:
            return @"DEBU";
            break;
        case DDLogFlagError:
            return @"EVEN";
            break;
        case DDLogFlagInfo:
            return @"INFO";
            break;
        case DDLogFlagVerbose:
            return @"VERB";
            break;
        case DDLogFlagWarning:
            return @"WARN";
            break;
        default:
            return @"UNKN";
            break;
    }
    
}
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    
//    [self checkRollLog:logMessage->_timestamp]; 
    
    NSString *timestamp = [self stringFromDate:(logMessage->_timestamp)];
    
    
    return [NSString stringWithFormat:@"%@ [%@:%@] %@|%@|%@:%@|%@",
            timestamp,
            logMessage->_threadName,
            logMessage->_threadID,
            [self getLogLevelDes:logMessage->_flag],
            TDDLogContextNames[logMessage->_context],
            DDExtractFileNameWithoutExtension([logMessage->_file UTF8String],NO),
            @(logMessage->_line),
            logMessage->_message];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&_atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&_atomicLoggerCount);
}




@end
