//
//  CancelFlowFormData.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "CancelFlowData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CancelFlowFormData : FormBaseModel

/**
 撤销申请单相关数据
 */
@property (nonatomic, strong) NSString *str_FormTaskId;
@property (nonatomic, strong) NSString *str_FormSerialNo;
@property (nonatomic, strong) NSString *str_FormReason;
@property (nonatomic, strong) NSString *str_FormFlowCode;
@property (nonatomic, strong) NSString *str_FormFlowName;

/**
 * 拼接数据
 */
@property(nonatomic,strong)CancelFlowData *SubmitData;

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

NS_ASSUME_NONNULL_END
