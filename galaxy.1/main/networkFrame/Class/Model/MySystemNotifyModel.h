//
//  MyFriendApplyRecordModel.h
//  MyDemo
//
//  Created by tomzhu on 15/6/24.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyUserModel.h"

typedef NS_ENUM(NSInteger, SystemNotifyType) {
    SNSSystemNotifyType_AddFriend = 101,//添加好友申请
    SNSSystemNotifyType_addFriendReq,   //已添加为好友
    SNSSystemNotifyType_addFriendRefuse,//拒绝
    GroupSystemNotifyType_JoinGroupReq, //加群请求
};

@interface MySystemNotifyModel : MyUserModel
@property (nonatomic, assign)SystemNotifyType notifyType;
@property (nonatomic, strong)NSString *wording;
@property (nonatomic, strong)TIMElem *elem;
@end
