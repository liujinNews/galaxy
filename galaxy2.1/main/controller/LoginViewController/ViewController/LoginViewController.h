//
//  LoginViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface LoginViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;

@property (weak, nonatomic) IBOutlet UITextField *txf_account;

@property (weak, nonatomic) IBOutlet UITextField *txf_password;

@property (weak, nonatomic) IBOutlet UIImageView *img_BackImage;

@property (weak, nonatomic) IBOutlet UIImageView *img_account;

@property (weak, nonatomic) IBOutlet UIImageView *img_password;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@property (weak, nonatomic) IBOutlet UIButton *btn_Experience;

@property (weak, nonatomic) IBOutlet UIButton *btn_regisn;
@property (weak, nonatomic) IBOutlet UIButton *btn_losdward;

@property (weak, nonatomic) IBOutlet UIButton *btn_GoMain;

@property (nonatomic, assign) BOOL isTokenInvalid;//是否Token过期

@end
