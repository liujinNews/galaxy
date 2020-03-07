//
//  LookOverTimeViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/14.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface LookOverTimeViewController : VoiceBaseController

@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *procId;
@property (nonatomic, strong) NSString *flowGuid;
@property (nonatomic, assign) NSInteger comeStatus;//进入状态

@end
