//
//  editCompanyCell.m
//  galaxy
//
//  Created by 赵碚 on 15/12/24.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "editCompanyCell.h"

@implementation editCompanyCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    return self;
}


- (void)configIndustryViewWithCellInfo:(editCompanyData *)model sting:(NSString *)str{
    
    NSInteger height;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.industry]]) {
        CGSize size = [model.industry sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        height = 30+size.height;
    }else{
        height = 49;
    }
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, height)];
    [self.contentView addSubview:self.mainView];
    
    self.industryLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(self.mainView)-50, height) text:[NSString stringWithFormat:@"%@",model.industry] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.industryLa];
    self.industryLa.numberOfLines = 0;
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15.5, 18, 18)];
    skipImage.image = GPImage(@"MyApprove_Select");
    [self.mainView addSubview:skipImage];
    if ([[NSString stringWithFormat:@"%@",model.industry] isEqualToString:str]) {
        skipImage.hidden = NO;
    }else{
        skipImage.hidden = YES;
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:line];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
}

- (void)configCoscaleViewWithCellInfo:(editCompanyData *)model sting:(NSString *)str{
    NSInteger height;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.scale]]) {
        CGSize size = [model.scale sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        height = 30+size.height;
    }else{
        height = 49;
    }
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, height)];
    [self.contentView addSubview:self.mainView];
    
    self.industryLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(self.mainView)-50, height) text:[NSString stringWithFormat:@"%@",model.scale] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.industryLa];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15.5, 18, 18)];
    skipImage.image = GPImage(@"MyApprove_Select");
    [self.mainView addSubview:skipImage];
    if ([[NSString stringWithFormat:@"%@",model.scale] isEqualToString:str]) {
        skipImage.hidden = NO;
    }else{
        skipImage.hidden = YES;
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:line];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)configLocationViewWithCellInfo:(editCompanyData *)model sting:(NSString *)str{
    NSInteger height;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.provinceName]]) {
        CGSize size = [model.provinceName sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        height = 30+size.height;
    }else{
        height = 49;
    }
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, height)];
    [self.contentView addSubview:self.mainView];
    
    self.industryLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(self.mainView)-50, height) text:[NSString stringWithFormat:@"%@",model.provinceName] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.industryLa];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15.5, 18, 18)];
    skipImage.image = GPImage(@"MyApprove_Select");
    [self.mainView addSubview:skipImage];
    
    if ([[NSString stringWithFormat:@"%@",model.provinceName] isEqualToString:str]) {
        skipImage.hidden = NO;
    }else{
        skipImage.hidden = YES;
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:line];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
