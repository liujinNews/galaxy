//
//  costCenterCell.m
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "costCenterCell.h"

@implementation costCenterCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//成本中心列表
-(void)configCostCenterCellInfo:(costCenterData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
   
    UILabel * amountLa = [GPUtils createLable:CGRectMake(15, 0, ScreenRect.size.width-30, 49) text:[NSString stringWithFormat:@"%@", cellInfo.costCenter] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([cellInfo.costCenter isEqualToString:@"(null)"]||[cellInfo.costCenter isEqualToString:@"<null>"]||[cellInfo.costCenter isEqualToString:@""]) {
        amountLa.text = @"";
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-15, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)configProcurementTypeCellInfo:(costCenterData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(15, 0, ScreenRect.size.width-30, 49) text:[NSString stringWithFormat:@"%@", cellInfo.type] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([cellInfo.type isEqualToString:@"(null)"]||[cellInfo.type isEqualToString:@"<null>"]||[cellInfo.type isEqualToString:@""]) {
        amountLa.text = @"";
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-15, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
//出差类型
-(void)configTravelTypeTypeCellInfo:(costCenterData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(15, 0, ScreenRect.size.width-30, 49) text:[NSString stringWithFormat:@"%@", cellInfo.travelType] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([cellInfo.travelType isEqualToString:@"(null)"]||[cellInfo.travelType isEqualToString:@"<null>"]||[cellInfo.travelType isEqualToString:@""]) {
        amountLa.text = @"";
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-15, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//财务管理
-(void)configFinancialOrgnTypeCellInfo:(NSArray *)arr WithIndex:(NSInteger)index{
    NSDictionary *titleDic = arr[index];
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 46)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 24, 24)];
    headerbg.image = GPImage([titleDic objectForKey:@"financialImage"]);
    [self.mainView addSubview:headerbg];
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-90, 46) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([NSString isEqualToNull:[titleDic objectForKey:@"financialType"]]) {
        amountLa.text = [titleDic objectForKey:@"financialType"];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    if (index!=arr.count-1) {
        self.line = [[UIView alloc]initWithFrame:CGRectMake(54, 45.5, Main_Screen_Width-69, 0.5)];
        self.line.backgroundColor = Color_GrayLight_Same_20;
        [self.mainView  addSubview:self.line];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//切换公司
-(void)configCompanySwitchCellInfo:(NSDictionary *)titleDic{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 48)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIView * headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    headerLine.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView addSubview:headerLine];
    
    UILabel * geneLbl = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width-50, 46) text:[titleDic objectForKey:@"companyName"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    geneLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:geneLbl];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 47.5, Main_Screen_Width, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//普通员工企业信息
-(void)configNormalCompanyTypeCellInfo:(NSDictionary *)titleDic{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 46)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 22, 22)];
    headerbg.image = GPImage([titleDic objectForKey:@"normalImage"]);
    [self.mainView addSubview:headerbg];
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-90, 46) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([NSString isEqualToNull:[titleDic objectForKey:@"normalType"]]) {
        amountLa.text = [titleDic objectForKey:@"normalType"];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(54, 45.5, Main_Screen_Width-69, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
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
