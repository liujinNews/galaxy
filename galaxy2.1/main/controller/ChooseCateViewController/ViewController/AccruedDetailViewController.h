//
//  AccruedDetailViewController.h
//  galaxy
//
//  Created by APPLE on 2020/1/2.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "MyProcurementModel.h"
#import "AccruedTableViewCell.h"
#import "AccruedDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccruedDetailViewController : FlowBaseViewController<UISearchBarDelegate,GPClientDelegate>

//Type 0(审批完成1次) 1(审批中审批完成1次) 2(审批完成多次) 3(审批中审批完成多次)
@property (nonatomic, strong) NSDictionary *dict_otherPars;
@property (nonatomic, copy) NSString *ChooseCategoryId;
@property (nonatomic, copy) NSString *ChooseCategoryName;
@property (nonatomic, assign) BOOL isMultiSelect;//是否多选
@property (nonatomic,strong) MyProcurementModel *ChooseModel;//配置项Mdoel
@property (nonatomic, copy) void(^ChooseFreshCateBackBlock)(NSMutableArray *array, NSString *type);
//开户行网点选择block
@property (nonatomic, copy) void(^ChooseBankOutletsBlock)(NSMutableArray *array);
@property (nonatomic, copy) void(^ChooseAccruedBackBlock)(NSMutableArray *array,NSString *type);
-(id)initWithType:(NSString *)type;

//yes (根据taskId和gridOrder判断) no根据别的判断
@property (nonatomic, assign) BOOL multi_FieldJudgment;
@property (nonatomic, copy) NSMutableArray *chooseCategoryArr;

@end

NS_ASSUME_NONNULL_END
