//
//  CommonPeopleTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonPeopleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_head;

@property (weak, nonatomic) IBOutlet UILabel *lab_name;

@property (weak, nonatomic) IBOutlet UILabel *lab_department;

@property (nonatomic, strong) NSDictionary *dic;

@end
