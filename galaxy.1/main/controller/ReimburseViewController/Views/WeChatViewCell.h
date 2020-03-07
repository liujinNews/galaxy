//
//  WeChatViewCell.h
//  galaxy
//
//  Created by hfk on 2017/11/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatInvoiceModel.h"

@interface WeChatViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_Shoupiao;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_Shoupiao;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_ShoupiaoNum;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_ShoupiaoNum;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_Kaipiao;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_Kaipiao;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_Amount;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_Amount;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_Tax;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_Tax;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_Date;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_Date;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_FapiaoCode;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_FapiaoCode;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Title_FapiaoNum;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Sub_FapiaoNum;
@property (weak, nonatomic) IBOutlet UIImageView *Img_LineView;
@property (weak, nonatomic) IBOutlet UIButton *Btn_LookPdf;
@property (weak, nonatomic) IBOutlet UIImageView *Img_Diffent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Height_Shoupiao;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Height_Kaipiao;

-(void)configCellWithModel:(WeChatInvoiceModel *)model;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
