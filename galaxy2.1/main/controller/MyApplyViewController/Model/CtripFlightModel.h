//
//  CtripFlightModel.h
//  galaxy
//
//  Created by hfk on 2016/10/28.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CtripFlightModel : NSObject
@property (copy, nonatomic) NSString *orderID;//订单号
@property (copy, nonatomic) NSString *orderStatus;//订单状态
@property (copy, nonatomic) NSString *flight;//航班号
@property (copy, nonatomic) NSString *airLineName;//航空公司名称
@property (copy, nonatomic) NSString *takeoffDate;//起飞时间
@property (copy, nonatomic) NSString *takeoffYear;//起飞年份
@property (copy, nonatomic) NSString *takeoffMonth;//起飞月份
@property (copy, nonatomic) NSString *takeoffDay;//起飞日
@property (copy, nonatomic) NSString *takeoffWeek;//起飞日期星期
@property (copy, nonatomic) NSString *takeoffTime;//起飞时分
@property (copy, nonatomic) NSString *arrivalDate;//到达时间
@property (copy, nonatomic) NSString *arrivalYear;//到达年份
@property (copy, nonatomic) NSString *arrivalMonth;//到达月份
@property (copy, nonatomic) NSString *arrivalDay;//到达日
@property (copy, nonatomic) NSString *arrivalWeek;//到达日期星期
@property (copy, nonatomic) NSString *arrivalTime;//到达时分
@property (copy, nonatomic) NSString *flightWay;//航班类型（单程、往返、多程）
@property (copy, nonatomic) NSString *dPortName;//出发机场
@property (copy, nonatomic) NSString *dAirportShortname;//出发航站楼名称
@property (copy, nonatomic) NSString *dCityName;//出发城市名称
@property (copy, nonatomic) NSString *aPortName;//到达机场
@property (copy, nonatomic) NSString *aAirportShortname;//到达航站楼名称
@property (copy, nonatomic) NSString *aCityName;//到达城市名称
@property (copy, nonatomic) NSString *className;//仓位名称
@property (copy, nonatomic) NSString *totalTime;//飞行时间
@property (copy, nonatomic) NSString *amount;//金额
@property (copy, nonatomic) NSString *passenger;//乘机人

@end
