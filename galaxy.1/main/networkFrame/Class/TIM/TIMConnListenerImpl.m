//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TIMConnListenerImpl.h"
#import "GlobalData.h"
#import "MyCommOperation.h"
#import "AccountHelper.h"

@implementation TIMConnListenerImpl

/**
 *  连接成功
 */
- (void)onConnSucc{
    TDDLogEvent(@"connect Failed");
    if ([GlobalData shareInstance].isLogined && [GlobalData shareInstance].connStatus == ConnStatusDisConnected) {
        //重新刷新好友列表，群列表
        [[MyCommOperation shareInstance] requestFriendList];
        [[MyCommOperation shareInstance] requestGroupList];
        [[MyCommOperation shareInstance] requestBlackList];
    }
    
//    [GlobalData shareInstance].preConnStatus = [GlobalData shareInstance].connStatus;
    [GlobalData shareInstance].connStatus = ConnStatusConnected;
    
}
/**
 *  连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err{
    TDDLogEvent(@"connect Failed");
    //重新到登录页面？
}

/**
 *  连接断开
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err{
//    [GlobalData shareInstance].preConnStatus = [GlobalData shareInstance].connStatus;
    [GlobalData shareInstance].connStatus = ConnStatusDisConnected;
}

@end
