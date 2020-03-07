//
//  LookTravelRequestsViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "PayMentDetailController.h"
#import "MyApplyModel.h"
@interface LookTravelRequestsViewController : VoiceBaseController

@property (nonatomic,strong)NSString *taskId;
@property (nonatomic,strong)NSString *procId;
@property (nonatomic,strong)NSString *flowCode;
@property (nonatomic,strong)NSString *userId;
//1没有按钮 2 有撤回按钮 3三个按钮 4 支付
@property (nonatomic,assign)NSInteger comeStatus;//进入状态

@property (nonatomic, strong) FormBaseModel *FormData;

@end
