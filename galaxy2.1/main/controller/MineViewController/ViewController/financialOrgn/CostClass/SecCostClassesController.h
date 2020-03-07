//
//  SecCostClassesController.h
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "CostClassesModel.h"
@interface SecCostClassesController : FlowBaseViewController
@property(nonatomic,strong)CostClassesModel *costModel;

-(id)initWithType:(NSString *)type;
@end
