//
//  PerformanceTypeController.h
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "OtherReimTypeChooseCell.h"

@interface PerformanceTypeController : RootViewController
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL requestType;
@property(nonatomic,strong)NSString *flowGuid;

@end
