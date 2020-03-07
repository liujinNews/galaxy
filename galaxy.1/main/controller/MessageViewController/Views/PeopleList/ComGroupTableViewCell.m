//
//  ComGroupTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ComGroupTableViewCell.h"

@implementation ComGroupTableViewCell

-(void)layoutSubviews
{
    if ([NSString isEqualToNull:self.model.groupId]) {
        self.lbl_name.text = self.model.groupName;
    }
    else
    {
        self.lbl_name.text = self.model.userDspName;
//        self.img_image.hidden = YES;
    }
    if ([NSString isEqualToNull:_model.mbrs]) {
        _lab_Number.text = [NSString stringWithFormat:@"(%@)",_model.mbrs];
    }
    else
    {
        _lab_Number.text = @"(0)";
    }
    self.lbl_name.textColor = [XBColorSupport darkColor];
    self.lab_Number.textColor = [XBColorSupport lightDarkColor];
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
}

@end
