
//
//  GPUtils.h
//  galaxy
//
//  Created by 赵碚 on 15/7/22.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
@interface GPUtils : NSObject



//用typedef定义DismissBlock和CancelBlock
typedef void (^DismissBlock)(NSInteger buttonIndex);
typedef void (^CancelBlock)(void);


//简单弹出框
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray*)otherButtons
                              onDismiss:(DismissBlock)dismissed
                               onCancel:(CancelBlock)cancelled;


//Button创建方法
+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate;

+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate type:(UIButtonType)type;

+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;

+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage title:(NSString *)title font:(UIFont *)font color:(UIColor *)color;

+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate normalBackgroundImage:(UIImage *)normalImage
highlightedBackgroundImage:(UIImage *)highlightedImage title:(NSString *)title font:(UIFont *)font color:(UIColor *)color
;
+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate normalImage:(UIImage *)normalImage
selectedImage:(UIImage *)selImage title:(NSString *)title font:(UIFont *)font normalcolor:(UIColor *)norcolor selectedcolor:(UIColor *)selcolor;

+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color;

//UILabel创建方法
+(UILabel *)createLable:(CGRect)rect;
+(UILabel *)createLable:(CGRect)rect text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;
+(UILabel *)createLable:(CGRect)rect text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color  textAlignment:(NSTextAlignment)textAlignment shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)size;



//UITextField创建方法
+(UITextField *)createTextField:(CGRect)rect;

+(UITextField *)createTextField:(CGRect)rect placeholder:(NSString *)placeholder delegate:(id)delegate font:(UIFont *)font textColor:(UIColor *)color;


//UIImageView创建
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName;




+(UITextView *)createUITextView:(CGRect)rect delegate:(id)delegate font:(UIFont *)font textColor:(UIColor *)color;

+(void)setBorder:(UIView*)view;
//压缩图片尺寸(按比例)
+(UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleFloat;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(NSUInteger )width;

//发送短信
+(void)sendSMSMessageWithDelegate:(UIViewController<MFMessageComposeViewControllerDelegate>*)delegate AndMessages:(NSString*)messages AndPhoneNum:(NSString*)phoneNum;

//注册推送方式
+(void)registerPushForIOS8;
+(void)registerPushForIOS7;

+(UIViewController *)getCurrentRootViewController;
+ (UIColor *)colorHString: (NSString *)color;

+(NSString *)transformToDictionaryFromJson:(NSDictionary *)dic;
//千分位金额
+(NSString *)transformNsNumber:(NSString *)string;
+(NSString *)TransformNsNumber:(NSString *)exchangeRate;
//大额金钱计算
+(NSString *)decimalNumberAddWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue;
+(NSString *)decimalNumberSubWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue;
+(NSString *)decimalNumberMultipWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue;
+(NSString *)decimalNumberDividingWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue;
+(NSString *)getRoundingOffNumber:(NSString *)string afterPoint:(int)position;

+(NSString *)notRounding:(float)price afterPoint:(int)position;
//算textView高度
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
+(UIImageView *)findHairlineImageViewUnder:(UIView *)view ;

+(NSMutableAttributedString *)transformNSMutableAttributedString:(NSString *)string withFirFont:(UIFont *)firfont withSecFont:(UIFont *)secfont;
//剔除出A数组中有且B数组中也有的
+(NSMutableArray *)filtOutSamefromData:(NSMutableArray *)dataArray toFiltData:(NSMutableArray *)filtArray;
//剔除出A数组中有但是B数组中没有的
+(NSMutableArray *)filtOutdifferfromData:(NSMutableArray *)dataArray toFiltData:(NSMutableArray *)filtArray;
//时间处理
+(NSMutableArray *)transformTimeString:(NSString *)timestring;
+(NSMutableArray *)transformTimeString:(NSString *)timestring WithTimeFormat:(NSString *)timeFormat;
//nsstring转nsdate
+(NSDate*)TimeStringTranFromData:(NSString*)uiDate WithTimeFormart:(NSString *)formart;
+(NSDate*) convertLeaveDateFromString:(NSString*)uiDate;
+(NSDate*) convertLeaveDateFromStrings:(NSString*)uiDate;
//身份证验证
+ (BOOL)validateIDCardNumber:(NSString *)value;
//随机颜色
+(UIColor *)randomColor;
//sha256加密方式
+(NSString*)sha256HashFor:(NSString*)input;
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;

+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;
+(NSString *)escapedQuery:(NSString *)query;
//计算时间差
+(NSString *)getTimeIntervalFirstTime:(NSString *)firstTime SecondTime:(NSString *)secondTime;
//判断是否不是文件类型
+(BOOL)isFileType:(id)source;
//获取当前UIViewController
+(UIViewController *)getCurrentVC;
//数组拼成字符串
+(NSString *)getSelectResultWithArray:(NSArray *)array;
+(NSString *)getSelectResultWithArray:(NSArray *)array WithCompare:(NSString *)compare;

//获取当前时间
+(NSString *)getNowTimeDateWithFormatter:(NSString *)formatter;
//判断是否是手机号码
+(BOOL)isPhoneNoWithString:(NSString *)phone;
//去掉浮点数后面多余的0
+(NSString*)removeFloatAllZero:(NSString*)string;
//sha1加密
+(NSString *)sha1:(NSString *)input;
//获取时间戳
+(NSString *)getTimeStamp;

+(void)updateImageDataWithTotalArray:(NSMutableArray *)tolArr WithImageArray:(NSMutableArray *)imgArr WithMaxCount:(NSInteger)maxcount;
+ (NSDate *)getLaterDateFromDate:(NSDate *)date withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end
