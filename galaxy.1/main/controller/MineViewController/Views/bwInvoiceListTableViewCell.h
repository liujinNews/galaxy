//
//  bwInvoiceListTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/11/20.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bwInvoiceListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_State;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_amount;
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (weak, nonatomic) IBOutlet UILabel *lab_type;

@end
