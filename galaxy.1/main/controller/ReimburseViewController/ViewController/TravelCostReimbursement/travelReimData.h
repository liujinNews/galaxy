//
//  travelReimData.h
//  galaxy
//
//  Created by hfk on 15/10/13.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface travelReimData : NSObject

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
@property (nonatomic, copy) NSString *IsCostCenterMgr;
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


//@property (nonatomic, copy) NSString *TwoHandlerUserId;
//@property (nonatomic, copy) NSString *TwoHandlerUserName;


@property (nonatomic, copy) NSString *Contact;
@property (nonatomic, copy) NSString *TravelInfo;
@property (nonatomic, copy) NSString *TravelNumber;
@property (nonatomic, copy) NSString *FromCityCode;
@property (nonatomic, copy) NSString *FromCity;
@property (nonatomic, copy) NSString *ToCityCode;
@property (nonatomic, copy) NSString *ToCity;
@property (nonatomic, copy) NSString *TravelTypeId;
@property (nonatomic, copy) NSString *TravelType;
@property (nonatomic, copy) NSString *RelevantDeptId;
@property (nonatomic, copy) NSString *RelevantDept;
@property (nonatomic, copy) NSString *FinancialSourceId;
@property (nonatomic, copy) NSString *FinancialSource;
@property (nonatomic, copy) NSString *StaffOutNumber;
@property (nonatomic, copy) NSString *StaffOutInfo;
@property (nonatomic, copy) NSString *VehicleNumber;
@property (nonatomic, copy) NSString *VehicleInfo;
@property (nonatomic, copy) NSString *ClaimTypeId;
@property (nonatomic, copy) NSString *ClaimType;
@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *CurrencyCode;
@property (nonatomic, copy) NSString *NumberOfDocuments;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *SumAmount;
@property (nonatomic, copy) NSString *CorpPayAmount;
@property (nonatomic, copy) NSString *CapitalizedAmount;
@property (nonatomic, copy) NSString *LoanAmount;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *IsProjMgr;
@property (nonatomic, copy) NSString *AdvanceInfo;
@property (nonatomic, copy) NSString *AdvanceNumber;
@property (nonatomic, copy) NSString *ActualAmount;
@property (nonatomic, copy) NSString *NoInvAmount;

@property (nonatomic, copy) NSString *OverBudReason;
@property (nonatomic, copy) NSString *EstimatedAmount;

@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *BudgetInfo;

@property (nonatomic, copy) NSString *ClientId;
@property (nonatomic, copy) NSString *ClientName;

@property (nonatomic, copy) NSString *SupplierId;
@property (nonatomic, copy) NSString *SupplierName;

@property (nonatomic, copy) NSString *Payee;
@property (nonatomic, copy) NSString *CredentialType;
@property (nonatomic, copy) NSString *IdentityCardId;
@property (nonatomic, copy) NSString *BankAccount;
@property (nonatomic, copy) NSString *BankOutlets;
@property (nonatomic, copy) NSString *BankName;
@property (nonatomic, copy) NSString *BankNo;
@property (nonatomic, copy) NSString *BankCode;
@property (nonatomic, copy) NSString *CNAPS;
@property (nonatomic, copy) NSString *BankProvinceCode;
@property (nonatomic, copy) NSString *BankProvince;
@property (nonatomic, copy) NSString *BankCityCode;
@property (nonatomic, copy) NSString *BankCity;


@property (nonatomic, copy) NSString *Projbudinfo;
@property (nonatomic, copy) NSString *Projbuddata;
@property (nonatomic, copy) NSString *Overlimit;

@property (nonatomic, copy) NSString *IsOverBud;
@property (nonatomic, copy) NSString *IsOverStd;

@property (nonatomic, copy) NSString *BnfId;
@property (nonatomic, copy) NSString *BnfName;

@property (nonatomic, copy) NSString *FellowOfficers;
@property (nonatomic, copy) NSString *FellowOfficersId;
@property (nonatomic, copy) NSString *FromDate;
@property (nonatomic, copy) NSString *ToDate;

@property (nonatomic, copy) NSString *IsExpExpired;
@property (nonatomic, copy) NSString *IsOverStd2;
@property (nonatomic, copy) NSString *IsDeptBearExps;
@property (nonatomic, copy) NSString *ReversalType;

@property (nonatomic, copy) NSString *ShareDeptIds;
@property (nonatomic, copy) NSString *ShareProjIds;
@property (nonatomic, copy) NSString *ShareProjMgrIds;
@property (nonatomic, copy) NSString *ExpenseCodes;
@property (nonatomic, copy) NSString *ExpenseTypes;

@property (nonatomic, copy) NSString *InvLoanAmount;
@property (nonatomic, copy) NSString *InvTotalAmount;
@property (nonatomic, copy) NSString *InvActualAmount;

@property (nonatomic, copy) NSString *CostShareApproval1;
@property (nonatomic, copy) NSString *CostShareApproval2;
@property (nonatomic, copy) NSString *CostShareApproval3;

@property (nonatomic, copy) NSString *SubstituteInvoice;

@property (nonatomic, copy) NSString *CostCenterMgrUserIds;



+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(travelReimData*)model;
@end
