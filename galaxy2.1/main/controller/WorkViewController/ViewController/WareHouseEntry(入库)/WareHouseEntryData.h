//
//  WareHouseEntryData.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WareHouseEntryData : NSObject

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
@property (nonatomic, copy) NSString *ApproverId1;
@property (nonatomic, copy) NSString *ApproverId2;
@property (nonatomic, copy) NSString *ApproverId3;
@property (nonatomic, copy) NSString *ApproverId4;
@property (nonatomic, copy) NSString *ApproverId5;
@property (nonatomic, copy) NSString *UserLevelNo;
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


@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *StoreDate;
@property (nonatomic, copy) NSString *SupplierId;
@property (nonatomic, copy) NSString *SupplierName;
@property (nonatomic, copy) NSString *ContractAppNumber;
@property (nonatomic, copy) NSString *ContractNo;
@property (nonatomic, copy) NSString *ContractName;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *PurchaseNumber;
@property (nonatomic, copy) NSString *PurchaseInfo;
@property (nonatomic, copy) NSString *ReceivedDate;
@property (nonatomic, copy) NSString *StoreTypeId;
@property (nonatomic, copy) NSString *StoreType;
@property (nonatomic, copy) NSString *InvStorageId;
@property (nonatomic, copy) NSString *InvStorageCode;
@property (nonatomic, copy) NSString *InvStorageName;
@property (nonatomic, copy) NSString *InvStorageAddr;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *CapitalizedAmount;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(WareHouseEntryData *)model;

@end

NS_ASSUME_NONNULL_END
