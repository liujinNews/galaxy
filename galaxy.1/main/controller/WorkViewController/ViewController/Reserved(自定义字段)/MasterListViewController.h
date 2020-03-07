//
//  MasterListViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "MyProcurementModel.h"
typedef void(^MasterBlock)(void);
@interface MasterListViewController : FlowBaseViewController
@property(nonatomic,strong)UITextField *aimTextField;
@property(nonatomic,strong)MyProcurementModel *model;
@property (nonatomic, strong) MasterBlock block;

-(id)initWithType:(NSString *)type;
@end
