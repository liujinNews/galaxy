//
//  PerformanceFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "PerformanceData.h"
#import "PerformanceDetail.h"
@interface PerformanceFormData : FormBaseModel
/**
 考核评分方式0自评，1领导评，2自评+领导评）
 */
@property (nonatomic, assign) NSInteger int_performanceMode;
/**
 考核时间(0年，1季度，2月)
 */
@property (nonatomic, assign) NSInteger int_performanceTime;
/**
 填写页面
 自评     分数          PerformanceMode=0,2     1
 领导评论  分数          PerformanceMode=1       2
 
 查看页面
 自评  领导评论  分数    PerformanceMode=2       3
 自评                  PerformanceMode=0       4
 领导评论              PerformanceMode=1       5
 自评    领导评论       PerformanceMode=2       6
 */
@property (nonatomic, assign) NSInteger int_EditType;
/**
 自评分数显示
 */
@property (nonatomic, assign) BOOL bool_selfScore;
/**
 领导分数显示
 */
@property (nonatomic, assign) BOOL bool_leaderScore;
/**
 考核类型id
 */
@property (nonatomic, strong) NSString *str_TypeId;
/**
 考核类型
 */
@property (nonatomic, strong) NSString *str_TypeName;
/**
 自评分数
 */
@property (nonatomic, strong) NSString *str_SelfTotalScore;
/**
 领导分数
 */
@property (nonatomic, strong) NSString *str_LeaderTotalScore;
/**
 评价月
 */
@property (nonatomic, strong) NSString *str_PerformanceMth;
/**
 评价季度
 */
@property (nonatomic, strong) NSString *str_PerformanceQuarter;
/**
 评价年
 */
@property (nonatomic, strong) NSString *str_PerformanceYear;

@property (nonatomic, strong) NSString *str_LeaderComments;
/**
 领导必填项判断
 */
@property (nonatomic, strong) MyProcurementModel *model_LeaderComments;


/**
 * 拼接数据
 */
@property(nonatomic,strong)PerformanceData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
//处理分数显示模块
-(void)dealTheScoreViewShowSetting;
//获取最终分数
-(void)getTheTotalScore;
/**
 获取表名
 */
-(NSString *)getTableName;
@end
