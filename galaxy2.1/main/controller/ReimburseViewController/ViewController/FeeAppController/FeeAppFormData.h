//
//  FeeAppFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "FeeAppData.h"
@interface FeeAppFormData : FormBaseModel

/**
 明细费用类别点击行数
 */
@property (nonatomic,assign)NSInteger int_DetailTypeIndex;

/**
 * 拼接数据
 */
@property(nonatomic,strong)FeeAppData *SubmitData;
/**
 *  申请类型
*/
@property(nonatomic,strong)NSString *str_ApplicationType;
/**
 *  费用申请单Id
 */
//@property(nonatomic,strong)NSString *str_FeeAppNumber;
/**
 *  费用申请单题目
 */
@property(nonatomic,strong)NSString *str_FeeAppInfo;
/**
 * 预计金额
 */
@property(nonatomic,strong)NSString *str_EstimatedAmount;
/**
 * 本位币金额
*/
@property(nonatomic,strong)NSString *str_LocalCyAmount;
/**
 * 资本性支出
*/
@property(nonatomic,strong)NSString *str_CapexAmount;
/**
 * 费用
*/
@property(nonatomic,strong)NSString *str_CostAmount;
/**
 * 业务经理
*/
@property (nonatomic,strong)NSString *str_BusinessMgr;
/**
 * 业务经理
*/
@property (nonatomic,strong)NSString *str_BusinessMgrId;
/**
 * 业务负责人
*/
@property (nonatomic,strong)NSString *str_BusinessOwner;
/**
 * 业务负责人ID
*/
@property (nonatomic,strong)NSString *str_BusinessOwnerId;
/**
 * 单据可见范围
*/
@property (nonatomic,strong)NSString *str_FormScope;
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
