//
//  chooseTravelDateView.m
//  galaxy
//
//  Created by 赵碚 on 15/7/30.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "chooseTravelDateView.h"

@implementation chooseTravelDateView

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

//给view添加圆角效果
- (void)roundCorners:(UIRectCorner)corners radii:(CGFloat)radii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


-(id)initWithFrame:(CGRect)frame pickerView:(UIView *)pickerView titleView:(UIView *)titleView
{
    
    self=[super init];
    if (self) {
        self.clipsToBounds = YES;
        frame.size.width = ScreenRect.size.width;
        frame.origin.x=0;
        frame.origin.y=ApplicationDelegate.window.bounds.size.height;
        self.frame = frame;
        self.isShow=NO;
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        if (@available(iOS 13.0, *)) {
            pickerView.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            // Fallback on earlier versions
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
        [view addSubview:titleView];
        pickerView.frame = CGRectMake(0, 40, Main_Screen_Width, pickerView.frame.size.height);
        [self addSubview:view];
        [self addSubview:pickerView];
    }
    return self;
}

-(void)didTap:(id)sender
{
    if (self) {
        [self remove];
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewCancelClick:)]) {
            [self.delegate actionViewCancelClick:self];
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
    [self remove];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewCancelClick:)]) {
        [self.delegate actionViewCancelClick:self];
    }
}

-(void)pickerDone:(UIButton *)sender
{
    [self remove];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewDoneClick:)]) {
        [self.delegate actionViewDoneClick:self];
    }
}
UIKIT_STATIC_INLINE void
UIViewSetFrameY(UIView *view, CGFloat y) {
    view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}

//显示出来
- (void)show
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
-(void)showUpView:(UIView *)puView
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

- (void)remove
{
    self.isShow=NO;
    backgroundView.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        UIViewSetFrameY(self, ApplicationDelegate.window.bounds.size.height);
    } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dimsissPDActionView)]) {
            [self.delegate dimsissPDActionView];
        }
        if (self.block) {
            self.block();
        }
        [self->backgroundView removeFromSuperview];
        self->backgroundView=nil;
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
