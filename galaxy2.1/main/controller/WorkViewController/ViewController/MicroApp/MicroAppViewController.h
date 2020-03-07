//
//  MicroAppViewController.h
//  galaxy
//
//  Created by hfk on 16/5/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "WorkShowModel.h"
@interface MicroAppViewController : RootViewController<GPClientDelegate>
/**
 是否是单独点击过去还是直接跳转  YES:点击过去的
 */
@property (nonatomic, assign) BOOL isClick;
//微应用跳转Model
@property(nonatomic,strong)WorkShowModel *JumpModel;

@property(nonatomic,strong)NSString *microAppCode;



@end


