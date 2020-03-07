//
//  MyGroupSystemNotifyCell.h
//  MyDemo
//
//  Created by tomzhu on 15/7/11.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySystemNotifyModel;

typedef void (^GroupAcceptBtnAction)(MySystemNotifyModel *notifyModel);

@interface MyGroupSystemNotifyCell : UITableViewCell

@property (nonatomic, copy)GroupAcceptBtnAction acceptBtnAction;

- (void)updateModel:(MySystemNotifyModel *)model;

@end
