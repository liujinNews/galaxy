//
//  DVBarChartView.m
//  xxxxx
//
//  Created by Fire on 15/11/11.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVBarChartView.h"
#import "DVXBarView.h"
#import "DVYBarView.h"
#import "UIColor+Hex.h"
#import "UIView+ChartBase.h"

@interface DVBarChartView () <DVXBarViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) DVXBarView *xBarView;
@property (strong, nonatomic) DVYBarView *yBarView;
@property (assign, nonatomic) CGFloat gap;

@end

@implementation DVBarChartView

- (void)draw {
    
    
    if (self.xValues.count == 0) return;
    
    // 设置y轴视图的尺寸
    self.yBarView.hhwidth = self.yAxisViewWidth;
    self.yBarView.hhx = 0;
    self.yBarView.hhheight = self.hhheight;
    self.yBarView.hhy = 0;
    
    // 设置scrollView的尺寸
    self.scrollView.hhx = self.yBarView.hhwidth;
    self.scrollView.hhy = 0;
    self.scrollView.hhwidth = self.hhwidth - self.scrollView.hhx;
    self.scrollView.hhheight = self.hhheight;
    
    // 设置x轴视图的尺寸
    self.xBarView.hhx = 0;
    self.xBarView.hhy = 0;
    self.xBarView.hhheight = self.scrollView.hhheight;
    
    if ((self.xAxisTitleArray.count * (self.barGap + self.barWidth) +80)<Main_Screen_Width) {
        self.xBarView.hhwidth=Main_Screen_Width+10;
    }else{
        self.xBarView.hhwidth = self.xAxisTitleArray.count * (self.barGap + self.barWidth) +80;
    }
    self.scrollView.contentSize = self.xBarView.frame.size;
    
    // 给y轴视图传递参数
    self.yBarView.xAxisTextGap = self.xAxisTextGap;
    self.yBarView.yAxisTextGap = self.yAxisTextGap;
    self.yBarView.textColor = self.textColor;
    self.yBarView.textFont = self.textFont;
    self.yBarView.percent = self.isPercent;
    self.yBarView.axisColor = self.axisColor;
    self.yBarView.numberOfYAxisElements = self.numberOfYAxisElements;
    self.yBarView.yAxisMaxValue = self.yAxisMaxValue;
    self.yBarView.backColor = self.backColor;
    self.yBarView.barWidth = self.barWidth;
    [self.yBarView draw];
    
    self.xBarView.xAxisTitleArray = self.xAxisTitleArray;
    self.xBarView.barGap = self.barGap;
    self.xBarView.xAxisTextGap = self.xAxisTextGap;
    self.xBarView.axisColor = self.axisColor;
    self.xBarView.numberOfYAxisElements = self.numberOfYAxisElements;
    self.xBarView.xValues = self.xValues;
    self.xBarView.yAxisMaxValue = self.yAxisMaxValue;
    self.xBarView.showPointLabel = self.isShowPointLabel;
    self.xBarView.backColor = self.backColor;
    self.xBarView.textFont = self.textFont;
    self.xBarView.textColor = self.textColor;
    self.xBarView.percent = self.isPercent;
    self.xBarView.barUserInteractionEnabled = self.isBarUserInteractionEnabled;
    self.xBarView.barWidth = self.barWidth;
    self.xBarView.barColor = self.barColor;
    self.xBarView.barSelectedColor =self.barColor;
    self.xBarView.index = self.index;
    self.xBarView.showSeparate=self.showSeparate;
    self.xBarView.separateColor=self.separateColor;
    [self.xBarView draw];
    
    if (self.index > 0) {
        
//        if (self.index * (self.barGap + self.barWidth) > self.scrollView.hhwidth * 0.5) {
//            [self.scrollView setContentOffset:CGPointMake(self.index * (self.barGap + self.barWidth) - self.scrollView.hhwidth * 0.5, 0) animated:YES];
//        }else{
//            
//            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
        [self.scrollView setContentOffset:CGPointMake(self.index * (self.barGap + self.barWidth), 0) animated:YES];
    }else{
    
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

- (void)commonInit {
    
    // 初始化某些属性值
    self.xAxisTextGap = 10;
    self.yAxisTextGap = 10;
    self.barGap = 25;
    self.axisColor =Color_White_Same_20;
    self.textColor =Color_Unsel_TitleColor;
    self.textFont = Font_Same_10_20;
    self.numberOfYAxisElements = 4;
    self.percent = NO;
    self.showPointLabel = YES;
    self.backColor = Color_form_TextFieldBackgroundColor;
    self.barUserInteractionEnabled =NO;
    self.barColor = [UIColor colorWithRed:39/255.0 green:171/255.0 blue:204/255.0 alpha:1];
    self.barSelectedColor = [UIColor colorWithHexString:@"fdb302"];
    self.barWidth =20;
    self.index = -1;
    self.showSeparate=YES;
    self.separateColor=Color_White_Same_20;
    
    // 添加x轴与y轴视图
    DVYBarView *yBarView = [[DVYBarView alloc] init];
    
    [self addSubview:yBarView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    DVXBarView *xBarView = [[DVXBarView alloc] init];
    
    [scrollView addSubview:xBarView];
    
    [self addSubview:scrollView];
    
    self.scrollView = scrollView;
    self.xBarView = xBarView;
    self.xBarView.delegate = self;
    self.yBarView = yBarView;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

+ (instancetype)barChartView {
    return [[self alloc] init];
}

- (void)xBarView:(DVXBarView *)xBarView didClickButtonAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(barChartView:didSelectedBarAtIndex:)]) {
        [self.delegate barChartView:self didSelectedBarAtIndex:index];
    }
}
@end
