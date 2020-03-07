//
//  travelReimFormDate.h
//  galaxy
//
//  Created by hfk on 2018/1/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "travelReimData.h"

@interface travelReimFormDate : FormBaseModel
/**
 *  报销类型Id
 */
@property(nonatomic,copy)NSString *str_ClaimTypeId;
/**
 *  报销类型
 */
@property(nonatomic,copy)NSString *str_ClaimType;
/**
 是否关联出差申请单
 */
@property (nonatomic, assign) BOOL bool_isReleTravel;
/**
 *  出差申请单第一条Id和选择Id
 */
@property(nonatomic,strong)NSString *str_travelFormId;
/**
 *  出差申请单第一条原因/出差申请单题目
 */
@property(nonatomic,strong)NSString *str_travelFormInfo;
/**
 出差申请出发城市
 */
@property(nonatomic,strong)NSString *str_FromCityCode;
@property(nonatomic,strong)NSString *str_FromCity;
/**
 出差申请到达城市
 */
@property(nonatomic,strong)NSString *str_ToCityCode;
@property(nonatomic,strong)NSString *str_ToCity;
/**
 *  出差申请单第一条钱
 */
@property(nonatomic,strong)NSString *str_travelFormMoney;
@property(nonatomic,strong)NSString *str_InvtravelFormMoney;

/**
 出差申请时间格式 0年月日 1年月日时分
 */
@property(nonatomic,assign)NSInteger int_travelTimeParams;
/**
 出差类型
 */
@property(nonatomic,strong)NSString *str_travelTypeId;
@property(nonatomic,strong)NSString *str_travelType;
/**
 归口科室
 */
@property(nonatomic,strong)NSString *str_relevantDeptId;
@property(nonatomic,strong)NSString *str_relevantDept;
/**
 经费来源
 */
@property(nonatomic,strong)NSString *str_financialSourceId;
@property(nonatomic,strong)NSString *str_financialSource;
/**
 出差期间出发时间
 */
@property(nonatomic,strong)NSString *str_FromDate;
/**
 出差期间返回时间
 */
@property(nonatomic,strong)NSString *str_ToDate;
/**
 出差同行人员
 */
@property(nonatomic,strong)NSString *str_FellowOfficers;
/**
 出差同行人员Id
 */
@property(nonatomic,strong)NSString *str_FellowOfficersId;
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
/**
 *  借款单钱
 */
@property(nonatomic,strong)NSString *str_AdvanceMoney;
@property(nonatomic,strong)NSString *str_InvAdvanceMoney;

/**
 出差申请单借款单是否显示
 */
@property(nonatomic,assign)BOOL bool_TravelShow;
@property(nonatomic,assign)BOOL bool_AdvanceShow;
/**
 *  受益人Id
 */
@property(nonatomic,copy)NSString *str_BeneficiariesId;
/**
 *  受益人名称
 */
@property(nonatomic,copy)NSString *str_Beneficiaries;
/**
 出差申请单请求参数(0审批完成 1审批中审批完成)
 */
@property(nonatomic,copy)NSString *str_TravelStatus;

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
 用车申请单id
 */
@property (nonatomic, strong) NSString *str_VehicleNumber;
/**
用车申请单name
 */
@property (nonatomic, strong) NSString *str_VehicleInfo;

/**
 记录是否收到发票
 */
@property(nonatomic,copy)NSString *str_ReceiptOfInv;
/**
 借款单冲销方式(0本位币，1原币)
 */
@property(nonatomic,strong)NSString *str_ReversalType;
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
@property(nonatomic,strong)travelReimData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;

//处理借款单或出差申请单数据
-(void)dealWithAdvanceOrTravelFormMoney;

-(NSString *)dealWithAcutual;


/**
 获取表名
 */
-(NSString *)getTableName;


/**
 获取出差期间最终格式
 */
-(NSString *)getTravelFromTimeAndToTime:(NSString *)time;


/**
 处理提交的分摊数据
 */
-(void)getSubmitExpShareDataWithDict:(NSArray *)array;

@end
