//
//  PowerSettingCell.m
//  galaxy
//
//  Created by hfk on 16/5/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PowerSettingCell.h"

@implementation PowerSettingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configViewWithModel:(PowerSettingModel *)model withIndex:(NSInteger)index{
    NSInteger rowHeight;
    if ([NSString isEqualToNull:model.Description]) {
        NSString *str=model.Description;
        //        str=[str stringByReplacingOccurrencesOfString:@"\n" withString:@","];
        CGSize size = [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-180, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        rowHeight=30+size.height;
    }else{
        rowHeight=60;
    }
    [self.mainView removeFromSuperview];
    
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, rowHeight)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    if ([NSString isEqualToNull:model.roleName]) {
        self.roleNameLabel=[GPUtils createLable:CGRectMake(15,5,100, rowHeight - 10) text:model.roleName font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
//        self.roleNameLabel.center=CGPointMake(65,rowHeight/2);
        self.roleNameLabel.numberOfLines = 0;
//        self.roleNameLabel.backgroundColor=[UIColor cyanColor];
        [self.mainView addSubview:self.roleNameLabel];
    }
    
    if ([NSString isEqualToNull:model.Description]) {
        NSString *str=model.Description;
        self.DescriptionLabel=[GPUtils createLable:CGRectMake(0,0, Main_Screen_Width-180, 14) text:str font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        self.DescriptionLabel.numberOfLines=0;
        CGSize size = [str sizeCalculateWithFont:self.DescriptionLabel.font constrainedToSize:CGSizeMake(self.DescriptionLabel.frame.size.width, 10000) lineBreakMode:self.DescriptionLabel.lineBreakMode];
        self.DescriptionLabel.frame = CGRectMake(0,0,Main_Screen_Width-180,size.height);
        self.DescriptionLabel.center=CGPointMake(45+Main_Screen_Width/2, rowHeight/2);
        self.DescriptionLabel.text=str;
//                self.DescriptionLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:self.DescriptionLabel];
    }
    
    UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
    iconImage.frame = CGRectMake(0,0, 20, 20);
    iconImage.center=CGPointMake(Main_Screen_Width-25, rowHeight/2);
    [self.mainView addSubview:iconImage];
    
}
//MARK:cell删除背景的线
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            subview.backgroundColor=Color_Sideslip_TableView;
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
