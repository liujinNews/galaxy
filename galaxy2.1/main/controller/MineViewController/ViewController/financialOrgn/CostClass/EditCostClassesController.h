//
//  EditCostClassesController.h
//  galaxy
//
//  Created by hfk on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "CostClassesModel.h"
@interface EditCostClassesController : RootViewController
-(id)initWithType:(NSString *)type;
@property(nonatomic,strong)CostClassesModel *editModel;
@end
