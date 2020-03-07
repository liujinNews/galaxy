//
//  PayMentDetailLeadController.h
//  galaxy
//
//  Created by hfk on 2019/6/21.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayMentDetailLeadController : RootViewController

@property (nonatomic, strong) NSDictionary *dict_parameter;

@property (nonatomic,copy) void(^importDetailBackBlock)(NSMutableArray *array);

@end

NS_ASSUME_NONNULL_END
