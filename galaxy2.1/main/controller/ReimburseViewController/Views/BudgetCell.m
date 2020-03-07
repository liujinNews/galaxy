//
//  BudgetCell.m
//  galaxy
//
//  Created by hfk on 15/12/24.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "BudgetCell.h"

@implementation BudgetCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configViewWithString:(NSString *)str withCount:(NSInteger)count withIndex:(NSInteger)index
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSLog(@"%@",str);
    self.budgetInfoLab=[GPUtils createLable:CGRectMake(10, 12, Main_Screen_Width-55, 15) text:[NSString stringWithFormat:@"%@",str] font:Font_Important_15_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentLeft];
    //    self.budgetInfoLab.backgroundColor=[UIColor cyanColor];
    self.budgetInfoLab.center=CGPointMake(Main_Screen_Width/2-17.5, 20);
    [self.mainView addSubview:self.budgetInfoLab];
    
    if (index!=count-1) {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenRect.size.width, 1)];
        line.backgroundColor =Color_GrayLight_Same_20;;
        [self.mainView addSubview:line];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
