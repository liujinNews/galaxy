//
//  bwInvoiceShowTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/11/16.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bwInvoiceShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_XSF_MC;//收票方
@property (weak, nonatomic) IBOutlet UILabel *lab_KPRQ;//开票日期
@property (weak, nonatomic) IBOutlet UILabel *lab_JSHJ;//价税合计
@property (weak, nonatomic) IBOutlet UILabel *lab_kpxm;//开票信息

@end
