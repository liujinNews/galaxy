//
//  PeopleNoInfoViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/8.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface PeopleNoInfoViewController : VoiceBaseController
@property (weak, nonatomic) IBOutlet UIButton *btn_image;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_phone;
@property (weak, nonatomic) IBOutlet UIButton *btn_email;
@property (weak, nonatomic) IBOutlet UILabel *lab_phone;

@property (nonatomic, strong) NSDictionary *dic_userId;

@property (nonatomic, strong) UIColor *color;

@end
