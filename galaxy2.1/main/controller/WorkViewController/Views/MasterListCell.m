//
//  MasterListCell.m
//  galaxy
//
//  Created by hfk on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MasterListCell.h"

@implementation MasterListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    return self;
}
- (void)configViewWithModel:(MasterListModel *)model withStr:(NSString *)Str withType:(NSString *)type{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 45)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (![Str isEqualToString:@""]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 22.5);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }else{
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(25, 22.5);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        [self.mainView addSubview:self.selectImageView];
    }
    
    
    _TypeLabel = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 45) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    //    _TypeLabel.backgroundColor=[UIColor cyanColor];
    if ([type isEqualToString:@"MasterList"]) {
        _TypeLabel.text=[NSString stringWithFormat:@"%@",model.name];
    }
    [self.mainView addSubview:_TypeLabel];
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
