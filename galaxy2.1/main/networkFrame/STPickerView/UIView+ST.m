//
//  UIView+ST.m
//  Copyright © 2016年 ST. All rights reserved.
//

#import "UIView+ST.h"


@implementation UIView (ST)
-(void)setStx:(CGFloat)stx{
    CGRect frame = self.frame;
    frame.origin.x = stx;
    self.frame = frame;
}
-(void)setSty:(CGFloat)sty{
    CGRect frame = self.frame;
    frame.origin.y = sty;
    self.frame = frame;
}
-(CGFloat)stx{
    return self.frame.origin.x;
}

-(CGFloat)sty{
    return self.frame.origin.y;
}
-(void)setStwidth:(CGFloat)stwidth{
    CGRect frame = self.frame;
    frame.size.width = stwidth;
    self.frame = frame;
}
-(void)setStheight:(CGFloat)stheight{
    CGRect frame = self.frame;
    frame.size.height = stheight;
    self.frame = frame;
}
-(CGFloat)stheight{
    return self.frame.size.height;
}
-(CGFloat)stwidth{
    return self.frame.size.width;
}
- (UIView * (^)(CGFloat x))setStx
{
    return ^(CGFloat x) {
        self.stx = x;
        return self;
    };
}
-(void)setStcenterX:(CGFloat)stcenterX{
    CGPoint center = self.center;
    center.x = stcenterX;
    self.center = center;
}
- (CGFloat)stcenterX
{
    return self.center.x;
}
-(void)setStcenterY:(CGFloat)stcenterY{
    CGPoint center = self.center;
    center.y = stcenterY;
    self.center = center;
}
- (CGFloat)stcenterY
{
    return self.center.y;
}

- (void)setStsize:(CGSize)stsize
{
    CGRect frame = self.frame;
    frame.size = stsize;
    self.frame = frame;
}

- (CGSize)stsize
{
    return self.frame.size;
}

- (void)setStorigin:(CGPoint)storigin
{
    CGRect frame = self.frame;
    frame.origin = storigin;
    self.frame = frame;
}

- (CGPoint)storigin
{
    return self.frame.origin;
}

- (CGFloat)stleft {
    return self.frame.origin.x;
}
-(void)setStleft:(CGFloat)stleft{
    CGRect frame = self.frame;
    frame.origin.x = stleft;
    self.frame = frame;
}

- (CGFloat)sttop {
    return self.frame.origin.y;
}
-(void)setSttop:(CGFloat)sttop{
    CGRect frame = self.frame;
    frame.origin.y = sttop;
    self.frame = frame;
}
- (CGFloat)stright {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setStright:(CGFloat)stright {
    CGRect frame = self.frame;
    frame.origin.x = stright - frame.size.width;
    self.frame = frame;
}

- (CGFloat)stbottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setStbottom:(CGFloat)stbottom {
    CGRect frame = self.frame;
    frame.origin.y = stbottom - frame.size.height;
    self.frame = frame;
}


- (UIView *(^)(UIColor *color)) setColor
{
    return ^ (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIView *(^)(CGRect frame)) setFrame
{
    return ^ (CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGSize size)) setSize
{
    return ^ (CGSize size) {
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        return self;
    };
}

- (UIView *(^)(CGPoint point)) setCenter
{
    return ^ (CGPoint point) {
        self.center = point;
        return self;
    };
}

- (UIView *(^)(NSInteger tag)) setTag
{
    return ^ (NSInteger tag) {
        self.tag = tag;
        return self;
    };
}

- (void)addTarget:(id)target
           action:(SEL)action;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)addBorderColor:(UIColor *)color{
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:0.5];
    [self.layer setCornerRadius:4];
}

@end
