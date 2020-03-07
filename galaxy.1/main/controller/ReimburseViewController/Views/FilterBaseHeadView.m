//
//  FilterBaseHeadView.m
//  galaxy
//
//  Created by hfk on 16/8/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FilterBaseHeadView.h"

@implementation FilterBaseHeadView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor=Color_form_TextFieldBackgroundColor;
    if (self){
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,8,100, 16)];
        _titleLabel.font=Font_Same_14_20 ;
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.textColor=Color_GrayDark_Same_20;
        [self addSubview:_titleLabel];
    }
    return self;
}
- (void)configHeadViewWith:(NSInteger)index withArray:(NSArray *)arr
{
    _titleLabel.text=arr[index];
}

@end
