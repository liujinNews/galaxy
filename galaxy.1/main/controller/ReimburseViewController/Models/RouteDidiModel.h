//
//  RouteDidiModel.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/29.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteDidiModel : NSObject

@property (nonatomic, strong) NSString *actual_price;       //实付金额（总金额-券抵扣金额）
@property (nonatomic, strong) NSString *baoxiao_status;     //报销状态
@property (nonatomic, strong) NSString *call_phone;         //叫车人手机号
@property (nonatomic, strong) NSString *city_name;          //城市名称
@property (nonatomic, strong) NSString *departure_time;     //出发时间
@property (nonatomic, strong) NSString *end_name;           //目的地地址

@property (nonatomic, strong) NSString *expenseCat;
@property (nonatomic, strong) NSString *expenseCatCode;
@property (nonatomic, strong) NSString *expenseCode;
@property (nonatomic, strong) NSString *expenseIcon;
@property (nonatomic, strong) NSString *expenseType;


@property (nonatomic, strong) NSString *finish_time;
@property (nonatomic, strong) NSString *imported;
@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSString *normal_distance;    //总里程
@property (nonatomic, strong) NSString *order_id;           //订单ID
@property (nonatomic, strong) NSString *passenger_phone;    //乘车人手机号
@property (nonatomic, strong) NSString *pay_time;           //支付时间
@property (nonatomic, strong) NSString *pay_type;           //支付方式（0-企业 1-个人 2-混合）
@property (nonatomic, strong) NSString *personal_real_pay;  //个人实际支付
@property (nonatomic, strong) NSString *company_real_pay;   //企业实际支付

@property (nonatomic, strong) NSString *reimbursementTypId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *require_level;
@property (nonatomic, strong) NSString *start_name;         //出发地地址
@property (nonatomic, strong) NSString *status;             //订单状态（2-已支付 3-已退款 4-已取消 7-部分退款）
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *total_price;
@property (nonatomic, strong) NSString *use_car_type;       //用车方式
@property (nonatomic, strong) NSString *use_car_config_id;
@property (nonatomic, strong) NSString *carDescription;
@property (nonatomic, strong) NSString *carVendorName;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *corpPayType;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *createrID;
@property (nonatomic, strong) NSString *createrName;
@property (nonatomic, strong) NSString *departure;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSString *employeeName;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *exclTax;
@property (nonatomic, strong) NSString *orderDate;
@property (nonatomic, strong) NSString *orderSource;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *serviceProviderCode;
@property (nonatomic, strong) NSString *serviceProviderName;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *tmcOrderID;
@property (nonatomic, strong) NSString *travel;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *xbOrderID;
@property (nonatomic, strong) NSString *xcSerialNo;
@property (nonatomic, strong) NSString *tax;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *personalPay;
@property (nonatomic, strong) NSString *companyPay;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *exchangeRate;
//@property (nonatomic, strong) NSString *;
//@property (nonatomic, strong) NSString *;
//@property (nonatomic, strong) NSString *;
//@property (nonatomic, strong) NSString *;
//@property (nonatomic, strong) NSString *;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+(RouteModel *)DidiChangeRouteModle:(RouteDidiModel *)model;

@end
