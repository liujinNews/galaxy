//
//  Dashline.m
//  galaxy
//
//  Created by hfk on 2018/1/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "Dashline.h"

@implementation Dashline
- (instancetype)initWithFrame:(CGRect)frame withLineLength:(NSInteger)lineLength withLineSpacing:(NSInteger)lineSpacing withLineColor:(UIColor *)lineColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        _lineLength = lineLength;
        _lineSpacing = lineSpacing;
        _lineColor = lineColor;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,self.frame.size.width);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGFloat lengths[] = {_lineLength,_lineSpacing};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0,self.frame.size.height);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

@end
