//
//  MyGroupSearchResultCell.h
//  MyDemo
//
//  Created by tomzhu on 15/6/15.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGroupInfoModel.h"

@class MyUserModel;

typedef void (^JoinBtnAction)(TIMGroupInfo* user);

@interface MyGroupSearchResultCell : UITableViewCell {
    UILabel *_nameLabel;
    UIImageView *_headerFaceView;
    UIView *_bgView;
}

@property (nonatomic, copy)JoinBtnAction addBtnAction;

- (void) updateModel: (TIMGroupInfo*) model;

@end
