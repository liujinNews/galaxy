//
//  MyBillTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MyBillTableViewCell.h"

@implementation MyBillTableViewCell

-(void)layoutSubviews
{
    _view_backView.layer.shadowOffset = CGSizeMake(0, 1);
    _view_backView.layer.shadowOpacity = 0.25;
    _view_backView.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    _view_backView.layer.shadowOffset = CGSizeMake(2, 2);
    _view_backView.layer.cornerRadius = 15;
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
