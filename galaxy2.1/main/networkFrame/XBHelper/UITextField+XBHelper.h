//
//  UITextField+XBHelper.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (XBHelper)

@property (nonatomic,copy) void(^kc_textFieldDidEditToMaxLengthBlock)(UITextField *tf);

@end
