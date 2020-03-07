//
//  UIView+Common.h
//  galaxy
//
//  Created by hfk on 2018/5/4.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EaseBlankPageView;

typedef NS_ENUM(NSInteger, EaseBlankPageType){
    EaseBlankNormalView = 0,
};

@interface UIView (Common)

#pragma mark BlankPageView
@property (strong, nonatomic) EaseBlankPageView *blankPageView;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasTips:(NSString *)tips hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasTips:(NSString *)tips hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block;

@end


@interface EaseBlankPageView : UIView
@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic) UILabel *tipLabel, *titleLabel;
@property (strong, nonatomic) UIButton *reloadButton, *actionButton;
@property (assign, nonatomic) EaseBlankPageType curType;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);
@property (copy, nonatomic) void(^clickButtonBlock)(EaseBlankPageType curType);
- (void)configWithType:(EaseBlankPageType)blankPageType hasTips:(NSString *)tips hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block;

@end
