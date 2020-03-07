//
//  FieldNamesModel.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/12.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldNamesModel : NSObject

@property(nonatomic, copy)NSString *Reason;

@property(nonatomic, copy)NSString *TravelType; //出差类型列表
@property(nonatomic, copy)NSString *TravelTypeId; //出差类型Id
@property(nonatomic, copy)NSString *TravelCatId;
@property(nonatomic, copy)NSString *TravelCat;

@property(nonatomic, copy)NSString *RelevantDeptId;
@property(nonatomic, copy)NSString *RelevantDept;
@property(nonatomic, copy)NSString *FinancialSourceId;
@property(nonatomic, copy)NSString *FinancialSource;

@property(nonatomic, copy)NSString *Branch;
@property(nonatomic, copy)NSString *BranchId;
@property(nonatomic, copy)NSString *UserReserved1;
@property(nonatomic, copy)NSString *UserReserved2;
@property(nonatomic, copy)NSString *UserReserved3;
@property(nonatomic, copy)NSString *UserReserved4;
@property(nonatomic, copy)NSString *UserReserved5;
@property(nonatomic, copy)NSString *RequestorBusDeptId;
@property(nonatomic, copy)NSString *RequestorBusDept;
@property(nonatomic, copy)NSString *AreaId;
@property(nonatomic, copy)NSString *Area;
@property(nonatomic, copy)NSString *UserLevelId;
@property(nonatomic, copy)NSString *UserLevel;
@property(nonatomic, copy)NSString *RequestorDate;

@property (nonatomic, copy) NSString *LocationId;
@property (nonatomic, copy) NSString *Location;


@property (nonatomic, copy) NSString *ApproverId1;
@property (nonatomic, copy) NSString *ApproverId2;
@property (nonatomic, copy) NSString *ApproverId3;
@property (nonatomic, copy) NSString *ApproverId4;
@property (nonatomic, copy) NSString *ApproverId5;
@property (nonatomic, copy) NSString *UserLevelNo;


@property (nonatomic, copy) NSString *OperatorUserId;
@property (nonatomic, copy) NSString *Operator;
@property (nonatomic, copy) NSString *OperatorDeptId;
@property (nonatomic, copy) NSString *OperatorDept;


@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *jobTitleCode;
@property (nonatomic, copy) NSString *JobTitleLvl;


@property(nonatomic, copy)NSString *FromDate;
@property(nonatomic, copy)NSString *ToDate;
@property(nonatomic, copy)NSString *FromCityCode;
@property(nonatomic, copy)NSString *FromCity;
@property(nonatomic, copy)NSString *FromCityType;
@property(nonatomic, copy)NSString *ToCityCode;
@property(nonatomic, copy)NSString *ToCity;
@property(nonatomic, copy)NSString *FellowOfficers;
@property(nonatomic, copy)NSString *FellowOfficersId;
@property(nonatomic, copy)NSString *ShareDeptIds;
@property(nonatomic, copy)NSString *LocalCyAmount;
@property(nonatomic, copy)NSString *RepayDate;
@property(nonatomic, copy)NSString *CurrencyCode;
@property(nonatomic, copy)NSString *Currency;
@property(nonatomic, copy)NSString *ExchangeRate;
@property(nonatomic, copy)NSString *AdvanceAmount;
@property(nonatomic, copy)NSString *Remark;
@property(nonatomic, assign)NSInteger IsContractsHotel;
@property(nonatomic, copy)NSString *NotContractsReason;
@property(nonatomic, assign)NSInteger IsSupplierBear;
@property(nonatomic, copy)NSString *SupplierEvaluation;
@property(nonatomic, assign)NSInteger IsSelfDrive;
@property(nonatomic, copy)NSString *SelfDriveReason;
@property(nonatomic, assign)NSInteger FirstHandlerUserId;
@property(nonatomic, copy)NSString *FirstHandlerUserName;
@property(nonatomic, copy)NSString *isexpense;
@property(nonatomic, copy)NSString *RequestorUserId;
@property(nonatomic, copy)NSString *RequestorAccount;
@property(nonatomic, copy)NSString *Requestor;
@property(nonatomic, copy)NSString *HRID;
@property(nonatomic, copy)NSString *RequestorDeptId;
@property(nonatomic, copy)NSString *RequestorDept;

@property (nonatomic, copy) NSString *CompanyId;
@property(nonatomic, copy)NSString *Reserved1;
@property(nonatomic, copy)NSString *Reserved2;
@property(nonatomic, copy)NSString *Reserved3;
@property(nonatomic, copy)NSString *Reserved4;
@property(nonatomic, copy)NSString *Reserved5;
@property(nonatomic, copy)NSString *Reserved6;
@property(nonatomic, copy)NSString *Reserved7;
@property(nonatomic, copy)NSString *Reserved8;
@property(nonatomic, copy)NSString *Reserved9;
@property(nonatomic, copy)NSString *Reserved10;

@property(nonatomic, copy)NSString *TicketFee;
@property(nonatomic, copy)NSString *HotelFee;
@property(nonatomic, copy)NSString *TrafficFee;
@property(nonatomic, copy)NSString *MealFee;
@property(nonatomic, copy)NSString *TravelAllowance;
@property(nonatomic, copy)NSString *EntertainmentFee;
@property(nonatomic, copy)NSString *OtherFee;
@property(nonatomic, copy)NSString *EstimatedAmount;


@property (nonatomic, copy) NSString *ExpenseCode;
@property (nonatomic, copy) NSString *ExpenseType;
@property (nonatomic, copy) NSString *ExpenseIcon;
@property (nonatomic, copy) NSString *ExpenseCatCode;
@property (nonatomic, copy) NSString *ExpenseCat;


@property(nonatomic, copy)NSString *ProjId;
@property(nonatomic, copy)NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *IsProjMgr;

@property (nonatomic, copy) NSString *ClientId;
@property (nonatomic, copy) NSString *ClientName;

@property (nonatomic, copy) NSString *CostCenterId;
@property (nonatomic, copy) NSString *CostCenter;
@property (nonatomic, copy) NSString *CostCenterMgrUserId;
@property (nonatomic, copy) NSString *CostCenterMgr;
@property (nonatomic, copy) NSString *IsCostCenterMgr;


@property (nonatomic, copy) NSString *SupplierId;
@property (nonatomic, copy) NSString *SupplierName;
@property (nonatomic, copy) NSString *Attachments;

@property (nonatomic, copy) NSString *IsUseCar;

@property (nonatomic, copy) NSString *CcUsersId;
@property (nonatomic, copy) NSString *CcUsersName;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(FieldNamesModel*)model;

@end
