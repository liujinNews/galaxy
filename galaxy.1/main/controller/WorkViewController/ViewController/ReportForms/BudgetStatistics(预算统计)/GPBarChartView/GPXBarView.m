//
//  GPXBarView.m
//  galaxy
//
//  Created by 赵碚 on 16/6/8.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "UIView+ChartBase.h"

#import "GPXBarView.h"
@interface GPXBarView ()
/**
 *  图表顶部留白区域
 */
@property (assign, nonatomic) CGFloat topMargin;
/**
 *  记录图表区域的高度
 */
@property (assign, nonatomic) CGFloat chartHeight;
/**
 *  记录坐标轴Label的高度
 */
@property (assign, nonatomic) CGFloat textHeight;
/**
 *  存放坐标轴的label（底部的）
 */
@property (strong, nonatomic) NSMutableArray *titleButtonArray;

/**
 *  存放柱子顶部的label
 */
@property (strong, nonatomic) NSMutableArray *barTopButtonArray;
/**
 *  记录点按钮的集合
 */
@property (strong, nonatomic) NSMutableArray *barButtonArray;
/**
 *  选中的点
 */
@property (strong, nonatomic) UIButton *selectedBarButton;

/**
 *  选中的柱子顶部的label
 */
@property (strong, nonatomic) UIButton *selectedBarTopButton;
/**
 *  选中的坐标轴的label
 */
@property (strong, nonatomic) UIButton *selectedTitleButton;
@end

@implementation GPXBarView

- (NSMutableArray *)titleButtonArray {
    
    if (_titleButtonArray == nil) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}

- (NSMutableArray *)barTopButtonArray {
    
    if (_barTopButtonArray == nil) {
        _barTopButtonArray = [NSMutableArray array];
    }
    return _barTopButtonArray;
}

- (NSMutableArray *)barButtonArray {
    
    if (_barButtonArray == nil) {
        _barButtonArray = [NSMutableArray array];
    }
    return _barButtonArray;
}

- (void)draw {
    
    self.backgroundColor = self.backColor;
    
    // 移除先前存在的所有视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 移除数组内所有的Label元素
    [self.titleButtonArray removeAllObjects];
    [self.barTopButtonArray removeAllObjects];
    [self.barButtonArray removeAllObjects];
    
    CGSize labelSize = CGSizeMake(self.barWidth, 29);
    
    
    // 添加坐标轴Label
    for (int i = 0; i < self.xAxisTitleArray.count; i++) {
        NSString *title = self.xAxisTitleArray[i];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = self.textFont;
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.barSelectedColor forState:UIControlStateSelected];
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(barDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.numberOfLines = 1;
        button.hhx = (i + 1) * self.barGap + i * labelSize.width-10;
        button.hhy = self.hhheight - labelSize.height;
        button.hhwidth = labelSize.width+20;
        button.hhheight = labelSize.height;
        button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        [self.titleButtonArray addObject:button];
        [self addSubview:button];
    }
    
    // 计算横向分割线位置
    self.topMargin =20;
    
    CGFloat separateHeight = 1;
    
    // 画横向分割线
    if (self.isShowSeparate) {
        
        for (int i = 0; i < self.numberOfYAxisElements; i++) {
            
            UIView *separate = [[UIView alloc] init];
            
            separate.hhx = 0;
            separate.hhwidth = self.hhwidth;
            separate.hhheight = separateHeight;
            separate.hhy = 23*i;
            separate.backgroundColor = self.separateColor;
            [self addSubview:separate];
        }
        
        NSInteger count=floor(self.hhwidth/45);
        for (int i = 1; i <=count; i++) {
            
            UIView *separate = [[UIView alloc] init];
            separate.hhx =45*i-10;
            separate.hhwidth =1;
            separate.hhheight =95;
            separate.hhy =0;
            separate.backgroundColor = self.separateColor;
//            [self addSubview:separate];
        }
    }
    // 添加坐标轴
    self.textHeight = labelSize.height;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.axisColor;
    view.hhheight = 1;
    view.hhwidth = self.hhwidth + 200;
    view.hhx = -200;
    view.hhy = self.hhheight - labelSize.height - self.xAxisTextGap;
    [self addSubview:view];
    
    self.topMargin = 20;
    self.chartHeight = self.hhheight - labelSize.height - self.xAxisTextGap - self.topMargin;
    
    
    for (int i = 0; i < self.xValues.count; i++) {
        NSDictionary *dic = self.xValues[i];
        NSNumber *value = dic[@"value"];
        //        NSString *title = [self decimalwithFormat:@"0" floatV:value.floatValue];
        if (value.floatValue < 0) {
            value = @(0);
        }
        
        CGPoint center = CGPointMake((i+1)*self.barGap + i*self.barWidth, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
        
        if (self.yAxisMaxValue * self.chartHeight == 0) {
            center = CGPointMake((i+1)*self.barGap + i*self.barWidth, self.chartHeight + self.topMargin);
        }
        
        // 添加point处的Label
        if (self.isShowPointLabel) {
            NSString *title=[NSString stringWithFormat:@"%@",dic[@"value"]];

            [self addLabelWithTitle:title atLocation:center andTag:i];
            
        }
        //添加柱形图
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        //        [button setBackgroundColor:self.barColor forState:UIControlStateNormal];
        //        [button setBackgroundColor:self.barSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:[self imageWithColor:[GPUtils colorHString:dic[@"color"]]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:[GPUtils colorHString:dic[@"color"]]] forState:UIControlStateSelected];
        
        CGSize buttonSize = CGSizeMake(self.barWidth, value.floatValue/self.yAxisMaxValue * self.chartHeight);
        
        if (self.yAxisMaxValue == 0) {
            
            button.hhsize = CGSizeMake(self.barWidth, 0);
        }else{
            button.hhsize = buttonSize;
        }
        
        button.hhx = center.x;
        button.hhy = center.y;
        
        button.userInteractionEnabled = self.isBarUserInteractionEnabled;
        
        [button addTarget:self action:@selector(barDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.barButtonArray addObject:button];
        if (button.userInteractionEnabled) {
            if (self.index < 0) {
                if (i == 0) {
                    [self barDidClicked:button];
                }
            }else{
                if (i == self.index) {
                    [self barDidClicked:button];
                }
            }
        }
        [self addSubview:button];
    }
    
    [self setNeedsDisplay];
}


- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

// 添加pointLabel的方法
- (void)addLabelWithTitle:(NSString *)title atLocation:(CGPoint)location andTag:(NSInteger)tag {
    
    
    UIButton *button = [[UIButton alloc] init];
    
    if (self.isPercent) {
        [button setTitle:[NSString stringWithFormat:@"%@%%", title] forState:UIControlStateNormal];
        
    }else{
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.barSelectedColor forState:UIControlStateSelected];
    button.titleLabel.font = self.textFont;
    button.layer.backgroundColor = self.backColor.CGColor;
    button.alpha=0.2;
    
    NSDictionary *attr = @{NSFontAttributeName : self.textFont};
    CGSize labelSize = [button.currentTitle sizeWithAttributes:attr];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.hhwidth = labelSize.width;
    button.hhheight = labelSize.height;
    NSInteger x=(tag+1)*self.barGap +self.barWidth*(0.5+tag);
    button.hhx =x- button.hhwidth / 2;
    button.hhy = location.y - button.hhheight - 3;
    button.tag = 200+tag;
    
    [button addTarget:self action:@selector(barDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.barTopButtonArray addObject:button];
    [self addSubview:button];
}

- (void)barDidClicked:(UIButton *)button {
    
    NSInteger index = 0;
    
    if (button.tag >= 100 && button.tag < 200) {
        index = button.tag - 100;
    } else if (button.tag >= 200) {
        index = button.tag - 200;
    } else {
        index = button.tag;
    }
    
    self.selectedBarButton.selected = NO;
    self.selectedBarTopButton.selected = NO;
    self.selectedTitleButton.selected = NO;
    
    UIButton *barButton = self.barButtonArray[index];
    UIButton *barTopButton = self.barTopButtonArray[index];
    UIButton *titleButton = self.titleButtonArray[index];
    
    barButton.selected = YES;
    barTopButton.selected = YES;
    titleButton.selected = YES;
    
    self.selectedBarButton = barButton;
    self.selectedBarTopButton = barTopButton;
    self.selectedTitleButton = titleButton;
    
    if ([self.delegate respondsToSelector:@selector(xBarView:didClickButtonAtIndex:)]) {
        [self.delegate xBarView:self didClickButtonAtIndex:index];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
