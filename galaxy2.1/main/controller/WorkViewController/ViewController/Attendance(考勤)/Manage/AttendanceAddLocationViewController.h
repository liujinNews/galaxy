//
//  AttendanceAddLocationViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
//#import <AMapSearch/AMapSearchKit/AMapSearchAPI.h>

typedef void(^AttrndanceAddLocationBlock)(AMapPOI *Poi);

@interface AttendanceAddLocationViewController : VoiceBaseController

@property (nonatomic, copy) AttrndanceAddLocationBlock block;

@end
