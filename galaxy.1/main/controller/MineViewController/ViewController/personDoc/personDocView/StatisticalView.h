//
//  StatisticalView.h
//  galaxy
//
//  Created by 赵碚 on 15/11/9.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StatisticalViewDelegate;
@interface StatisticalView : UIView
@property (weak, nonatomic) id<StatisticalViewDelegate>delegate;
@property BOOL isShow;

-(id)initWithStatisticalFrame:(CGRect)frame pickerView:(UIView *)pickerView titleView:(UIView *)titleView;

- (void)showStatistical;

-(void)showStatisticalUpView:(UIView *)puView;

-(void)showStatisticalDownView:(UIView*)puView frame:(CGRect)frame;

- (void)removeStatistical;

@end

@protocol StatisticalViewDelegate <NSObject>

@optional
- (void)actionStatisticalViewCancelClick:(StatisticalView *)actionView;   //取消代理事件

- (void)actionStatisticalViewDoneClick:(StatisticalView *)actionView;     //确定完成代理时间

@required


- (void)dimsissStatisticalPDActionView;
@end
