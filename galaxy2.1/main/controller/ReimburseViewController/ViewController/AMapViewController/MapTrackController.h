//
//  MapTrackController.h
//  galaxy
//
//  Created by hfk on 2017/8/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "RouteModel.h"
@interface MapTrackController : RootViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) RouteModel *model;

@end
