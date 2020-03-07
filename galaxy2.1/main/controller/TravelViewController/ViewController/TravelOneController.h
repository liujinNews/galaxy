//
//  TravelOneOrderController.h
//  galaxy
//
//  Created by APPLE on 2019/12/10.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "TravelCarDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelOneController : RootViewController
@property (nonatomic, strong) TravelCarDetail *model;
@property (nonatomic, copy) NSString *type;// 16 机票 4 酒店 2 火车票 20 用车

@end

NS_ASSUME_NONNULL_END
