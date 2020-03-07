//
//  InvoiceManagerCell.h
//  galaxy
//
//  Created by hfk on 2017/11/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceManagerModel.h"
@interface InvoiceManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Img_Invoice_Type;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Invoice_Amount;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Invoice_Title;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Invoice_Date;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Invoice_SubTitle;
@property (weak, nonatomic) IBOutlet UILabel *Lab_DateSource;

-(void)configCellWithModel:(InvoiceManagerModel *)model;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
