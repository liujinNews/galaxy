//
//  NSString+StringSize.m
//  galaxy
//
//  Created by hfk on 15/11/19.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)
- (CGSize)sizeCalculateWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    // 根据不同的版本采用不同的方法计算字符串的大小
    // currentDevice 取到当前的设备 systemVersion 取到这台设备的系统版本号
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) { // 7.0以前的版本用这个方法计算
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
        
    } else { // 7.0以及以后的版本
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        return CGSizeMake( [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.width+2,  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height+1);
    }
}
@end
