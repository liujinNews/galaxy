//
//  ConfigItem.m
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "ConfigItem.h"

@interface ConfigItem ()

@end

@implementation ConfigItem

- (instancetype)initWithTitle:(NSString *)title itemType:(ItemType)type switchOn:(BOOL)isOn describe:(NSString*)des action:(ConfigCellAction)action{
    if (self = [super init]) {
        if (title) {
            self.title = title;
        }
        if (des) {
            self.describe = des;
        }
        if (action) {
            self.action = action;
        }
        self.switchOn = isOn;
        self.type = type;
        self.isEnable = YES;//默认控件可用
    }
    return self;
}

- (void)ConfigCellAction
{
    if (_action)
    {
        _action(self);
    }
}

@end