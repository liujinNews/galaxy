//
//  MyChatVideoCell.h
//  MyDemo
//
//  Created by tomzhu on 15/12/8.
//  Copyright © 2015年 sofawang. All rights reserved.
//

#import "MyChatBaseCell.h"
@class MyMsgVideoModel;

@interface MyChatVideoCell : MyChatBaseCell

@property(nonatomic, strong) id delegate;

+ (CGFloat)heightForModel:(MyMsgVideoModel*)model;

@end
