//
//  RemittanceFormData.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "RemittanceData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemittanceFormData : FormBaseModel
/**
 已登记发票信息
 */
@property (nonatomic, strong) NSMutableArray *array_invoiceRegAppInfo;
/**
 已请款信息
 */
@property (nonatomic, strong) NSMutableArray *array_remittanceAppInfo;
/**
 结算单信息
 */
@property (nonatomic, strong) NSMutableArray *array_settlementSlipInfo;


/**
 合同内容
 */
@property (nonatomic, copy) NSString *str_ContractAppNumber;
@property (nonatomic, copy) NSString *str_ContractNo;
@property (nonatomic, copy) NSString *str_ContractName;

/**
 * 拼接数据
 */
@property(nonatomic,strong)RemittanceData *SubmitData;

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


@end

NS_ASSUME_NONNULL_END
