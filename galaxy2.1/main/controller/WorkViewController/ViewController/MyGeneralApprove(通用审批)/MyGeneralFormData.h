//
//  MyGeneralFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/5.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "MyGeneralApproveDate.h"
@interface MyGeneralFormData : FormBaseModel
/**
 类型id
 */
@property (nonatomic, strong) NSString *str_TypeId;
/**
 类型
 */
@property (nonatomic, strong) NSString *str_Type;
/**
 * 拼接数据
 */
@property(nonatomic,strong)MyGeneralApproveDate *SubmitData;

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
