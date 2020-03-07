//
//  AFSessionSingleton.h
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFSessionSingleton : AFHTTPSessionManager
/**
 *  单利方法
 *  @return 实例对象
 */
+(AFHTTPSessionManager*)shareManager;

+ (id)changeJsonClient;

//喜报文件传输
+(AFHTTPSessionManager*)shareFileManager;
@end
