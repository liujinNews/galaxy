//
//  AddDeparTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeparTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab_label;

@property (weak, nonatomic) IBOutlet UITextField *txf_textfield;

@property (nonatomic, strong) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
