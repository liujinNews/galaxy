//
//  BudgetStatisticsTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BudgetStatisticsTableViewCell.h"

@implementation BudgetStatisticsTableViewCell


-(void)layoutSubviews
{
    if ([NSString isEqualToNull:_dic[@"expenseIcon"]]) {
        _img_header.image = [UIImage imageNamed:_dic[@"expenseIcon"]];
    }
    if (_type == 1) {
        _lab_money.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:_dic[@"totalAmount"]]];
        _lab_title.text = [NSString stringWithFormat:@"%@",_dic[@"expenseType"]];
        _lab_Percentage.text = [NSString stringWithFormat:@"%@",_dic[@"percent"]];
    }
    else if(_type ==3)
    {
        _lab_money.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:_dic[@"amount"]]];
        _lab_title.text = [NSString stringWithFormat:@"%@",_dic[@"expenseType"]];
        _lab_Percentage.text = [NSString stringWithFormat:@"%@",_dic[@"ratio"]];
    }
    else
    {
        _lab_money.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:_dic[@"amount"]]];
        _lab_title.text = [NSString stringWithFormat:@"%@",_dic[@"expenseType"]];
        if ([NSString isEqualToNull:_dic[@"percent"]]) {
            _lab_Percentage.text = [NSString stringWithFormat:@"%@",_dic[@"percent"]];
        }
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
