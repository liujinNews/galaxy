//
//  PeopleAdd_label_text_TableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleAdd_label_text_TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txf_textField;

@property (weak, nonatomic) IBOutlet UILabel *lab_lable;

@property (nonatomic, strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIImageView *img_rightImage;


@end
