//
//  ChooseCategoryController.h
//  galaxy
//
//  Created by hfk on 16/4/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "ChooseCategoryModel.h"

@interface ChooseCategoryController : RootViewController<GPClientDelegate>

@property (nonatomic, assign) BOOL isMultiSelect;//是否多选
@property (nonatomic, strong) NSMutableArray *ChooseCategoryArray;//选择数据
@property (nonatomic, copy) NSString *ChooseCategoryId;
@property (nonatomic, strong) NSDictionary *dict_Parameter;//请求数据源参数
@property (nonatomic, strong) UIImageView *selectedImg;//不选提示框
@property (nonatomic, copy) void(^ChooseNormalCateBackBlock)(NSMutableArray *array, NSString *type);
//开户行网点选择block
@property (nonatomic, copy) void(^ChooseBankOutletsBlock)(NSMutableArray *array);
@property (nonatomic, strong) NSDictionary *dict_BankOutlets;//参数

-(id)initWithType:(NSString *)type;

@end
