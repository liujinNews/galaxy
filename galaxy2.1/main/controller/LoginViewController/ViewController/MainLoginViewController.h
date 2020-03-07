//
//  MainLoginViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/6/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface MainLoginViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIImageView *img_icon;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;//登陆按钮

@property (weak, nonatomic) IBOutlet UIButton *btn_register;//注册按钮

@property (weak, nonatomic) IBOutlet UIButton *btn_experience;//快速体验

@property (weak, nonatomic) IBOutlet UILabel *lab_experience;

@property (weak, nonatomic) IBOutlet UIImageView *img_experience;

@property (nonatomic, assign) int isGoLoginView;//1是去登录页面

@property (nonatomic, assign) BOOL isTokenInvalid;//是否Token过期


@end
