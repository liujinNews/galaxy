//
//  ExpenseCodeListTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/10/31.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseCodeListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
@property (weak, nonatomic) IBOutlet UILabel *lab_ExpenseCat;
@property (weak, nonatomic) IBOutlet UIImageView *img_Icon;

@end
