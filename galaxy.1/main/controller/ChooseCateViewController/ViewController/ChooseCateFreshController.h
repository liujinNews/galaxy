//
//  ChooseCateFreshController.h
//  galaxy
//
//  Created by hfk on 2017/6/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "ChooseCateFreModel.h"
#import "MyProcurementModel.h"
#import "ChooseCategoryCell.h"
@interface ChooseCateFreshController : FlowBaseViewController<UISearchBarDelegate,GPClientDelegate>

//Type 0(审批完成1次) 1(审批中审批完成1次) 2(审批完成多次) 3(审批中审批完成多次)
@property (nonatomic, strong) NSDictionary *dict_otherPars;
@property (nonatomic, copy) NSString *ChooseCategoryId;
@property (nonatomic, copy) NSString *ChooseCategoryName;
@property (nonatomic, assign) BOOL isMultiSelect;//是否多选
@property (nonatomic,strong) MyProcurementModel *ChooseModel;//配置项Mdoel
@property (nonatomic, copy) void(^ChooseFreshCateBackBlock)(NSMutableArray *array, NSString *type);
//开户行网点选择block
@property (nonatomic, copy) void(^ChooseBankOutletsBlock)(NSMutableArray *array);

-(id)initWithType:(NSString *)type;

@end

