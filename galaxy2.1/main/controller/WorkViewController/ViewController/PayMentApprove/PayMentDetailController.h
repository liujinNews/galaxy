//
//  PayMentDetailController.h
//  galaxy
//
//  Created by hfk on 2017/5/26.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface PayMentDetailController : RootViewController
@property(nonatomic,strong)NSMutableArray *batchPayArray;//批量支付

@property (nonatomic, strong) NSMutableDictionary *dic_AgreeAmount;

@property (nonatomic, strong)NSString *flowCode;

@end
