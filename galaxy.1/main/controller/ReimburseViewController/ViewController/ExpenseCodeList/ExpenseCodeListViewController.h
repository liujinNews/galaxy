//
//  ExpenseCodeListViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/10/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface ExpenseCodeListViewController : VoiceBaseController

@property (nonatomic, strong) NSArray *arr_DataList;
@property (nonatomic, strong) NSString *str_CateLevel;

@property (nonatomic, strong) NSString *str_flowCode;

@property (nonatomic, strong) void(^CellClick)(CostCateNewSubModel *model);

@property (copy, nonatomic) void(^ChooseCateBlock)(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel);

@end
