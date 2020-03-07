//
//  personnalSynTableViewCell.m
//  galaxy
//
//  Created by 赵碚 on 16/5/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "personnalSynTableViewCell.h"

@implementation personnalSynTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//设置员工职位列表
-(void)configPersonnalSynDataCellInfo:(personnalSynData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",cellInfo.photoGraph]];
    NSString * photoGraph;
    if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
        photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
    }
    UIImageView * avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    avatarImage.layer.masksToBounds = YES;
    avatarImage.layer.cornerRadius = 20.0f;
    NSString * genders = [NSString stringWithFormat:@"%@",cellInfo.gender];
    avatarImage.image = GPImage([genders isEqualToString:@"1"] ? @"Message_Woman":@"Message_Man");
    [self.mainView addSubview:avatarImage];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",photoGraph]]) {
        if ([photoGraph isEqualToString:@"http://10.1.2.17:8081/Content/img/defaultportrait.png"]||[photoGraph isEqualToString:@"https://web.xibaoxiao.com/Content/img/defaultportrait.png"]) {
            
        }else {
            [avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoGraph]]];
        }
    }
    
    NSString *request = @"";
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.userDspName]]) {
        request = @"";
    }
    else
    {
        request = [NSString stringWithFormat:@"%@",cellInfo.userDspName];
    }
    
    NSString *job = @"";
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.requestorDept]]) {
        job = @"";
    }
    else
    {
        job = [NSString stringWithFormat:@"%@",cellInfo.requestorDept];
    }
    if ([job isEqualToString:@""]) {
        job = [NSString stringWithFormat:@"%@",request];
    }
    else
    {
        job = [NSString stringWithFormat:@"%@/%@",request,job];
    }
    UILabel * nameLa = [GPUtils createLable:CGRectMake(65, 5, Main_Screen_Width-180, 30) text:job font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    nameLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nameLa];
    
    NSString * cityStr;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.toCity]]) {
        cityStr = [NSString stringWithFormat:@"%@",cellInfo.toCity];
    }else{
        cityStr = @"";
    }
    UILabel * cityLa = [GPUtils createLable:CGRectMake(65, 30, WIDTH(self.mainView)-180, 20) text:cityStr font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    cityLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cityLa];
    /////////////////////////////////////////////////
    NSString * fromdataStr;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.fromDate]]) {
        fromdataStr = [NSString stringWithFormat:@"%@",cellInfo.fromDate];
    }else{
        fromdataStr = @"";
    }
    NSString * todataStr;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.toDate]]) {
        todataStr = [NSString stringWithFormat:@"%@",cellInfo.toDate];
    }else{
        todataStr = @"";
    }
    
    todataStr = [NSString stringWithFormat:@"%@-%@",fromdataStr,todataStr];
    UILabel * timeLa = [GPUtils createLable:CGRectMake(65, 50, Main_Screen_Width-120, 20) text:todataStr font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    timeLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:timeLa];
    
    
    
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-115, 5, 100, 30) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:phoneLa];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.mobile]]) {
        phoneLa.text = [NSString stringWithFormat:@"%@",cellInfo.mobile];
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, 69.5, WIDTH(self.mainView)-30, 0.5)];
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
