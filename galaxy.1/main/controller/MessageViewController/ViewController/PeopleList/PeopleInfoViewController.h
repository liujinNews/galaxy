//
//  PeopleInfoViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/8.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "ComPeopleModel.h"

@interface PeopleInfoViewController : RootViewController

@property (nonatomic, strong) ComPeopleModel *model;

@property (weak, nonatomic) IBOutlet UIButton *btn_IM;
@property (weak, nonatomic) IBOutlet UILabel *labT_department;
@property (weak, nonatomic) IBOutlet UILabel *labT_job;
@property (weak, nonatomic) IBOutlet UILabel *labT_phone;
@property (weak, nonatomic) IBOutlet UILabel *labT_email;
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UIImageView *img_cap;

@end
