//
//  PeopleAdd_lable_btn_TableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleAdd_lable_btn_TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_label;

@property (weak, nonatomic) IBOutlet UIButton *btn_buttonClick;

@property (nonatomic, strong) NSDictionary *dic;

@end
