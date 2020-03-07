//
//  AddFeeBudgetController.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "FeeBudgetInfoModel.h"

@interface AddFeeBudgetController : VoiceBaseController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSMutableArray *arr_Main;

@property (nonatomic, strong) FeeBudgetInfoModel *model;

@property (copy, nonatomic) void(^SaveBackBlock)(FeeBudgetInfoModel *model, NSInteger type);

@end
