//
//  AFSessionSingleton.m
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "AFSessionSingleton.h"

@implementation AFSessionSingleton

static AFHTTPSessionManager *_manager = nil;;
//static dispatch_once_t onceToken;

+(AFHTTPSessionManager *)shareManager {
//    dispatch_once(&onceToken, ^{
        _manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
        _manager.requestSerializer.timeoutInterval = 10.0;
//    });
    return _manager;
}

+ (id)changeJsonClient{
    _manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
    _manager.requestSerializer.timeoutInterval = 10.0;
    return _manager;
}

//  文件传输
+(AFHTTPSessionManager *)shareFileManager{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[NSObject fileUrlStr]]];
        _manager.requestSerializer.timeoutInterval = 10.0;
//    });
    return _manager;
}


@end

