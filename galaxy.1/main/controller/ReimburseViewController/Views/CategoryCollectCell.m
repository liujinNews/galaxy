//
//  CategoryCollectCell.m
//  galaxy
//
//  Created by hfk on 16/4/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CategoryCollectCell.h"

@implementation CategoryCollectCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=Color_White_Same_20;
    }
    return self;
}
-(void)configWithArray:(NSMutableArray *)dateArray withRow:(NSInteger)row{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width/5, 65)];
    self.mainView.center=self.contentView.center;
        self.mainView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:self.mainView];
    
    CostCateNewModel *model=dateArray[row];
    self.CategoryImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    self.CategoryImgView.center=CGPointMake(Main_Screen_Width/10, 18);
    self.CategoryImgView.image=[UIImage imageNamed:model.expenseIcon];
    [self.mainView addSubview:self.CategoryImgView];
    
    self.CateTitleLabel=[GPUtils createLable:CGRectMake(5, 39, Main_Screen_Width/5-10, 24) text:nil font:Font_Same_10_20 textColor:Color_GrayDark_Same_20  textAlignment:NSTextAlignmentCenter];
    self.CateTitleLabel.numberOfLines=2;
    if ([NSString isEqualToNull:model.expenseType]) {
        self.CateTitleLabel.text=model.expenseType;
    }
    [self.mainView addSubview:self.CateTitleLabel];
}
@end
