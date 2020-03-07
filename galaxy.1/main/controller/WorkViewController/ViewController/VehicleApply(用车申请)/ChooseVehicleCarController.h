//
//  ChooseVehicleCarController.h
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@interface ChooseVehicleCarController : FlowBaseViewController<GPClientDelegate>

@property (assign, nonatomic)NSInteger totalPages;

@property(nonatomic,assign)BOOL bool_HasManager;

@property(nonatomic,strong)NSString *str_taskId;


@property (nonatomic,copy) void(^chooseCarBlock)(NSDictionary *dict);

@end
