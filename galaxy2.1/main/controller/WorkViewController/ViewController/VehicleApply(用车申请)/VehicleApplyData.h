//
//  VehicleApplyData.h
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleApplyData : NSObject

@property (nonatomic, copy) NSString *OperatorUserId;
@property (nonatomic, copy) NSString *Operator;
@property (nonatomic, copy) NSString *OperatorDeptId;
@property (nonatomic, copy) NSString *OperatorDept;
@property (nonatomic, copy) NSString *RequestorUserId;
@property (nonatomic, copy) NSString *Requestor;
@property (nonatomic, copy) NSString *RequestorAccount;
@property (nonatomic, copy) NSString *RequestorDeptId;
@property (nonatomic, copy) NSString *RequestorDept;
@property (nonatomic, copy) NSString *JobTitleCode;
@property (nonatomic, copy) NSString *JobTitle;
@property (nonatomic, copy) NSString *JobTitleLvl;
@property (nonatomic, copy) NSString *UserLevelId;
@property (nonatomic, copy) NSString *UserLevel;
@property (nonatomic, copy) NSString *HRID;
@property (nonatomic, copy) NSString *BranchId;
@property (nonatomic, copy) NSString *Branch;
@property (nonatomic, copy) NSString *CostCenterId;
@property (nonatomic, copy) NSString *CostCenter;
@property (nonatomic, copy) NSString *CostCenterMgrUserId;
@property (nonatomic, copy) NSString *CostCenterMgr;
@property (nonatomic, copy) NSString *RequestorBusDeptId;
@property (nonatomic, copy) NSString *RequestorBusDept;
@property (nonatomic, copy) NSString *AreaId;
@property (nonatomic, copy) NSString *Area;
@property (nonatomic, copy) NSString *LocationId;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *UserReserved1;
@property (nonatomic, copy) NSString *UserReserved2;
@property (nonatomic, copy) NSString *UserReserved3;
@property (nonatomic, copy) NSString *UserReserved4;
@property (nonatomic, copy) NSString *UserReserved5;
@property (nonatomic, copy) NSString *UserLevelNo;
@property (nonatomic, copy) NSString *ApproverId1;
@property (nonatomic, copy) NSString *ApproverId2;
@property (nonatomic, copy) NSString *ApproverId3;
@property (nonatomic, copy) NSString *ApproverId4;
@property (nonatomic, copy) NSString *ApproverId5;
@property (nonatomic, copy) NSString *RequestorDate;


@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Attachments;
@property (nonatomic, copy) NSString *FirstHandlerUserId;
@property (nonatomic, copy) NSString *FirstHandlerUserName;
@property (nonatomic, copy) NSString *CompanyId;
@property (nonatomic, copy) NSString *Reserved1;
@property (nonatomic, copy) NSString *Reserved2;
@property (nonatomic, copy) NSString *Reserved3;
@property (nonatomic, copy) NSString *Reserved4;
@property (nonatomic, copy) NSString *Reserved5;
@property (nonatomic, copy) NSString *Reserved6;
@property (nonatomic, copy) NSString *Reserved7;
@property (nonatomic, copy) NSString *Reserved8;
@property (nonatomic, copy) NSString *Reserved9;
@property (nonatomic, copy) NSString *Reserved10;
@property (nonatomic, copy) NSString *CcUsersId;
@property (nonatomic, copy) NSString *CcUsersName;



@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;

@property (nonatomic, copy) NSString *ClientId;
@property (nonatomic, copy) NSString *ClientName;
@property (nonatomic, copy) NSString *SupplierId;
@property (nonatomic, copy) NSString *SupplierName;

@property (nonatomic, copy) NSString *CarNo;    //车辆
@property (nonatomic, copy) NSString *CarDesc;
@property (nonatomic, copy) NSString *Driver;    //司机
@property (nonatomic, copy) NSString *DriverTel;    //司机电话
@property (nonatomic, copy) NSString *Mileage;    //行驶里程(KM)

@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *DepartCity;
@property (nonatomic, copy) NSString *BackCity;
@property (nonatomic, copy) NSString *VehicleDate;
@property (nonatomic, copy) NSString *BackDate;
@property (nonatomic, copy) NSString *VehicleStaffId;
@property (nonatomic, copy) NSString *VehicleStaff;

@property (nonatomic, copy) NSString *EntourageId;
@property (nonatomic, copy) NSString *Entourage;
@property (nonatomic, copy) NSString *VehicleTypeId;
@property (nonatomic, copy) NSString *VehicleType;
@property (nonatomic, copy) NSString *VehicleTypeFlag;
@property (nonatomic, copy) NSString *DriverUserId;
@property (nonatomic, copy) NSString *InitialMileage;
@property (nonatomic, copy) NSString *EndMileage;
@property (nonatomic, copy) NSString *PteCarAllowance;
@property (nonatomic, copy) NSString *FuelBills;
@property (nonatomic, copy) NSString *Pontage;
@property (nonatomic, copy) NSString *ParkingFee;
@property (nonatomic, copy) NSString *OtherFee;
@property (nonatomic, copy) NSString *TotalBudget;
@property (nonatomic, copy) NSString *IsPassNight;
@property (nonatomic, copy) NSString *TravelNumber;
@property (nonatomic, copy) NSString *TravelInfo;
@property (nonatomic, copy) NSString *DispatcherReview;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(VehicleApplyData *)model;


@end
