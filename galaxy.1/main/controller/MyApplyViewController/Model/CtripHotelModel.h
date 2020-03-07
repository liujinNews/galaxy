//
//  CtripHotelModel.h
//  galaxy
//
//  Created by hfk on 2016/10/28.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CtripHotelModel : NSObject
@property (copy, nonatomic) NSString *orderID;//订单号
@property (copy, nonatomic) NSString *amount;//金额
@property (copy, nonatomic) NSString *hotelName;//酒店名称
@property (copy, nonatomic) NSString *address;//酒店地址
@property (copy, nonatomic) NSString *orderStatus;//订单状态
@property (copy, nonatomic) NSString *orderDate;//订单日期
@property (copy, nonatomic) NSString *startDate;//入住时间
@property (copy, nonatomic) NSString *startYear;//入住年份
@property (copy, nonatomic) NSString *startMonth;//入住月份
@property (copy, nonatomic) NSString *startDay;//入住日
@property (copy, nonatomic) NSString *startWeek;//入住星期
@property (copy, nonatomic) NSString *startTime;//入住时间
@property (copy, nonatomic) NSString *endDate;//离店时间
@property (copy, nonatomic) NSString *endYear;//离店年份
@property (copy, nonatomic) NSString *endMonth;//离店月份
@property (copy, nonatomic) NSString *endDay;//离店日
@property (copy, nonatomic) NSString *endWeek;//离店星期
@property (copy, nonatomic) NSString *endTime;//离店时间
@property (copy, nonatomic) NSString *payType;//支付方式
@property (copy, nonatomic) NSString *balanceType;//支付类型
@property (copy, nonatomic) NSString *roomName;//房间名称
@property (copy, nonatomic) NSString *roomQuantity;//房间数
@property (copy, nonatomic) NSString *roomDays;//间夜数
@property (copy, nonatomic) NSString *hasBreakfast;//是否有早餐
@property (copy, nonatomic) NSString *passenger;//入住人
@end
