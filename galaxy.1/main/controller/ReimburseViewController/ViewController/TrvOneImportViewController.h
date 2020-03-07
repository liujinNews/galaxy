//
//  TrvOneImportViewController.h
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrvOneImportViewController : FlowBaseViewController

@property (nonatomic, strong) NSString *str_phone;
//支付方式 默认全部，0-企业支付 1-个人垫付
@property (nonatomic, strong) NSString *str_payType;

@end

NS_ASSUME_NONNULL_END
