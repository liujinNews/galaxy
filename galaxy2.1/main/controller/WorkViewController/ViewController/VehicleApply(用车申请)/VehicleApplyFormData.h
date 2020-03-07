//
//  VehicleApplyFormData.h
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "VehicleApplyData.h"

@interface VehicleApplyFormData : FormBaseModel
/**
 出差申请单请求参数(0审批完成 1审批中审批完成)
 */
@property(nonatomic,copy)NSString *str_TravelStatus;
/**
 用车类型typeid
 */
@property (nonatomic, strong) NSString *str_TypeId;
/**
 用车类型type
 */
@property (nonatomic, strong) NSString *str_Type;
/**
 用车类型TypeFlag
 */
@property (nonatomic, strong) NSString *str_TypeFlag;
/**
 同车人员
 */
@property (nonatomic, strong) NSString *str_VehicleStaff;
/**
 同车人员Id
 */
@property (nonatomic, strong) NSString *str_VehicleStaffId;
/**
 是否过夜
 */
@property(nonatomic,strong)NSString *str_IsPassNight;

/**
 同行人员2Id
 */
@property (nonatomic, copy) NSString *str_EntourageId;
/**
 同行人员2Id
 */
@property (nonatomic, copy) NSString *str_Entourage;

/**
 出差申请单信息
 */
@property (nonatomic, strong) NSString *str_travelFormInfo;
/**
 出差申请单信息id
 */
@property (nonatomic, strong) NSString *str_travelFormId;
/**
 车辆描述
 */
@property (nonatomic, strong) NSString *str_CarDes;

/**
 私车公用补贴计算字典
 */
@property (nonatomic, strong) NSDictionary *dict_stdSelfDrive;

/**
 * 拼接数据
 */
@property(nonatomic,strong)VehicleApplyData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
/**
 车辆是否被预定
 */
-(NSString *)checkCarIsUsedUrl;
-(NSDictionary *)checkCarIsUsedParameter;

/**
 获取表名
 */
-(NSString *)getTableName;


@end
