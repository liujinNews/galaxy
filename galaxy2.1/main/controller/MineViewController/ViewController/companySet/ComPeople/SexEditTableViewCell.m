//
//  SexEditTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 15/12/26.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "SexEditTableViewCell.h"

@implementation SexEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.lbl_label.textColor = [XBColorSupport supportLab85Color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
