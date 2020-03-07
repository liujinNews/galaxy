//
//  DVXAxisView.m
//  DVLineChart
//
//  Created by Fire on 15/10/16.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVXAxisView.h"
#import "DVPlot.h"
#import "UIView+ChartBase.h"

@interface DVXAxisView ()
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
@property (strong, nonatomic) NSMutableArray *titleLabelArray;
/**
 *  记录坐标轴的第一个Label
 */
@property (strong, nonatomic) UILabel *firstLabel;
/**
 *  记录点按钮的集合
 */
@property (strong, nonatomic) NSMutableArray *buttonPointArray;
/**
 *  选中的点
 */
@property (strong, nonatomic) UIButton *selectedPoint;

@property (strong, nonatomic) NSMutableArray *pointButtonArray;
@end

@implementation DVXAxisView

- (NSMutableArray *)pointButtonArray {
    
    if (_pointButtonArray == nil) {
        _pointButtonArray = [NSMutableArray array];
    }
    return _pointButtonArray;
}

- (NSMutableArray *)titleLabelArray {
    if (_titleLabelArray == nil) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.textFont = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    
    [self draw];
    
}

- (NSMutableArray *)buttonPointArray {
	
	if (_buttonPointArray == nil) {
		_buttonPointArray = [NSMutableArray array];
	}
	return _buttonPointArray;
}

- (void)draw {
    
    self.backgroundColor = self.backColor;
    
    // 移除先前存在的所有视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 移除数组内所有的Label元素
    [self.titleLabelArray removeAllObjects];
    [self.pointButtonArray removeAllObjects];
    
    // 添加坐标轴Label
    for (int i = 0; i < self.xAxisTitleArray.count; i++) {
        NSString *title = self.xAxisTitleArray[i];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = self.textFont;
        label.textColor = self.textColor;
        
        NSDictionary *attr = @{NSFontAttributeName : self.textFont};
        CGSize labelSize = [title sizeWithAttributes:attr];
        
        label.hhx = (i + 1) * self.pointGap - labelSize.width / 2;
        label.hhy = self.hhheight - labelSize.height;
        label.hhwidth = labelSize.width;
        label.hhheight = labelSize.height;
        
        if (i == 0) {
            self.firstLabel = label;
        }
        
        [self.titleLabelArray addObject:label];
        [self addSubview:label];
    }
    
    // 添加坐标轴
    NSDictionary *attribute = @{NSFontAttributeName : self.textFont};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];
    
    self.textHeight = textSize.height;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.axisColor;
    view.hhheight = 1;
    view.hhwidth = self.hhwidth + 200;
    view.hhx = -200;
    view.hhy = self.hhheight - textSize.height - self.xAxisTextGap;
    [self addSubview:view];
    
    // 计算横向分割线位置
    self.topMargin =20;
    self.chartHeight = self.hhheight - textSize.height - self.xAxisTextGap - self.topMargin;
    CGFloat separateHeight = 1;
    CGFloat separateMargin = (self.hhheight - self.topMargin - textSize.height - self.xAxisTextGap - self.numberOfYAxisElements * separateHeight) / self.numberOfYAxisElements;
    
    // 画横向分割线
    if (self.isShowSeparate) {
        
        for (int i = 0; i < self.numberOfYAxisElements; i++) {
            
            UIView *separate = [[UIView alloc] init];
            
            separate.hhx = 0;
            separate.hhwidth = self.hhwidth;
            separate.hhheight = separateHeight;
            separate.hhy = view.hhy - (i + 1) * (separateMargin + separate.hhheight);
            separate.backgroundColor = self.separateColor;
            [self addSubview:separate];
        }
        //竖向分割线
        NSInteger count=floor(self.hhwidth/45);
        for (int i = 1; i <=count; i++) {
            
            UIView *separate = [[UIView alloc] init];
            separate.hhx =45*i;
            separate.hhwidth =1;
            separate.hhheight =95;
            separate.hhy =18;
            separate.backgroundColor = self.separateColor;
            [self addSubview:separate];
        }
    }
    
    
    // 如果Label的文字有重叠，那么隐藏
    for (int i = 0; i < self.titleLabelArray.count; i++) {
        
        UILabel *label = self.titleLabelArray[i];
        
        CGFloat maxX = CGRectGetMaxX(self.firstLabel.frame);
        
        if (self.isShowTailAndHead == NO) {
            if (i != 0) {
                if ((maxX + 3) > label.hhx) {
                    label.hidden = YES;
                }else{
                    label.hidden = NO;
                    self.firstLabel = label;
                }
            }else {
                if (self.firstLabel.hhx < 0) {
                    self.firstLabel.hhx = 0;
                }
            }
        }else{
            
            if (i > 0 && i < self.titleLabelArray.count - 1) {
                
                label.hidden = YES;
                
            }else if(i == 0){
            
                if (self.firstLabel.hhx < 0) {
                    self.firstLabel.hhx = 0;
                }
            
            }else{
                
                if (CGRectGetMaxX(label.frame) > self.hhwidth) {
                    
                    label.hhx = self.hhwidth - label.hhwidth;
                }
            }
        }
    }
    
    
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect {

    for (DVPlot *plot in self.plots) {
		
		[self drawLineInRect:rect withPlot:plot isPoint:NO];
		
		if (plot.withPoint) {
			
			[self drawLineInRect:rect withPlot:plot isPoint:YES];
			
		}
    }
}

- (void)drawLineInRect:(CGRect)rect withPlot:(DVPlot *)plot isPoint:(BOOL)isPoint {
    
    
    if (isPoint) {  // 画点
        
        for (int i = 0; i < plot.pointArray.count; i++) {
            
            NSNumber *value = plot.pointArray[i];
//            NSString *title = [self decimalwithFormat:@"0.00" floatV:value.floatValue];
//
//			
//			// 判断title的值，整数或者小数
//			if (![self isPureFloat:title]) {
//				title = [NSString stringWithFormat:@"%.0f", title.floatValue];
//			}
			NSString *title = [NSString stringWithFormat:@"%@",value];
			
			if (value.floatValue < 0) {
				value = @(0);
			}
			
            CGPoint center = CGPointMake((i+1)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
			
			if (self.yAxisMaxValue * self.chartHeight == 0) {
				center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
			}
			
            // 添加point处的Label
            if (self.isShowPointLabel) {
                
                [self addLabelWithTitle:title atLocation:center andTag:i];
                
            }
			
			UIButton *button = [[UIButton alloc] init];
			button.tag = i;
            [button setBackgroundImage:plot.pointImage forState:UIControlStateNormal];
			[button setBackgroundImage:plot.pointImage forState:UIControlStateSelected];
			button.hhsize = CGSizeMake(11,11);
			button.center = center;
			
			button.layer.cornerRadius = 5.5;
			button.layer.masksToBounds = YES;
			
			button.userInteractionEnabled = self.isPointUserInteractionEnabled;
			
			[button addTarget:self action:@selector(pointDidClicked:) forControlEvents:UIControlEventTouchUpInside];
			
            [self.pointButtonArray addObject:button];
            
			if (button.userInteractionEnabled) {
				if (i == 0) {
					[self pointDidClicked:button];
				}
			}
			
			[self addSubview:button];
        }
        
    }else{
        
        if (plot.isChartViewFill) { // 画线，空白处填充
            
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            CGPoint start = CGPointMake(self.pointGap, self.hhheight - self.xAxisTextGap - self.textHeight);
            
            [path moveToPoint:start];
            
            for (int i = 0; i < plot.pointArray.count; i++) {
                
                NSNumber *value = plot.pointArray[i];
                
                if (value.floatValue < 0) {
                    value = @(0);
                }
                
                CGPoint center = CGPointMake((i+1)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
                
                if (self.yAxisMaxValue * self.chartHeight == 0) {
                    center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
                }
                
                [path addLineToPoint:center];
                
            }
            
            CGPoint end = CGPointMake(plot.pointArray.count*self.pointGap, self.hhheight - self.xAxisTextGap - self.textHeight);
            
            [path addLineToPoint:end];
            
            [[plot.lineColor colorWithAlphaComponent:0.05] set];
            // 将路径添加到图形上下文
            CGContextAddPath(ctx, path.CGPath);
            // 渲染
            CGContextFillPath(ctx);

            
            // 画线，只有线，没有填充色
            
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];//画线
            
            UIBezierPath *path1 = [[UIBezierPath alloc] init];
            
            NSNumber *startValue1 = plot.pointArray.firstObject;
            
            CGPoint start1 = CGPointMake(self.pointGap, self.chartHeight-([startValue1 floatValue]/self.yAxisMaxValue) * self.chartHeight + self.topMargin);
//            NSLog(@"height%f",self.chartHeight);
//            NSLog(@"%f",self.yAxisMaxValue);
//            NSLog(@"%f",self.topMargin);
//            NSLog(@"%f", ([startValue1 floatValue]/self.yAxisMaxValue) * self.chartHeight );
            [path1 moveToPoint:start1];
            
            for (int i = 0; i < plot.pointArray.count; i++) {
                
                if (i < plot.pointArray.count - 1) {
                    
                    NSNumber *value1 = plot.pointArray[i+1];
                    CGPoint center1 = CGPointMake((i+2)*self.pointGap, self.chartHeight - value1.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
                    
                    if (self.yAxisMaxValue * self.chartHeight == 0) {
                        center1 = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
                    }
                    [path1 addLineToPoint:center1];
                    
                }
                
            }
            layer.path = path1.CGPath;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [plot.lineColor colorWithAlphaComponent:0.2].CGColor;
            [self.layer addSublayer:layer];
            
            
        }else{  // 画线，只有线，没有填充色
            
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];//画线
            
            UIBezierPath *path1 = [[UIBezierPath alloc] init];
            
            NSNumber *startValue1 = plot.pointArray.firstObject;
            
            CGPoint start1 = CGPointMake(self.pointGap, self.chartHeight - startValue1.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
            
            [path1 moveToPoint:start1];
            
            for (int i = 0; i < plot.pointArray.count; i++) {
                
                if (i < plot.pointArray.count - 1) {
                    
                    NSNumber *value1 = plot.pointArray[i+1];
                    CGPoint center1 = CGPointMake((i+2)*self.pointGap, self.chartHeight - value1.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
                    
                    if (self.yAxisMaxValue * self.chartHeight == 0) {
                        center1 = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
                    }
                    [path1 addLineToPoint:center1];
                    
                }
                
            }
            layer.path = path1.CGPath;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [plot.lineColor colorWithAlphaComponent:0.2].CGColor;
            [self.layer addSublayer:layer];
        }
    }
    
}

// 添加pointLabel的方法
- (void)addLabelWithTitle:(NSString *)title atLocation:(CGPoint)location andTag:(NSInteger)i {
    
    UIButton *button = [[UIButton alloc] init];
    
    if (self.isPercent) {
        [button setTitle:[NSString stringWithFormat:@"%@%%", title] forState:UIControlStateNormal];
    }else{
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    button.titleLabel.font = self.textFont;
//    label.font = self.textFont;
    button.layer.backgroundColor = self.backColor.CGColor;
    button.tag = i;
    button.alpha=0.2;
    button.userInteractionEnabled = self.isPointUserInteractionEnabled;
    
    NSDictionary *attr = @{NSFontAttributeName : self.textFont};
    CGSize buttonSize = [button.currentTitle sizeWithAttributes:attr];
    
    button.hhwidth = buttonSize.width;
    button.hhheight = buttonSize.height;
    button.hhx = location.x - button.hhwidth / 2;
    button.hhy = location.y - button.hhheight-5;
    [button addTarget:self action:@selector(pointDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (void)pointDidClicked:(UIButton *)button {
	
	self.selectedPoint.selected = NO;
    UIButton *pointButton = [self.pointButtonArray objectAtIndex:button.tag];
    pointButton.selected = YES;
    self.selectedPoint = pointButton;
	
	if ([self.delegate respondsToSelector:@selector(xAxisView:didClickButtonAtIndex:)]) {
		[self.delegate xAxisView:self didClickButtonAtIndex:button.tag];
	}
	
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(NSString *)numStr
{
	//    NSScanner* scan = [NSScanner scannerWithString:string];
	//    float val;
	//    return [scan scanFloat:&val] && [scan isAtEnd];
	
	CGFloat num = [numStr floatValue];
	
	int i = num;
	
	CGFloat result = num - i;
	
	// 当不等于0时，是小数
	return result != 0;
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
@end
