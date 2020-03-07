//
//  MySystemNotificationModel.h
//  MyDemo
//
//  Created by tomzhu on 15/6/16.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyModel.h"
#import <ImSDK/ImSDK.h>


/**
 *
 */
@interface MyGroupSystemNotificationModel : MyModel

@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* group;       //群组Id
@property (nonatomic, strong)NSString* user;    //操作人
@property (nonatomic, strong)NSString* msg;     //操作理由
@property (nonatomic, assign)NSInteger type;    //系统消息类型
@property (nonatomic, strong)TIMGroupSystemElem *notifElem;   //TIMmodel

@end
