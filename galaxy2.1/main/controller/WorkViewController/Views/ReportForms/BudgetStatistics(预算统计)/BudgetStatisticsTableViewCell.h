//
//  BudgetStatisticsTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/5/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetStatisticsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_header;

@property (weak, nonatomic) IBOutlet UILabel *lab_title;


@property (weak, nonatomic) IBOutlet UILabel *lab_money;


@property (weak, nonatomic) IBOutlet UILabel *lab_Percentage;

@property (weak, nonatomic) IBOutlet UIImageView *img_right;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, assign) int type ;//为了应对多地方引用而分类

@end
