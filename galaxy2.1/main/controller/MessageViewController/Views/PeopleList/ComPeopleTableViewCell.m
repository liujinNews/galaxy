//
//  ComPeopleTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ComPeopleTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ComPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews
{
    _img_head.hidden = YES;
    if ([FestivalStyle isEqualToString:@"1"]) {
//        _img_head.hidde n = NO;
    }
    if ([NSString isEqualToNull:self.model.groupId]) {
        self.lbl_name.text = self.model.groupName;
    }
    else if ([NSString isEqualToNull:self.model.requestor]) {
        self.lbl_name.text = self.model.requestor;
    }
    else
    {
        self.lbl_name.text = self.model.userDspName;
    }
    if ([[NSString stringWithFormat:@"%@",self.model.isAdmin] isEqualToString:@"1"]) {
        _img_system.hidden = NO;
    }
    self.lbl_depa.text = self.model.jobTitle;
    _img_rightImage.image = [_model.gender intValue]==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
    if ([NSString isEqualToNull:_model.photoGraph]) {
        NSDictionary * dic = (NSDictionary *)[NSString transformToObj:self.model.photoGraph];
        NSString * nicai = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        if ([NSString isEqualToNull:nicai]) {
            [self.img_rightImage sd_setImageWithURL:[NSURL URLWithString:nicai]];
        }
    }
    self.lbl_name.textColor = [XBColorSupport darkColor];
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
