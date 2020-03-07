//
//  MessageIndexTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MessageIndexTableViewCell.h"

@implementation MessageIndexTableViewCell

-(void)layoutSubviews
{
    if (self.model.Type==1) {
        if ([NSString isEqualToNull:self.model.logo]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:self.model.logo];
            [self.img_TitleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
        }else{
            [self.img_TitleImage setImage:[UIImage imageNamed:@"Message_CompanyLogo"]];
        }
        self.lab_Title.text = [NSString stringWithIdOnNO:self.model.coName];
        self.lab_Content.text = [NSString isEqualToNull:self.model.content]?self.model.content:@"";
    }else{
        [self.img_TitleImage setImage:[UIImage imageNamed:self.model.logo]];
        self.lab_Title.text = self.model.title;
        self.lab_Content.text = [NSString isEqualToNull:self.model.content]?self.model.content:@"";
    }
    self.img_TitleImage.layer.masksToBounds = YES;
    self.img_TitleImage.layer.cornerRadius = 22.0f;
    self.img_TitleImage.layer.borderWidth=1.0;

    if (self.model.Type==1) {
        self.img_TitleImage.layer.borderColor=Color_ImgHead_Circle.CGColor;
    }else{
        self.img_TitleImage.layer.borderColor=[UIColor clearColor].CGColor;
    }

    self.lab_Title.numberOfLines = 1;
    self.lab_Title.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.btn_RedRound.backgroundColor=Color_Red_Message_20;

    if ([self.model.count floatValue]==0) {
        self.btn_RedRound.hidden = YES;
    }else{
        self.btn_RedRound.hidden = NO;
        [self.btn_RedRound setTitle:[NSString stringWithFormat:@"%@",self.model.count] forState:UIControlStateNormal];
        
        NSString *num=[NSString stringWithFormat:@"%@",self.model.count];
        if ([NSString isEqualToNullAndZero:num]) {
            if ([num floatValue]>99) {
                self.RedRoundHeight.constant=22;
                self.RedRoundWidth.constant=32;
                [self.btn_RedRound setTitle:@"99+" forState:UIControlStateNormal];
                self.btn_RedRound.layer.cornerRadius =10;
            }else{
                self.RedRoundHeight.constant=22;
                self.RedRoundWidth.constant=22;
                self.btn_RedRound.layer.cornerRadius =11;
            }
        }
        
        
    }
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.lab_Title.textColor = [XBColorSupport darkColor];
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
