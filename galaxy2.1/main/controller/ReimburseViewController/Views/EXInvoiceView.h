//
//  EXInvoiceView.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/9/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXInvoiceView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *img_State;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_State;
@property (weak, nonatomic) IBOutlet UILabel *lab_purchaserName;
@property (weak, nonatomic) IBOutlet UILabel *lab_purchaserTaxNo;
@property (weak, nonatomic) IBOutlet UILabel *lab_salesName;
@property (weak, nonatomic) IBOutlet UILabel *lab_totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lab_shuier;
@property (weak, nonatomic) IBOutlet UILabel *lab_billingDate;
@property (weak, nonatomic) IBOutlet UILabel *lab_invoiceCode;
@property (weak, nonatomic) IBOutlet UILabel *lab_invoiceNumber;

@property (weak, nonatomic) IBOutlet UILabel *lab_title_shoupiaofang;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_shoupiaofangshibiema;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_kaipiaofang;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_kaipiaojiner;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_shuier;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_fapiaoriqi;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_fapiaodaima;
@property (weak, nonatomic) IBOutlet UILabel *lab_title_fapiaohaoma;
@property (weak, nonatomic) IBOutlet UIImageView *img_state_back;
@property (weak, nonatomic) IBOutlet UILabel *lab_invoice_type;
@property (weak, nonatomic) IBOutlet UIImageView *img_state_img;

@end
