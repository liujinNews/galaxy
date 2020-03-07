//
//  GPRequestPaket.m
//  galaxy
//
//  Created by 赵碚 on 15/7/28.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "GPRequestPaket.h"

@implementation GPRequestPaket

-(id)initWithRequestId:(NSString*)requestId{
    self = [self init];
    if (self) {
        self.parametersDic = [[NSMutableDictionary alloc]init];
        [self.parametersDic setObject:@"FDE55D29E567D879" forKey:@"token"];
        [self.parametersDic setObject:@"0" forKey:@"uid"];
        [self.parametersDic setObject:@"aaaaaa" forKey:@"device"];
        [self.parametersDic setObject:@"ios" forKey:@"source"];
        [self.parametersDic setObject:requestId forKey:@"requestid"];//请求id
    }
    return self;
}

-(void)setDataWithObject:(NSString*)obj forKey:(NSString*)key {
    [self.parametersDic setObject:obj forKey:key];
}

-(void)setRequestId:(NSString *)requestId{
    _requestId = requestId;
    [self.parametersDic setObject:requestId forKey:@"requestid"];
}

@end
