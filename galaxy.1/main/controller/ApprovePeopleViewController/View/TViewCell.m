//
//  TViewCell.m
//  galaxy
//
//  Created by 赵碚 on 15/7/31.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "userData.h"
#import "TViewCell.h"

@implementation TViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    return self;
}

- (void)configViewWithCellInfo:(buildCellInfo *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 60)];
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case travelApplyForType:
            if ([[NSString stringWithFormat:@"%@",cellInfo.requestor] isEqualToString:Custing(@"不设置代理人", nil)]) {
                [self configtravelApplyForCellInfoByNo:cellInfo];
            }
            else if ([[NSString stringWithFormat:@"%@",cellInfo.requestor] isEqualToString:Custing(@"全部", nil)]) {
                [self configtravelApplyForCellInfoByAll:cellInfo];
            }
            else
            {
                [self configtravelApplyForCellInfo:cellInfo];
            }
            
            break;
        case messageCenterType:
            [self configMessageCenterCellInfo:cellInfo];
        case travelCostReimburseType:
            break;
        case liveCostReimburseType:
            break;
    }
    
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(X(self.titleLbl), 59.5, Main_Screen_Width-X(self.titleLbl), 0.5)];
    _lineView.backgroundColor=Color_GrayLight_Same_20;
    [self.mainView addSubview:_lineView];
}

-(void)configtravelApplyForCellInfo:(buildCellInfo *)cellInfo{
    UIImageView *arrowView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Message_Man"]];
    arrowView.frame=CGRectMake(39, 8, 39, 39);
    arrowView.layer.masksToBounds = YES;
    arrowView.layer.cornerRadius = 20.0f;
    [self.mainView addSubview:arrowView];
    
    [arrowView setImage:cellInfo.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"]];
    
    NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",cellInfo.photoGraph]];
    if ([dic isKindOfClass:[NSNull class]] || dic == nil|| dic.count == 0||!dic){
        
    }else{
        NSString * photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        [arrowView sd_setImageWithURL:[NSURL URLWithString:photoGraph]];
    }
    
    self.titleLbl = [GPUtils createLable:CGRectMake(88, 0, ScreenRect.size.width-180, 30) text:[GPUtils getSelectResultWithArray:@[cellInfo.requestor,[NSString isEqualToNull:cellInfo.requestorHRID]?[NSString stringWithFormat:@"%@",cellInfo.requestorHRID]:@""] WithCompare:@"/"] font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    self.titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:self.titleLbl];
    NSString *request = @"";
    if (![NSString isEqualToNull:cellInfo.requestor]) {
        request = @"";
    }
    else
    {
        request = cellInfo.requestorDept;
    }
    NSString *job = @"";
    if (![NSString isEqualToNull:cellInfo.jobTitle]) {
        job = @"";
    }
    else
    {
        job = cellInfo.jobTitle;
    }
    if ([job isEqualToString:@""]) {
        job = [NSString stringWithFormat:@"%@",request];
    }
    else
    {
        job = [NSString stringWithFormat:@"%@/%@",request,job ];
    }
    
    UILabel * departmentLa = [GPUtils createLable:CGRectMake(88, 30, ScreenRect.size.width-90, 20) text:job font:Font_cellTime_12 textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
    departmentLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:departmentLa];
    if (![NSString isEqualToNull:cellInfo.requestorDept]) {
        departmentLa.text = @"";
    }
    
    self.chooseImage = [[UIImageView alloc] initWithImage:GPImage(@"MyApprove_UnSelect")];
    [self.chooseImage setHighlightedImage:GPImage(@"MyApprove_Select")];
    self.chooseImage.frame=CGRectMake(10, 20, 20, 20);
    self.chooseImage.highlighted = [cellInfo.isClick isEqualToString:@"1"];
    [self.mainView addSubview:self.chooseImage];
    
}

-(void)configtravelApplyForCellInfoByNo:(buildCellInfo *)cellInfo{
    
    self.titleLbl = [GPUtils createLable:CGRectMake(39, 15, ScreenRect.size.width-180, 30) text:[GPUtils getSelectResultWithArray:@[cellInfo.requestor,[NSString isEqualToNull:cellInfo.requestorHRID]?[NSString stringWithFormat:@"%@",cellInfo.requestorHRID]:@""] WithCompare:@"/"] font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    self.titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:self.titleLbl];
    
    self.chooseImage = [[UIImageView alloc] initWithImage:GPImage(@"MyApprove_UnSelect")];
    [self.chooseImage setHighlightedImage:GPImage(@"MyApprove_Select")];
    self.chooseImage.frame=CGRectMake(10, 20, 20, 20);
    self.chooseImage.highlighted = [cellInfo.isClick isEqualToString:@"1"];
    [self.mainView addSubview:self.chooseImage];
}

-(void)configtravelApplyForCellInfoByAll:(buildCellInfo *)cellInfo{
    
    self.titleLbl = [GPUtils createLable:CGRectMake(39, 15, ScreenRect.size.width-180, 30) text:[GPUtils getSelectResultWithArray:@[cellInfo.requestor,[NSString isEqualToNull:cellInfo.requestorHRID]?[NSString stringWithFormat:@"%@",cellInfo.requestorHRID]:@""] WithCompare:@"/"] font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    self.titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:self.titleLbl];
    
    self.chooseImage = [[UIImageView alloc] initWithImage:GPImage(@"MyApprove_UnSelect")];
    [self.chooseImage setHighlightedImage:GPImage(@"MyApprove_Select")];
    self.chooseImage.frame=CGRectMake(10, 20, 20, 20);
    self.chooseImage.highlighted = [cellInfo.isClick isEqualToString:@"1"];
    [self.mainView addSubview:self.chooseImage];
}

-(void)handleGesture:(UITapGestureRecognizer *)tapGesture{
    
    if ([self.isRemember isEqualToString:unRemember]) {
        self.isRemember = Remember;
        self.chooseImage.image = GPImage(@"MyApprove_UnSelect");
        self.isRememberPwd = Remember;
    }
    else
    {
        self.isRemember = unRemember;
        self.chooseImage.image = GPImage(@"MyApprove_Select");
        self.isRememberPwd = unRemember;
    }
}

-(void)configMessageCenterCellInfo:(buildCellInfo *)cellInfo{
    
    self.titleLbl = [GPUtils createLable:CGRectMake(20, 10, 180, 30) text:@"2000.00" font:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f]textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLbl];
    
    self.detailLbl = [GPUtils createLable:CGRectMake(ScreenRect.size.width - 90, 10, 80, 30) text:@"机票" font:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f]textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.detailLbl];
    
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
