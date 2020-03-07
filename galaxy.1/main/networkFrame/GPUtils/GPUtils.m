//
//  GPUtils.m
//  galaxy
//
//  Created by 赵碚 on 15/7/22.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "GPUtils.h"
#import "GTMBase64.h"

@implementation GPUtils

//为块声明静态存储空间
static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;

#pragma mark 显示UIAlertView的不同方法
//简单弹出框

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray*)otherButtons
                              onDismiss:(DismissBlock)dismissed
                               onCancel:(CancelBlock)cancelled
{
    _cancelBlock  = [cancelled copy];
    _dismissBlock  = [dismissed copy];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self self]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons){
        [alert addButtonWithTitle:buttonTitle];
    }
    [alert show];
    
    //如果app被进入到后台了，就取消掉alert
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:NO];
    }];
    
    return alert;
}

//处理UIAlertViewDelegate
+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex]){
        _cancelBlock();
    }else{
        _dismissBlock(buttonIndex - 1); // cancel button is button 0
    }
}


#pragma mark 创建UIButton的不同方法

//创建UIButton
+(UIButton *)createButton:(CGRect)rect
                   action:(SEL)sel
                 delegate:(id)delegate
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:rect];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:Color_Unsel_TitleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:SYSTEMFONT(FontPointSize16)];
    if (delegate && [delegate respondsToSelector:sel]) {
        [btn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

+(UIButton *)createButton:(CGRect)rect
                   action:(SEL)sel
                 delegate:(id)delegate
              normalImage:(UIImage *)normalImage
         highlightedImage:(UIImage *)highlightedImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor clearColor];
    [btn setFrame:rect];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    if (delegate && [delegate respondsToSelector:sel]) {
        [btn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
+(UIButton *)createButton:(CGRect)rect action:(SEL)sel delegate:(id)delegate normalImage:(UIImage *)normalImage
            selectedImage:(UIImage *)selImage title:(NSString *)title font:(UIFont *)font normalcolor:(UIColor *)norcolor selectedcolor:(UIColor *)selcolor
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor clearColor];
    btn.frame=rect;
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:norcolor forState:UIControlStateNormal];
    [btn setTitleColor:selcolor forState:UIControlStateSelected];
    btn.titleLabel.font=font;
    if (delegate && [delegate respondsToSelector:sel]) {
        [btn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}


+(UIButton *)createButton:(CGRect)rect
                   action:(SEL)sel
                 delegate:(id)delegate
              normalImage:(UIImage *)normalImage
         highlightedImage:(UIImage *)highlightedImage
                    title:(NSString *)title
                     font:(UIFont *)font
                    color:(UIColor *)color

{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor clearColor];
    [btn setFrame:rect];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    if (delegate && [delegate respondsToSelector:sel]) {
        [btn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

+(UIButton *)createButton:(CGRect)rect
                   action:(SEL)sel
                 delegate:(id)delegate
    normalBackgroundImage:(UIImage *)normalImage
highlightedBackgroundImage:(UIImage *)highlightedImage
                    title:(NSString *)title
                     font:(UIFont *)font
                    color:(UIColor *)color

{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor clearColor];
    [btn setFrame:rect];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    btn.titleLabel.font=font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    if (delegate && [delegate respondsToSelector:sel]) {
        [btn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

+(UIButton *)createButton:(CGRect)rect
                   action:(SEL)sel
                 delegate:(id)delegate
                    title:(NSString *)title
                     font:(UIFont *)font
               titleColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor clearColor];
    [btn setFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitle:title forState:UIControlStateHighlighted];
    btn.titleLabel.font=font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    if (delegate && [delegate respondsToSelector:sel]) {
        [btn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

//创建UIButton
+(UIButton *)createButton:(CGRect)rect
                   action:(SEL)sel
                 delegate:(id)delegate
                     type:(UIButtonType)type
{
    UIButton *btn = [UIButton buttonWithType:type];
    [btn setFrame:rect];
    [btn.titleLabel setFont:SYSTEMFONT(FontPointSize16)];
    if ([delegate respondsToSelector:sel]) {
        [btn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}


#pragma mark 创建UILabel

//创建UILabel
+(UILabel *)createLable:(CGRect)rect
{
    UILabel *lbl = [[UILabel alloc]initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = SYSTEMFONT(FontPointSize16);
    lbl.textColor = Color_Unsel_TitleColor;
    return lbl;
}

+(UILabel *)createLable:(CGRect)rect text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    label.text= [NSString stringWithIdOnNO:text];
    label.font=font;
    label.textColor=color;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=textAlignment;
    return label;
}

+(UILabel *)createLable:(CGRect)rect text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color  textAlignment:(NSTextAlignment)textAlignment shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)size
{
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    label.text=text;
    label.font=font;
    label.textColor=color;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=textAlignment;
    label.shadowColor=shadowColor;
    label.shadowOffset=size;
    return label;
}

//UIImageView创建
+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    return imageView;
}


#pragma mark 创建UITextField

//创建UITextField
+(UITextField *)createTextField:(CGRect)rect
{
    UITextField *txtField = [[UITextField alloc]initWithFrame:rect];
    txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtField.font = SYSTEMFONT(FontPointSize16);
    txtField.textColor = Color_Unsel_TitleColor;
    return txtField;
}

+(UITextField *)createTextField:(CGRect)rect placeholder:(NSString *)placeholder delegate:(id)delegate font:(UIFont *)font textColor:(UIColor *)color
{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = font;
    textField.textColor = color;
    textField.placeholder=[placeholder isEqual:[NSNull null]]?@"":placeholder;
    textField.delegate=delegate;
    return textField;
}




#pragma mark 创建UITextView

//创建UITextView
+(UITextView *)createUITextView:(CGRect)rect delegate:(id)delegate font:(UIFont *)font textColor:(UIColor *)color
{
    UITextView *textView=[[UITextView alloc] initWithFrame:rect];
    textView.delegate=delegate;

    textView.font=font;
    textView.textColor=color;
    textView.backgroundColor=[UIColor clearColor];
    return textView;
}

//设置UIView及子类的边框
+(void)setBorder:(UIView*)view{
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 1.0;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

//压缩图片尺寸(按比例)
+(UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleFloat
{
    CGSize size = CGSizeMake(image.size.width * scaleFloat, image.size.height * scaleFloat);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformScale(transform, scaleFloat, scaleFloat);
    CGContextConcatCTM(context, transform);
    
    // Draw the image into the transformed context and return the image
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(NSUInteger )width{
    CGSize size=[text sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat delta = size.height;
    return delta;
}
//发送短信
+(void)sendSMSMessageWithDelegate:(UIViewController<MFMessageComposeViewControllerDelegate> *)delegate AndMessages:(NSString *)messages AndPhoneNum:(NSString *)phoneNum{
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController* mcvc = [[MFMessageComposeViewController alloc]init];
        mcvc.recipients = [[NSArray alloc]initWithObjects:phoneNum, nil];
        mcvc.body = messages;
        mcvc.messageComposeDelegate = delegate;
        [delegate presentViewController:mcvc animated:YES completion:nil];
    }else
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息", nil)
                                                   message:Custing(@"该设备不支持短信功能", nil)
                                                  delegate:nil
                                         cancelButtonTitle:Custing(@"确定", nil)
                                         otherButtonTitles:nil,nil];
        [alert show];
    }
}



+(void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = Custing(@"Accept",nil);
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

+(void)registerPushForIOS7{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

//获得当前根控制器
+(UIViewController *)getCurrentRootViewController {
    
    UIViewController *result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal)
        
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        
        for(topWindow in windows)
            
        {
            
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        result = nextResponder;
    
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    
    else
        
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    return result;
    
}

//根据十六进制值获取颜色
+ (UIColor *)colorHString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(NSString *)transformToDictionaryFromJson:(NSDictionary *)dic
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}
//增加2为小数
+(NSString *)transformNsNumber:(NSString *)money
{
    money=[[NSString stringWithFormat:@"%@",money] stringByReplacingOccurrencesOfString:@"," withString:@""];
    money=[NSString isEqualToNull:money]?money:@"0";
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:money];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
//    money = [roundedOunces stringValue];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
//    double amount=[money doubleValue];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:roundedOunces];
    return formattedNumberString;
}
//增加4为小数
+(NSString *)TransformNsNumber:(NSString *)exchangeRate
{
    exchangeRate=[[NSString stringWithFormat:@"%@",exchangeRate] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setPositiveFormat:@"###,##0.0000;"];
    double amount=[exchangeRate doubleValue];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:amount]];
    return formattedNumberString;
}

//大数相加
+(NSString *)decimalNumberAddWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue{

    multiplierValue=[[NSString stringWithFormat:@"%@",multiplierValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    multiplicandValue=[[NSString stringWithFormat:@"%@",multiplicandValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![NSString isEqualToNull:multiplierValue]||[multiplierValue doubleValue]==0) {
        multiplierValue=@"0";
    }
    if (![NSString isEqualToNull:multiplicandValue]||[multiplicandValue doubleValue]==0) {
        multiplicandValue=@"0";
    }

    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplierValue]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplicandValue]];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByAdding:multiplierNumber];
//    NSLog(@"wowoowowowowwoo%@",product);
    return [product stringValue];

}
//大数相减
+(NSString *)decimalNumberSubWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue
{
//    [GPUtils decimalNumberSubWithString:@"6" with:@"3"];       结果3
    multiplierValue=[[NSString stringWithFormat:@"%@",multiplierValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    multiplicandValue=[[NSString stringWithFormat:@"%@",multiplicandValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![NSString isEqualToNull:multiplierValue]||[multiplierValue doubleValue]==0) {
        multiplierValue=@"0";
    }
    if (![NSString isEqualToNull:multiplicandValue]||[multiplicandValue doubleValue]==0) {
        multiplicandValue=@"0";
    }

    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplierValue]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplicandValue]];
    NSDecimalNumber *product = [multiplierNumber decimalNumberBySubtracting:multiplicandNumber];
    return [product stringValue];

}
//大数相乘
+(NSString *)decimalNumberMultipWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue{
    
    multiplierValue=[[NSString stringWithFormat:@"%@",multiplierValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    multiplicandValue=[[NSString stringWithFormat:@"%@",multiplicandValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![NSString isEqualToNull:multiplierValue]||[multiplierValue doubleValue]==0) {
        multiplierValue=@"0";
    }
    if (![NSString isEqualToNull:multiplicandValue]||[multiplicandValue doubleValue]==0) {
        multiplicandValue=@"0";
    }
    
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplierValue]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplicandValue]];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
//        NSLog(@"wowoowowowowwoo%@",product);
    return [product stringValue];
}
//大数相除
+(NSString *)decimalNumberDividingWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue{

    //    NSString *sub=[GPUtils decimalNumberDividingWithString:@"6" with:@"3"];   结果2
    multiplierValue=[[NSString stringWithFormat:@"%@",multiplierValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    multiplicandValue=[[NSString stringWithFormat:@"%@",multiplicandValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![NSString isEqualToNull:multiplierValue]||[multiplierValue doubleValue]==0) {
        multiplierValue=@"0";
    }
    if (![NSString isEqualToNull:multiplicandValue]||[multiplicandValue doubleValue]==0) {
        multiplicandValue=@"1";
    }
    
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplierValue]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",multiplicandValue]];
    
    NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];
    //        NSLog(@"wowoowowowowwoo%@",product);
    return [product stringValue];
}
//四舍五入保留
+(NSString *)getRoundingOffNumber:(NSString *)string afterPoint:(int)position{
    if (![NSString isEqualToNull:string]) {
        string=@"0";
    }
    string=[[NSString stringWithFormat:@"%@",string] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:string];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces stringValue];
}

+(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


//textView文本高度
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}
//去掉导航栏线条
+(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//改变字体Label部分颜色
+(NSMutableAttributedString *)transformNSMutableAttributedString:(NSString *)string withFirFont:(UIFont *)firfont withSecFont:(UIFont *)secfont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:[GPUtils colorHString:ColorPink] range:NSMakeRange(0, str.length-3)];
    [str addAttribute:NSFontAttributeName value:firfont range:NSMakeRange(0, str.length-3)];
    [str addAttribute:NSForegroundColorAttributeName value:[GPUtils colorHString:ColorGrayPlace] range:NSMakeRange(str.length-3, 3)];
    [str addAttribute:NSFontAttributeName value:secfont range:NSMakeRange(str.length-3, 3)];
    return str;
}
+(NSMutableArray *)filtOutSamefromData:(NSMutableArray *)dataArray toFiltData:(NSMutableArray *)filtArray{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",filtArray];
    //过滤数组
    NSMutableArray *array=[NSMutableArray arrayWithArray:[dataArray filteredArrayUsingPredicate:filterPredicate]];
    return array;
}
+(NSMutableArray *)filtOutdifferfromData:(NSMutableArray *)dataArray toFiltData:(NSMutableArray *)filtArray{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",filtArray];
    //过滤数组
    NSMutableArray *array=[NSMutableArray arrayWithArray:[dataArray filteredArrayUsingPredicate:filterPredicate]];
    return array;
}

+(NSMutableArray *)transformTimeString:(NSString *)timestring{
    return [GPUtils transformTimeString:timestring WithTimeFormat:@"yyyy/MM/dd HH:mm:ss"];
}

+(NSMutableArray *)transformTimeString:(NSString *)timestring WithTimeFormat:(NSString *)timeFormat{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:timeFormat];
    NSDate *fromdate=[format dateFromString:timestring];
    
    NSDateFormatter * MonthDayFormatter = [[NSDateFormatter alloc]init];
    MonthDayFormatter.timeZone = [NSTimeZone localTimeZone];
    [MonthDayFormatter setDateFormat:@"MM月dd日"];
    NSString *MonthDayStr= [MonthDayFormatter stringFromDate:fromdate];
    if (MonthDayStr==nil) {
        return nil;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:MonthDayStr];
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage];
    
    if ([language isEqualToString:@"zh-Hans"]) {
        NSRange range1 = [MonthDayStr rangeOfString:@"月"];
        NSRange range2 = [MonthDayStr rangeOfString:@"日"];
        [str addAttribute:NSForegroundColorAttributeName value:Color_form_TextField_20 range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.f] range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f] range:range1];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f] range:range2];
    }else if ([language isEqualToString:@"en"]){
        NSRange range1 = [MonthDayStr rangeOfString:@"月"];
        NSRange range2 = [MonthDayStr rangeOfString:@"日"];
        [str replaceCharactersInRange:range1 withString:@"/"];
        [str replaceCharactersInRange:range2 withString:@""];
        [str addAttribute:NSForegroundColorAttributeName value:Color_form_TextField_20 range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.f] range:NSMakeRange(0, str.length)];
    }
    
    NSDateFormatter * TimeFormatter = [[NSDateFormatter alloc]init];
    TimeFormatter.timeZone = [NSTimeZone localTimeZone];
    [TimeFormatter setDateFormat:@"HH:mm"];
    NSString *TimeStr= [TimeFormatter stringFromDate:fromdate];
    
    NSMutableArray *array=[NSMutableArray array];
    [array addObject:str];
    [array addObject:TimeStr];
    return array;
}
+(NSDate*)TimeStringTranFromData:(NSString*)uiDate WithTimeFormart:(NSString *)formart{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:formart];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
+(NSDate*) convertLeaveDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
+(NSDate*) convertLeaveDateFromStrings:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (unsigned)(long)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

+(UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

//sha256加密方式
+(NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [GTMBase64 stringByEncodingData:resultData];
        //        return [self hexStringFromData:resultData];
        
    }
    free(buffer);
    return nil;
}


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

+ (NSString *)escapedQuery:(NSString *)query {
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef)query,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                    kCFStringEncodingUTF8));
    return escapedString;
}

+(NSString *)getTimeIntervalFirstTime:(NSString *)firstTime SecondTime:(NSString *)secondTime{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy/MM/dd";
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    // 当前时间字符串格式
    // 截止时间data格式
    
    NSDate *expireDates = [dateFomatter dateFromString:secondTime];
    NSInteger expireinterval = [fromzone secondsFromGMTForDate: expireDates];
    NSDate *expireDate = [expireDates  dateByAddingTimeInterval: expireinterval];
    // 当前时间data格式
    NSDate *nowDates = [dateFomatter dateFromString:firstTime];
    NSInteger nowinterval = [fromzone secondsFromGMTForDate: nowDates];
    NSDate *nowDate =[nowDates  dateByAddingTimeInterval: nowinterval];
   
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceNow];
    NSTimeInterval timeInterval1 = [expireDate timeIntervalSinceNow];
    return [NSString stringWithFormat:@"%ld",(long)ceilf((float)((timeInterval1-timeInterval)/86400))];
}

+(BOOL)isFileType:(id)source{
    if (![source isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else{
//        if ((![source[@"extensionname"] isEqualToString:@".doc"]&&![source[@"extensionname"] isEqualToString:@".docx"]&&![source[@"extensionname"] isEqualToString:@".xls"]&&![source[@"extensionname"] isEqualToString:@".xlsx"]&&![source[@"extensionname"] isEqualToString:@".pdf"]&&![source[@"extensionname"] isEqualToString:@".csv"]&&![source[@"extensionname"] isEqualToString:@".txt"]&&![source[@"extensionname"] isEqualToString:@".zip"]&&![source[@"extensionname"] isEqualToString:@".rar"]&&![source[@"extensionname"] isEqualToString:@".7z"]&&![source[@"extensionname"] isEqualToString:@"XLSX"]&&![source[@"extensionname"] isEqualToString:@"DOCX"]&&![source[@"extensionname"] isEqualToString:@"PDF"])) {
//            return YES;
//        }else{
//            return NO;
//        }containsString
        if (![source[@"extensionname"] containsString:@"doc"]&&![source[@"extensionname"] containsString:@"xls"]&&![source[@"extensionname"] containsString:@"pdf"]&&![source[@"extensionname"] containsString:@"csv"]&&![source[@"extensionname"] containsString:@"txt"]&&![source[@"extensionname"] containsString:@"zip"]&&![source[@"extensionname"] containsString:@"rar"]&&![source[@"extensionname"] containsString:@"7z"]) {
            return YES;
        }else{
            return NO;
        }
    }
}


+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
+(NSString *)getSelectResultWithArray:(NSArray *)array{
  return  [GPUtils getSelectResultWithArray:array WithCompare:@"/"];
}
+(NSString *)getSelectResultWithArray:(NSArray *)array WithCompare:(NSString *)compare{
    NSMutableArray *resultArray=[NSMutableArray array];
    for (id obeject in array) {
        if ([NSString isEqualToNull:obeject]) {
            [resultArray addObject:[NSString stringWithFormat:@"%@",obeject]];
        }
    }
    return  resultArray.count>0?[resultArray componentsJoinedByString:compare]:@"";
}


+(NSString *)getNowTimeDateWithFormatter:(NSString *)formatter{
    NSDate *pickerDate = [NSDate date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    pickerFormatter.timeZone = [NSTimeZone localTimeZone];
    [pickerFormatter setDateFormat:formatter];
    return  [pickerFormatter stringFromDate:pickerDate];
}

+(BOOL)isPhoneNoWithString:(NSString *)phone{
//        NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    if (phone.length!=11) {
        return NO;
    }else{
        NSString *phoneRegex =@"1[0-9]{1,10}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        return [phoneTest evaluateWithObject:phone];
    }
}
+(NSString*)removeFloatAllZero:(NSString*)string
{
    
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}

+(NSString *)sha1:(NSString *)input
{    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
+(NSString *)getTimeStamp{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:timeInterval] longLongValue]; // 将double转为long long型
    return [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    
//    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
//    NSInteger frominterval = [fromzone secondsFromGMTForDate: [NSDate date]];
//    NSDate *fromDate = [[NSDate date]  dateByAddingTimeInterval: frominterval];
//    NSTimeInterval timeInterval = [fromDate timeIntervalSince1970];
//    long long dTime = [[NSNumber numberWithDouble:timeInterval] longLongValue]; // 将double转为long long型
//    return [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
}
+(void)updateImageDataWithTotalArray:(NSMutableArray *)tolArr WithImageArray:(NSMutableArray *)imgArr WithMaxCount:(NSInteger)maxcount{
    [imgArr removeAllObjects];
    NSMutableArray *arr_pdf = [NSMutableArray array];
    for (int i = 0; i<tolArr.count; i++) {
//        if ([tolArr[i] isKindOfClass:[NSDictionary class]]) {
//            NSString *type = tolArr[i][@"extensionname"];
//            if ([type isEqualToString:@".pdf"]||[type isEqualToString:@".doc"]||[type isEqualToString:@".docx"]||[type isEqualToString:@".xls"]||[type isEqualToString:@".xlsx"]||[type isEqualToString:@".csv"]||[type isEqualToString:@".txt"]||[type isEqualToString:@".zip"]||[type isEqualToString:@".rar"]||[type isEqualToString:@".7z"]||[type isEqualToString:@"XLSX"]||[type isEqualToString:@"DOCX"]||[type isEqualToString:@"PDF"]) {
//                [arr_pdf addObject:tolArr[i]];
//            }else{
//                [imgArr addObject:tolArr[i]];
//            }
//        }else{
//            [imgArr addObject:tolArr[i]];
//        }
        if ([tolArr[i] isKindOfClass:[NSDictionary class]]) {
            NSString *type = tolArr[i][@"extensionname"];
            if ([type containsString:@"pdf"]||[type containsString:@"doc"]||[type containsString:@"xls"]||[type containsString:@"csv"]||[type containsString:@"txt"]||[type isEqualToString:@"zip"]||[type containsString:@"rar"]||[type containsString:@"7z"]) {
                [arr_pdf addObject:tolArr[i]];
            }else{
                [imgArr addObject:tolArr[i]];
            }
        }else{
            [imgArr addObject:tolArr[i]];
        }
    }
    [tolArr removeAllObjects];
    [tolArr addObjectsFromArray:imgArr];
    [tolArr addObjectsFromArray:arr_pdf];
    
    if (tolArr.count>maxcount) {
        [tolArr removeObjectsInRange:NSMakeRange(maxcount, tolArr.count-maxcount)];
    }
}
+ (NSDate *)getLaterDateFromDate:(NSDate *)date withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
//    NSDateComponents *comps = nil;
//
//    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:year];
    
    [adcomps setMonth:month];
    
    [adcomps setDay:day];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    
    return newdate;
}


@end
