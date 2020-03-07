//
//  ApproveRemindTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApproveRemindTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIImageView *img_Redround;

@property (weak, nonatomic) IBOutlet UILabel *lab_content;

@property (weak, nonatomic) IBOutlet UIButton *btn_title;

@property (weak, nonatomic) IBOutlet UILabel *lab_money;

@property (weak, nonatomic) IBOutlet UIImageView *img_right_icon;

@property (weak, nonatomic) IBOutlet UILabel *lab_right_title;

@property (weak, nonatomic) IBOutlet UIButton *btn_Approval;
@property (weak, nonatomic) IBOutlet UILabel *lab_depa;

@property (weak, nonatomic) IBOutlet UILabel *lab_SeeDetails;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lay_title_width;

@property (weak, nonatomic) IBOutlet UIImageView *img_Line;
@property (weak, nonatomic) IBOutlet UIImageView *img_Right_Jian;
@property (weak, nonatomic) IBOutlet UILabel *lab_urge;

@end
