//
//  BillBorrowingTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/17.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BillBorrowingTableViewCell.h"

@implementation BillBorrowingTableViewCell

-(void)layoutSubviews
{
    _lab_name.text = _dic[@"operator"];
    _lab_date.text = _dic[@"operatorDate"];
    _lab_content.text = _dic[@"comment"];
    _lab_money.text = [NSString stringWithFormat:@"%@%@",[_dic[@"type"] intValue]==1?@"+":@"-",[GPUtils transformNsNumber:_dic[@"amount"]]];
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
