//
//  AttendanceSelectWeekViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
typedef void(^AttendanceSelectWeekBlock)(NSMutableArray *arr,NSString *week);
@interface AttendanceSelectWeekViewController : VoiceBaseController

@property (nonatomic, strong) AttendanceSelectWeekBlock block;
@property (nonatomic, strong) NSMutableArray *muarr_return;

@end
