//
//  MyCollectionHeadView.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MyCollectionHeadView.h"

@implementation MyCollectionHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _stateImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 4, 27)];
        _stateImgView.backgroundColor=Color_Blue_Important_20;
        [self addSubview:_stateImgView];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 18)];
        _titleLabel.center=CGPointMake(X(_stateImgView)+WIDTH(_stateImgView)+111, 13.5);
        _titleLabel.font=Font_Important_15_20 ;
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.textColor=Color_Unsel_TitleColor;
        [self addSubview:_titleLabel];
    }
    return self;
}
-(void)configHeadViewWithTitle:(NSString *)title{
    if ([title isEqualToString:Custing(@"工作", nil)]) {
        _stateImgView.hidden=YES;
        _titleLabel.hidden=YES;
        self.backgroundColor=Color_GrayLight_Same_20;
    }else{
        _stateImgView.hidden=NO;
        _titleLabel.hidden=NO;
        _titleLabel.text=title;
        _stateImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        self.backgroundColor=Color_White_Same_20;
    }
}
@end

