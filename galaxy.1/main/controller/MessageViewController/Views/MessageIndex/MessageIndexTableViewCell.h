//
//  MessageIndexTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageIndexCellModel.h"

@interface MessageIndexTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_TitleImage;

@property (weak, nonatomic) IBOutlet UILabel *lab_Title;

@property (weak, nonatomic) IBOutlet UILabel *lab_Content;

@property (weak, nonatomic) IBOutlet UIButton *btn_RedRound;

@property (nonatomic, strong) MessageIndexCellModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RedRoundHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RedRoundWidth;

@end
