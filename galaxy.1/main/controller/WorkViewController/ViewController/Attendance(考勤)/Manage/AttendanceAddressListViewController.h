//
//  AttendanceAddressListViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
typedef void(^AttendanceAddressListViewBlock)(NSMutableArray *arr);
@interface AttendanceAddressListViewController : VoiceBaseController

@property (nonatomic, strong) NSMutableArray *muarr_return;
@property (nonatomic, strong) AttendanceAddressListViewBlock block;

@end
