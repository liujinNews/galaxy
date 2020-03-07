//
//  ComPeopleTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComPeopleModel.h"
#import "NSString+Common.h"

@interface ComPeopleEditTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

@property (weak, nonatomic) IBOutlet UIImageView *img_rightImage;

@property (weak, nonatomic) IBOutlet UILabel *lbl_depa;

@property (weak, nonatomic) IBOutlet UIImageView *img_EditImage;
@property (nonatomic, strong) ComPeopleModel *model;

@end
