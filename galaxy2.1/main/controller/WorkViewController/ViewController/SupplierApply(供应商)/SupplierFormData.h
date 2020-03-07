//
//  SupplierFormData.h
//  galaxy
//
//  Created by hfk on 2018/6/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "SupplierData.h"
#import "SupplierDetail.h"

@interface SupplierFormData : FormBaseModel
/**
 供应商分类id
 */
@property (nonatomic, strong) NSString *str_SupplierCatId;
/**
 供应商分类
 */
@property (nonatomic, strong) NSString *str_SupplierCat;
/**
 VMSCode
 */
@property (nonatomic, copy) NSString *str_VmsCode;
/**
 供应商编号是否由系统生成(0是 1人工输入)
 */
@property (nonatomic, assign) NSInteger int_codeIsSystem;
/**
 供应商编号
 */
@property (nonatomic, copy) NSString *str_SupplierCode;
/**
 开户行行号
 */
@property (nonatomic, copy) NSString *str_BankNo;
/**
 开户行编号
 */
@property (nonatomic, copy) NSString *str_BankCode;
/**
 支行行号
 */
@property (nonatomic, copy) NSString *str_CNAPS;
/**
 省
 */
@property (nonatomic, copy) NSString *str_BankProvinceCode;
@property (nonatomic, copy) NSString *str_BankProvince;
/**
 城市code
 */
@property (nonatomic, copy) NSString *str_BankCityCode;
@property (nonatomic, copy) NSString *str_BankCity;

/**
 * 拼接数据
 */
@property(nonatomic,strong)SupplierData *SubmitData;

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
