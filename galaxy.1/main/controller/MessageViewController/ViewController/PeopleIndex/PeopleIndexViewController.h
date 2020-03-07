//
//  PeopleIndexViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface PeopleIndexViewController : RootViewController

@property (weak, nonatomic) IBOutlet UILabel *lab_EnterpriseContacts;

@property (weak, nonatomic) IBOutlet UILabel *lab_OrganizationStructure;

@property (weak, nonatomic) IBOutlet UILabel *lab_MyDepartment;

@property (weak, nonatomic) IBOutlet UILabel *lab_FrequentContacts;

@property (weak, nonatomic) IBOutlet UIScrollView *scr_Scroll;//滚动

@property (weak, nonatomic) IBOutlet UIImageView *img_xibao;

@property (weak, nonatomic) IBOutlet UIButton *departBtn;
@property (weak, nonatomic) IBOutlet UIButton *organiBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIView *view_CustBg;

@property (weak, nonatomic) IBOutlet UIView *view_adFriBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;


@end
