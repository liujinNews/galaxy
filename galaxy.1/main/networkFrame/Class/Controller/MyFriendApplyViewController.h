//
//  MyNewFriendsCellViewController.h
//  MyDemo
//
//  Created by wilderliao on 15/8/28.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySystemNotifyModel.h"
#import "MyChatViewController.h"

@protocol MyFriendApplyViewControllerDelegate <NSObject>

- (void)reloadData;
 
@end

@interface MyFriendApplyViewController : UIViewController

@property (nonatomic, weak)id<MyFriendApplyViewControllerDelegate> delegate;

- (void)initModel:(MySystemNotifyModel *)model;

@end