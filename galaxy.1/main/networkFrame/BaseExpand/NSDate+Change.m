//
//  NSDate+Change.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "NSDate+Change.h"

@implementation NSDate (Change)

/**
 * 是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得年
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    && nowCmps.month == selfCmps.month
    && nowCmps.day == selfCmps.day;
}

/**
 * 是否为昨天
 */
- (BOOL)isYesterday
{
    // now : 2015-02-01 00:01:05 -->  2015-02-01
    // self : 2015-01-31 23:59:10 --> 2015-01-31
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 获得只有年月日的时间
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    // 比较
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

/**
 * 是否为明天
 */
- (BOOL)isTomorrow
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 获得只有年月日的时间
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    // 比较
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == -1;
}


+(NSString *)NSDateChangeTime:(NSString *)time
{
    if (time.length == 25) {
        time = [time substringWithRange:NSMakeRange(0, 19)];
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone systemTimeZone];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:time];
    
    
    if (createdAtDate.isThisYear) { // 今年
        if (createdAtDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createdAtDate];
        } else if (createdAtDate.isToday) { // 今天
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar components:unit fromDate:createdAtDate toDate:[NSDate date] options:0];
            
            if (cmps.hour >= 1) { // 时间间隔 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间间隔 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 时间间隔 < 1分钟
                return @"刚刚";
            }
        } else { // 不是今天昨天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createdAtDate];
        }
    } else { // 不是今年
        return time;
    }
}


+(NSDate *)dateWithstring:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

+(NSString *)dateWithstringByLine:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date=[formatter dateFromString:string];
    if (date == nil) {
        date = [NSDate date];
    }
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return  [formatter stringFromDate:date];;
}

+(NSString *)dateWithstringBySemicolon:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[formatter dateFromString:string];
    if (date == nil) {
        date = [NSDate date];
    }
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return  [formatter stringFromDate:date];;
}


+(NSString * )intervalSinceReferenceDate:(NSDate *)fromDate localeDate:(NSDate *)localeDate
{
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    NSInteger iSeconds = lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = (lTime / 3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth = lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    
    return [NSString stringWithFormat:@"相差%ld年%ld月 或者 %ld日%ld时%ld分%ld秒", (long)iYears,(long)iMonth,(long)iDays,iHours,iMinutes,iSeconds];
}

+(double )intervalSinceReferenceDate_double:(NSDate *)fromDate localeDate:(NSDate *)localeDate
{
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    
//    long lTime = (long)intervalTime;
//    NSInteger iSeconds = lTime % 60;
//    NSInteger iMinutes = (lTime / 60) % 60;
//    NSInteger iHours = (lTime / 3600);
//    NSInteger iDays = lTime/60/60/24;
//    NSInteger iMonth = lTime/60/60/24/12;
//    NSInteger iYears = lTime/60/60/24/384;
    
    return intervalTime;
}

+(NSString *)CountDateTime:(NSString *)form to:(NSString *)to{
    if ([NSString isEqualToNull:form]&&[NSString isEqualToNull:to]) {
        NSDate *formdate = [NSDate DateFromString:form];
        NSDate *todate = [NSDate DateFromString:to];
        double intervalTime = [todate timeIntervalSinceReferenceDate] - [formdate timeIntervalSinceReferenceDate];
        if (intervalTime<0) {
            return @"-1";
        }
        return [NSString notRounding:[NSString stringWithFormat:@"%f",intervalTime/3600] afterPoint:2];
    }else{
        return @"";
    }
}

+(NSDate*)DateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
+(NSDate*)DateFromString:(NSString*)uiDate WithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
+(NSDate*)TimeFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+(NSString *)stringWithDateBySSS:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSSSSS"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)getDateNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    return destDateString;
}

+(NSString *)getDateAndTimeNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    return destDateString;
}

+(NSString *)getbeforeDate_byMonth:(NSInteger)intr{
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = nil;
//    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-intr];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    return beforDate;
    
}

+(NSString *)DateDuringFromTime:(NSString *)formTime to:(NSString *)toTime WithFormat:(NSString *)format WithDuringType:(NSInteger)duringType{
    NSString *duringTime = @"";
    if ([NSString isEqualToNull:formTime]&&[NSString isEqualToNull:toTime]) {
        NSDate *formdate = [NSDate DateFromString:formTime WithFormat:format];
        NSDate *todate = [NSDate DateFromString:toTime WithFormat:format];
        double intervalTime = [todate timeIntervalSinceReferenceDate] - [formdate timeIntervalSinceReferenceDate];
        if (duringType == 3) {
            intervalTime += 3600*24;
        }
        if (intervalTime > 0) {
            if (duringType == 1) {
                duringTime = [NSString notRounding:[NSString stringWithFormat:@"%f",intervalTime/3600] afterPoint:2];
            }else{
                duringTime = [NSString notRounding:[NSString stringWithFormat:@"%f",intervalTime/(3600*24)] afterPoint:2];
            }
        }
    }
    return duringTime;
}

+(NSString *)getHalfDateWithDuring:(NSString *)during{
    float duringTime = 0;
    if ([NSString isEqualToNull:during]) {
        duringTime = ceilf([during floatValue] * 10 / 5) * 5 / 10;
    }
    return [NSString stringWithFormat:@"%.1f",duringTime];
}

+(double)CompareDateStartTime:(NSString *)startTime endTime:(NSString *)endTime WithFormatter:(NSString *)format{
    double resul=0;
    if ([NSString isEqualToNull:startTime]&&[NSString isEqualToNull:endTime]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        NSDate *startdate =[formatter dateFromString:startTime];
        NSDate *enddate = [formatter dateFromString:endTime];
        resul = [enddate timeIntervalSinceReferenceDate] - [startdate timeIntervalSinceReferenceDate];
    }
    return resul;
}

+(NSString *)AddCostCountFromDate:(NSString *)from ToDate:(NSString *)to{
    double str = [NSDate CompareDateStartTime:[from substringToIndex:10] endTime:[to substringToIndex:10] WithFormatter:@"yyyy/MM/dd"];
    int day = ((int)((str/60/60/24)+0.5)) - 1;
    if (day == -1) {
        double newtime = [NSDate CompareDateStartTime:from endTime:[NSString stringWithFormat:@"%@ 12:00",[from substringToIndex:10]] WithFormatter:@"yyyy/MM/dd HH:mm"];
        double fromtime = newtime>0?1:0.5;
        double endtime = [NSDate CompareDateStartTime:to endTime:[NSString stringWithFormat:@"%@ 12:00",[to substringToIndex:10]] WithFormatter:@"yyyy/MM/dd HH:mm"];
        double totime = endtime>0?0.5:1;
        double retu = 0.0;
        if (fromtime == 1&&totime == 1) {
            retu = 1;
        }else if (fromtime == 1&&totime == 0.5){
            retu = 0.5;
        }else if (fromtime == 0.5&&totime == 1){
            retu = 0.5;
        }
        
        return [NSString stringWithFormat:@"%.1f",retu];
    }
    double newtime = [NSDate CompareDateStartTime:from endTime:[NSString stringWithFormat:@"%@ 12:00",[from substringToIndex:10]] WithFormatter:@"yyyy/MM/dd HH:mm"];
    double endtime = [NSDate CompareDateStartTime:to endTime:[NSString stringWithFormat:@"%@ 12:00",[to substringToIndex:10]] WithFormatter:@"yyyy/MM/dd HH:mm"];
    double fromtime = newtime>0?1:0.5;
    double totime = endtime>0?0.5:1;
    return [NSString stringWithFormat:@"%.1f",(fromtime+totime+day)];
}

+ (NSDate *)getInternetDate
{
    NSString *urlString = @"https://web.xibaoxiao.com";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: netDate];
//    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return netDate;
}


+ (NSString *)getCurrentPreviousMonth{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    return  [formatter stringFromDate:newdate];
}


@end
