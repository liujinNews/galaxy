//
//  costCenterData.h
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface costCenterData : NSObject
@property(nonatomic,copy)NSString * companyId;
@property(nonatomic,copy)NSString * idd;
@property(nonatomic,copy)NSString * costCenter;
@property(nonatomic,copy)NSString * costCenterEn;
@property(nonatomic,copy)NSString * costCenterMgrUserId;
@property(nonatomic,copy)NSString * costCenterMgr;




+ (void)GetCostCenterListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

//采购类型
@property(nonatomic,copy)NSString * no;
@property(nonatomic,copy)NSString * purchaseCode;
@property(nonatomic,copy)NSString * type;
+ (void)GetProcurementListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

//出差类型
@property(nonatomic,copy)NSString * travelType;
@property(nonatomic,copy)NSString * travelTypeEn;
+ (void)GetTravelTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;



@end
