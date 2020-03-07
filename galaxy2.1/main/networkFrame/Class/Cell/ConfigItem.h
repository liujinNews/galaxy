//
//  ConfigItem.h
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigItemProtocol.h"

@interface ConfigItem : NSObject<ConfigItemProtocol>
{
}

@property (nonatomic, copy) ConfigCellAction action;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *describe;
@property BOOL switchOn;
@property BOOL isEnable;
@property ItemType type;

@end