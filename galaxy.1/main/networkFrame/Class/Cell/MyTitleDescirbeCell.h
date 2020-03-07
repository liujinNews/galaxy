//
//  MyTitleDescirbeCell.h
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigItem.h"
//nameLable = [[UILabel alloc] init];
//            nameLable.text = [GlobalData shareInstance].me;
//            [nameLable setFont:[UIFont systemFontOfSize:15]];
//            nameLable.bounds = CGRectMake(0, 0, 200, 30);
//            nameLable.textAlignment = NSTextAlignmentRight;
//            cell.accessoryView = nameLable;
//            cell.textLabel.text = @"ID";
@interface MyTitleDescirbeCell : UITableViewCell

@property (nonatomic, weak) ConfigItem *item;

- (void)config:(ConfigItem *)item;
@end
