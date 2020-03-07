//
//  CtripTrainModel.h
//  galaxy
//
//  Created by hfk on 2016/10/28.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CtripTrainModel : NSObject
@property (copy, nonatomic) NSString *orderID;//订单号
@property (copy, nonatomic) NSString *orderStatus;//订单状态
@property (copy, nonatomic) NSString *amount;//金额
@property (copy, nonatomic) NSString *trainName;//车次名
@property (copy, nonatomic) NSString *departureStationName;//出发车站名
@property (copy, nonatomic) NSString *arrivalStationName;//到达车站名
@property (copy, nonatomic) NSString *firstSeatTypeName;//首选坐席名字
@property (copy, nonatomic) NSString *dealSeatNo;//出票座位号
@property (copy, nonatomic) NSString *dealSeatName;//出票座位号描述
@property (copy, nonatomic) NSString *departureDate;//出发时间
@property (copy, nonatomic) NSString *departureYear;//出发年份
@property (copy, nonatomic) NSString *departureMonth;//出发月份
@property (copy, nonatomic) NSString *departureDay;//出发日
@property (copy, nonatomic) NSString *departureWeek;//出发日期星期
@property (copy, nonatomic) NSString *departureTime;//出发时分
@property (copy, nonatomic) NSString *arrivalDate;//到达时间
@property (copy, nonatomic) NSString *arrivalYear;//到达年份
@property (copy, nonatomic) NSString *arrivalMonth;//到达月份
@property (copy, nonatomic) NSString *arrivalDay;//到达日
@property (copy, nonatomic) NSString *arrivalWeek;//到达日期星期
@property (copy, nonatomic) NSString *arrivalTime;//到达时分
@property (copy, nonatomic) NSString *totalTime;//乘坐时间
@property (copy, nonatomic) NSString *passenger;//乘车人
@end
