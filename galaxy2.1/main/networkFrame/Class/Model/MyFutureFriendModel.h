//
//  MyFutureFriendModel.h
//  MyDemo
//
//  Created by wilderliao on 15/9/10.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyUserModel.h"

typedef NS_ENUM(NSInteger, FutureFriendType) {
    FUTURE_FRIEND_PENDENCY_IN_TYPE = 0x1,   //收到的未决请求   "同意"
    FUTURE_FRIEND_PENDENCY_OUT_TYPE = 0x2,  //发出去的未决请求 “等待验证”
    FUTURE_FRIEND_RECOMMEND_TYPE = 0x4,     //推荐好友        “添加”
    FUTURE_FRIEND_RECOMMEND_ADDED = 0x8     //已决好友        “此时删除Cell”
};

@interface MyFutureFriendModel : MyUserModel

@property (nonatomic, strong)NSString *remarkInfo;
@property (nonatomic, assign)FutureFriendType futureFriendType;

@end
