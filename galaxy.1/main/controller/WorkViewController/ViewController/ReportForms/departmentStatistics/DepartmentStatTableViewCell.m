//
//  DepartmentStatTableViewCell.m
//  galaxy
//
//  Created by 赵碚 on 16/6/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "DepartmentStatTableViewCell.h"

@implementation DepartmentStatTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configViewWithMineCellInfo:(departmentStatData *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,[cellInfo.height integerValue])];
    self.mainView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case departmentCellAmount:
            [self configDepartmentCellAmount:cellInfo];
            break;
        case departmentCell:
            [self configDepartmentCell:cellInfo];
            break;
        case departmentCellPerson:
            [self configDepartmentCellPerson:cellInfo];
            break;
        case departmentCellDepart:
            [self configDepartmentCellDepart:cellInfo];
            break;
        case departmentCellCategary:
            [self configDepartmentCellCategary:cellInfo];
            break;
    }
}


//总金额
-(void)configDepartmentCellAmount:(departmentStatData*)cellInfo{
    
    UIView * amountView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    amountView.backgroundColor = Color_ClearBlue_Same_20;
    [self.mainView addSubview:amountView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [amountView addSubview:line];
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(amountView)-30, 55) text:Custing(@"合计", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    amountLa.backgroundColor = [UIColor clearColor];
    [amountView addSubview:amountLa];

    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        amountLa.text = [NSString stringWithFormat:@"%@ %@",Custing(@"合计", nil),[GPUtils transformNsNumber:cellInfo.totalAmount]];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//部门
-(void)configDepartmentCell:(departmentStatData*)cellInfo{
    
    UIView * amountView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 45)];
    amountView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.mainView addSubview:amountView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [amountView addSubview:line];
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-165, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [amountView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.groupName]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.groupName];
    }
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-150, 0, 105, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    amountLa.backgroundColor = [UIColor clearColor];
    [amountView addSubview:amountLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        amountLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15, 15, 15)];
    skipImage.image = GPImage(@"skipImage");
    [amountView addSubview:skipImage];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, Main_Screen_Width, 0.5)];
    line1.backgroundColor = Color_GrayLight_Same_20;
    [amountView addSubview:line1];
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//员工
-(void)configDepartmentCellPerson:(departmentStatData*)cellInfo{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView addSubview:line];


    UIImageView * avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    avatarImage.layer.masksToBounds = YES;
    avatarImage.layer.cornerRadius = 20.0f;
    NSString * genders = [NSString stringWithFormat:@"%@",cellInfo.gender];
    avatarImage.image = GPImage([genders isEqualToString:@"1"] ? @"Message_Woman" : @"Message_Man");
    [self.mainView addSubview:avatarImage];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.photoGraph]]) {
        if ([cellInfo.photoGraph isEqualToString:@"http://10.1.2.17:8081/Content/img/defaultportrait.png"]||[cellInfo.photoGraph isEqualToString:@"https://web.xibaoxiao.com/Content/img/defaultportrait.png"]) {
            
        }else {
            [avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",cellInfo.photoGraph]]];
        }
        
    }

    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(65, 20, Main_Screen_Width-200, 30) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.userDspName]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.userDspName];
    }
    
    UILabel * totalAmountLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-125, 20, 105, 30) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    totalAmountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:totalAmountLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        totalAmountLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];
    }
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, Main_Screen_Width, 0.5)];
    line1.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView addSubview:line1];
}

//按费用类别统计、、、部门
-(void)configDepartmentCellDepart:(departmentStatData*)cellInfo{
    
    UIView * amountView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 45)];
    amountView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.mainView addSubview:amountView];
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-165, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [amountView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.groupName]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.groupName];
    }
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-150, 0, 105, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    amountLa.backgroundColor = [UIColor clearColor];
    [amountView addSubview:amountLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.totalAmount]]) {
        amountLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.totalAmount]];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15, 15, 15)];
    skipImage.image = GPImage(@"skipImage");
    [amountView addSubview:skipImage];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 44.5, Main_Screen_Width-15, 0.5)];
    line1.backgroundColor = Color_GrayLight_Same_20;
    [amountView addSubview:line1];
    
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//按费用类别统计
-(void)configDepartmentCellCategary:(departmentStatData*)cellInfo{
    
    UIView * amountView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 45)];
    amountView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.mainView addSubview:amountView];
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-165, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [amountView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.expenseType]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo.expenseType];
    }
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-150, 0, 105, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    amountLa.backgroundColor = [UIColor clearColor];
    [amountView addSubview:amountLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.amount]]) {
        amountLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo.amount]];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 15, 15, 15)];
    skipImage.image = GPImage(@"skipImage");
    [amountView addSubview:skipImage];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 44.5, Main_Screen_Width-15, 0.5)];
    line1.backgroundColor = Color_GrayLight_Same_20;
    [amountView addSubview:line1];
    
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
