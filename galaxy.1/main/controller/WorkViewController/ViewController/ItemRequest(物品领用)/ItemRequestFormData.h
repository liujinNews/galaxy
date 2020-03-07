//
//  ItemRequestFormData.h
//  galaxy
//
//  Created by hfk on 2018/3/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "ItemRequestData.h"
@interface ItemRequestFormData : FormBaseModel
/**
 类型
 */
@property (nonatomic, copy) NSString *str_Type;
/**
合同相关数据
 */
@property (nonatomic, copy) NSString *str_ContractName;
@property (nonatomic, copy) NSString *str_ContractAppNumber;
@property (nonatomic, copy) NSString *str_ContractNo;
/**
 关联采购申请
 */
@property (nonatomic, copy) NSString *str_PurchaseNumber;
@property (nonatomic, copy) NSString *str_PurchaseInfo;
/**
 关联入库单申请
 */
@property (nonatomic, copy) NSString *str_InventoryNumber;
@property (nonatomic, copy) NSString *str_InventoryInfo;
/**
 验证库存数组
 */
@property (nonatomic, strong) NSMutableArray *arr_CheckInventory;
/**
 验证库存返回结果数组
 */
@property (nonatomic, strong) NSMutableArray *arr_CheckInventoryResult;

/**
 *  合计金额
 */
@property(nonatomic,strong)NSString *str_TotalMoney;

/**
 * 拼接数据
 */
@property(nonatomic,strong)ItemRequestData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
/**
 获取表名
 */
-(NSString *)getTableName;

/**
判断是否需要验证库存
 */
-(BOOL)needCheckInventory;

/**
 获取合计金额
 */
-(void)getTotolAmount;


@end
