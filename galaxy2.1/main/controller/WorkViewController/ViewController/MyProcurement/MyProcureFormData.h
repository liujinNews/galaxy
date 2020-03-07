//
//  MyProcureFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "DeatilsModel.h"
#import "MyProcureData.h"
@interface MyProcureFormData : FormBaseModel
/**
 *  是否需要采购模板
 */
@property (nonatomic,assign)BOOL bool_PurchaseTpl;
/**
 *  采购默认模板
 */
@property (nonatomic,strong)NSDictionary *dict_DefaultTpl;
/**
 *  采购类型数组
 */
@property (nonatomic,strong)NSMutableArray *arr_procureType;
/**
 *  支付方式数组
 */
@property (nonatomic,strong)NSMutableArray *arr_payWay;
/**
 类型
 */
@property (nonatomic, strong) NSString *str_PurchaseType;
/**
 类型
 */
@property (nonatomic, strong) NSString *str_FormScope;
/**
 *  费用申请单Id
 */
//@property(nonatomic,strong)NSString *str_FeeAppNumber;
/**
 *  费用申请单题目
 */
@property(nonatomic,strong)NSString *str_FeeAppInfo;
/**
类型code
 */
@property (nonatomic, strong) NSString *str_PurchaseCode;
/**
 支付方式
 */
@property (nonatomic, strong) NSString *str_PayMode;
/**
 支付方式code
 */
@property (nonatomic, strong) NSString *str_PayCode;
/**
 *  合计金额
 */
@property(nonatomic,strong)NSString *str_TotalMoney;

/**
 * 拼接数据
 */
@property(nonatomic,strong)MyProcureData *SubmitData;


@property(nonatomic,strong)NSMutableArray *detailedArray;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
/**
 采购明细打开显示内容处理
 */
-(void)initProcureItemDate;
/**
 获取表名
 */
-(NSString *)getTableName;


/**
 获取合计金额
 */
-(void)getTotolAmount;


@end
