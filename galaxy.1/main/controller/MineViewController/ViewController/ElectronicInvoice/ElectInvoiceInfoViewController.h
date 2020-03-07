//
//  ElectInvoiceInfoViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/2/17.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface ElectInvoiceInfoViewController : VoiceBaseController

@property (nonatomic, strong) NSDictionary *dic;//传递数据
@property (nonatomic, strong) NSString *AcctionNo;
@property (nonatomic, strong) NSString *AcctionType;
@property (weak, nonatomic) IBOutlet UILabel *lab_skf;
@property (weak, nonatomic) IBOutlet UILabel *lab_fkf;
@property (weak, nonatomic) IBOutlet UILabel *lab_fpje;
@property (weak, nonatomic) IBOutlet UILabel *lab_fpsj;
@property (weak, nonatomic) IBOutlet UILabel *lab_fpxmc;
@property (weak, nonatomic) IBOutlet UILabel *lab_fpdm;
@property (weak, nonatomic) IBOutlet UILabel *lab_fphm;

@end
