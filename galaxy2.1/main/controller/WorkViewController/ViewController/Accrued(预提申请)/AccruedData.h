//
//  AccruedData.h
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccruedData : NSObject

@property (nonatomic, copy) NSString *OperatorUserId; //填表人
@property (nonatomic, copy) NSString *OperatorDeptId;  //填表人部门
@property (nonatomic, copy) NSString *RequestorUserId; //申请人
@property (nonatomic, copy) NSString *RequestorDeptId; //部门
@property (nonatomic, copy) NSString *JobTitleCode; //职位
@property (nonatomic, copy) NSString *UserLevelId; //员工级别
@property (nonatomic, copy) NSString *HRID;       //工号
@property (nonatomic, copy) NSString *BranchId;  //机构
@property (nonatomic, copy) NSString *AreaId; //地区
@property (nonatomic, copy) NSString *LocationId;  //办事处
@property (nonatomic, copy) NSString *CostCenterId;  //成本中心
@property (nonatomic, copy) NSString *RequestorDate;  //申请日期
@property (nonatomic, copy) NSString *Reason;  //标题
@property (nonatomic, copy) NSString *Remark;  //备注
@property (nonatomic, copy) NSString *Attachments;  //附件
@property (nonatomic, copy) NSString *CcUsersId;  //抄送人
@property (nonatomic, copy) NSString *RequestorBusDept;  //业务部门
@property (nonatomic, copy) NSString *Branch;
@property (nonatomic, copy) NSString *CostCenter;
@property (nonatomic, copy) NSString *CostCenterMgrUserId;
@property (nonatomic, copy) NSString *CostCenterMgr;
@property (nonatomic, copy) NSString *UserLevel;
@property (nonatomic, copy) NSString *UserLevelNo;
@property (nonatomic, copy) NSString *Area;
@property (nonatomic, copy) NSString *JobTitle;
@property (nonatomic, copy) NSString *JobTitleLvl;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *Operator;
@property (nonatomic, copy) NSString *OperatorDept;
@property (nonatomic, copy) NSString *RequestorAccount;
@property (nonatomic, copy) NSString *Requestor;
@property (nonatomic, copy) NSString *RequestorDept;
@property (nonatomic, copy) NSString *CompanyId;
@property (nonatomic, copy) NSString *UserReserved1;
@property (nonatomic, copy) NSString *UserReserved2;
@property (nonatomic, copy) NSString *UserReserved3;
@property (nonatomic, copy) NSString *UserReserved4;
@property (nonatomic, copy) NSString *UserReserved5;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(AccruedData *)model;




@end

NS_ASSUME_NONNULL_END
