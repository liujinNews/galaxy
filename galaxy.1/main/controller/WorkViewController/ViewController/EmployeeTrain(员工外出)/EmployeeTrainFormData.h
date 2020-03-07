//
//  EmployeeTrainFormData.h
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "EmployeeTrainData.h"
#import "EmployeeTrainDetail.h"

@interface EmployeeTrainFormData : FormBaseModel

/**
 * 拼接数据
 */
@property(nonatomic,strong)EmployeeTrainData *SubmitData;


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
