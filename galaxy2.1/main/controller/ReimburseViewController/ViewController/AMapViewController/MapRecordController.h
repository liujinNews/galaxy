//
//  MapRecordController.h
//  galaxy
//
//  Created by hfk on 2017/8/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "RouteModel.h"
#import "RouteDetailView.h"
@interface MapRecordController : RootViewController
@property (nonatomic, strong) RouteModel *model;
@end
