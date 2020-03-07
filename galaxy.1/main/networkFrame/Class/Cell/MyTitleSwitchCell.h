//
//  MyTitleSwitchCell.h
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ConfigItem;

@interface MyTitleSwitchCell : UITableViewCell

@property (nonatomic,strong) UISwitch *mySwitch;

@property (nonatomic, weak) ConfigItem *item;

- (void)config:(ConfigItem *)item;
@end
