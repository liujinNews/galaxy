//
//  WorkCardFormData.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "WorkCardData.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkCardFormData : FormBaseModel
/**
 证明人
 */
@property (nonatomic, strong) NSString *str_WitnessId;
@property (nonatomic, strong) NSString *str_WitnessName;

/**
 * 拼接数据
 */
@property(nonatomic,strong)WorkCardData *SubmitData;

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
