//
//  MyAdvanceFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "MyAdvanceData.h"
@interface MyAdvanceFormData : FormBaseModel
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
 出差申请单请求参数(0审批完成 1审批中审批完成)
 */
@property(nonatomic,copy)NSString *str_TravelStatus;
/**
 是否允许再次借款（0允许1不允许)
 */
@property (nonatomic, assign) BOOL bool_canAdvance;
/**
 类型id
 */
@property (nonatomic, strong) NSString *str_TypeId;
/**
 类型
 */
@property (nonatomic, strong) NSString *str_Type;
/**
 *  出差申请单Id
 */
@property(nonatomic,strong)NSString *str_travelFormId;
/**
 *  出差申请单题目
 */
@property(nonatomic,strong)NSString *str_travelFormInfo;
/**
 *  费用申请单Id
 */
@property(nonatomic,strong)NSString *str_FeeAppNumber;
/**
 *  费用申请单题目
 */
@property(nonatomic,strong)NSString *str_FeeAppInfo;
/**
上次借款金额
 */
@property(nonatomic,copy)NSString *str_LastAdvanceAmount;
/**
 * 拼接数据
 */
@property(nonatomic,strong)MyAdvanceData *SubmitData;

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
