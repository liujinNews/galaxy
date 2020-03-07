//
//  DVYBarView.m
//  xxxxx
//
//  Created by Fire on 15/11/11.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVYBarView.h"
#import "UIView+ChartBase.h"

@interface DVYBarView ()

@property (strong, nonatomic) UIView *separate;

@end

@implementation DVYBarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 垂直坐标轴
        UIView *separate = [[UIView alloc] init];
        
        self.separate = separate;
        
        [self addSubview:separate];
        
        self.textFont = [UIFont systemFontOfSize:12];
        
    }
    return self;
}
- (void)draw {
    
    self.backgroundColor = self.backColor;
    
    
    // 计算坐标轴的位置以及大小
//    NSDictionary *attr = @{NSFontAttributeName : self.textFont};
    
//    CGSize labelSize = [@"x" sizeWithAttributes:attr];
    CGSize labelSize = CGSizeMake(self.barWidth, 29);
    
    self.separate.backgroundColor = self.axisColor;
    self.separate.hhx = self.hhwidth - 1;
    self.separate.hhwidth = 1;
    self.separate.hhy = 0;
    self.separate.hhheight = self.hhheight - labelSize.height - self.xAxisTextGap;
    
    // 为顶部留出的空白
    CGFloat topMargin = 50;
    
    // Label做占据的高度
    CGFloat allLabelHeight = self.hhheight - topMargin - self.xAxisTextGap - labelSize.height;
    
    NSDictionary *attr = @{NSFontAttributeName : self.textFont};

    CGSize yLabelSize = [@"x" sizeWithAttributes:attr];
    // Label之间的间隙
    CGFloat labelMargin = (allLabelHeight + yLabelSize.height - (self.numberOfYAxisElements + 1) * yLabelSize.height) / self.numberOfYAxisElements;
    
    
    
    // 移除所有的Label
    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            
            [label removeFromSuperview];
        }
    }
    
    // 添加Label
    for (int i = 0; i < self.numberOfYAxisElements + 1; i++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat avgValue = self.yAxisMaxValue / (self.numberOfYAxisElements);
        if (self.isPercent) {
            label.text = [NSString stringWithFormat:@"%.0f%%", avgValue * i];
        }else{
            label.text = [NSString stringWithFormat:@"%.0f", avgValue * i];
        }
        
        label.textAlignment = NSTextAlignmentRight;// UITextAlignmentRight;
        label.font = self.textFont;
        label.textColor = self.textColor;
        
        label.hhx = 0;
        label.hhheight = yLabelSize.height;
        label.hhy = self.hhheight - labelSize.height - self.xAxisTextGap - (label.hhheight + labelMargin) * i - label.hhheight/2;
        label.hhwidth = self.hhwidth - 1 - self.yAxisTextGap;
        [self addSubview:label];
    }
}
@end
