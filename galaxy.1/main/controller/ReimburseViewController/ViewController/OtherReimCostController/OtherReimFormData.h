//
//  OtherReimFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"

@interface OtherReimFormData : FormBaseModel
/**
 *  报销类型Id
 */
@property(nonatomic,copy)NSString *str_ClaimTypeId;
/**
 *  报销类型
 */
@property(nonatomic,copy)NSString *str_ClaimType;

@property (nonatomic,  strong)NSString *str_ApprovalAmount;

/**
 *  专项费标题
 */
@property(nonatomic,strong)NSString *str_OtherReimNavTitle;

/**
 *  费用申请单Id
 */
@property(nonatomic,strong)NSString *str_FeeAppNumber;
/**
 *  费用申请单题目
 */
@property(nonatomic,strong)NSString *str_FeeAppInfo;
/**
 *  业务招待Id
 */
@property(nonatomic,strong)NSString *str_EntertainNumber;
/**
 *  业务招待题目
 */
@property(nonatomic,strong)NSString *str_EntertainInfo;
/**
 *  车辆维修Id
 */
@property(nonatomic,strong)NSString *str_VehicleSvcNumber;
/**
 *  车辆维修题目
 */
@property(nonatomic,strong)NSString *str_VehicleSvcInfo;
/**
 预计金额
 */
@property(nonatomic,strong)NSString *str_EstimatedAmount;
/**
 *  借款单题目
 */
@property(nonatomic,strong)NSString *str_AdvanceInfo;
/**
 *  借款单Id
 */
@property(nonatomic,strong)NSString *str_AdvanceId;


@property(nonatomic,assign) BOOL bool_AdvanceShow;
/**
 *  是否有审批权限
 */
@property(nonatomic,copy)NSString *str_IsApprovalAuthority;

/**
 *  受益人Id
 */
@property(nonatomic,copy)NSString *str_BeneficiariesId;
/**
 *  受益人名称
 */
@property(nonatomic,copy)NSString *str_Beneficiaries;

/**
 *  结算方式数组
 */
@property (nonatomic,strong)NSMutableArray *arr_payWay;
/**
 结算方式
 */
@property (nonatomic, strong) NSString *str_PayMode;
/**
 结算方式code
 */
@property (nonatomic, strong) NSString *str_PayCode;

/**
 外出申请单id
 */
@property (nonatomic, strong) NSString *str_StaffOutNumber;
/**
 外出申请单name
 */
@property (nonatomic, strong) NSString *str_StaffOutInfo;
/**
 采购申请单id
 */
@property (nonatomic, strong) NSString *str_PurchaseNumber;
/**
 采购申请单name
 */
@property (nonatomic, strong) NSString *str_PurchaseInfo;
/**
 超标特殊申请单id
 */
@property (nonatomic, strong) NSString *str_SpecialReqestNumber;
/**
 超标特殊申请单name
 */
@property (nonatomic, strong) NSString *str_SpecialReqestInfo;
/**
 外出培训申请单id
 */
@property (nonatomic, strong) NSString *str_EmployeeTrainNumber;
/**
 外出培训申请单name
 */
@property (nonatomic, strong) NSString *str_EmployeeTrainInfo;
/**
 是否收到发票
 */
@property(nonatomic,copy)NSString *str_ReceiptOfInv;
/**
 收款人
 */
@property (nonatomic, copy) NSString *str_Payee;
/**
 开户行网点
 */
@property (nonatomic, copy) NSString *str_BankOutlets;
/**
 收款人账号
 */
@property (nonatomic, copy) NSString *str_BankAccount;
/**
 收款人银行名称
 */
@property (nonatomic, copy) NSString *str_BankName;
/**
 开户行行号
 */
@property (nonatomic, copy) NSString *str_BankNo;
/**
 开户行编号
 */
@property (nonatomic, copy) NSString *str_BankCode;
/**
 支行行号
 */
@property (nonatomic, copy) NSString *str_CNAPS;
/**
 省
 */
@property (nonatomic, copy) NSString *str_BankProvinceCode;
@property (nonatomic, copy) NSString *str_BankProvince;
/**
 城市code
 */
@property (nonatomic, copy) NSString *str_BankCityCode;
@property (nonatomic, copy) NSString *str_BankCity;
/**
 证件类型证件号
 */
@property (nonatomic, copy) NSString *str_CredentialType;
@property (nonatomic, copy) NSString *str_IdentityCardId;


/**
 * 拼接数据
 */
@property(nonatomic,strong)OtherReimData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;

-(NSString *)dealWithAcutual;
/**
 获取表名
 */
-(NSString *)getTableName;

/**
 处理提交的分摊数据
 */
-(void)getSubmitExpShareDataWithDict:(NSArray *)array;


@end
