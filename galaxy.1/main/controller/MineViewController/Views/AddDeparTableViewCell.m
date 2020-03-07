//
//  AddDeparTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "AddDeparTableViewCell.h"

@implementation AddDeparTableViewCell

-(void)layoutSubviews
{
    if (_dic) {
//        if (![_dic[@"title"]isEqualToString:@"姓名"]&&![_dic[@"title"]isEqualToString:@"手机"]&&![_dic[@"title"]isEqualToString:@"部门"]) {
//            _txf_textField.placeholder = @"选填";
//        }
        if ([NSString isEqualToNull:_dic[@"value"]]&&[_dic[@"value"]intValue]!=0&&[_dic[@"value"]intValue]!=1) {
            _txf_textfield.text =_dic[@"value"];
        }
        if ([NSString isEqualToNull:_dic[@"title"]]&&[_dic[@"title"]isEqualToString:Custing(@"上级部门：", nil)]) {
            _txf_textfield.text =_dic[@"value"];
        }
        _lab_label.text = _dic[@"title"];
    }
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.lab_label.textColor = Color_form_TextField_20;
    self.imgView.backgroundColor = [XBColorSupport supportImgView242Color];
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
