//
//  ExpenseListHeadView.m
//  galaxy
//
//  Created by hfk on 2018/5/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ExpenseListHeadView.h"

@implementation ExpenseListHeadView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor=Color_form_TextFieldBackgroundColor;
    if (self){
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,8,Main_Screen_Width-24, 16)];
        _titleLabel.font=Font_Same_12_20 ;
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.textColor=Color_Black_Important_20;
        [self addSubview:_titleLabel];
    }
    return self;
}
- (void)configHeadView{
    _titleLabel.text=Custing(@"最近常用费用类别", nil);
}
@end
