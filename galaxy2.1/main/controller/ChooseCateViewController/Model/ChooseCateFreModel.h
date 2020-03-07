//
// ChooseCateFreModel.h
// galaxy
//
// Created by hfk on 2017/6/21.
// Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseCateFreModel : NSObject
//项目
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *funder;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *projMgr;
@property (nonatomic, copy) NSString *projMgrUserId;
@property (nonatomic, copy) NSString *projName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *projTyp;
@property (nonatomic, copy) NSString *projTypId;
@property (nonatomic, copy) NSString *purchaseNumber;
@property (nonatomic, copy) NSString *purchaseInfo;


//成本中心
@property (nonatomic, copy) NSString *costCenter;
@property (nonatomic, copy) NSString *costCenterMgrUserId;
@property (nonatomic, copy) NSString *costCenterMgr;

//客户
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *invCorpName;
@property (nonatomic, copy) NSString *invTaxpayerID;
@property (nonatomic, copy) NSString *invBankName;
@property (nonatomic, copy) NSString *invBankAccount;
@property (nonatomic, copy) NSString *invTelephone;
@property (nonatomic, copy) NSString *invAddress;



//供应商
@property (nonatomic, copy) NSString *active;
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, copy) NSString *creater;
@property (nonatomic, copy) NSString *depositBank;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *postCode;


//公司
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupCode;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *isCheck;
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *showBranch;


//借款单
@property (nonatomic, copy) NSString *advanceAmount;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *serialNo;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *originalCurrencyAmt;


/**
 * 出差申请单
 */
@property (nonatomic, copy) NSString *estimatedAmount;
@property (nonatomic, copy) NSString *localCyAmount;
@property (nonatomic, copy) NSString *toDate;
@property (nonatomic, copy) NSString *fromDate;
@property (nonatomic, copy) NSString *fromDateStr;
@property (nonatomic, copy) NSString *toDateStr;
@property (nonatomic, copy) NSString *fellowOfficersId;
@property (nonatomic, copy) NSString *fellowOfficers;
@property (nonatomic, copy) NSString *toCityCode;
@property (nonatomic, copy) NSString *toCity;
@property (nonatomic, copy) NSString *travelTypeId;
@property (nonatomic, copy) NSString *relevantDeptId;
@property (nonatomic, copy) NSString *relevantDept;
@property (nonatomic, copy) NSString *financialSourceId;
@property (nonatomic, copy) NSString *financialSource;
@property (nonatomic, copy) NSString *fromCityCode;
@property (nonatomic, copy) NSString *fromCity;
@property (nonatomic, copy) NSString *requestorUserId;
@property (nonatomic, copy) NSString *requestor;
@property (nonatomic, copy) NSString *requestorDeptId;
@property (nonatomic, copy) NSString *requestorDept;

/**
 * 合同
 */
@property (nonatomic, copy) NSString *contractNo;
@property (nonatomic, copy) NSString *contractName;
@property (nonatomic, copy) NSString *invoicedAmount;
@property (nonatomic, copy) NSString *unbilledAmount;

/**
 *申请单
 */
@property (nonatomic, copy) NSString *flowCode;
@property (nonatomic, copy) NSString *flowName;
@property (nonatomic, copy) NSString *taskName;

/**
 * 合同分期
 */
@property (nonatomic, copy) NSString *paidAmount;         //已付金额
@property (nonatomic, copy) NSString *payDateStr;         //付款日期
@property (nonatomic, copy) NSString *totalAmount;        //合同金额
@property (nonatomic, copy) NSString *amount;           //付款金额
@property (nonatomic, copy) NSString *payDate;          //付款日期
@property (nonatomic, copy) NSString *gridOrder;         //合同明细GridOrder
@property (nonatomic, copy) NSString *bankName;          //银行
@property (nonatomic, copy) NSString *partyB;           //付款方
@property (nonatomic, copy) NSString *partyBId;           //付款方id



@property (nonatomic, copy) NSString *effectiveDateStr;
@property (nonatomic, copy) NSString *expiryDateStr;
@property (nonatomic, copy) NSString *payMode;
@property (nonatomic, copy) NSString *payCode;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *clientAddr;
@property (nonatomic, copy) NSString *ibanName;
@property (nonatomic, copy) NSString *ibanAccount;
@property (nonatomic, copy) NSString *ibanAddr;
@property (nonatomic, copy) NSString *swiftCode;
@property (nonatomic, copy) NSString *vmsCode;
@property (nonatomic, copy) NSString *ibanNo;
@property (nonatomic, copy) NSString *ibanADDRESS;
@property (nonatomic, copy) NSString *projId;




/**
 *借款类型
 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeCh;
@property (nonatomic, copy) NSString *typeEn;

/**
 请假类型
 */
@property (nonatomic, copy) NSString *leaveCode;
@property (nonatomic, copy) NSString *leaveTypeCh;
@property (nonatomic, copy) NSString *leaveTypeEn;
@property (nonatomic, copy) NSString *leaveType;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *paid;
@property (nonatomic, copy) NSString *limitDay;
@property (nonatomic, copy) NSString *leaveInLieu;
@property (nonatomic, copy) NSString *cycle;


/**
 员工级别
 */
@property (nonatomic, copy) NSString *userLevel;
@property (nonatomic, copy) NSString *userLevelEn;

/**
 采购明细物品列表
 */
@property (nonatomic, copy) NSString *purId;
@property (nonatomic, copy) NSString *purName;
@property (nonatomic, copy) NSString *purCode;
@property (nonatomic, copy) NSString *purBrand;
@property (nonatomic, copy) NSString *purSize;
@property (nonatomic, copy) NSString *purUnit;
@property (nonatomic, copy) NSString *purTplId;
@property (nonatomic, copy) NSString *purTplName;
@property (nonatomic, copy) NSString *purItemCatId;
@property (nonatomic, copy) NSString *purItemCatName;


//采购模板
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemName;

//合同类型
@property (nonatomic, copy) NSString *catId;
@property (nonatomic, copy) NSString *contractTyp;

//开票申请单
@property (nonatomic, copy) NSString *clientId;

//付款银行
@property (nonatomic, copy) NSString *accountName;

//收款人
@property (nonatomic, copy) NSString *payee;
@property (nonatomic, copy) NSString *bankCityCode;
@property (nonatomic, copy) NSString *bankCity;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankOutlets;
@property (nonatomic, copy) NSString *bankProvince;
@property (nonatomic, copy) NSString *bankProvinceCode;
@property (nonatomic, copy) NSString *cnaps;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *identityCardId;
@property (nonatomic, copy) NSString *credentialType;


//出差类型
@property (nonatomic, copy) NSString *travelType;

//库存
@property (nonatomic, copy) NSString *pendingQty;
@property (nonatomic, copy) NSString *qty;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *price;

//辅助核算项目
@property (nonatomic, copy) NSString *accountItemCode;
@property (nonatomic, copy) NSString *accountItem;

//仓库
@property (nonatomic, copy) NSString *managerId;
@property (nonatomic, copy) NSString *manager;



//项目活动列表
@property (nonatomic, copy) NSString *id_Lv1;
@property (nonatomic, copy) NSString *name_Lv1;
@property (nonatomic, copy) NSString *parentId_Lv1;


//开户行信息
@property (nonatomic, copy) NSString *clearingBankCode;
@property (nonatomic, copy) NSString *clearingBank;

//开户行网点信息
//"clearingBankNo" : "001666666666",  开户行号
//"clearingBank" : "人民银行",          开户行
//"clearingBankCode" : "001",         开户行编号
//"bankNo" : "001368034009",            网点编号
//"bankName" : "中国人民银行安庆市中心支行", 网点
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *clearingBankNo;
@property (nonatomic, copy) NSString *bankNo;

@property (nonatomic, copy) NSString *procType;//流程名称
@property (nonatomic, copy) NSString *expenseCatCode;
@property (nonatomic, copy) NSString *expenseCat;
@property (nonatomic, copy) NSString *expenseCode;
@property (nonatomic, copy) NSString *expenseType;
@property (nonatomic, copy) NSString *expenseIcon;
@property (nonatomic, copy) NSString *supplierId;
@property (nonatomic, copy) NSString *supplierName;


+ (void)GetProjectManagerDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetCostCenterDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetClientDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetSupplierDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetProjTypeDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetAreaDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetLocationDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetBranchListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetBusDeptsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetBorrowFormListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetTravelFormListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetFeeEntertainVehicleSvcFormListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetFormReasonDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetContractListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetPurchaseNumberListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetAdvanceTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetLeaveTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetUserLevelListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetConfigurationItemListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetPurchaseItemsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
+ (void)GetPurchaseTplsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetPurchaseItemsTplListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array WithTplModel:(ChooseCateFreModel *)tplModel;

+ (void)GetContractTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetReceiveBillListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetInvoiceFormsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetPayBankNameListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetStaffOutListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetAllPayeesListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetBusinessTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetInventorysListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetPaymentFormListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetAccountItemListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetInventoryStorageListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetProjActivityListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetClearingBankListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetBankOutletsListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (void)GetRelateContAndApplyListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
