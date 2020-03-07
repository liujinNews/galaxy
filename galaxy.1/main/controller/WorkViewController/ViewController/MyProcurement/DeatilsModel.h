//
//  DeatilsModel.h
//  galaxy
//
//  Created by hfk on 16/4/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeatilsViewCell.h"
@interface DeatilsModel : NSObject
@property (nonatomic,copy)NSString *Name;
@property (nonatomic,copy)NSString *Brand;
@property (nonatomic,copy)NSString *Size;
@property (nonatomic,copy)NSString *Qty;
@property (nonatomic,copy)NSString *Unit;
@property (nonatomic,copy)NSString *Amount;
@property (nonatomic,copy)NSString *Price;
@property (nonatomic,copy)NSString *SupplierId;
@property (nonatomic,copy)NSString *SupplierName;//供应商
@property (nonatomic,copy)NSString *PurchaseType;
@property (nonatomic,copy)NSString *Remark;
@property (nonatomic,copy)NSString *Attachments;//附件
@property (nonatomic,copy)NSString *TplId;//模板id
@property (nonatomic,copy)NSString *TplName;//模板名称
@property (nonatomic,copy)NSString *ItemId;//商品id
@property (nonatomic,copy)NSString *ItemCatId;//商品类型id
@property (nonatomic,copy)NSString *ItemCatName;//商品类型名称
@property (nonatomic,copy)NSString *Code;

@property (nonatomic,copy)NSString *No;//序号
@property (nonatomic,copy)NSString *Description;//采购项目名称
@property (nonatomic,copy)NSString *CurrencyCode;//币种
@property (nonatomic,copy)NSString *Currency;
@property (nonatomic,copy)NSString *ExchangeRate;//汇率
@property (nonatomic,copy)NSString *LocalCyAmount;//本位币金额
@property (nonatomic,copy)NSString *ExpenseCode;//费用类别
@property (nonatomic,copy)NSString *FeeAppNumber;//关联费用类别
@property (nonatomic,copy)NSString *FeeAppInfo;
@property (nonatomic,copy)NSString *Remarks;

//费用类别
@property (nonatomic,copy)NSString * ExpenseCatCode;
@property (nonatomic,copy)NSString * ExpenseCat;
@property (nonatomic,copy)NSString * ExpenseIcon;
@property (nonatomic,copy)NSString * ExpenseType;
//关联费用申请
@property (nonatomic,copy)NSString * str_FeeAppInfo;
@property (nonatomic,copy)NSString * str_FeeAppNumber;

@property (nonatomic,copy)NSString *BusinessRequirement;//具体功能/业务需求
@property (nonatomic,copy)NSString *TechRequirement;//具体技术需求
@property (nonatomic,copy)NSString *ServiceRequirement;//服务需求及其他

//上传附件图片数组
@property (nonatomic,strong)NSMutableArray *arr_FilesTotal;
@property (nonatomic,strong)NSMutableArray *arr_FilesImage;

@property (nonatomic,copy)NSString *IsCrossDepartment;//是否跨部门
//@property (nonatomic,copy)NSString *str_IsCrossDepartment;//是否跨部门描述
@property (nonatomic,copy)NSString *Reason;//申请单一来源原因


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(DeatilsModel *)model;
@end
