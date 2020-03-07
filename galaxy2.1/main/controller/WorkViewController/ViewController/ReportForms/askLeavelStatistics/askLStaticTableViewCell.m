//
//  askLStaticTableViewCell.m
//  galaxy
//
//  Created by 赵碚 on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "askLStaticTableViewCell.h"

@implementation askLStaticTableViewCell
-(void)layoutSubviews
{
    

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//设置员工职位列表
-(void)configAskLeavelStatisticsDataCellInfo:(NSDictionary *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIImageView * avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    avatarImage.layer.masksToBounds = YES;
    avatarImage.layer.cornerRadius = 20.0f;
    NSString * genders = [NSString stringWithFormat:@"%@",[cellInfo objectForKey:@"gender"]];
    avatarImage.image = GPImage([genders isEqualToString:@"1"] ? @"Message_Woman" : @"Message_Man");
    [self.mainView addSubview:avatarImage];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"_PhotoGraph"]]]) {
        if ([cellInfo[@"_PhotoGraph"] isEqualToString:@"http://10.1.2.17:8081/Content/img/defaultportrait.png"]||[cellInfo[@"_PhotoGraph"] isEqualToString:@"https://web.xibaoxiao.com/Content/img/defaultportrait.png"]) {
            
        }else {
            [avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",cellInfo[@"_PhotoGraph"]]]];
        }
    }

    NSString *request = @"";
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"name"]]]) {
        request = @"";
    }
    else
    {
        request = [NSString stringWithFormat:@"%@",cellInfo[@"name"]];
    }
    
    NSString *job = @"";
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"requestorDept"]]]) {
        job = @"";
    }
    else
    {
        job = [NSString stringWithFormat:@"%@",cellInfo[@"requestorDept"]];
    }
    if ([job isEqualToString:@""]) {
        job = [NSString stringWithFormat:@"%@",request];
    }
    else
    {
        job = [NSString stringWithFormat:@"%@/%@",request,job];
    }
    UILabel * nameLa = [GPUtils createLable:CGRectMake(65, 15, Main_Screen_Width-130, 40) text:job font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-85, 15, 70, 40) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"qty"]]]) {
        double strss = [[NSString stringWithFormat:@"%@",cellInfo[@"qty"]] doubleValue];
        phoneLa.text = [NSString stringWithFormat:@"%.1f",strss];
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, 69, WIDTH(self.mainView)-30, 1)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//设置员工职位列表
-(void)configAskLeavelStatisticsClassDataCellInfo:(NSDictionary *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSString *request = @"";
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"name"]]]) {
        request = @"";
    }
    else
    {
        request = [NSString stringWithFormat:@"%@",cellInfo[@"name"]];
    }
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 10, Main_Screen_Width-100, 29) text:request font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-85, 10, 70, 29) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"qty"]]]) {
        phoneLa.text = [NSString stringWithFormat:@"%@",cellInfo[@"qty"]];
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, 48.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


//设置预算统计（预算类别（0：成本中心，1：费用类别，2：成本中心&费用类别））
-(void)configBudgetStaticClassDataCellInfo:(NSDictionary *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 68)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(15, 10, Main_Screen_Width-120, 24) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"expenseType"]]]) {
        nameLa.text = [NSString stringWithFormat:@"%@",cellInfo[@"expenseType"]];
    }
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(15, 35, Main_Screen_Width-120, 20) text:@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"amount"]]]) {
        phoneLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:cellInfo[@"amount"]]];
    }
    
    UILabel * percentLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-105, 22, 70, 24) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    percentLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:percentLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo[@"percent"]]]) {
        percentLa.text = [NSString stringWithFormat:@"%@",cellInfo[@"percent"]];
    }
    
    
    self.skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 24, 20, 20)];
    _skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:_skipImage];
    
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
