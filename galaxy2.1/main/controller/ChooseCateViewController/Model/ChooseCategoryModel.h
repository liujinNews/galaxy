//
//  ChooseCategoryModel.h
//  galaxy
//
//  Created by hfk on 16/4/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseCategoryModel : NSObject
/**
 *  共用id
 */
@property (nonatomic,strong)NSString *Id;


/**
 *  支付方式
 */
@property (copy, nonatomic) NSString *payMode;
@property (copy, nonatomic) NSString *payCode;

/**
 *  采购类型
 */
@property (copy, nonatomic) NSString * purchaseCode;
@property (copy, nonatomic) NSString * purchaseType;

@property (nonatomic,copy)NSString *no;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *typPurp;

/**
 *  请假类型
 */
@property (nonatomic,copy)NSString *leaveCode;
@property (nonatomic,copy)NSString *leaveType;
@property (nonatomic,copy)NSString *limitDay;

/**
 *  部门类型
 */
@property (nonatomic,copy)NSString *groupId;
@property (nonatomic,copy)NSString *groupName;
@property (nonatomic,copy)NSString *jobTitle;
@property (nonatomic,copy)NSString *jobTitleCode;
@property (nonatomic,copy)NSString *jobTitleLvl;
@property (nonatomic,copy)NSString *groupCode;
@property (nonatomic,copy)NSString *isCheck;
@property (nonatomic,copy)NSString *showBranch;

/**
 *  费用类型大类(差旅/日常/其他)
 */
@property (nonatomic,copy)NSString *addCostType;
@property (nonatomic,copy)NSString *addCostCode;

/**
 报销类型
 */
@property (nonatomic,copy)NSString *claimType ;
@property (nonatomic,copy)NSString *isRelation ;
@property (nonatomic,copy)NSString *setApprover ;

/**
 车辆信息
 */
@property (nonatomic,copy)NSString *carDesc ;
@property (nonatomic,copy)NSString *carNo ;

/**
 合同类型
 */
@property (nonatomic,copy)NSString *contractType ;
@property (nonatomic,copy)NSString *contractTypeEn ;
@property (nonatomic,copy)NSString *catId ;
@property (nonatomic,copy)NSString *catName;

/**
 供应商分类
 */
@property (nonatomic,copy)NSString *code;

/**
 用车类型
 */
@property (nonatomic,copy)NSString *type;

/**
 角色
 */
@property (nonatomic,copy)NSString *roleId;
@property (nonatomic,copy)NSString *roleName;
@property (nonatomic,copy)NSString *roleNameEn;

/**
 省份
 */
@property (nonatomic,copy)NSString *provinceCode;
@property (nonatomic,copy)NSString *provinceName;

/**
 城市
 */
@property (nonatomic,copy)NSString *cityCode;
@property (nonatomic,copy)NSString *cityName;


+ (void)getPayWayByArray:(NSArray *)resultArray Array:(NSMutableArray *)array;
+ (void)getpurchaseTypeByArray:(NSArray *)resultArray Array:(NSMutableArray *)array;
+ (void)getLeaveTypeByArray:(NSArray *)resultArray Array:(NSMutableArray *)array;

+(void)getDepartmentNewByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;

+(void)getClaimType:(NSArray *)resultArray Array:(NSMutableArray *)array;

+(void)getCarInfoByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)getSupplierCatByArray:(NSArray *)resultArray Array:(NSMutableArray *)array;

+(void)getProductCatListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;


+ (void)getNewPayWayByArray:(NSArray *)resultArray Array:(NSMutableArray *)array;

+(void)getVehicleTypListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;

+(void)getAttendanceRoleListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;

+(void)getSupplierCatsListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;

+(void)getProvincesListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;

+(void)getCitysListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
