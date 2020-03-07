//
//  PopMenuItem.h
//  galaxy
//
//  Created by hfk on 2016/12/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

// ==========================================
//  PopMenuItem 菜单元素  数据模型
// ==========================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PopMenuItem : NSObject

/**
 *   标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  配图
 */
@property (nonatomic, strong) UIImage *iconImage;

/**
 *
 */
@property (nonatomic, strong) UIColor *glowColor;

/**
 *  按钮索引
 */
@property (nonatomic, assign) NSInteger index;

#pragma mark - 初始话 init

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName NS_AVAILABLE_IOS(2_0);

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor NS_AVAILABLE_IOS(2_0);

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                        index:(NSInteger)index NS_AVAILABLE_IOS(2_0);

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor
                        index:(NSInteger)index NS_AVAILABLE_IOS(2_0);

+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName NS_AVAILABLE_IOS(2_0);

+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor NS_AVAILABLE_IOS(2_0);

+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                        index:(NSInteger)index NS_AVAILABLE_IOS(2_0);

+ (instancetype)itemWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                    glowColor:(UIColor *)glowColor
                        index:(NSInteger)index NS_AVAILABLE_IOS(2_0);


@end
