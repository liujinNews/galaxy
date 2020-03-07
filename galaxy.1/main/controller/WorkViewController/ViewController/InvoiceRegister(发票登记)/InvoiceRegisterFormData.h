//
//  InvoiceRegisterFormData.h
//  galaxy
//
//  Created by hfk on 2018/11/21.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "InvoiceRegisterData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceRegisterFormData : FormBaseModel

/**
 已登记发票信息
 */
@property (nonatomic, strong) NSMutableArray *array_invoiceRegAppInfo;
/**
 合同内容
 */
@property (nonatomic, copy) NSString *str_ContractAppNumber;
@property (nonatomic, copy) NSString *str_ContractNo;
@property (nonatomic, copy) NSString *str_ContractName;
/**
 入库单
 */
@property (nonatomic, copy) NSString *str_StoreAppNumber;
@property (nonatomic, copy) NSString *str_StoreAppInfo;
/**
 发票类型 （1增值税专用发票 2增值税普通发票）
 */
@property (nonatomic, copy) NSString *str_InvoiceType;

/**
 * 拼接数据
 */
@property(nonatomic,strong)InvoiceRegisterData *SubmitData;

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
