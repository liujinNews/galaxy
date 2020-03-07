//
//  PopMenuButton.h
//  galaxy
//
//  Created by hfk on 2016/12/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//
// ==========================================
//  PopMenuButton 菜单视图 UIView  处理点击事件等
// ==========================================
#import <UIKit/UIKit.h>
// Model
#import "PopMenuItem.h"

// View
#import "GlowImageView.h"
@class PopMenuItem;

typedef void(^DidSelctedItemCompletedBlock)(PopMenuItem *menuItem);

@interface PopMenuButton : UIView
/**
 *  点击操作
 */
@property (nonatomic, copy) DidSelctedItemCompletedBlock didSelctedItemCompleted;

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame menuItem:(PopMenuItem *)menuItem;
@end
