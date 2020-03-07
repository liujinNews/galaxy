//
//  NSString+StringSize.h
//
//  Created by hfk on 15/11/19.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (StringSize)

// 这个方法计算字符串本身的大小，会自动根据当前的系统版本用不同的方法来计算。
- (CGSize)sizeCalculateWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
