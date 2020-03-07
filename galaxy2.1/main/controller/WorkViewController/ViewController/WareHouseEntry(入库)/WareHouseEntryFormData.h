//
//  WareHouseEntryFormData.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "WareHouseEntryData.h"

NS_ASSUME_NONNULL_BEGIN

@interface WareHouseEntryFormData : FormBaseModel

/**
 合同内容
 */
@property (nonatomic, copy) NSString *str_ContractAppNumber;
@property (nonatomic, copy) NSString *str_ContractNo;
@property (nonatomic, copy) NSString *str_ContractName;
/**
 采购申请单
 */
@property (nonatomic, strong) NSString *str_PurchaseNumber;
@property (nonatomic, strong) NSString *str_PurchaseInfo;
/**
 入库类型
 */
@property (nonatomic, strong) NSString *str_StoreTypeId;
@property (nonatomic, strong) NSString *str_StoreType;
/**
 仓库
 */
@property (nonatomic, strong) NSString *str_InvStorageId;
@property (nonatomic, strong) NSString *str_InvStorageCode;
@property (nonatomic, strong) NSString *str_InvStorageName;
/**
 合计金额
 */
@property(nonatomic,strong)NSString *str_TotalMoney;

/**
 * 拼接数据
 */
@property(nonatomic,strong)WareHouseEntryData *SubmitData;

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
 获取合计金额
 */
-(void)getTotolAmount;

@end

NS_ASSUME_NONNULL_END
