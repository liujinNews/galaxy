//
//  MyNewFriendCell.h
//  MyDemo
//
//  Created by tomzhu on 15/7/6.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MySystemNotifyModel;

typedef void (^FriendAcceptBtnAction)(NSString *user);

@interface MyNewFriendCell : UITableViewCell

@property (nonatomic, copy)FriendAcceptBtnAction acceptBtnAction;
 
- (void)updateModel:(MySystemNotifyModel *)model;

- (MySystemNotifyModel *)getModel;

@end
