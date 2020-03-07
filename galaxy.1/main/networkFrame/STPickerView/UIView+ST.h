//
//  UIView+ST.h
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ST)
/**
 *  1.间隔X值
 */
@property (nonatomic, assign) CGFloat stx;

/**
 *  2.间隔Y值
 */
@property (nonatomic, assign) CGFloat sty;

/**
 *  3.宽度
 */
@property (nonatomic, assign) CGFloat stwidth;

/**
 *  4.高度
 */
@property (nonatomic, assign) CGFloat stheight;

/**
 *  5.中心点X值
 */
@property (nonatomic, assign) CGFloat stcenterX;

/**
 *  6.中心点Y值
 */
@property (nonatomic, assign) CGFloat stcenterY;

/**
 *  7.尺寸大小
 */
@property (nonatomic, assign) CGSize stsize;

/**
 *  8.起始点
 */
@property (nonatomic, assign) CGPoint storigin;

/**
 *  9.上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat sttop;

/**
 *  10.下 < Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat stbottom;

/**
 *  11.左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat stleft;

/**
 *  12.右 < Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat stright;


/**
 *  1.添加边框
 *
 *  @param color <#color description#>
 */
- (void)addBorderColor:(UIColor *)color;

/**
 *  2.UIView 的点击事件
 *
 *  @param target   目标
 *  @param action   事件
 */

- (void)addTarget:(id)target
           action:(SEL)action;
@end
