//
//  SupplierData.h
//  galaxy
//
//  Created by hfk on 2018/6/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplierData : NSObject

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


@property (nonatomic, copy) NSString *SupplierName;
@property (nonatomic, copy) NSString *SupplierCode;
@property (nonatomic, copy) NSString *SupplierCatId;
@property (nonatomic, copy) NSString *SupplierCat;
@property (nonatomic, copy) NSString *VmsCode;
@property (nonatomic, copy) NSString *InvBankAccount;
@property (nonatomic, copy) NSString *BankOutlets;
@property (nonatomic, copy) NSString *InvBankName;
@property (nonatomic, copy) NSString *BankNo;
@property (nonatomic, copy) NSString *BankCode;
@property (nonatomic, copy) NSString *CNAPS;
@property (nonatomic, copy) NSString *BankProvinceCode;
@property (nonatomic, copy) NSString *BankProvince;
@property (nonatomic, copy) NSString *BankCityCode;
@property (nonatomic, copy) NSString *BankCity;
@property (nonatomic, copy) NSString *InvContacts;
@property (nonatomic, copy) NSString *InvTel;
@property (nonatomic, copy) NSString *InvAddr;
@property (nonatomic, copy) NSString *InvZipCode;



+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(SupplierData *)model;


@end
