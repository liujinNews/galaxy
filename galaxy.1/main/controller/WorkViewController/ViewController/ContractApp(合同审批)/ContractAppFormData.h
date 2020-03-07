//
//  ContractAppFormData.h
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "ContractAppData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractAppFormData : FormBaseModel

/**
 费用类别视图是否打开
 */
@property (nonatomic, assign) BOOL bool_isOpenCate;

/**
 关联合同
 */
@property (nonatomic, copy) NSString *str_RelateContId;
@property (nonatomic, copy) NSString *str_RelateContNo;
@property (nonatomic, copy) NSString *str_RelateContName;
/**
 采购申请单
 */
@property (nonatomic, strong) NSString *str_PurchaseNumber;
@property (nonatomic, strong) NSString *str_PurchaseInfo;

/**
 合同类型
 */
@property (nonatomic, copy) NSString *str_ContType;
@property (nonatomic, copy) NSString *str_ContTypeId;
/**
 是否使用标准合同模版
 */
@property(nonatomic, copy) NSString *str_IsStandardContractTemplate;
/**
 会签人员
 */
@property(nonatomic, copy) NSString *str_OtherApprover;
/**
 对方单位类型 1供应商 2客户 
 */
@property (nonatomic, copy) NSString *str_PartBType;
/**
 对方单位类型数组
 */
@property (nonatomic, strong) NSMutableArray *arr_PartBType;
/**
 付款方式
 */
@property (nonatomic, copy) NSString *str_PayCode;
@property (nonatomic, copy) NSString *str_PayMode;
@property (nonatomic, strong) NSMutableArray *arr_PayCode;
/**
 对方单位
 */
@property (nonatomic, copy) NSString *str_PartB;
@property (nonatomic, copy) NSString *str_PartBId;
/**
 是否外币(是否显示外币信息)
 */
@property (nonatomic, assign) BOOL bool_isForeign;
/**
 关联合同数组
 */
@property (nonatomic, strong) NSMutableArray *arr_RelateCont;
/**
 付款，回款，开票信息数组
 */
@property (nonatomic, strong) NSMutableArray *arr_ContractReleInfo;
/**
 合同编号是否由系统生成(0是 1人工输入)
 */
@property (nonatomic, assign) NSInteger int_codeIsSystem;
/**
 合同编号
 */
@property (nonatomic, copy) NSString *str_ContractNo;
/**
 发票类型 （1增值税专用发票 2增值税普通发票 3增值税电子普通发票）
 */
@property (nonatomic, copy) NSString *str_InvoiceType;


/**
 * 拼接数据
 */
@property (nonatomic, strong) ContractAppData *SubmitData;


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
