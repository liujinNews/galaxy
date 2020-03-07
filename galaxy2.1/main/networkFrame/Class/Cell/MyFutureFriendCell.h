//
//  MyRecommendFriendCell.h
//  MyDemo
//
//  Created by wilderliao on 15/9/9.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySearchModel.h"

@class MyFutureFriendModel;

typedef void (^AddBtnAction)(MyFutureFriendModel* futureFriendModel);
typedef void (^AcceptBtnAction)(MyFutureFriendModel* futureFriendModel);

@interface MyFutureFriendCell : UITableViewCell

@property (nonatomic, copy)AddBtnAction addBtnAction;
@property (nonatomic, copy)AcceptBtnAction acceptBtnAction;

- (void)updateModel:(MyFutureFriendModel *)model;

@end
