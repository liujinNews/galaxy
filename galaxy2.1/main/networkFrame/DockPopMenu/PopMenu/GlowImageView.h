//
//  GlowImageView.h
//  galaxy
//
//  Created by hfk on 2016/12/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

// ==========================================
//  GlowImageView 菜单按钮 UIView  处理点击事件等
// ==========================================
#import <UIKit/UIKit.h>

@interface GlowImageView : UIButton

/**
 *  设置阴影的偏移值（+，+）表示向左下偏移 默认为 （0,0）
 */
@property (nonatomic, assign) CGSize glowOffset;

/**
 *  设置阴影的模糊度 默认为： 5
 */
@property (nonatomic, assign) CGFloat glowAmount;

/**
 *  设置阴影的颜色 默认为 grayColor 灰色
 */
@property (nonatomic, strong) UIColor *glowColor;

@end
