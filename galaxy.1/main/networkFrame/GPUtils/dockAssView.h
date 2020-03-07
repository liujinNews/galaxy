//
//  dockAssView.h
//  galaxy
//
//  Created by 赵碚 on 15/7/27.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dockAssView : UIView

@property (strong, nonatomic) UIImageView * imgView;        //显示的tab图片
@property (strong, nonatomic) UILabel * label;              //按钮文字
@property (strong, nonatomic) UIImageView * redBallImgView; //红球，当前页面有提示时显示，这里对每一个view都添加一个红球以备之后不时之需，当前不需要的只需要隐藏掉即可

- (id)initWithFrame:(CGRect)frame;
- (void)initContentsName:(NSString *)imgName Text:(NSString *)text Color:(UIColor *)color;
- (void)setContentsName:(NSString *)imgName Color:(UIColor *)textColor;

@end
