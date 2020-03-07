//
//  UITextField+CloseCope.m
//  galaxy
//
//  Created by 贺一鸣 on 15/12/17.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "UITextField+CloseCope.h"

@implementation UITextField (CloseCope)

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

@end
