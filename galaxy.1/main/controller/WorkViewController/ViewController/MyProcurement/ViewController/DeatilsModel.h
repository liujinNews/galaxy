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
@property (nonatomic,copy)NSString * Name;
@property (nonatomic,copy)NSString * Brand;
@property (nonatomic,copy)NSString * Size;
@property (nonatomic,copy)NSString * Qty;
@property (nonatomic,copy)NSString * Unit;
@property (nonatomic,copy)NSString * Amount;
@property (nonatomic,copy)NSString * Price;
@property (nonatomic,copy)NSString * SupplierId;
@property (nonatomic,copy)NSString * SupplierName;
@property (nonatomic,copy)NSString * Remark;
@property (nonatomic,copy)NSString * Attachments;
@property (nonatomic,copy)NSString * TplId;//模板id
@property (nonatomic,copy)NSString * TplName;//模板名称
@property (nonatomic,copy)NSString * ItemId;//商品id
@property (nonatomic,copy)NSString * ItemCatId;//商品类型id
@property (nonatomic,copy)NSString * ItemCatName;//商品类型名称

//@property (nonatomic,copy)NSString * CompanyId;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
//model 转字典
+ (NSMutableDictionary *) initDicByModel:(DeatilsModel *)model;
@end
