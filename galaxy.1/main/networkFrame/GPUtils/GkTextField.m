//
//  GkTextField.m
//  galaxy
//
//  Created by hfk on 15/12/18.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "GkTextField.h"

@implementation GkTextField
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:)) {
        return NO;
    }
    if (action == @selector(copy:)) {
        return NO;
    }
    if (action == @selector(cut:)) {
        return NO;
    }
    if (action == @selector(select:)) {
        return NO;
    }
    if (action == @selector(selectAll:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}
@end
