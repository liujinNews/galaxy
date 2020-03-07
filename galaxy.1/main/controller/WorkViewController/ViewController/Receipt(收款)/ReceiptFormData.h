//
//  ReceiptFormData.h
//  galaxy
//
//  Created by hfk on 2018/6/3.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "ReceiptData.h"
@interface ReceiptFormData : FormBaseModel
/**
 开票申请单请求参数(0审批完成 1审批中审批完成)
 */
@property(nonatomic,copy)NSString *str_InvoiceStatus;

/**
 *  支付方式数组
 */
@property (nonatomic,strong)NSMutableArray *arr_payWay;
/**
 支付方式
 */
@property (nonatomic, strong) NSString *str_PayMode;
/**
 支付方式code
 */
@property (nonatomic, strong) NSString *str_PayCode;

/**
 类型id
 */
@property (nonatomic, strong) NSString *str_TypeId;
/**
 类型
 */
@property (nonatomic, strong) NSString *str_Type;
/**
合同任务号
 */
@property (nonatomic, strong) NSString *str_ContractAppNumber;
/**
合同编号
 */
@property (nonatomic, strong) NSString *str_ContractNo;
/**
 合同名称
 */
@property (nonatomic, strong) NSString *str_ContractName;
/**
 合同金额
 */
@property (nonatomic, strong) NSString *str_ContAmount;
/**
 合同开始日期
 */
@property (nonatomic, strong) NSString *str_ContEffectiveDate;
/**
合同截止日期
 */
@property (nonatomic, strong) NSString *str_ContExpiryDate;
/**
 回款金额
 */
@property (nonatomic, strong) NSString *str_RepaidAmount;
/**
未回款金额
 */
@property (nonatomic, strong) NSString *str_UnpaidAmount;
/**
 开票编号
 */
@property (nonatomic, strong) NSString *str_InvoiceAppNumber;
/**
 开票名称
 */
@property (nonatomic, strong) NSString *str_InvoiceAppInfo;
/**
 银行名称
 */
@property (nonatomic, strong) NSString *str_BankName;
/**
 银行账号
 */
@property (nonatomic, strong) NSString *str_BankAccount;
/**
 回款记录
 */
@property (nonatomic, strong) NSMutableArray *arr_receiveBillHistory;


/**
 * 拼接数据
 */
@property(nonatomic,strong)ReceiptData *SubmitData;

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
 获取收款信息地址
 */
-(NSString *)getReceiveBillInfoUrl;
/**
 获取收款信息参数
 */
-(NSDictionary *)getReceiveBillInfoParameters;
/**
 处理回款信息 1只取列表
 */
-(void)dealWithReceiveBillInfoWithType:(NSInteger)type;


@end
