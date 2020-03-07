//
//  EntertainmentFormData.h
//  galaxy
//
//  Created by hfk on 2018/4/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "EntertainmentData.h"

@interface EntertainmentFormData : FormBaseModel
/**
 类型
 */
@property (nonatomic, strong) NSString *str_Type;
@property (nonatomic, strong) NSString *str_TypeId;
/**
 明细费用类别点击行数
 */
@property (nonatomic,assign)NSInteger int_DetailTypeIndex;
/**
 是否用车
 */
@property(nonatomic,strong)NSString *str_IsUseCar;

/**
 * 拼接数据
 */
@property(nonatomic,strong)EntertainmentData *SubmitData;



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
