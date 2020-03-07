//
//  FriendshipManager.h
//  MyDemo
//
//  Created by tomzhu on 15/6/23.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

@interface FriendshipManager : NSObject

+(instancetype)sharedInstance ;

- (void)requestFriendList:(NSString*)userName completionHandler:(void (^)(NSArray*, NSString* error)) handler;

- (void)addFriend:(NSString*)addFriend byUser:(NSString *)userName applyWord:(NSString *)applyWord completionHandler:(void (^)(NSArray*, NSString* error)) handler;

- (void)delFriend:(NSString *)friendName byUser:(NSString *)userName completionHandler:(void (^)(NSArray*, NSString* error)) handler;

- (void)search:(NSString*)userName completionHandler:(void (^)(NSDictionary* data)) handler failHandler:(void (^)(int code, NSString *err)) fail;

- (void)requestBlackList:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)addBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)delBlackList:(NSArray*) users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)setAllowType:(TIMFriendAllowType)allowType succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)doResponse:(NSArray*)users succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

@end
