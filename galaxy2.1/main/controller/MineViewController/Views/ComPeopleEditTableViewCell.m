//
//  ComPeopleTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ComPeopleEditTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ComPeopleEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews
{
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
//    self.lbl_depa.text =[NSString isEqualToNull:self.model.jobTitle]?self.model.jobTitle:@"暂无职位信息";
    self.lbl_depa.text =[NSString isEqualToNull:self.model.jobTitle]?self.model.jobTitle:@"";
    self.img_rightImage.image = [UIImage imageNamed:@"my_feedback"];
    self.lbl_name.textColor = Color_form_TextField_20;
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
