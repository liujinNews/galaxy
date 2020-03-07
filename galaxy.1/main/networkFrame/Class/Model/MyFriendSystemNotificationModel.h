//
//  MyFriendSystemNotificationModel.h
//  MyDemo
//
//  Created by tomzhu on 15/6/17.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyModel.h"

@interface MyFriendSystemNotificationModel : MyModel
/**
 * 操作类型
 */
@property(nonatomic,assign) TIM_SNS_SYSTEM_TYPE type;

/**
 * 被操作用户列表：TIMSNSChangeInfo 列表
 */
@property(nonatomic,retain) NSArray * users;

@property (nonatomic, strong)TIMSNSSystemElem *notifElem;   //TIMmodel

@end
