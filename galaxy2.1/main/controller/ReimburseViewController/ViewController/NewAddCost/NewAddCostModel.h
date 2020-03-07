//
//  NewAddCostModel.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/28.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewAddCostModel : NSObject

@property (nonatomic, copy) NSString *Amount;                 //金额
@property (nonatomic, copy) NSString *CurrencyCode;           //币种代码
@property (nonatomic, copy) NSString *Currency;               //币种
@property (nonatomic, copy) NSString *ExchangeRate;           //汇率
@property (nonatomic, copy) NSString *LocalCyAmount;          //本位币金额
@property (nonatomic, copy) NSString *InvoiceType;            //发票类型
@property (nonatomic, copy) NSString *InvoiceTypeName;            //发票类型
@property (nonatomic, copy) NSString *InvoiceTypeCode;            //发票类型

@property (nonatomic, copy) NSString *AirTicketPrice;
@property (nonatomic, copy) NSString *DevelopmentFund;
@property (nonatomic, copy) NSString *FuelSurcharge;
@property (nonatomic, copy) NSString *OtherTaxes;
@property (nonatomic, copy) NSString *AirlineFuelFee;
@property (nonatomic, copy) NSString *TaxRate;                //税率
@property (nonatomic, copy) NSString *Tax;                    //税额
@property (nonatomic, copy) NSString *ExclTax;                //不含税金额
@property (nonatomic, copy) NSString *ExpenseCode;            //费用类别代码
@property (nonatomic, copy) NSString *ExpenseType;            //费用类别
@property (nonatomic, copy) NSString *ExpenseIcon;            //费用类别icon
@property (nonatomic, copy) NSString *ExpenseCatCode;         //费用大类代码
@property (nonatomic, copy) NSString *ExpenseCat;             //费用大类
@property (nonatomic, copy) NSString *ExpenseDate;            //日期
@property (nonatomic, copy) NSString *PayTypeId;
@property (nonatomic, copy) NSString *PayType;
@property (nonatomic, copy) NSString *SupplierId;
@property (nonatomic, copy) NSString *SupplierName;

@property (nonatomic, copy) NSString *Overseas;
@property (nonatomic, copy) NSString *Nationality;
@property (nonatomic, copy) NSString *NationalityId;
@property (nonatomic, copy) NSString *TransactionCode;
@property (nonatomic, copy) NSString *TransactionCodeId;
@property (nonatomic, copy) NSString *HandmadePaper;
@property (nonatomic, copy) NSString *InvoiceNo;              //发票号码
@property (nonatomic, copy) NSString *HasInvoice;                  //是否有发票
@property (nonatomic, copy) NSString *NoInvReason;            //无发票要原因
@property (nonatomic, copy) NSString *Attachments;            //发票
@property (nonatomic, copy) NSString *Files;                  //附件
@property (nonatomic, copy) NSString *CostCenterId;           //成本中心id
@property (nonatomic, copy) NSString *CostCenter;             //成本中心
@property (nonatomic, copy) NSString *ProjId;                 //项目id
@property (nonatomic, copy) NSString *ProjName;               //项目名称
@property (nonatomic, copy) NSString *ProjMgrUserId;          //项目负责人id
@property (nonatomic, copy) NSString *ProjMgr;                //项目负责人
@property (nonatomic, copy) NSString *ProjectActivityLv1;
@property (nonatomic, copy) NSString *ProjectActivityLv1Name;
@property (nonatomic, copy) NSString *ProjectActivityLv2;
@property (nonatomic, copy) NSString *ProjectActivityLv2Name;
@property (nonatomic, copy) NSString *ExpenseDesc;            //费用描述
@property (nonatomic, copy) NSString *Remark;                 //备注
@property (nonatomic, copy) NSString *CityCode;               //城市代码
@property (nonatomic, copy) NSString *CityName;               //城市
@property (nonatomic, copy) NSString *HotelName;              //酒店
@property (nonatomic, copy) NSString *Rooms;                  //房间数
@property (nonatomic, copy) NSString *CityType;               //城市类型
@property (nonatomic, copy) NSString *CheckInDate;            //入住日期
@property (nonatomic, copy) NSString *CheckOutDate;           //退房日期
@property (nonatomic, copy) NSString *TotalDays;              //天数
@property (nonatomic, copy) NSString *HotelPrice;             //房价
@property (nonatomic, copy) NSString *FellowOfficersId;       //同行人员id
@property (nonatomic, copy) NSString *FellowOfficers;         //同行人员
@property (nonatomic, copy) NSString *Breakfast;              //早餐
@property (nonatomic, copy) NSString *Lunch;                  //中餐
@property (nonatomic, copy) NSString *Supper;                 //晚餐
@property (nonatomic, copy) NSString *TotalPeople;
@property (nonatomic, copy) NSString *MealsTotalDays;
@property (nonatomic, copy) NSString *CateringCo;             //餐饮公司
@property (nonatomic, copy) NSString *Flight;                 //飞机
@property (nonatomic, copy) NSString *FDCityName;             //起点
@property (nonatomic, copy) NSString *FDCityType;
@property (nonatomic, copy) NSString *FDCityCode;
@property (nonatomic, copy) NSString *FACityType;
@property (nonatomic, copy) NSString *FACityCode;
@property (nonatomic, copy) NSString *FACityName;             //终点
@property (nonatomic, copy) NSString *ClassName;              //舱位
@property (nonatomic, copy) NSString *Discount;               //折扣
@property (nonatomic, copy) NSString *TDCityName;             //起点
@property (nonatomic, copy) NSString *TACityName;             //终点
@property (nonatomic, copy) NSString *SeatName;               //座位
@property (nonatomic, copy) NSString *SDCityName;             //起点
@property (nonatomic, copy) NSString *SACityName;             //终点
@property (nonatomic, copy) NSString *Mileage;                //里程(公里)
@property (nonatomic, copy) NSString *CarStd;                 //标准(元/公里)
@property (nonatomic, copy) NSString *OilPrice;               //油价
@property (nonatomic, copy) NSString *FuelBills;              //油费
@property (nonatomic, copy) NSString *Pontage;                //路桥费
@property (nonatomic, copy) NSString *ParkingFee;             //停车费
@property (nonatomic, copy) NSString *SDepartureTime;
@property (nonatomic, copy) NSString *SArrivalTime;




@property (nonatomic, copy) NSString *AllowanceAmount;        //补贴标准
@property (nonatomic, copy) NSString *AllowanceUnit;          //补贴单位
@property (nonatomic, copy) NSString *MealType;               //补贴类型
@property (nonatomic, copy) NSString *OverStd;                //超标准金额
@property (nonatomic, copy) NSString *OverStdAmt;                //招标金额
@property (nonatomic, copy) NSString *OverStd2;                //超标准金额
@property (nonatomic, copy) NSString *Tag;                    //费用类别对应的标准类型

@property (nonatomic, copy) NSString *ReceptionObject;    //接待对象
@property (nonatomic, copy) NSString *ReceptionReason;    //接待事由
@property (nonatomic, copy) NSString *ReceptionLocation;    //接待地点
@property (nonatomic, copy) NSString *Visitor;    //来访人员姓名和职位
@property (nonatomic, copy) NSString *VisitorDate;    //来访时间
@property (nonatomic, copy) NSString *LeaveDate;    //离开时间
@property (nonatomic, copy) NSString *ReceptionFellowOfficersId;//同行人员id
@property (nonatomic, copy) NSString *ReceptionFellowOfficers;    //同行人员名
@property (nonatomic, copy) NSString *ReceptionTotalPeople;    //同行人数
@property (nonatomic, copy) NSString *ReceptionCateringCo;    //餐饮公司



@property (nonatomic, copy) NSString *ReplExpenseCode;    //替票费用类别code
@property (nonatomic, copy) NSString *ReplExpenseType;    //替票费用类别



@property (nonatomic, copy) NSString *StartMeter;    //开始咪表
@property (nonatomic, copy) NSString *EndMeter;    //结束咪表
@property (nonatomic, copy) NSString *CorpCarDCityName;    //起点
@property (nonatomic, copy) NSString *CorpCarACityName;    //终点
@property (nonatomic, copy) NSString *CorpCarMileage;    //里程(公里)
@property (nonatomic, copy) NSString *CorpCarFuelBills;    //油费
@property (nonatomic, copy) NSString *CorpCarPontage;    //路桥费
@property (nonatomic, copy) NSString *CorpCarParkingFee;    //停车费
@property (nonatomic, copy) NSString *CorpCarNo;    //车牌号
@property (nonatomic, copy) NSString *CorpCarFromDate;    //用车期间开始
@property (nonatomic, copy) NSString *CorpCarToDate;    //用车期间结束

@property (nonatomic, copy) NSString *TaxiDCityName;    //加班车费出发地
@property (nonatomic, copy) NSString *TaxiACityName;    //加班车费目的地
@property (nonatomic, copy) NSString *TaxiFromDate;    //加班车费开始时间
@property (nonatomic, copy) NSString *TaxiToDate;    //加班车费结束时间


@property (nonatomic, copy) NSString *CrspFromDate;
@property (nonatomic, copy) NSString *CrspToDate;

@property (nonatomic, copy) NSString *TransDCityName;         //出发地
@property (nonatomic, copy) NSString *TransACityName;         //目的地
@property (nonatomic, copy) NSString *TransFromDate;          //出发时间
@property (nonatomic, copy) NSString *TransToDate;            //到达时间
@property (nonatomic, copy) NSString *TransTotalDays;         //总时间
@property (nonatomic, copy) NSString *TransType;
@property (nonatomic, copy) NSString *TransTypeId;


@property (nonatomic, copy) NSString *AllowanceFromDate;
@property (nonatomic, copy) NSString *AllowanceToDate;
@property (nonatomic, copy) NSString *TravelUserId;
@property (nonatomic, copy) NSString *TravelUserName;

@property (nonatomic, copy) NSString *ClientId;               //客户ID
@property (nonatomic, copy) NSString *ClientName;             //客户名称

@property (nonatomic, assign) NSInteger Type;                   //类型
@property (nonatomic, assign) NSInteger ClaimType;                   //类型

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

@property (nonatomic, copy) NSString *DriveCarId;
@property (nonatomic, copy) NSString *DidiOrderId;

@property (nonatomic, copy) NSString *FP_DM;
@property (nonatomic, copy) NSString *FP_HM;
@property (nonatomic, copy) NSString *DataSource;

//驻办
@property (nonatomic, copy) NSString *LocationId;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *OfficeFromDate;
@property (nonatomic, copy) NSString *OfficeToDate;
@property (nonatomic, copy) NSString *OfficeTotalDays;
//驻外
@property (nonatomic, copy) NSString *BranchId;
@property (nonatomic, copy) NSString *Branch;
@property (nonatomic, copy) NSString *OverseasFromDate;
@property (nonatomic, copy) NSString *OverseasToDate;
@property (nonatomic, copy) NSString *OverseasTotalDays;
//分摊
@property (nonatomic, copy) NSString *ExpenseShares;
@property (nonatomic, copy) NSString *ShareId;
@property (nonatomic, copy) NSString *ShareTotalAmt;
@property (nonatomic, copy) NSString *ShareRatio;

@property (nonatomic, copy) NSString *OwnerUserId;
@property (nonatomic, copy) NSString *UserId;

@property (nonatomic, copy) NSString *AccountItem;
@property (nonatomic, copy) NSString *AccountItemCode;
@property (nonatomic, copy) NSString *InvCyPmtExchangeRate;
@property (nonatomic, copy) NSString *InvPmtAmount;
@property (nonatomic, copy) NSString *InvPmtTax;
@property (nonatomic, copy) NSString *InvPmtAmountExclTax;

@property (nonatomic, copy) NSString *CostCenterMgrUserId;
@property (nonatomic, copy) NSString *CostCenterMgr;


//礼品费
@property (nonatomic, copy) NSString *ExpenseGiftDetail;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(NewAddCostModel *)model;

@end
