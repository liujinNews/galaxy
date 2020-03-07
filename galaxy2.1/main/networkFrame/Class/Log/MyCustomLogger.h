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

#ifndef My_CustomLogger_h
#define My_CustomLogger_h

#import <Foundation/Foundation.h>


#import "CocoaLumberjack.h"
#import "TDDCustomLogFileManager.h"
#import "TDDCustomLogFormatter.h"
#import "MySDKLogListener.h"


typedef enum {
    LogContext_Global=0,
    LogContext_IMSDK,
    LogContext_Max,
}ELogContext;

extern int myLogContext;

extern const NSString* TDDLogContextNames[];


extern int ddLogLevel;


#define Max_Log_Size (50 * 1024 * 1024)

#ifndef CUSTOM_LOG_CONTEXT
#define CUSTOM_LOG_CONTEXT myLogContext
#endif

#define TDDLogEvent(frmt, ...)   LOG_MAYBE(DDLogFlagError,   LOG_LEVEL_DEF, DDLogFlagError,   CUSTOM_LOG_CONTEXT, 0,  __PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)
#define TDDLogWarn(frmt, ...)    LOG_MAYBE(DDLogFlagWarning, LOG_LEVEL_DEF, DDLogFlagWarning, CUSTOM_LOG_CONTEXT, 0,  __PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)
#define TDDLogInfo(frmt, ...)    LOG_MAYBE(DDLogFlagInfo,    LOG_LEVEL_DEF, DDLogFlagInfo,    CUSTOM_LOG_CONTEXT, 0,  __PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)
#define TDDLogDebug(frmt, ...)   LOG_MAYBE(DDLogFlagDebug,   LOG_LEVEL_DEF, DDLogFlagDebug,   CUSTOM_LOG_CONTEXT, 0,  __PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)
#define TDDLogVerbose(frmt, ...) LOG_MAYBE(DDLogFlagVerbose, LOG_LEVEL_DEF, DDLogFlagVerbose, CUSTOM_LOG_CONTEXT, 0,  __PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)
#define TDDLogDetail(logFlag,context,isAsync,frmt,...)    LOG_LEVEL_DEF(isAsync, LOG_LEVEL_DEF, logFlag, context, 0,  __PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)



#define TDDLogFullDetail(isAsynchronous,flg,ctx,fileName,fnct,lineNum,frmt,...)  \
    do {                                                                        \
        if(LOG_LEVEL_DEF & flg)                                                 \
            [DDLog log:isAsynchronous                                           \
                level:LOG_LEVEL_DEF                                             \
                flag:flg                                                        \
                context:ctx                                                     \
                file:fileName                                                   \
                function:fnct                                                   \
                line:lineNum                                                    \
                tag:nil                                                         \
                format:(frmt), ## __VA_ARGS__]; \
} while(0)


#define LOGV_MACRO_FULL(isAsynchronous,lvl,flg,ctx,file,fnct,line,tag,frmt,avalist) \
    [DDLog log:isAsynchronous                                                       \
        level:lvl                                                                   \
        flag:flg                                                                    \
        context:ctx                                                                 \
        file:file                                                                   \
        function:fnct                                                               \
        line:line                                                                   \
        tag:tag                                                                     \
        format:(frmt), ## __VA_ARGS__]


#endif