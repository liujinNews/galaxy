//
//  ReceiptData.h
//  galaxy
//
//  Created by hfk on 2018/6/3.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptData : NSObject

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
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *CapitalizedAmount;
@property (nonatomic, copy) NSString *CurrencyCode;
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *ExchangeRate;
@property (nonatomic, copy) NSString *LocalCyAmount;
@property (nonatomic, copy) NSString *ReceiveDate;
@property (nonatomic, copy) NSString *ReceiveMethod;
@property (nonatomic, copy) NSString *ReceiveMethodId;
@property (nonatomic, copy) NSString *ReceiveType;
@property (nonatomic, copy) NSString *ReceiveTypeId;
@property (nonatomic, copy) NSString *ContractAppNumber;//合同任务号
@property (nonatomic, copy) NSString *ContractNo;//合同编号
@property (nonatomic, copy) NSString *ContractName;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *ContEffectiveDate;
@property (nonatomic, copy) NSString *ContExpiryDate;
@property (nonatomic, copy) NSString *ContAmount;
@property (nonatomic, copy) NSString *RepaidAmount;
@property (nonatomic, copy) NSString *UnpaidAmount;
@property (nonatomic, copy) NSString *InvoiceAppNumber;//开票任务号
@property (nonatomic, copy) NSString *InvoiceAppInfo;
@property (nonatomic, copy) NSString *ClientId;
@property (nonatomic, copy) NSString *ClientName;
@property (nonatomic, copy) NSString *BankName;
@property (nonatomic, copy) NSString *BankAccount;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(ReceiptData *)model;


@end
