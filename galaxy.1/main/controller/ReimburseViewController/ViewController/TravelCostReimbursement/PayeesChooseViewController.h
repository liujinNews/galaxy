//
//  PayeesChooseViewController.h
//  galaxy
//
//  Created by hfk on 2018/8/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "ChooseCateFreModel.h"

@interface PayeesChooseViewController : FlowBaseViewController

@property (nonatomic,copy) void(^PayeesChooseBlock)(ChooseCateFreModel *model);

@end
