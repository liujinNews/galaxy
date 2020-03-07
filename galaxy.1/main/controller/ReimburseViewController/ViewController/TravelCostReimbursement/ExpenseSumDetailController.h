//
//  ExpenseSumDetailController.h
//  galaxy
//
//  Created by hfk on 2018/4/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface ExpenseSumDetailController : RootViewController

@property (nonatomic,copy)NSString *TaskId;
@property (nonatomic,copy)NSString *ExpenseCat;
@property (nonatomic,copy)NSString *ExpenseType;
@property (nonatomic,copy)NSString *FlowCode;
@property (nonatomic,copy)NSString *str_TotalAmount;
@property (nonatomic,copy)NSString *str_UserId;
@property (nonatomic,copy)NSString *str_OwerId;
@property (nonatomic,copy)NSString *str_ProcId;
@property (nonatomic,copy)NSString *str_FlowGuid;


@end
