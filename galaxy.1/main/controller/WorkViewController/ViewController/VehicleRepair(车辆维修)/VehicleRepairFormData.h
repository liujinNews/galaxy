//
//  VehicleRepairFormData.h
//  galaxy
//
//  Created by hfk on 2018/4/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "VehicleRepairData.h"
@interface VehicleRepairFormData : FormBaseModel

/**
 明细费用类别点击行数
 */
@property (nonatomic,assign)NSInteger int_DetailTypeIndex;

/**
 * 拼接数据
 */
@property(nonatomic,strong)VehicleRepairData *SubmitData;

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
