//
//  BillPayViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/5/17.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface BillPayViewController : RootViewController

@property (weak, nonatomic) IBOutlet UILabel *lab_date;

@property (weak, nonatomic) IBOutlet UILabel *lab_cound;

@property (weak, nonatomic) IBOutlet UITableView *tbv_contenttebleview;

@property (weak, nonatomic) IBOutlet UILabel *lab_amound;

@end
