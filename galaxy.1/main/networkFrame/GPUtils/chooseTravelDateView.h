//
//  chooseTravelDateView.h
//  galaxy
//
//  Created by 赵碚 on 15/7/30.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^chooseTravelDateBlock)(void);
@protocol chooseTravelDateViewDelegate;

@interface chooseTravelDateView : UIView


@property (weak, nonatomic) id<chooseTravelDateViewDelegate>delegate;
@property BOOL isShow;
@property (nonatomic, strong) chooseTravelDateBlock block;
- (id)initWithFrame:(CGRect)frame pickerView:(UIView *)pickerView titleView:(UIView *)titleView;

- (void)show;

- (void)showUpView:(UIView *)puView;

- (void)remove;

@end



@protocol chooseTravelDateViewDelegate <NSObject>

@optional
- (void)actionViewCancelClick:(chooseTravelDateView *)actionView;   //取消代理事件

- (void)actionViewDoneClick:(chooseTravelDateView *)actionView;     //确定完成代理时间

@required


- (void)dimsissPDActionView;

@end
