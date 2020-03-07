//
//  PeopleAdd_lable_btn_TableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PeopleAdd_lable_btn_TableViewCell.h"

@implementation PeopleAdd_lable_btn_TableViewCell


-(void)layoutSubviews
{
    if (_dic) {
        _lbl_label.text = _dic[@"title"];
        if (![NSString isEqualToNull:_dic[@"value"]]) {
            [_btn_buttonClick setTitle:Custing(@"选填", nil) forState:UIControlStateNormal];
            [_btn_buttonClick setTitleColor:Color_cellPlace forState:UIControlStateNormal];
        }
        else
        {
            [_btn_buttonClick setTitle:_dic[@"value"] forState:UIControlStateNormal];
            [_btn_buttonClick setTitleColor:Color_cellContent forState:UIControlStateNormal];
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
