//
//  InvoiceAppFormData.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "InvoiceAppData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceAppFormData : FormBaseModel

/**
 发票类型
 */
@property (nonatomic, strong) NSMutableArray *arr_InvoiceType;
/**
 是否回款数组
 */
@property (nonatomic, strong) NSMutableArray *arr_IsPayBack;

/**
 关联收款单请求参数(0审批完成 1审批中审批完成)
 */
@property (nonatomic, copy) NSString *str_ReceiveBillStatus;
/**
 是否是管理员(填写回款信息)
 */
@property (nonatomic, assign) BOOL bool_isMgr;
/**
 1已回款2未回款
 */
@property (nonatomic, copy) NSString *str_IsPayBack;
/**
 回款同意数据
 */
@property (nonatomic, strong) NSDictionary *dict_PayBack;
/**
 发票类型 （1增值税专用发票 2增值税普通发票）
 */
@property (nonatomic, copy) NSString *str_InvoiceType;
/**
 发票周期
 */
@property (nonatomic, copy) NSString *str_InvFromDate;
@property (nonatomic, copy) NSString *str_InvToDate;
/**
 合同
 */
@property (nonatomic, copy) NSString *str_ContractAppNumber;
@property (nonatomic, copy) NSString *str_ContractName;
@property (nonatomic, copy) NSString *str_ContractNo;
/**
 收款单
 */
@property (nonatomic, copy) NSString *str_ReceiveBillInfo;
@property (nonatomic, copy) NSString *str_ReceiveBillNumber;
/**
 *  回款发票数组
 */
@property(nonatomic,strong)NSMutableArray *arr_InvFilesImgArray;
@property(nonatomic,strong)NSMutableArray *arr_InvFilesTolArray;
/**
 开票历史
 */
@property(nonatomic,strong)NSMutableArray *arr_InvoiceHistory;
@property(nonatomic,assign)BOOL bool_isOpenInvoiceHistory;

/**
 * 拼接数据
 */
@property(nonatomic,strong)InvoiceAppData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;

//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
//获取开票历史
-(NSString *)getInvoiceHistoryUrl;
-(NSDictionary *)getInvoiceHistoryParameter;
/**
 获取表名
 */
-(NSString *)getTableName;


@end

NS_ASSUME_NONNULL_END
