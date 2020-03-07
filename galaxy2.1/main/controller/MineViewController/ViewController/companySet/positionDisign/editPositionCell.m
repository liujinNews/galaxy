//
//  editPositionCell.m
//  galaxy
//
//  Created by 赵碚 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "editPositionCell.h"

@implementation editPositionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//设置员工职位列表
-(void)configEditPositionCellInfo:(editPositionData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(15, 0, ScreenRect.size.width-30, 49) text:[NSString stringWithFormat:@"%@", cellInfo.jobTitle] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([cellInfo.jobTitle isEqualToString:@"(null)"]||[cellInfo.jobTitle isEqualToString:@"<null>"]||[cellInfo.jobTitle isEqualToString:@""]) {
        amountLa.text = @"";
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-15, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//设置员工等级列表
-(void)configEditUserLevelCellInfo:(editPositionData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * levelLa = [GPUtils createLable:CGRectMake(15, 0, ScreenRect.size.width/3-15, 49) text:[NSString stringWithFormat:@"%@", cellInfo.userLevel] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    levelLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:levelLa];
    if ([cellInfo.userLevel isEqualToString:@"(null)"]||[cellInfo.userLevel isEqualToString:@"<null>"]||[cellInfo.userLevel isEqualToString:@""]) {
        levelLa.text = @"";
    }
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(ScreenRect.size.width/3, 0, ScreenRect.size.width/3*2-15, 49) text:[NSString stringWithFormat:@"%@", cellInfo.descriptino] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([cellInfo.descriptino isEqualToString:@"(null)"]||[cellInfo.descriptino isEqualToString:@"<null>"]||[cellInfo.descriptino isEqualToString:@""]) {
        amountLa.text = @"";
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
