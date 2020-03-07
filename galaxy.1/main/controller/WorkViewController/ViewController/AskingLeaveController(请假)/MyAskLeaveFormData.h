//
//  MyAskLeaveFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "MyAskLeaveData.h"
@interface MyAskLeaveFormData : FormBaseModel
/**
判断是否第一次请求
 */
@property (nonatomic, assign) BOOL bool_firstRequest;
/**
 类型code
 */
@property (nonatomic, copy) NSString *str_LeaveTypecCode;
@property (nonatomic, copy) NSString *str_LeaveTypeId;

/**
 类型
 */
@property (nonatomic, strong) NSString *str_LeaveType;
/**
 开始时间
 */
@property (nonatomic, strong) NSString *str_FromDate;
/**
 结束上下午(1上午 2下午)
 */
@property (nonatomic, strong) NSString *str_FromNoon;
/**
结束时间
 */
@property (nonatomic, strong) NSString *str_ToDate;
/**
 结束上下午(1上午 2下午)
 */
@property (nonatomic, strong) NSString *str_ToNoon;
/**
 请假时间格式 1 年月日时分 2年月日 上下午
 */
@property (nonatomic, assign) NSInteger int_LeaveTimeType;


//[ApprovalDays] 审批中天数
//[Cycle] 周期（0年度请假,1仅一次）
//[WorkType] 类型（0自然日,1工作日）
//[YearLeaveDay] 跨年拆分天数（，分割）
/**
 调休天数
 */
@property (nonatomic, copy) NSString *str_LeaveDays;
/**
 已用天数
 */
@property (nonatomic, copy) NSString *str_UsedDays;
/**
 剩余天数
 */
@property (nonatomic, copy) NSString *str_RemainingDays;

/**
 是否调休（0否,1是）
 */
@property (nonatomic, copy) NSString *str_LeaveInLieu;
/**
 是否限制请假天数（0否,1是）
 */
@property (nonatomic, copy) NSString *str_LimitDay;


/**
 请假总天数
 */
@property (nonatomic, strong) NSString *str_TotolDays;
/**
 调休情况字典
 */
@property (nonatomic, strong) NSDictionary  *dict_HolidayStatus;

/**
 工作时间段
 */
@property (nonatomic, copy) NSString  *str_WorkStartTime;
@property (nonatomic, copy) NSString  *str_WorkEndTime;

/**
 日历开始年份月日
 */
@property (nonatomic, strong) NSString *str_WcStartTime;
/**
 日历结束年份
 */
@property (nonatomic, strong) NSString *str_WcEndTime;
/**
 配置的工作日历字典
 */
@property (nonatomic, strong) NSMutableDictionary *dict_WcDict;
/**
 选择日期期间的日期数组
 */
@property (nonatomic, strong) NSMutableArray *arr_DaysListArray;
/**
 筛选完成最终日期数组
 */
@property (nonatomic, strong) NSMutableArray *arr_SubmitDaysArray;


/**
 跨年拆分天数
 */
@property (nonatomic, strong) NSString *str_YearLeaveDay;



/**
 * 拼接数据
 */
@property(nonatomic,strong)MyAskLeaveData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//获取剩余假期接口
-(NSString *)HolidayUrl;
//获取剩余假期参数
-(NSDictionary *)HolidayParametersWithFromDate:(NSString *)fromDate;

//获取请假日历接口
-(NSString *)LeaveCalendarUrl;
//获取请假日历参数
-(NSDictionary *)LeaveCalendarParameters;

//处理表单数据
-(void)DealWithFormBaseData;
/**
 获取表名
 */
-(NSString *)getTableName;

//获取年份
-(NSString *)getYearMonthDayWithString:(NSString *)date;

/**
 调休情况字典
 */
-(void)getHolidayDaysInfoWithDict:(NSDictionary *)dicts;
/**
 处理日历
 */
-(void)getWorkCalendarWithDict:(NSDictionary *)dicts;
/**
 获取请假总天数(工作日)
 */
-(void)getAskLeaveTotolDays;
/**
 请假开始结束时间间隔
 */
-(NSString *)DateDuring;

@end
