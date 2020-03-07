//
//  StatisticalView.m
//  galaxy
//
//  Created by 赵碚 on 15/11/9.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "StatisticalView.h"

@implementation StatisticalView

{
    UIView *backgroundView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark 给View添加圆角


-(id)initWithStatisticalFrame:(CGRect)frame pickerView:(UIView *)pickerView titleView:(UIView *)titleView
{
    //
    self=[super init];
    if (self) {
        self.clipsToBounds = YES;
        frame.size.width = ScreenRect.size.width;
        frame.size.height = Main_Screen_Height-Main_Screen_Height*0.0959;
        frame.origin.x=0;
        frame.origin.y=ApplicationDelegate.window.bounds.size.height;
        self.frame = frame;
        self.isShow=NO;
        self.backgroundColor=[UIColor clearColor];
        //**********************************************************************
        
    }
    return self;
}

-(void)didTap:(id)sender
{
    if (self) {
        [self removeStatistical];
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewCancelClick:)]) {
            [self.delegate actionStatisticalViewCancelClick:self];
        }
    }
}
-(void)setBackgroundView
{
    backgroundView = [[UIView alloc]initWithFrame:CGRectIntegral([[UIScreen mainScreen] bounds])];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [backgroundView addGestureRecognizer:tapGesture];
    
    [ApplicationDelegate.window addSubview:backgroundView];
}
-(void)pickerCancel:(UIButton *)sender
{
    [self removeStatistical];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewCancelClick:)]) {
        [self.delegate actionStatisticalViewCancelClick:self];
    }
}

-(void)pickerDone:(UIButton *)sender
{
    [self removeStatistical];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewDoneClick:)]) {
        [self.delegate actionStatisticalViewDoneClick:self];
    }
}
UIKIT_STATIC_INLINE void
UIViewSetFrameY(UIView *view, CGFloat y) {
    view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}

//显示出来
- (void)showStatistical
{
    if (!self.isShow) {
        [self setBackgroundView];
        [ApplicationDelegate.window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            UIViewSetFrameY(self,ApplicationDelegate.window.bounds.size.height - self.frame.size.height);
        }];
        self.isShow=YES;
    }
    
}

//显示并更新View
-(void)showStatisticalUpView:(UIView *)puView
{
    if (!self.isShow) {
        [self setBackgroundView];
        [ApplicationDelegate.window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            UIViewSetFrameY(self, ApplicationDelegate.window.bounds.size.height - self.frame.size.height);
        }];
        self.isShow=YES;
    }
    [self addSubview:puView];
}

-(void)showStatisticalDownView:(UIView *)puView frame:(CGRect)frame
{
    if (!self.isShow) {
        [self setBackgroundView];
        [ApplicationDelegate.window addSubview:self];
        self.frame = CGRectMake(frame.origin.x, 0-Main_Screen_Height, frame.size.width, frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            NSLog(@"%f",Main_Screen_Width/Main_Screen_Height);
            if ((Main_Screen_Width/Main_Screen_Height) >=0.66666) {
                UIViewSetFrameY(self, Main_Screen_Height/5);
            }else{
                UIViewSetFrameY(self, Main_Screen_Height/4);
            }
            
        }];
        self.isShow=YES;
    }
    [self addSubview:puView];
}

- (void)removeStatistical
{
    self.isShow=NO;
    backgroundView.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        UIViewSetFrameY(self, ApplicationDelegate.window.bounds.size.height);
    } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dimsissStatisticalPDActionView)]) {
            [self.delegate dimsissStatisticalPDActionView];
        }
        [backgroundView removeFromSuperview];
        backgroundView=nil;
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
