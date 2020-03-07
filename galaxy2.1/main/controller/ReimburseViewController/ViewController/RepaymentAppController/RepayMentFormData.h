//
//  RepayMentFormData.h
//  galaxy
//
//  Created by hfk on 2018/1/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "RepaymentAppData.h"
@interface RepayMentFormData : FormBaseModel
/**
 *  结算方式数组
 */
@property (nonatomic,strong) NSMutableArray *arr_payWay;
/**
 结算方式
 */
@property (nonatomic, strong) NSString *str_PayMode;
/**
 结算方式code
 */
@property (nonatomic, strong) NSString *str_PayCode;

/**
 借款单number
 */
@property (nonatomic, strong) NSString *str_AdvanceId;
/**
 借款单名称
 */
@property (nonatomic, strong) NSString *str_AdvanceInfo;
/**
 * 拼接数据
 */
@property(nonatomic,strong)RepaymentAppData *SubmitData;

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
