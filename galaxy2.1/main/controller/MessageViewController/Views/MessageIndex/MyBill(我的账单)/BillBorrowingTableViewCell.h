//
//  BillBorrowingTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/5/17.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillBorrowingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab_name;

@property (weak, nonatomic) IBOutlet UILabel *lab_date;

@property (weak, nonatomic) IBOutlet UILabel *lab_content;

@property (weak, nonatomic) IBOutlet UILabel *lab_money;

@property (nonatomic, strong) NSDictionary *dic;

@end
