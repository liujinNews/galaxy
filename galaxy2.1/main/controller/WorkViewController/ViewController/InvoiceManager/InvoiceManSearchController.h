//
//  InvoiceManSearchController.h
//  galaxy
//
//  Created by hfk on 2017/11/17.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface InvoiceManSearchController : RootViewController

@property (copy, nonatomic) void(^SearchClickedBlock)(NSDictionary *parameters);

@end
