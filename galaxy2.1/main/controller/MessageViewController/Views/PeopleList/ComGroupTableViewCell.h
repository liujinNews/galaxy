//
//  ComGroupTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComPeopleModel.h"

@interface ComGroupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

@property (weak, nonatomic) IBOutlet UIImageView *img_image;

@property (weak, nonatomic) IBOutlet UILabel *lab_Number;

@property (nonatomic, strong) ComPeopleModel *model;

@end
