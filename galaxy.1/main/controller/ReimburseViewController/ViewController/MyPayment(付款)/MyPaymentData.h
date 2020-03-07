//
//  MyPaymentData.h
//  galaxy
//
//  Created by hfk on 2018/11/30.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPaymentData : NSObject

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


@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *PaymentTypId;
@property (nonatomic, copy) NSString *PaymentTyp;
@property (nonatomic, copy) NSString *PaymentNumber;
@property (nonatomic, copy) NSString *PaymentInfo;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *CapitalizedAmount;
@property (nonatomic, copy) NSString *CurrencyCode;
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *ExchangeRate;
@property (nonatomic, copy) NSString *LocalCyAmount;
@property (nonatomic, copy) NSString *PayMode;
@property (nonatomic, copy) NSString *PayCode;
@property (nonatomic, copy) NSString *PaymentDate;
@property (nonatomic, copy) NSString *ExpenseCatCode;
@property (nonatomic, copy) NSString *ExpenseCat;
@property (nonatomic, copy) NSString *ExpenseCode;
@property (nonatomic, copy) NSString *ExpenseType;
@property (nonatomic, copy) NSString *ExpenseIcon;
@property (nonatomic, copy) NSString *ExpenseDesc;
@property (nonatomic, copy) NSString *InvoiceType;
@property (nonatomic, copy) NSString *InvoiceTypeName;
@property (nonatomic, copy) NSString *InvoiceTypeCode;
@property (nonatomic, copy) NSString *AirTicketPrice;
@property (nonatomic, copy) NSString *DevelopmentFund;
@property (nonatomic, copy) NSString *FuelSurcharge;
@property (nonatomic, copy) NSString *OtherTaxes;
@property (nonatomic, copy) NSString *AirlineFuelFee;
@property (nonatomic, copy) NSString *Tax;
@property (nonatomic, copy) NSString *TaxRate;
@property (nonatomic, copy) NSString *ExclTax;
@property (nonatomic, copy) NSString *FeeAppNumber;
@property (nonatomic, copy) NSString *FeeAppInfo;
@property (nonatomic, copy) NSString *EstimatedAmount;
@property (nonatomic, copy) NSString *OverBudReason;
@property (nonatomic, copy) NSString *PurchaseNumber;
@property (nonatomic, copy) NSString *PurchaseInfo;
@property (nonatomic, copy) NSString *PurAmount;
@property (nonatomic, copy) NSString *PurOverAmount;
@property (nonatomic, copy) NSString *RelateContNo;
@property (nonatomic, copy) NSString *RelateContInfo;
@property (nonatomic, copy) NSString *RelateContTotalAmount;
@property (nonatomic, copy) NSString *RelateContAmountPaid;
@property (nonatomic, copy) NSString *RelateContFlowCode;
@property (nonatomic, copy) NSString *ContractAppNumber;
@property (nonatomic, copy) NSString *ContractName;
@property (nonatomic, copy) NSString *ContractNo;
@property (nonatomic, copy) NSString *ContractAmount;
@property (nonatomic, copy) NSString *ContractOverAmount;
@property (nonatomic, copy) NSString *ContEffectiveDate;
@property (nonatomic, copy) NSString *ContExpiryDate;
@property (nonatomic, copy) NSString *ContPmtTyp;
@property (nonatomic, copy) NSString *ContPmtTypId;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *IsProjMgr;
@property (nonatomic, copy) NSString *ProjectActivityLv1;
@property (nonatomic, copy) NSString *ProjectActivityLv1Name;
@property (nonatomic, copy) NSString *ProjectActivityLv2;
@property (nonatomic, copy) NSString *ProjectActivityLv2Name;
@property (nonatomic, copy) NSString *BnfId;
@property (nonatomic, copy) NSString *BnfName;
@property (nonatomic, copy) NSString *ClientId;
@property (nonatomic, copy) NSString *ClientName;
@property (nonatomic, copy) NSString *BeneficiaryId;
@property (nonatomic, copy) NSString *Beneficiary;
@property (nonatomic, copy) NSString *VmsCode;
@property (nonatomic, copy) NSString *BankAccount;
@property (nonatomic, copy) NSString *BankOutlets;
@property (nonatomic, copy) NSString *DepositBank;
@property (nonatomic, copy) NSString *BankNo;
@property (nonatomic, copy) NSString *BankCode;
@property (nonatomic, copy) NSString *CNAPS;
@property (nonatomic, copy) NSString *BankProvinceCode;
@property (nonatomic, copy) NSString *BankProvince;
@property (nonatomic, copy) NSString *BankCityCode;
@property (nonatomic, copy) NSString *BankCity;
@property (nonatomic, copy) NSString *BankHeadOffice;
@property (nonatomic, copy) NSString *IbanClientName;
@property (nonatomic, copy) NSString *IbanClientAddr;
@property (nonatomic, copy) NSString *IbanName;
@property (nonatomic, copy) NSString *IbanAccount;
@property (nonatomic, copy) NSString *IbanAddr;
@property (nonatomic, copy) NSString *IbanSwiftCode;
@property (nonatomic, copy) NSString *IbanNo;
@property (nonatomic, copy) NSString *IbanADDRESS;
@property (nonatomic, copy) NSString *RefInvoiceAmount;
@property (nonatomic, copy) NSString *RefInvoiceType;
@property (nonatomic, copy) NSString *RefInvoiceTypeName;
@property (nonatomic, copy) NSString *RefInvoiceTypeCode;
@property (nonatomic, copy) NSString *RefTaxRate;
@property (nonatomic, copy) NSString *RefTax;
@property (nonatomic, copy) NSString *RefExclTax;
@property (nonatomic, copy) NSString *HasInvoice;
@property (nonatomic, copy) NSString *NoInvReason;
@property (nonatomic, copy) NSString *IsDeptBearExps;
@property (nonatomic, copy) NSString *Files;



@property (nonatomic, copy) NSString *Projbudinfo;
@property (nonatomic, copy) NSString *Projbuddata;
@property (nonatomic, copy) NSString *IsOverBud;


@property (nonatomic, copy) NSString *ShareDeptIds;

@property (nonatomic, copy) NSString *ExpenseCodes;
@property (nonatomic, copy) NSString *ExpenseTypes;

@property (nonatomic, copy) NSString *BudgetInfo;


@property (nonatomic, copy) NSString *AccountItemCode;
@property (nonatomic, copy) NSString *AccountItem;

@property (nonatomic, copy) NSString *CostShareApproval1;
@property (nonatomic, copy) NSString *CostShareApproval2;
@property (nonatomic, copy) NSString *CostShareApproval3;

@property (nonatomic, copy) NSString *IsExpExpired;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(MyPaymentData *)model;




@end

NS_ASSUME_NONNULL_END
