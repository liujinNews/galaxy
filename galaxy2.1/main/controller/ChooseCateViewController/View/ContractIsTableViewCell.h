//
//  ContractIsTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractIsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_serialNo;
@property (weak, nonatomic) IBOutlet UILabel *lab_totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_no;
@property (weak, nonatomic) IBOutlet UILabel *lab_no;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_Amount;
@property (weak, nonatomic) IBOutlet UILabel *lab_amount;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_gridOrder;
@property (weak, nonatomic) IBOutlet UILabel *lab_gridOrder;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_paidAmount;
@property (weak, nonatomic) IBOutlet UILabel *lab_paidAmount;

-(void) setLable_Value:(ChooseCateFreModel *)model;

@end
