//
//  buildCellInfo.h
//  galaxy
//
//  Created by 赵碚 on 15/7/29.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, buildCellType) {
    travelApplyForType,
    travelCostReimburseType,
    liveCostReimburseType,
    messageCenterType
} ;
@interface buildCellInfo : NSObject
@property(nonatomic, assign)buildCellType type;

@property(nonatomic,copy)NSString * companyId;
@property(nonatomic,copy)NSString * contact;
@property(nonatomic,copy)NSString * jobTitle;
@property(nonatomic,copy)NSString * jobTitleCode;
@property(nonatomic,copy)NSString * jobTitleLvl;
@property(nonatomic,copy)NSString * photoGraph;
@property(nonatomic,copy)NSString * requestor;
@property(nonatomic,assign)int gender;
@property(nonatomic,copy)NSString * email;

@property(nonatomic,copy)NSString * requestorAccount;
@property(nonatomic,copy)NSString * requestorDept;
@property(nonatomic,copy)NSString * requestorDeptId;
@property(nonatomic,copy)NSString * requestorHRID;
@property(nonatomic,assign)NSInteger  requestorUserId;

@property(nonatomic,copy)NSString * guihua;//首字母
@property(nonatomic,copy)NSString * isClick;//是否被选中
@property(nonatomic, assign)NSInteger apply;//是否申请人员

@property(nonatomic,copy)NSString * branchId;
@property(nonatomic,copy)NSString * branch;
@property(nonatomic,copy)NSString * bankName;
@property(nonatomic,copy)NSString * bnfId;
@property(nonatomic,copy)NSString * bnfName;
@property(nonatomic,copy)NSString * lineManagerId;

@property(nonatomic,copy)NSString * reserved1;
@property(nonatomic,copy)NSString * reserved2;
@property(nonatomic,copy)NSString * reserved3;
@property(nonatomic,copy)NSString * reserved4;
@property(nonatomic,copy)NSString * reserved5;
@property(nonatomic,copy)NSString * reserved6;
@property(nonatomic,copy)NSString * reserved7;
@property(nonatomic,copy)NSString * reserved8;
@property(nonatomic,copy)NSString * reserved9;
@property(nonatomic,copy)NSString * reserved10;
@property(nonatomic,copy)NSString * approverId1;
@property(nonatomic,copy)NSString * approverId2;
@property(nonatomic,copy)NSString * approverId3;
@property(nonatomic,copy)NSString * approverId4;
@property(nonatomic,copy)NSString * approverId5;
@property(nonatomic,copy)NSString * area;
@property(nonatomic,copy)NSString * accountName;
@property(nonatomic,copy)NSString * requestorBusDeptId;

@property(nonatomic,copy)NSString * location;
@property(nonatomic,copy)NSString * costCenter;
@property(nonatomic,copy)NSString * userLevelName;
@property(nonatomic,copy)NSString * userLevelId;
@property(nonatomic,copy)NSString * userLevelNo;
@property(nonatomic,copy)NSString * costCenterName;

@property(nonatomic,copy)NSString * userLevel;
@property(nonatomic,copy)NSString * hrid;
@property(nonatomic,copy)NSString * areaName;
@property(nonatomic,copy)NSString * requestorBusDept;
@property(nonatomic,copy)NSString * userDspName;
@property(nonatomic,copy)NSString * locationName;
@property(nonatomic,copy)NSString * bankAccount;


+ (void)GetcompanyBookDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2 cleanSelf:(BOOL)cleanSelf;

+ (NSMutableDictionary *) initDicByModel:(buildCellInfo*)model;

+ (buildCellInfo *) retrunByDic:(NSDictionary *)dic;

+ (void)GetcompanyAddressDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2;

+ (void)GetcompanyAddressByNoDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2;


@end
