//
//  AddCostClassesController.h
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface AddCostClassesController : RootViewController
@property(nonatomic,strong)NSString *superId;
-(id)initWithType:(NSString *)type;
@end
