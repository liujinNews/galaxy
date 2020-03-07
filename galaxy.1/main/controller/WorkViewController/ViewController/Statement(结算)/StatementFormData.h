//
//  StatementFormData.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "StatementData.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatementFormData : FormBaseModel

/**
 合同内容
 */
@property (nonatomic, copy) NSString *str_ContractAppNumber;
@property (nonatomic, copy) NSString *str_ContractNo;
@property (nonatomic, copy) NSString *str_ContractName;
/**
 *  扣款附件图片数组
 */
@property(nonatomic,strong)NSMutableArray *arr_DeduceImgArray;
@property(nonatomic,strong)NSMutableArray *arr_DedueTolArray;
/**
 *  结算附件图片数组
 */
@property(nonatomic,strong)NSMutableArray *arr_SettleImgArray;
@property(nonatomic,strong)NSMutableArray *arr_SettleTolArray;

/**
 * 拼接数据
 */
@property(nonatomic,strong)StatementData *SubmitData;

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
