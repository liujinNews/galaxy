//
//  InvoiceAppData.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceAppData : NSObject

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

@property (nonatomic, copy) NSString *Reason;
@property (nonatomic, copy) NSString *InvContent;
@property (nonatomic, copy) NSString *InvAmount;
@property (nonatomic, copy) NSString *InvType;
@property (nonatomic, copy) NSString *TaxRate;
@property (nonatomic, copy) NSString *InvFromDate;
@property (nonatomic, copy) NSString *InvToDate;
@property (nonatomic, copy) NSString *InvExpectedDate;
@property (nonatomic, copy) NSString *PlanPaymentDate;
@property (nonatomic, copy) NSString *ContractNo;
@property (nonatomic, copy) NSString *ContractAppNumber;
@property (nonatomic, copy) NSString *ContractName;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *ReceiveBillNumber;
@property (nonatomic, copy) NSString *ReceiveBillInfo;
@property (nonatomic, copy) NSString *ContractDate;
@property (nonatomic, copy) NSString *EffectiveDate;
@property (nonatomic, copy) NSString *ExpiryDate;
@property (nonatomic, copy) NSString *ContractAmount;
@property (nonatomic, copy) NSString *InvoicedAmount;
@property (nonatomic, copy) NSString *UnbilledAmount;
@property (nonatomic, copy) NSString *ClientId;
@property (nonatomic, copy) NSString *ClientName;
@property (nonatomic, copy) NSString *TaxNumber;
@property (nonatomic, copy) NSString *BankName;
@property (nonatomic, copy) NSString *BankAccount;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *Tel;
@property (nonatomic, copy) NSString *ReceiverName;
@property (nonatomic, copy) NSString *ReceiverTel;
@property (nonatomic, copy) NSString *ReceiverAddress;
@property (nonatomic, copy) NSString *ReceiverPostCode;
//@property (nonatomic, copy) NSString *Payback;
//@property (nonatomic, copy) NSString *PaybackAccount;
//@property (nonatomic, copy) NSString *InvNumber;
//@property (nonatomic, copy) NSString *InvDate;
//@property (nonatomic, copy) NSString *InvFiles;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(InvoiceAppData *)model;


@end

NS_ASSUME_NONNULL_END
