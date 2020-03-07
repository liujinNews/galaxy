//
//  GPXBarView.h
//  galaxy
//
//  Created by 赵碚 on 16/6/8.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPXBarView;

@protocol GPXBarViewDelegate <NSObject>

@optional
- (void)xBarView:(GPXBarView *)xBarView didClickButtonAtIndex:(NSInteger)index;


@end

@interface GPXBarView : UIView

@property (weak, nonatomic) id<GPXBarViewDelegate> delegate;

/**
 *  文字大小
 */
@property (strong, nonatomic) UIFont *textFont;
/**
 *  文字颜色
 */
@property (strong, nonatomic) UIColor *textColor;
/**
 *  x轴文字与坐标轴间隙
 */
@property (assign, nonatomic) CGFloat xAxisTextGap;
/**
 *  坐标轴颜色
 */
@property (strong, nonatomic) UIColor *axisColor;
/**
 *  y值的数组
 */
@property (strong, nonatomic) NSArray *xValues;
/**
 *  柱与柱之间的间距
 */
@property (assign, nonatomic) CGFloat barGap;
/**
 *  x轴的文字集合
 */
@property (strong, nonatomic) NSArray *xAxisTitleArray;
/**
 *  y轴分为几段
 */
@property (assign, nonatomic) int numberOfYAxisElements;
/**
 *  y轴的最大值
 */
@property (assign, nonatomic) CGFloat yAxisMaxValue;
/**
 *  是否显示点Label
 */
@property (assign, nonatomic, getter=isShowPointLabel) BOOL showPointLabel;
/**
 *  视图的背景颜色
 */
@property (strong, nonatomic) UIColor *backColor;
/**
 *  柱的宽度
 */
@property (assign, nonatomic) CGFloat barWidth;
/**
 *  柱的颜色
 */
@property (strong, nonatomic) UIColor *barColor;
/**
 *  柱的选中的颜色
 */
@property (strong, nonatomic) UIColor *barSelectedColor;
/**
 *  pointLabel是否添加百分号
 */
@property (assign, nonatomic, getter=isPercent) BOOL percent;
/**
 *  点是否允许点击
 */
@property (assign, nonatomic, getter=isBarUserInteractionEnabled) BOOL barUserInteractionEnabled;
/**
 *  横向分割线的颜色
 */
@property (strong, nonatomic) UIColor *separateColor;
/**
 *  是否显示横向分割线
 */
@property (assign, nonatomic, getter=isShowSeparate) BOOL showSeparate;

/**
 *  标记选中哪一个柱子
 */
@property (assign, nonatomic) NSInteger index;

- (void)draw;

@end
