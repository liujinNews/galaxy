//
//  addTravelAndDayCateryCell.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "addTravelAndDayCateryCell.h"

@implementation addTravelAndDayCateryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//费用类别（差旅费、日常费添加左侧显示）
-(void)configAddTravelAndDayCateryCellInfo:(addTravelAndDayCateryData *)cellInfo withSelect:(BOOL)select{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 98, 49)];
    self.mainView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.mainView];
    
    
    self.expenseLa = [GPUtils createLable:CGRectMake(10, 0, 88, 49) text:[NSString stringWithFormat:@"%@", cellInfo.ExpenseType] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    self.expenseLa.backgroundColor = [UIColor clearColor];
    self.expenseLa.numberOfLines = 0;
    [self.mainView addSubview:self.expenseLa];
    
    UIView * houLine = [[UIView alloc] initWithFrame:CGRectMake(97.5, 0, 0.5, 49)];
    houLine.backgroundColor = [GPUtils colorHString:@"#e6e6e6"];
    [self.mainView addSubview:houLine];
    
    UIView * diLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5, 98, 0.5)];
    diLine.backgroundColor = [GPUtils colorHString:@"#e6e6e6"];
    [self.mainView addSubview:diLine];
    
    UIView * mage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2.5, 49)];
    [self.mainView addSubview:mage];
    
    if (select) {
        houLine.hidden = YES;
        self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.expenseLa.textColor = Color_Blue_Important_20;
        mage.backgroundColor = Color_Blue_Important_20;
    }
}

//费用类别（差旅费、日常费）
-(void)configTravelAndDayCateryCellInfo:(addTravelAndDayCateryData *)cellInfo {
    [self.mainView removeFromSuperview];
    NSInteger heghts = 58 + cellInfo.sizes.height;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, heghts)];
    self.mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.mainView];
    
    UIView * mage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2.5, 25)];
    mage.backgroundColor = Color_Blue_Important_20;
    [self.mainView addSubview:mage];
    
    self.expenseLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width - 30, 25) text:[NSString stringWithFormat:@"%@", cellInfo.ExpenseType] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    self.expenseLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:self.expenseLa];
    
    UIView * cateView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, Main_Screen_Width, cellInfo.sizes.height + 33)];
    cateView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.mainView addSubview:cateView];
    
    
    UILabel * cateLa = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width - 30, cellInfo.sizes.height + 31) text:[cellInfo.expenstr substringFromIndex:3] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    cateLa.numberOfLines = 0;
    cateLa.backgroundColor = [UIColor clearColor];
    [cateView addSubview:cateLa];
    
    UIView * lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    lineV1.backgroundColor = Color_GrayLight_Same_20;
    [cateView addSubview:lineV1];
    
    UIView * lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, cellInfo.sizes.height + 32.5, Main_Screen_Width, 0.5)];
    lineV2.backgroundColor = Color_GrayLight_Same_20;
    [cateView addSubview:lineV2];
    
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
