//
//  ContractAppData.h
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractAppData : NSObject

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




@property (nonatomic, copy) NSString *ContractNo;         //合同编号
@property (nonatomic, copy) NSString *ContractName;       //合同名称
@property (nonatomic, copy) NSString *Description;        //描述
@property (nonatomic, copy) NSString *ExpenseCatCode;
@property (nonatomic, copy) NSString *ExpenseCat;
@property (nonatomic, copy) NSString *ExpenseCode;
@property (nonatomic, copy) NSString *ExpenseType;
@property (nonatomic, copy) NSString *ExpenseIcon;
@property (nonatomic, copy) NSString *RelateContNo;       //关联合同
@property (nonatomic, copy) NSString *RelateContName;
@property (nonatomic, copy) NSString *RelateTaskId;
@property (nonatomic, copy) NSString *PurchaseNumber;
@property (nonatomic, copy) NSString *PurchaseInfo;
@property (nonatomic, copy) NSString *ContractTypId;      //合同类型
@property (nonatomic, copy) NSString *ContractType;
@property (nonatomic, copy) NSString *TotalAmount;        //合同金额
@property (nonatomic, copy) NSString *CurrencyCode;       //币种
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *ExchangeRate;       //汇率
@property (nonatomic, copy) NSString *LocalCyAmount;      //本位币
@property (nonatomic, copy) NSString *OtherApprover;//会签人员
@property (nonatomic, copy) NSString *OtherApproverIds;//会签人员id
@property (nonatomic, copy) NSString *IsStandardContractTemplate;//是否使用标准合同模版
@property (nonatomic, copy) NSString *CapitalizedAmount;  //大写
@property (nonatomic, copy) NSString *ContractDate;       //签订日期
@property (nonatomic, copy) NSString *EffectiveDate;      //合同有效期
@property (nonatomic, copy) NSString *ExpiryDate;         //合同截止日期
@property (nonatomic, copy) NSString *PayCode;            //付款方式
@property (nonatomic, copy) NSString *PayMode;
@property (nonatomic, copy) NSString *MoneyOrderRate;     //汇款比例
@property (nonatomic, copy) NSString *ProjId;             //项目
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *IsProjMgr;
@property (nonatomic, copy) NSString *ContractCopies;     //签订份数
@property (nonatomic, copy) NSString *PartyA;             //我方单位名称
@property (nonatomic, copy) NSString *PartyAStaff;        //负责人
@property (nonatomic, copy) NSString *PartyATel;          //电话



@property (nonatomic, copy) NSString *PartyB;            //对方单位名称
@property (nonatomic, copy) NSString *PartyBId;
@property (nonatomic, copy) NSString *PartyBType;        //1供应商 否则客户
@property (nonatomic, copy) NSString *PartyBStaff;       //联系人
@property (nonatomic, copy) NSString *PartyBTel;         //电话
@property (nonatomic, copy) NSString *BankName;          //开户银行
@property (nonatomic, copy) NSString *BankAccount;       //银行账号
@property (nonatomic, copy) NSString *PartyBAddress;     //地址
@property (nonatomic, copy) NSString *PartyBPostCode;    //邮编


@property (nonatomic, copy) NSString *InvoiceTitle;
@property (nonatomic, copy) NSString *InvoiceType;
@property (nonatomic, copy) NSString *TaxRate;
@property (nonatomic, copy) NSString *ClientName;
@property (nonatomic, copy) NSString *ClientAddr;
@property (nonatomic, copy) NSString *IbanName;
@property (nonatomic, copy) NSString *IbanAccount;
@property (nonatomic, copy) NSString *IbanAddr;
@property (nonatomic, copy) NSString *SwiftCode;
@property (nonatomic, copy) NSString *BankNo;
@property (nonatomic, copy) NSString *BankADDRESS;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(ContractAppData *)model;


@end

NS_ASSUME_NONNULL_END
