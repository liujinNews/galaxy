//
//  ApproveRemindByCityTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApproveRemindByCityTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIImageView *img_Redround;

@property (weak, nonatomic) IBOutlet UILabel *lab_content;

@property (weak, nonatomic) IBOutlet UIButton *btn_title;

@property (weak, nonatomic) IBOutlet UILabel *lab_money;

@property (weak, nonatomic) IBOutlet UIImageView *img_right_icon;

@property (weak, nonatomic) IBOutlet UILabel *lab_right_title;
@property (weak, nonatomic) IBOutlet UILabel *lab_depa;

@property (weak, nonatomic) IBOutlet UILabel *lab_city;

@property (weak, nonatomic) IBOutlet UIView *view_backView;

@property (weak, nonatomic) IBOutlet UIButton *btn_Approval;

@property (weak, nonatomic) IBOutlet UILabel *lab_Destination;

@property (weak, nonatomic) IBOutlet UILabel *lab_SeeDetails;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lay_btnTitle_width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lay_labDestination_width;
@property (weak, nonatomic) IBOutlet UILabel *lab_urge;

@property (weak, nonatomic) IBOutlet UIImageView *img_Line;

@end
