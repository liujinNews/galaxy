//
//  MeetingDuringHeadView.m
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MeetingDuringHeadView.h"

@implementation MeetingDuringHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (!_lineView) {
            _lineView=[[UIView alloc]initWithFrame:CGRectZero];
            _lineView.backgroundColor=Color_GrayLight_Same_20;
            [self addSubview:_lineView];
        }
        if (!_imgView) {
            _imgView=[[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:_imgView];
        }
        if (!_titleLabel) {
            _titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
            _titleLabel.font=Font_Same_12_20 ;
            _titleLabel.textAlignment=NSTextAlignmentLeft;
            [self addSubview:_titleLabel];
        }
    }
    return self;
}
-(void)configHeadViewWithType:(NSInteger)type{
    
    _imgView.frame=CGRectMake(12, 10, 14, 14);
    _titleLabel.frame=CGRectMake(30, 5, Main_Screen_Width-30, 25);
    _titleLabel.text=Custing(@"已预订时间段", nil);
    
    if (type==1) {
        _lineView.frame=CGRectMake(12, 0, Main_Screen_Width-24, 0.5);
        _imgView.image=[UIImage imageNamed:@"Meeting_Room_Choose"];
        _titleLabel.textColor=Color_Orange_Weak_20;
    }else{
        _lineView.frame=CGRectZero;
        _imgView.image=[UIImage imageNamed:@"Meeting_Room_Show"];
        _titleLabel.textColor=Color_Black_Important_20;
    }
}
@end
