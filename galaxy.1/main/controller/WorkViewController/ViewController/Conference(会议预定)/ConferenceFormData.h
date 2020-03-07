//
//  ConferenceFormData.h
//  galaxy
//
//  Created by hfk on 2017/12/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "ConferenceData.h"
@interface ConferenceFormData : FormBaseModel
/**
 会议类型id
 */
@property (nonatomic, strong) NSString *str_TypeId;
/**
 会议类型
 */
@property (nonatomic, strong) NSString *str_Type;
/**
 会议室名称id
 */
@property (nonatomic, strong) NSString *str_RoomId;
/**
 会议室名称
 */
@property (nonatomic, strong) NSString *str_RoomName;
/**
 开始时间
 */
@property (nonatomic, strong) NSString *str_FromeDate;
/**
 结束时间
 */
@property (nonatomic, strong) NSString *str_ToDate;
/**
 参会人员id
 */
@property (nonatomic, strong) NSString *str_StaffId;
/**
 参会人员
 */
@property (nonatomic, strong) NSString *str_StaffName;
/**
  会议公开方式id
 */
@property (nonatomic, strong) NSString *str_OpenMethodId;
/**
 会议公开方式数组
 */
@property (nonatomic, strong) NSMutableArray *arr_OpenMethod;
/**
 * 拼接数据
 */
@property(nonatomic,strong)ConferenceData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
//处理公开方式id
-(NSString *)getOpenMethodId:(id)OpenMethodId;
/**
 获取表名
 */
-(NSString *)getTableName;

@end
