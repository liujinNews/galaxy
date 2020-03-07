//
//  projectCostTViewCell.m
//  galaxy
//
//  Created by 赵碚 on 16/6/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "projectCostTViewCell.h"

@implementation projectCostTViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//员工费用统计
-(void)configPersonnelStatCellInfo:(PersonnelStatData *)cellInfo{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 45)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-165, 45) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.requestor]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.requestor];
    }
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-150, 0, 105, 45) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        phoneLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];
        
    }
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15, 15, 15)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//项目
-(void)configProjectCostDataCellInfo:(NSDictionary *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 45)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-125, 45) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"name"]]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo[@"name"]];
    }
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-120, 0, 105, 45) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"qty"]]]) {
        phoneLa.text = [NSString stringWithFormat:@"%@",cellInfo[@"qty"]];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//项目费用统计
-(void)configProjectStatDataCellInfo:(PersonnelStatData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 45)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-125, 45) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.projName]]) {
        nameLa.frame = CGRectMake(15, 0, Main_Screen_Width-165, 45);
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.projName];
    }
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-120, 0, 105, 45) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15, 15, 15)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        phoneLa.frame = CGRectMake(Main_Screen_Width-150, 0, 105, 45);
        phoneLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];
        
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//ZF项目费用统计
-(void)configZFProjectStatDataCellInfo:(PersonnelStatData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-165, 35) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.projName]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.projName];
    }
    
    UILabel * entityLa = [GPUtils createLable:CGRectMake(15, 35, Main_Screen_Width-165, 25) text:@"" font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    entityLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:entityLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.descriptino]]) {
        entityLa.text = [NSString stringWithFormat:@"%@",cellInfo.descriptino];
    }
    
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-150, 0, 105, 70) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        phoneLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];
    }
    
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 27.5, 15, 15)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


//员工费用统计类别
-(void)configPersonnelCostCategoryDataCellInfo:(PersonnelStatData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIImageView * cateImate = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    NSString * cateImagge = [NSString stringWithFormat:@"%@",cellInfo.expenseIcon];
    cateImate.image = [UIImage imageNamed:cateImagge];
    cateImate.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateImate];
    
    
    UILabel * cateName = [GPUtils createLable:CGRectMake(70, 10, Main_Screen_Width-200, 29) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    cateName.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateName];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.expenseType]]) {
        cateName.text = [NSString stringWithFormat:@"%@",cellInfo.expenseType];
    }
    
    
    UILabel * cateTime = [GPUtils createLable:CGRectMake(70, 39, Main_Screen_Width-200, 20) text:@"" font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    cateTime.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateTime];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.expenseDate]]) {
        cateTime.text = [NSString stringWithFormat:@"%@",cellInfo.expenseDate];
    }
    
    UILabel * cateAmount = [GPUtils createLable:CGRectMake(Main_Screen_Width-120, 20, 105, 30) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    cateAmount.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateAmount];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        if ([[NSString stringWithFormat:@"%@",cellInfo.totalAmount] isEqualToString:@"0"]) {
            cateAmount.text = @"0";
        }else{
            cateAmount.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];
            
        }
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


//项目费用统计类别
-(void)configProjectCostCategoryDataCellInfo:(PersonnelStatData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIImageView * cateImate = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    NSString * cateImagge = [NSString stringWithFormat:@"%@",cellInfo.expenseIcon];
    cateImate.image = [UIImage imageNamed:cateImagge];
    cateImate.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateImate];
    
    
    UILabel * cateName = [GPUtils createLable:CGRectMake(70, 10, Main_Screen_Width-200, 29) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    cateName.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateName];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.expenseType]]) {
        cateName.text = [NSString stringWithFormat:@"%@",cellInfo.expenseType];
    }

    
    UILabel * cateTime = [GPUtils createLable:CGRectMake(70, 39, Main_Screen_Width-200, 20) text:@"" font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    cateTime.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateTime];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.expenseDate]]) {
        cateTime.text = [NSString stringWithFormat:@"%@",cellInfo.expenseDate];
    }
    
    UILabel * cateAmount = [GPUtils createLable:CGRectMake(Main_Screen_Width-120, 10, 105, 29) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    cateAmount.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateAmount];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        if ([[NSString stringWithFormat:@"%@",cellInfo.totalAmount] isEqualToString:@"0"]) {
           cateAmount.text = @"0";
        }else{
            cateAmount.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];

        }
    }
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-120, 39, 105, 20) text:@"" font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.requestor]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.requestor];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//部门员工费用统计类别
-(void)configDepartmentCategoryDataCellInfo:(PersonnelStatData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIImageView * cateImate = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    NSString * cateImagge = [NSString stringWithFormat:@"%@",cellInfo.expenseIcon];
    cateImate.image = [UIImage imageNamed:cateImagge];
    cateImate.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateImate];
    
    
    UILabel * cateName = [GPUtils createLable:CGRectMake(70, 10, Main_Screen_Width-200, 29) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    cateName.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateName];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.expenseType]]) {
        cateName.text = [NSString stringWithFormat:@"%@",cellInfo.expenseType];
    }
    
    
    UILabel * cateTime = [GPUtils createLable:CGRectMake(70, 39, Main_Screen_Width-200, 20) text:@"" font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    cateTime.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateTime];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.expenseDate]]) {
        cateTime.text = [NSString stringWithFormat:@"%@",cellInfo.expenseDate];
    }
    
    UILabel * cateAmount = [GPUtils createLable:CGRectMake(Main_Screen_Width-120, 20, 105, 30) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    cateAmount.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cateAmount];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.amount]]) {
        if ([[NSString stringWithFormat:@"%@",cellInfo.amount] isEqualToString:@"0"]) {
            cateAmount.text = @"0";
        }else{
            cateAmount.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.amount]];
            
        }
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
