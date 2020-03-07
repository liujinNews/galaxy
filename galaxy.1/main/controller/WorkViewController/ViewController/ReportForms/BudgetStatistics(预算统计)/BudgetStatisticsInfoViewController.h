//
//  BudgetStatisticsInfoViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/5/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface BudgetStatisticsInfoViewController : RootViewController

@property (nonatomic, strong) NSDictionary *Dic;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *year;

@property (nonatomic, strong) NSString *totalAmount;
@property (weak, nonatomic) IBOutlet UITableView *tbv_tableview;

@end
