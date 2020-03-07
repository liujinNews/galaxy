//
//  TravelRequestsViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface TravelRequestsViewController : VoiceBaseController

@property (nonatomic,assign)NSInteger comeStatus; //进入状态

@property (nonatomic,strong)NSString *taskId;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *procId;
@property (nonatomic, strong) FormBaseModel *FormData;

@end
