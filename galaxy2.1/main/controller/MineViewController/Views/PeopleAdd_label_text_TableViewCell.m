//
//  PeopleAdd_label_text_TableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PeopleAdd_label_text_TableViewCell.h"

@implementation PeopleAdd_label_text_TableViewCell

-(void)layoutSubviews
{
    if (_dic) {
        if (![_dic[@"title"]isEqualToString:@"姓名"]&&![_dic[@"title"]isEqualToString:@"手机"]&&![_dic[@"title"]isEqualToString:@"邮箱"]) {
            _txf_textField.placeholder = [NSString stringWithFormat:@"请选择%@",_dic[@"title"]];
        }
        else
        {
            _txf_textField.placeholder = [NSString stringWithFormat:@"请输入%@",_dic[@"title"]];
        }
        if ([NSString isEqualToNull:_dic[@"value"]]) {
            _txf_textField.text =_dic[@"value"];
        }
        _lab_lable.text = _dic[@"title"];
        
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
