//
//  AddDetailsModel.h
//  galaxy
//
//  Created by hfk on 16/4/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddDetailsModel : NSObject

@property (copy, nonatomic) NSString *amount;
@property (copy, nonatomic) NSString *attachments;
@property (copy, nonatomic) NSString *files;
@property (copy, nonatomic) NSString *checked;
@property (copy, nonatomic) NSString *cityCode;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *costCenter;
@property (copy, nonatomic) NSString *costCenterId;
@property (copy, nonatomic) NSString *costCenterMgrUserId;
@property (copy, nonatomic) NSString *costCenterMgr;
@property (copy,nonatomic)  NSString *currency;
@property (copy,nonatomic)  NSString *currencyCode;
@property (copy,nonatomic)  NSString *exchangeRate;
@property (copy, nonatomic) NSString *tax;//税额
@property (copy, nonatomic) NSString *expenseCode;
@property (copy, nonatomic) NSString *expenseDate;
@property (copy, nonatomic) NSString *expenseIcon;
@property (copy, nonatomic) NSString *expenseType;
@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *localCyAmount;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *source;//来自哪个端
@property (copy, nonatomic) NSString *totalDays;
@property (copy, nonatomic) NSString *checkInDate;
@property (copy, nonatomic) NSString *checkOutDate;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *BeforeType;
@property (copy, nonatomic) NSString *AllowanceAmount;//补贴标准金额
@property (copy, nonatomic) NSString *AllowanceUnit;//1天，2月，3年
@property (copy, nonatomic) NSString *OrderId;
@property (copy, nonatomic) NSString *DataSource;//数据来源9华住,10携程,12百望电子发票
@property (copy, nonatomic) NSString *expenseCat;//费用类别大类
@property (copy, nonatomic) NSString *expenseCatCode;
@property (copy, nonatomic) NSString *cityType;//1国内城市2国际城市3港澳台
@property (copy, nonatomic) NSString *OverStd;
//发票相关
@property (copy, nonatomic) NSString *bxdh;
@property (copy, nonatomic) NSString *fP_ActTyp;
@property (copy, nonatomic) NSString *fP_DM;
@property (copy, nonatomic) NSString *fP_HM;
@property (copy, nonatomic) NSString *spsqm;
@property (copy, nonatomic) NSString *accountNo;
@property (copy, nonatomic) NSString *bxsqm;
@property (copy, nonatomic) NSString *bX_RQ;




@property (copy, nonatomic) NSString *clientName;
@property (copy, nonatomic) NSString *projName;
@property (copy, nonatomic) NSString *transToDate;
@property (copy, nonatomic) NSString *tag;

@property(nonatomic,copy)NSString *reserved1;
@property(nonatomic,copy)NSString *reserved2;
@property(nonatomic,copy)NSString *reserved3;
@property(nonatomic,copy)NSString *reserved4;
@property(nonatomic,copy)NSString *reserved5;
@property(nonatomic,copy)NSString *reserved6;
@property(nonatomic,copy)NSString *reserved7;
@property(nonatomic,copy)NSString *reserved8;
@property(nonatomic,copy)NSString *reserved9;
@property(nonatomic,copy)NSString *reserved10;
@property(nonatomic,copy)NSString *reserved11;
@property(nonatomic,copy)NSString *reserved12;
@property(nonatomic,copy)NSString *hotelPrice;
@property(nonatomic,copy)NSString *exclTax;
@property(nonatomic,copy)NSString *noInvReason;

@property(nonatomic,copy)NSString *fellowOfficersId;
@property(nonatomic,copy)NSString *faCityName;
@property(nonatomic,copy)NSString *transToDateStr;
@property(nonatomic,copy)NSString *carStd;
@property(nonatomic,copy)NSString *className;
@property(nonatomic,copy)NSString *invoiceNo;
@property(nonatomic,copy)NSString *fdCityName;
@property(nonatomic,copy)NSString *transFromDate;
@property(nonatomic,copy)NSString *taCityName;
@property(nonatomic,copy)NSString *saCityName;
@property(nonatomic,copy)NSString *driveCarId;
@property(nonatomic,copy)NSString *discount;
@property(nonatomic,copy)NSString *parkingFee;
@property(nonatomic,copy)NSString *projMgr;

@property(nonatomic,copy)NSString *breakfast;
@property(nonatomic,copy)NSString *fellowOfficers;
@property(nonatomic,copy)NSString *supper;
@property(nonatomic,copy)NSString *fuelBills;
@property(nonatomic,copy)NSString *tdCityName;
@property(nonatomic,copy)NSString *projId;
@property(nonatomic,copy)NSString *sdCityName;
@property(nonatomic,copy)NSString *clientId;
@property(nonatomic,copy)NSString *hasInvoice;
@property(nonatomic,copy)NSString *mileage;
@property(nonatomic,copy)NSString *lunch;
@property(nonatomic,copy)NSString *expenseDesc;

@property(nonatomic,copy)NSString *projMgrUserId;

@property(nonatomic,copy)NSString *seatName;
@property(nonatomic,copy)NSString *transDCityName;
@property(nonatomic,copy)NSString *transACityName;
@property(nonatomic,copy)NSString *transFromDateStr;
@property(nonatomic,copy)NSString *driveCar;
@property(nonatomic,copy)NSString *pontage;
@property(nonatomic,copy)NSString *didiOrderId;

@property(nonatomic,copy)NSString *payTypeId;

@property(nonatomic,copy)NSString *taxiDCityName;
@property(nonatomic,copy)NSString *taxiACityName;
@property(nonatomic,copy)NSString *taxiFromDate;
@property(nonatomic,copy)NSString *taxiToDate;
@property(nonatomic,copy)NSString *overStd2;

@property (nonatomic, copy) NSString *invCyPmtExchangeRate;
@property (nonatomic, copy) NSString *invPmtAmount;
@property (nonatomic, copy) NSString *invPmtTax;
@property (nonatomic, copy) NSString *invPmtAmountExclTax;


@property (nonatomic, copy) NSString *airlineFuelFee;//总金额
@property (nonatomic, copy) NSString *airTicketPrice;//民航发展基金
@property (nonatomic, copy) NSString *developmentFund;//发展基金
@property (nonatomic, copy) NSString *fuelSurcharge;//燃油附加费
@property (nonatomic, copy) NSString *otherTaxes;//其他费用
@property (nonatomic, copy) NSString *taxRate;
@property (nonatomic, copy) NSString *invoiceType;
@property (nonatomic, copy) NSString *invoiceTypeCode;
@property (nonatomic, copy) NSString *invoiceTypeName;
@property (nonatomic, copy) NSString *reimbursementTypId;
@property (nonatomic, copy) NSString *reimbursementTyp;
@property (nonatomic, copy) NSString *isIntegrity;//消费记录信息是否完整(1不完整 0完整)
//@property (nonatomic, assign) BOOL isDataIntegrity;//是否验证发票导入记录完整性(1要验证 0不要验证)


+ (void)getCostRecordDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (NSString *)getCostRecordDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array Click:(NSMutableArray *)Click amount:(NSString *)amount;

+ (void)getCostOneDataByDictionary:(NSDictionary *)dic model:(AddDetailsModel *)data;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(AddDetailsModel*)model;
@end
