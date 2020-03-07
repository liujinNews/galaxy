//
//  UIView+ChartBase.m
//  chartExample
//
//  Created by hfk on 16/5/10.
//  Copyright © 2016年 hfk. All rights reserved.
//

#import "UIView+ChartBase.h"

@implementation UIView (ChartBase)
- (void)setHhx:(CGFloat)hhx{
    CGRect frame = self.frame;
    frame.origin.x = hhx;
    self.frame = frame;
}

- (CGFloat)hhx{
    return self.frame.origin.x;
}

- (void)setHhy:(CGFloat)hhy{
    CGRect frame = self.frame;
    frame.origin.y = hhy;
    self.frame = frame;
}

- (CGFloat)hhy{
    return self.frame.origin.y;
}


- (void)setHhwidth:(CGFloat)hhwidth{
    CGRect frame = self.frame;
    frame.size.width = hhwidth;
    self.frame = frame;
}

- (CGFloat)hhwidth{
    return self.frame.size.width;
}

- (void)setHhheight:(CGFloat)hhheight{
    CGRect frame = self.frame;
    frame.size.height = hhheight;
    self.frame = frame;
}

- (CGFloat)hhheight{
    return self.frame.size.height;
}


- (void)setHhcenterX:(CGFloat)hhcenterX{
    CGPoint point = self.center;
    point.x = hhcenterX;
    self.center = point;
}

- (CGFloat)hhcenterX{
    return self.center.x;
}

- (void)setHhcenterY:(CGFloat)hhcenterY{
    CGPoint point = self.center;
    point.y = hhcenterY;
    self.center = point;
}

- (CGFloat)hhcenterY{
    return self.center.y;
}

- (void)setHhsize:(CGSize)hhsize{
    CGRect frame = self.frame;
    frame.size = hhsize;
    self.frame = frame;
}


- (CGSize)hhsize{
    return self.frame.size;
}
@end
