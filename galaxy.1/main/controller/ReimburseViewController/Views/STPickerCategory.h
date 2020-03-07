//
//  STPickerCategory.h
//  galaxy
//
//  Created by hfk on 2016/11/30.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "STPickerView.h"
#import "CostCateNewModel.h"
@class STPickerCategory;

@interface STPickerCategory : STPickerView
/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property (nonatomic,strong)NSMutableArray *DateSourceArray;
@property (nonatomic,strong)CostCateNewSubModel *CateModel;
@property (nonatomic,assign)NSInteger firstindex;
@property (nonatomic,assign)NSInteger secondindex;
@property (nonatomic,copy)NSString *typeTitle;

@property (nonatomic,copy)NSString *str_flowCode;

//选择费用类别
@property (copy, nonatomic) void(^ChooseCateBlock)(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel);


-(void)UpdatePickUI;
@end
