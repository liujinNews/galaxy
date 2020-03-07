//
//  ExpenseCodeListTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/10/31.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ExpenseCodeListTableViewCell.h"

@implementation ExpenseCodeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.lab_Title.textColor = [XBColorSupport supportLab66Color];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
