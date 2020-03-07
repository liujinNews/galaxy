//
//  UnReadManager.m
//  galaxy
//
//  Created by hfk on 2018/5/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "UnReadManager.h"

#define ISFISTRINSTALL @"ISFISTRINSTALL"

@implementation UnReadManager

+ (instancetype)shareManager{
    static UnReadManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}
- (void)updateUnRead{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:@"ISFISTRINSTALL"] == nil||![NSString isEqualToNull:[userDef objectForKey:@"ISFISTRINSTALL"]]) {
        return;
    }
    [[GPClient shareGPClient]REquestByPostWithPath:GETMESSAGEUNREAD Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){       
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([NSString isEqualToNull:responceDic[@"result"]]) {
                [UIApplication sharedApplication].applicationIconBadgeNumber = [responceDic[@"result"] integerValue];
            }
    
        }
            break;
        default:
            break;
    }
}

//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
  
}

@end
