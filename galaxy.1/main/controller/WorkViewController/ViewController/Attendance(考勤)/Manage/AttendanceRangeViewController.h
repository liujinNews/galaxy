//
//  AttendanceRangeViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
typedef void(^AttendanceRangeBlock)(NSString *str_return);
@interface AttendanceRangeViewController : VoiceBaseController

@property (nonatomic, strong) NSString *str_return;
@property (nonatomic, strong) AttendanceRangeBlock block;
@end
