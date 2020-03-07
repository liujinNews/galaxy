//
//  OtherReimTypeController.h
//  galaxy
//
//  Created by hfk on 2016/11/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "OtherReimTypeChooseCell.h"
#import "OtherReimTypeChooseModel.h"
@interface OtherReimTypeController : RootViewController
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL requestType;

@property(nonatomic,strong)NSString *flowGuid;


@end
