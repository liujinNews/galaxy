//
//  DVLineChartView.m
//  DVLineChart
//
//  Created by Fire on 15/10/16.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVLineChartView.h"
#import "DVXAxisView.h"
#import "DVYAxisView.h"
#import "UIView+ChartBase.h"

@interface DVLineChartView () <DVXAxisViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) DVXAxisView *xAxisView;
@property (strong, nonatomic) DVYAxisView *yAxisView;
@property (assign, nonatomic) CGFloat gap;

@end

@implementation DVLineChartView

- (NSMutableArray *)plots {
    
    if (_plots == nil) {
        _plots = [NSMutableArray array];
    }
    return _plots;
}

- (void)commonInit {
    
    // 初始化某些属性值
    self.xAxisTextGap = 10;
    self.yAxisTextGap = 10;
    self.pointGap =45;
    self.axisColor =Color_White_Same_20;
    self.textColor =Color_Unsel_TitleColor;
    self.textFont = Font_Same_10_20;
    self.numberOfYAxisElements =4;
    self.percent = NO;
    self.showSeparate =YES;
    self.separateColor=Color_White_Same_20;
//    self.chartViewFill = YES;
    self.showPointLabel = YES;
    self.backColor = Color_form_TextFieldBackgroundColor;
    self.pointUserInteractionEnabled =NO;
    self.index = -1;
    
    // 添加x轴与y轴视图
    DVYAxisView *yAxisView = [[DVYAxisView alloc] init];
    
    [self addSubview:yAxisView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    DVXAxisView *xAxisView = [[DVXAxisView alloc] init];
    
    [scrollView addSubview:xAxisView];
    
    [self addSubview:scrollView];
    
    self.scrollView = scrollView;
    self.xAxisView = xAxisView;
    self.xAxisView.delegate = self;
    self.yAxisView = yAxisView;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
//    // 1. 创建一个"轻触手势对象"
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    
//    // 点击几次
//    tap.numberOfTapsRequired = 2;
//    [self.xAxisView addGestureRecognizer:tap];
//    
//    // 2. 捏合手势
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
//    [self.xAxisView addGestureRecognizer:pinch];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=Color_White_Same_20;
        [self commonInit];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
     self.backgroundColor=Color_White_Same_20;
    [self commonInit];
}

+ (instancetype)lineChartView {
    
    return [[self alloc] init];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
}

- (void)addPlot:(DVPlot *)plot {
    
    if (plot == nil) return;
    if (plot.pointArray.count == 0) return;
    NSLog(@"dian%@",plot.pointArray);
    [self.plots addObject:plot];
    
}

- (void)draw {
    
    if (self.plots.count == 0) return;
    
    
    // 设置y轴视图的尺寸
    self.yAxisView.hhwidth =0;
    self.yAxisView.hhx = 0;
    self.yAxisView.hhheight =self.hhheight;
    self.yAxisView.hhy = 0;
    
    // 设置scrollView的尺寸
    self.scrollView.hhx = self.yAxisView.hhwidth;
    self.scrollView.hhy = 0;
    
    self.scrollView.hhwidth = self.hhwidth - self.scrollView.hhx;
    self.scrollView.hhheight = self.hhheight;
    
    // 设置x轴视图的尺寸
    self.xAxisView.hhx = 0;
    self.xAxisView.hhy = 0;
    self.xAxisView.hhheight = self.scrollView.hhheight;
    if ((self.xAxisTitleArray.count * self.pointGap + 80)<Main_Screen_Width) {
        self.xAxisView.hhwidth=Main_Screen_Width+10;
    }else{
        self.xAxisView.hhwidth = self.xAxisTitleArray.count * self.pointGap + 80;
    }
    
    self.scrollView.contentSize = self.xAxisView.frame.size;
    
    self.gap = self.pointGap;
    
    // 给y轴视图传递参数
    self.yAxisView.xAxisTextGap = self.xAxisTextGap;
    self.yAxisView.yAxisTextGap = self.yAxisTextGap;
    self.yAxisView.textColor = self.textColor;
    self.yAxisView.textFont = self.textFont;
    self.yAxisView.percent = self.isPercent;
    self.yAxisView.axisColor =self.axisColor;
    self.yAxisView.numberOfYAxisElements = self.numberOfYAxisElements;
    self.yAxisView.yAxisMaxValue = self.yAxisMaxValue;
    self.yAxisView.backColor = self.backColor;
    [self.yAxisView draw];
    
    self.xAxisView.xAxisTitleArray = self.xAxisTitleArray;
    self.xAxisView.pointGap = self.pointGap;
    self.xAxisView.xAxisTextGap = self.xAxisTextGap;
    self.xAxisView.axisColor =self.axisColor;
    self.xAxisView.showSeparate = self.isShowSeparate;
    self.xAxisView.numberOfYAxisElements = self.numberOfYAxisElements;
    self.xAxisView.plots = self.plots;
    self.xAxisView.yAxisMaxValue = self.yAxisMaxValue;
//    self.xAxisView.chartViewFill = self.isChartViewFill;
    self.xAxisView.showPointLabel = self.isShowPointLabel;
    self.xAxisView.backColor = self.backColor;
    self.xAxisView.textFont = self.textFont;
    self.xAxisView.textColor = self.textColor;
    self.xAxisView.percent = self.isPercent;
    self.xAxisView.pointUserInteractionEnabled = self.isPointUserInteractionEnabled;
    self.xAxisView.separateColor = self.separateColor;
    [self.xAxisView draw];
    
    if (self.index >0) {
        
//        if (self.index * self.pointGap > self.scrollView.hhwidth * 0.5) {
//            [self.scrollView setContentOffset:CGPointMake(self.index * self.pointGap - self.scrollView.hhwidth * 0.5 + self.pointGap * 0.8, 0) animated:YES];
//        }else{
//            
//            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
                 [self.scrollView setContentOffset:CGPointMake(self.index * self.pointGap , 0) animated:YES];
    }else{
    
      [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    
}

// 轻触手势监听方法
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    
    self.pointGap = self.gap;
    
    if (self.xAxisView.hhwidth == self.scrollView.hhwidth) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.xAxisView.hhwidth = self.xAxisTitleArray.count * self.gap + 100;
            
        }];
        
        self.xAxisView.showTailAndHead = NO;
        
        self.xAxisView.pointGap = self.gap;
        
        self.scrollView.contentSize = CGSizeMake(self.xAxisView.hhwidth, 0);
        
    }else{
        
        self.xAxisView.showTailAndHead = YES;
        
        CGFloat scale = self.scrollView.hhwidth / (self.xAxisTitleArray.count * self.gap + 100);
        
        self.pointGap *= scale;
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.xAxisView.hhwidth = self.scrollView.hhwidth;
        }];
        
        self.xAxisView.pointGap = self.pointGap;
        
        self.scrollView.contentSize = CGSizeMake(self.xAxisView.hhwidth, 0);
    }
    
}

// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == 3) {
        
        if (self.xAxisView.hhwidth <= self.scrollView.hhwidth) {
            
            CGFloat scale = self.scrollView.hhwidth / self.xAxisView.hhwidth;
            
            self.pointGap *= scale;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.xAxisView.hhwidth = self.scrollView.hhwidth;
            }];
            
            self.xAxisView.showTailAndHead = YES;
            
            self.xAxisView.pointGap = self.pointGap;
            
        }else if (self.xAxisView.hhwidth >= self.xAxisTitleArray.count * self.gap + 100){
            
            [UIView animateWithDuration:0.25 animations:^{
                self.xAxisView.hhwidth = self.xAxisTitleArray.count * self.gap + 100;
                
            }];
            
            self.xAxisView.showTailAndHead = NO;
            
            self.pointGap = self.gap;
            
            self.xAxisView.pointGap = self.pointGap;
        }
    }else{
        
        
        self.xAxisView.hhwidth *= recognizer.scale;
        
        self.xAxisView.showTailAndHead = NO;
        
        self.pointGap *= recognizer.scale;
        self.xAxisView.pointGap = self.pointGap;
        recognizer.scale = 1.0;
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.xAxisView.hhwidth, 0);
}

- (void)xAxisView:(DVXAxisView *)xAxisView didClickButtonAtIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(lineChartView:DidClickPointAtIndex:)]) {
        [self.delegate lineChartView:self DidClickPointAtIndex:index];
    }
    
}
@end
