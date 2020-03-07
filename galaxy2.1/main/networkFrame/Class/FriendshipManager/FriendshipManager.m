//
//  FriendshipManager.m
//  MyDemo
//
//  Created by tomzhu on 15/6/23.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "FriendshipManager.h"

static FriendshipManager *sharedInstance;

@implementation FriendshipManager

+(instancetype)sharedInstance {
    static dispatch_once_t FriendshipManagerToken;
    
    dispatch_once(&FriendshipManagerToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Friend Operation
- (void)requestFriendList:(NSString *)userName completionHandler:(void (^)(NSArray *, NSString *))handler {
    [[TIMFriendshipManager sharedInstance] GetFriendList:^(NSArray *data) {
        handler([NSArray arrayWithArray:data], nil);
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"TIM request friendList failed: code=%d err=%@", code, err);
        handler(nil, [NSString stringWithFormat:@"code=%d err=%@", code, ERRORCODE_TO_ERRORDEC(code)]);
    }];
}

- (void)addFriend:(NSString *)addFriend byUser:(NSString *)userName applyWord:(NSString *)applyWord completionHandler:(void (^)(NSArray *, NSString *))handler {
    TIMAddFriendRequest *addFriendRequest = [[TIMAddFriendRequest alloc] init];
    addFriendRequest.identifier = addFriend;
    addFriendRequest.remark = @"";
    addFriendRequest.addWording = applyWord;
    NSArray *requestList = @[addFriendRequest];
    [[TIMFriendshipManager sharedInstance] AddFriend:requestList succ:^(NSArray *data) {
        for (TIMFriendResult *res in data) {
            if (res.status == TIM_ADD_FRIEND_STATUS_PENDING) {
                TDDLogEvent(@"TIM add friend pending");
                handler(nil, nil);
            }
            else if (res.status == TIM_FRIEND_STATUS_SUCC) {
                TDDLogEvent(@"TIM add friend succ");
                handler(nil, nil);
            }
            else {
                TDDLogEvent(@"TIM add friend failed: status=%ld", (long)res.status);
                handler(nil, [NSString stringWithFormat:@"code=%ld,err=%@",(long)res.status,ERRORCODE_TO_ERRORDEC(res.status)]);
            }
        }
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"TIM add friend failed: code=%d err=%@", code, err);
        handler(nil, [NSString stringWithFormat:@"code=%d err=%@", code, ERRORCODE_TO_ERRORDEC(code)]);
    }];
}

- (void)delFriend:(NSString *)friendName byUser:(NSString *)userName completionHandler:(void (^)(NSArray *, NSString *))handler {
    NSArray *delFriendList = @[friendName];
    [[TIMFriendshipManager sharedInstance] DelFriend:TIM_FRIEND_DEL_BOTH users:delFriendList succ:^(NSArray *data) {
        TDDLogEvent(@"delFriend successful. delFriend:%@", data);
        handler(nil, nil);
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"delFriend failed. code:%d err:%@", code, err);
        handler(nil, ERRORCODE_TO_ERRORDEC(code));
    }];
}

- (void)search:(NSString *)userName completionHandler:(void (^)(NSDictionary *))handler failHandler:(void (^)(int code, NSString *err)) fail{
    [[TIMFriendshipManager sharedInstance] GetFriendsProfile:@[userName] succ:^(NSArray *data) {
        if (data) {
            TIMUserProfile *friendProfile = [data firstObject];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[friendProfile.identifier] forKeys:@[@"username"]];
            NSDictionary *fakeData = [NSDictionary dictionaryWithObjects:@[userInfo] forKeys:@[userName]];
            handler(fakeData);
        }
        else {
            NSLog(@"code:-1,err:没有搜索到该用户");
        }
    } fail:^(int code, NSString *err) {
        fail(code,ERRORCODE_TO_ERRORDEC(code));
    }];
}

#pragma mark - Black Operation
- (void)requestBlackList:(TIMFriendSucc)succ fail:(TIMFail)fail; {
    [[TIMFriendshipManager sharedInstance] GetBlackList:succ fail:fail];
}

- (void)addBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail {
    [[TIMFriendshipManager sharedInstance] AddBlackList:users succ:succ fail:fail];
}

- (void)delBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail {
    [[TIMFriendshipManager sharedInstance] DelBlackList:users succ:succ fail:fail];
}

- (void) setAllowType:(TIMFriendAllowType)allowType succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMFriendshipManager sharedInstance] SetAllowType:allowType succ:succ fail:fail];
}

- (void)doResponse:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail {
    [[TIMFriendshipManager sharedInstance] DoResponse:users succ:succ fail:fail];
}

#pragma mark - Other Operation
- (void)setNickname:(NSString *)nick succ:(TIMSucc)succ fail:(TIMFail)fail {
    [[TIMFriendshipManager sharedInstance] SetNickname:nick succ:^{} fail:^(int code, NSString *err) {}];
}

@end
