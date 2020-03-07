//
//  OutGoingFormData.h
//  galaxy
//
//  Created by hfk on 2017/12/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "OutGoingData.h"
@interface OutGoingFormData : FormBaseModel
/**
 外出类型id
 */
@property (nonatomic, strong) NSString *str_OutTypeId;
/**
 外出类型
 */
@property (nonatomic, strong) NSString *str_OutType;
/**
 外出同行人员id
 */
@property (nonatomic, strong) NSString *str_EntourageId;
/**
 外出同行人员
 */
@property (nonatomic, strong) NSString *str_Entourage;
/**
 * 拼接数据
 */
@property(nonatomic,strong)OutGoingData *SubmitData;

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
