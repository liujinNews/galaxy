//
//  UITextField+XBHelper.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "UITextField+XBHelper.h"

static NSString *const KCTextFieldDidEditToMaxLengthBlockKey = @"kc_textFieldDidEditToMaxLengthBlock";

@implementation UITextField (XBHelper)

- (void)setKc_textFieldDidEditToMaxLengthBlock:(void (^)(UITextField *))kc_textFieldDidEditToMaxLengthBlock
{
    objc_setAssociatedObject(self, (__bridge const void *)(KCTextFieldDidEditToMaxLengthBlockKey), kc_textFieldDidEditToMaxLengthBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITextField *))kc_textFieldDidEditToMaxLengthBlock
{
    return objc_getAssociatedObject(self, (__bridge const void *)(KCTextFieldDidEditToMaxLengthBlockKey));
}

- (void)kc_textFieldTextChange
{
    [self deleteBackward];
    !self.kc_textFieldDidEditToMaxLengthBlock ? : self.kc_textFieldDidEditToMaxLengthBlock(self);
}


@end
