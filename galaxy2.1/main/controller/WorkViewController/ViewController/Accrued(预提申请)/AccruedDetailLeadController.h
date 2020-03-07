//
//  AccruedDetailLeadController.h
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccruedDetailLeadController : RootViewController

@property (nonatomic, strong) NSDictionary *dict_parameter;

@property (nonatomic,copy) void(^importDetailBackBlock)(NSMutableArray *array);

@end

NS_ASSUME_NONNULL_END
