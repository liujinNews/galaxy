//
//  NSString+Common.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/3.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

char pinyinFirstLetter(unsigned short hanzi);

@interface NSString(NSString_Common)

+ (NSString *)stringWithId:(id)ids;

+ (NSInteger)returnStringWidth:(NSString *)str font:(UIFont *)font;

+ (NSNumber *)stringWithNumber:(NSString *)str;

+ (NSString *)stringWithIdOnNO:(id)ids;
+ (NSString *)stringIsExist:(id)ids;
+ (NSString *)firstCharactor:(NSString *)aString;

+ (NSDate*) convertDateFromString:(NSString*)uiDate;

+ (CGFloat)getLabelWidth:(int)fontNumber biggestWidth:(CGFloat)biggestWidth text:(NSString *)text;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)stringFromDateByHHmm:(NSDate *)date;
//两个日期对比
+(NSInteger)datebyday:(NSString *)date1 date2:(NSString *)date2;
+(NSInteger)datebydays:(NSString *)date1 date2:(NSString *)date2;
+(NSString *)stringWithDateBystring:(NSString *)string;
+ (NSString *)GetstringFromDate;

+ (BOOL)isEqualToNull:(NSString *)str;
+ (BOOL)isEqualToNullAndZero:(id)object;

//json 转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;




//JSON转其他类型(字典,数组.....)
+(id)transformToObj:(NSString*)json;
//obj转json格式字符串
+(NSString*)transformToJson:(id)obj;
+(NSString*)transformToJsonWithOutEnter:(id)obj;

//日期返回 格式 yyyy/MM/dd
+(NSString *)stringWithDate:(NSDate *)date;
//日期转字符串
+(NSString *)stringWithDateAndTime:(NSDate *)date;
//日期返回 格式 yyyy年MM月
+(NSString *)stringWithYearAndMonth:(NSDate *)date;
+(NSString *)stringWithYearOnMonth:(NSDate *)date;
+(NSString *)stringWithStringYearOnMonth:(NSString *)string;
+(NSString *)stringWithAddStringYearOnMonth:(NSString *)string;
//日期返回 格式 yyyy
+(NSString *)stringWithYear:(NSDate *)date;

//日期返回 格式 MM
+(NSString *)stringWithMonth:(NSDate *)date;

+(NSString *)stringWithTime:(NSDate *)date;


// 将str加密成本地保存的文件名
+ (NSString *)md5String:(NSString *)str;
- (NSString *)md5;

-(NSString*)firstPinYin;

//是否为空
+ (BOOL)isEmpty:(NSString *)string;

/**
 compare two version
 @param sourVersion *.*.*.*
 @param desVersion *.*.*.*
 @returns No,sourVersion is less than desVersion; YES, the statue is opposed
 */
+(BOOL)compareVerison:(NSString *)sourVersion withDes:(NSString *)desVersion;

//当前字符串是否只包含空白字符和换行符
- (BOOL)isWhitespaceAndNewlines;

//去除字符串前后的空白,不包含换行符
- (NSString *)trim;

//去除字符串中所有空白
- (NSString *)removeWhiteSpace;
- (NSString *)removeNewLine;

//将字符串以URL格式编码
- (NSString *)stringByUrlEncoding;

/*!
 @brief     大写第一个字符
 @return    格式化后的字符串
 */
- (NSString *)capitalize;

//以给定字符串开始,忽略大小写
- (BOOL)startsWith:(NSString *)str;
//以指定条件判断字符串是否以给定字符串开始
- (BOOL)startsWith:(NSString *)str Options:(NSStringCompareOptions)compareOptions;


//以给定字符串结束，忽略大小写
- (BOOL)endsWith:(NSString *)str;
//以指定条件判断字符串是否以给定字符串结尾
- (BOOL)endsWith:(NSString *)str Options:(NSStringCompareOptions)compareOptions;

//包含给定的字符串, 忽略大小写
- (BOOL)containsString:(NSString *)str;
//以指定条件判断是否包含给定的字符串
- (BOOL)containsString:(NSString *)str Options:(NSStringCompareOptions)compareOptions;

//判断字符串是否相同，忽略大小写
- (BOOL)equalsString:(NSString *)str;


- (NSString *)emjoiText;


#pragma mark Hashing
#if kSupportGTM64
- (NSString *)base64Encoding;
#endif

- (NSString *)valueOfLabel:(NSString *)label;

- (NSString *)substringAtRange:(NSRange)rang;


// 是否带有表情府

- (NSUInteger)utf8Length;

- (BOOL)isContainsEmoji;

//递归计算符合规定的文本长度
- (NSString *)cutBeyondTextInLength:(NSInteger)maxLenth;

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode align:(NSTextAlignment)alignment;

+(NSString *)toCapitalLetters:(NSString *)money;
+(NSString *)toCapitalLetter:(NSString *)money;


+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;
+(NSString *)notRounding:(NSString *)price afterPoint:(int)position;

+(NSString *)countTax:(NSString *)amount taxrate:(NSString *)tax;

+(NSString *)getTheEndResultString:(NSString *)importString subString:(NSString *)subString;

+(NSString *)setDateListReturnString:(NSMutableArray *)_muarr_return;

+(NSString *)getDeviceName;
//金额数字转中文大写
+(NSString *)getChineseMoneyByString:(NSString*)string;

/*!
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
+(NSString *)reviseString:(NSString *)str;


/**
 给银行账号加密处理
 */
+(NSString *)getSecretBankAccount:(NSString *)bankAccount;


@end
