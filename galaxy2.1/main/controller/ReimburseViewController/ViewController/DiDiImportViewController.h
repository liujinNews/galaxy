//
//  DiDiImportViewController.h
//  galaxy
//
//  Created by hfk on 2018/8/16.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@interface DiDiImportViewController : FlowBaseViewController

@property (nonatomic, strong) NSString *str_phone;
//支付方式 默认全部，0-企业支付 1-个人垫付
@property (nonatomic, strong) NSString *str_payType;


@end
