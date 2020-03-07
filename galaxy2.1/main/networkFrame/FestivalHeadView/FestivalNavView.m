//
//  FestivalNavView.m
//  galaxy
//
//  Created by hfk on 2016/12/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FestivalNavView.h"
@interface FestivalNavView()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *leftBt;
@property(nonatomic,strong)UIButton *rightBt;

@end
@implementation FestivalNavView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.headBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.headBackView.backgroundColor=Color_form_TextFieldBackgroundColor;
        self.headBackView.alpha = 0;
        [self addSubview:self.headBackView];
        
        self.rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBt.backgroundColor = [UIColor clearColor];
        self.rightBt.frame = CGRectMake(self.frame.size.width-46, 28, 30, 30);
        [self.rightBt addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBt];
        
        self.leftBt=[UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBt.backgroundColor=[UIColor clearColor];
        self.leftBt.frame=CGRectMake(5, 28, 30, 30);
        [self.leftBt addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftBt];
        
        self.backgroundColor=[UIColor clearColor];
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(44, 20, frame.size.width-44-44, 44)];
        self.label.textAlignment=NSTextAlignmentCenter;
        self.label.textColor=Color_form_TextFieldBackgroundColor;
        self.label.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.label];
    }
    return self;
}
-(void)setLeft_bt_Image:(NSString *)left_bt_Image
{
    _left_bt_Image = left_bt_Image;
    [self.leftBt setImage:[UIImage imageNamed:_left_bt_Image] forState:UIControlStateNormal];
}
-(void)setRight_bt_Image:(NSString *)right_bt_Image
{
    _right_bt_Image = right_bt_Image;
    [self.rightBt setImage:[UIImage imageNamed:_right_bt_Image] forState:UIControlStateNormal];
}

-(void)setTitle:(NSString *)title{
    _title=title;
    self.label.text=title;
}
-(void)setColor:(UIColor *)color{
    _color=color;
    self.label.textColor=color;
}
-(void)setHead_bg_Image:(NSString *)head_bg_Image{
    _head_bg_Image=head_bg_Image;
    self.headBackView.image=[UIImage imageNamed:_head_bg_Image];
}
-(void)setHasLeft:(BOOL)hasLeft{
    _hasLeft=hasLeft;
    self.leftBt.hidden=!_hasLeft;
    self.leftBt.userInteractionEnabled=hasLeft;
}
-(void)setHasRinght:(BOOL)hasRinght{
    _hasRinght=hasRinght;
    self.rightBt.hidden=!_hasRinght;
    self.rightBt.userInteractionEnabled=hasRinght;
}
//左边
-(void)leftClick{
    if ([_delegate respondsToSelector:@selector(NaLeft)] ) {
        [_delegate NaLeft];
    }
}
//右边
-(void)rightClick{
    if ([_delegate respondsToSelector:@selector(NaRight)]) {
        [_delegate NaRight];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
