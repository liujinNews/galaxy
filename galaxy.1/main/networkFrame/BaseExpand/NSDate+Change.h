//
//  NSDate+Change.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Change)

//日期输出昨天今天明天
+(NSString *)NSDateChangeTime:(NSString *)time;

+(NSString *)stringWithDateBySSS:(NSDate *)date;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

/**
 * 是否为明天
 */
- (BOOL)isTomorrow;

//格式yyyy/MM/dd
+(NSDate *)dateWithstring:(NSString *)string;

+(NSString *)dateWithstringByLine:(NSString *)string;

+(NSString *)dateWithstringBySemicolon:(NSString *)string;


+(NSString * )intervalSinceReferenceDate:(NSDate *)fromDate localeDate:(NSDate *)localeDate;

+(double )intervalSinceReferenceDate_double:(NSDate *)fromDate localeDate:(NSDate *)localeDate;

+(NSString *)CountDateTime:(NSString *)form to:(NSString *)to;

+(NSDate*)DateFromString:(NSString*)uiDate;

+(NSDate*)DateFromString:(NSString*)uiDate WithFormat:(NSString *)format;

+(NSDate*)TimeFromString:(NSString*)uiDate;

+(NSString *)getDateNow;

+(NSString *)getDateAndTimeNow;

+(NSString *)getbeforeDate_byMonth:(NSInteger)intr;

//1小时 2天数
+(NSString *)DateDuringFromTime:(NSString *)formTime to:(NSString *)toTime WithFormat:(NSString *)format WithDuringType:(NSInteger)duringType;

//以0.5为单位，获取时间
+(NSString *)getHalfDateWithDuring:(NSString *)during;

+(double)CompareDateStartTime:(NSString *)startTime endTime:(NSString *)endTime WithFormatter:(NSString *)format;

+(NSString *)AddCostCountFromDate:(NSString *)from ToDate:(NSString *)to;

+(NSDate *)getInternetDate;

+(NSString *)getCurrentPreviousMonth;

@end
