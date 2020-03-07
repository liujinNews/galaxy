//
//  MakeInvoiceFormData.h
//  galaxy
//
//  Created by hfk on 2018/6/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "MakeInvoiceData.h"

@interface MakeInvoiceFormData : FormBaseModel

/**
 付款单
 */
@property (nonatomic, copy) NSString *str_PayNumber;
@property (nonatomic, copy) NSString *str_PayInfo;

/**
 发票类型 （1增值税专用发票 2增值税普通发票 3增值税电子普通发票）
 */
@property (nonatomic, copy) NSString *str_InvoiceType;
/**
 *  发票中图片数组
 */
@property(nonatomic,strong)NSMutableArray *arr_filesArray;
/**
 *  发票总文件数组
 */
@property(nonatomic,strong)NSMutableArray *arr_TolfilesArray;
/**
 * 拼接数据
 */
@property(nonatomic,strong)MakeInvoiceData *SubmitData;

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
