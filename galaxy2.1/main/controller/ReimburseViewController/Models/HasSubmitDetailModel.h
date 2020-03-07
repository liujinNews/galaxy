//
//  HasSubmitDetailModel.h
//  galaxy
//
//  Created by hfk on 16/5/3.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HasSubmitDetailModel : NSObject

@property(nonatomic,copy)NSString *mealType;
@property(nonatomic,copy)NSString *leaveDate;
@property(nonatomic,copy)NSString *transTypeId;
@property(nonatomic,copy)NSString *transType;

@property(nonatomic,copy)NSString *faCityCode;
@property(nonatomic,copy)NSString *faCityType;


@property(nonatomic,copy)NSString *corpCarPontage;
@property(nonatomic,copy)NSString *payTypeId;
@property(nonatomic,copy)NSString *payType;

@property(nonatomic,copy)NSString *fdCityType;
@property(nonatomic,copy)NSString *fdCityCode;
@property(nonatomic,copy)NSString *crspToDate;
@property(nonatomic,copy)NSString *creater1;
@property(nonatomic,copy)NSString *supplierId;
@property(nonatomic,copy)NSString *totalPeople;
@property(nonatomic,copy)NSString *crspFromDate;
@property(nonatomic,copy)NSString *corpCarDCityName;
@property(nonatomic,copy)NSString *corpCarParkingFee;
@property(nonatomic,copy)NSString *corpCarToDate;
@property(nonatomic,copy)NSString *startMeter;
@property(nonatomic,copy)NSString *correspondence;
@property(nonatomic,copy)NSString *visitorDate;
@property(nonatomic,copy)NSString *receptionTotalPeople;
@property(nonatomic,copy)NSString *cateringCo;
@property(nonatomic,copy)NSString *corpCarFromDate;

@property(nonatomic,copy)NSString *visitor;
@property(nonatomic,copy)NSString *receptionLocation;
@property(nonatomic,copy)NSString *corpCarNo;
@property(nonatomic,copy)NSString *supplierName;
@property(nonatomic,copy)NSString *receptionFellowOfficersId;
@property(nonatomic,copy)NSString *replExpenseType;
@property(nonatomic,copy)NSString *allowanceFromDate;
@property(nonatomic,copy)NSString *allowanceToDate;

@property(nonatomic,copy)NSString *endMeter;
@property(nonatomic,copy)NSString *corpCarMileage;
@property(nonatomic,copy)NSString *rooms;
@property(nonatomic,copy)NSString *hotelName;

@property(nonatomic,copy)NSString *corpCarACityName;
@property(nonatomic,copy)NSString *receptionReason;
@property(nonatomic,copy)NSString *corpCarFuelBills;
@property(nonatomic,copy)NSString *receptionFellowOfficers;
@property(nonatomic,copy)NSString *receptionCateringCo;
@property(nonatomic,copy)NSString *receptionObject;
@property(nonatomic,copy)NSString *replExpenseCode;

@property(nonatomic,copy)NSString *isExpExpired;








@property(nonatomic,copy)NSString *active;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *tax;
@property(nonatomic,copy)NSString *attachments;
@property(nonatomic,copy)NSString *files;
@property(nonatomic,copy)NSString *allowanceAmount;
@property(nonatomic,copy)NSString *allowanceUnit;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *companyId;
@property(nonatomic,copy)NSString *costCenter;
@property(nonatomic,copy)NSString *costCenterId;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *creater;
@property(nonatomic,copy)NSString *currency;
@property(nonatomic,copy)NSString *currencyCode;
@property(nonatomic,copy)NSString *exchangeRate;
@property(nonatomic,copy)NSString *expenseCode;
@property(nonatomic,copy)NSString *expenseDate;
@property(nonatomic,copy)NSString *expenseIcon;
@property(nonatomic,copy)NSString *expenseType;
@property(nonatomic,copy)NSString *gridOrder;
@property(nonatomic,copy)NSString *localCyAmount;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *taskId;
@property(nonatomic,copy)NSString *totalDays;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *updater;
@property(nonatomic,copy)NSString *overStd;
@property(nonatomic,copy)NSString *overStdAmt;


@property (copy, nonatomic) NSString *expenseCat;//费用类别大类
@property (copy, nonatomic) NSString *expenseCatCode;
@property (copy, nonatomic) NSString *cityType;//1国内城市2国际城市3港澳台
@property (copy, nonatomic) NSString *dataSource;//数据来源9华住,10携程,12百望电子发票
@property (copy, nonatomic) NSString *requestorUserId;

//发票相关
@property (copy, nonatomic) NSString *bxdh;
@property (copy, nonatomic) NSString *fP_ActTyp;
@property (copy, nonatomic) NSString *fP_DM;
@property (copy, nonatomic) NSString *fP_HM;
@property (copy, nonatomic) NSString *spsqm;
@property (copy, nonatomic) NSString *accountNo;
@property (copy, nonatomic) NSString *bxsqm;
@property (copy, nonatomic) NSString *bX_RQ;


@property (copy, nonatomic) NSString *breakfast;
@property (copy, nonatomic) NSString *carStd;
@property (copy, nonatomic) NSString *checkInDate;
@property (copy, nonatomic) NSString *checkOutDate;
@property (copy, nonatomic) NSString *className;
@property (copy, nonatomic) NSString *clientId;
@property (copy, nonatomic) NSString *clientName;
@property (copy, nonatomic) NSString *didiOrderId;
@property (copy, nonatomic) NSString *discount;
@property (copy, nonatomic) NSString *driveCarId;
@property (copy, nonatomic) NSString *expenseDesc;
@property (copy, nonatomic) NSString *faCityName;
@property (copy, nonatomic) NSString *fdCityName;
@property (copy, nonatomic) NSString *fellowOfficers;
@property (copy, nonatomic) NSString *fellowOfficersId;
@property (copy, nonatomic) NSString *fuelBills;
@property (copy, nonatomic) NSString *hasInvoice;
@property (copy, nonatomic) NSString *hasInvoiceName;
@property (copy, nonatomic) NSString *hotelPrice;
@property (copy, nonatomic) NSString *invoiceNo;
@property (copy, nonatomic) NSString *invoiceType;
@property (copy, nonatomic) NSString *invoiceTypeName;
@property (copy, nonatomic) NSString *invoiceTypeCode;
@property (copy, nonatomic) NSString *lunch;
@property (copy, nonatomic) NSString *mileage;
@property (copy, nonatomic) NSString *noInvReason;
@property (copy, nonatomic) NSString *parkingFee;
@property (copy, nonatomic) NSString *pontage;
@property (copy, nonatomic) NSString *projId;
@property (copy, nonatomic) NSString *projMgr;
@property (copy, nonatomic) NSString *projMgrUserId;
@property (copy, nonatomic) NSString *projName;
@property (copy, nonatomic) NSString *reserved1;
@property (copy, nonatomic) NSString *reserved2;
@property (copy, nonatomic) NSString *reserved3;
@property (copy, nonatomic) NSString *reserved4;
@property (copy, nonatomic) NSString *reserved5;
@property (copy, nonatomic) NSString *reserved6;
@property (copy, nonatomic) NSString *reserved7;
@property (copy, nonatomic) NSString *reserved8;
@property (copy, nonatomic) NSString *reserved9;
@property (copy, nonatomic) NSString *reserved10;
@property (copy, nonatomic) NSString *saCityName;
@property (copy, nonatomic) NSString *sdCityName;
@property (copy, nonatomic) NSString *seatName;
@property (copy, nonatomic) NSString *supper;
@property (copy, nonatomic) NSString *taCityName;
@property (copy, nonatomic) NSString *tag;
@property (copy, nonatomic) NSString *taxRate;
@property (copy, nonatomic) NSString *tdCityName;
@property (copy, nonatomic) NSString *transACityName;
@property (copy, nonatomic) NSString *transDCityName;
@property (copy, nonatomic) NSString *transFromDate;
@property (copy, nonatomic) NSString *transToDate;
@property (copy, nonatomic) NSString *transTotalDays;
@property (copy, nonatomic) NSString *exclTax;
@property (copy, nonatomic) NSString *isEdit;

@property (copy, nonatomic) NSString *taxiFromDate;
@property (copy, nonatomic) NSString *taxiToDate;
@property (copy, nonatomic) NSString *taxiACityName;
@property (copy, nonatomic) NSString *taxiDCityName;
@property (copy, nonatomic) NSString *overStd2;

@property (copy, nonatomic) NSString *accountItemCode;
@property (copy, nonatomic) NSString *accountItem;

@property (nonatomic, copy) NSString *invCyPmtExchangeRate;
@property (nonatomic, copy) NSString *invPmtAmount;
@property (nonatomic, copy) NSString *invPmtTax;
@property (nonatomic, copy) NSString *invPmtAmountExclTax;

@property (nonatomic, copy) NSString *airlineFuelFee;//总金额
@property (nonatomic, copy) NSString *airTicketPrice;//民航发展基金
@property (nonatomic, copy) NSString *developmentFund;//发展基金
@property (nonatomic, copy) NSString *fuelSurcharge;//燃油附加费
@property (nonatomic, copy) NSString *otherTaxes;//其他费用


/**
 0:不需要确认 1:需要确认但是没有确认 2:需要确认且已经确认
 */
@property (copy, nonatomic) NSString *hasSured;

@property(nonatomic,copy)NSString *att_content;



+(void)getCostCateSumArrayWithArray:(NSArray *)array resultArray:(NSMutableArray *)resultarr;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(HasSubmitDetailModel*)model;


@end
