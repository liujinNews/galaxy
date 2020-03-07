//
//  OverTimeFormData.h
//  galaxy
//
//  Created by hfk on 2018/9/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "OverTimeData.h"
#import "OverTimeDeatil.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverTimeFormData : FormBaseModel
/**
 节假日数组
 */
@property (nonatomic, strong) NSMutableArray *arr_OverTimeType;
/**
 加班核算方式数组
 */
@property (nonatomic, strong) NSMutableArray *arr_AccountingMode;
/**
 子表休假是否显示
 */
@property (nonatomic, assign) BOOL bool_hasExchangeHoliday;
/**
 调休天数
 */
@property (nonatomic, strong) NSString *str_ExchangeHoliday;
/**
 类型typeid
 */
@property (nonatomic, strong) NSString *str_TypeId;
/**
 加班核算方式
 */
@property (nonatomic, strong) NSString *str_AccountingModeId;
@property (nonatomic, strong) NSString *str_AccountingMode;
/**
 本月加班明细
 */
@property (nonatomic, strong) NSDictionary *dic_overtimeHistoryOutput;
/**
 是否事前加班 YES是
 */
@property (nonatomic, assign) BOOL bool_isBeforehand;
/**
 * 拼接数据
 */
@property(nonatomic,strong)OverTimeData *SubmitData;

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
