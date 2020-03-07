//
//  SpecialReqestFormData.h
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "SpecialReqestData.h"
#import "SpecialReqestDetail.h"

@interface SpecialReqestFormData : FormBaseModel

/**
 *  出差申请单Id
 */
@property(nonatomic,strong)NSString *str_travelFormId;
/**
 *  出差申请单题目
 */
@property(nonatomic,strong)NSString *str_travelFormInfo;
/**
 出差申请时间格式 0年月日 1年月日时分
 */
@property(nonatomic,assign)NSInteger int_travelTimeParams;

/**
 *  出差地code
 */
@property(nonatomic,strong)NSString *str_travelCityCode;
/**
 *  出差地信息
 */
@property(nonatomic,strong)NSString *str_travelCity;

/**
 *  出差人员id
 */
@property(nonatomic,strong)NSString *str_travelUserId;
/**
 *  出差人员
 */
@property(nonatomic,strong)NSString *str_travelUser;

/**
 * 拼接数据
 */
@property(nonatomic,strong)SpecialReqestData *SubmitData;


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
 获取出差期间最终格式
 */
-(NSString *)getTravelFromTimeAndToTime:(NSString *)time;


@end
