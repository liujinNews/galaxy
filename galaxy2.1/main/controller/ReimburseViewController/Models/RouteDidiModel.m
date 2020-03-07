//
//  RouteDidiModel.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/29.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RouteDidiModel.h"

@implementation RouteDidiModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(RouteModel *)DidiChangeRouteModle:(RouteDidiModel *)model{
    RouteModel *route = [[RouteModel alloc]init];
    route.Id = model.order_id;
    route.departureName = model.departure_time;
    route.arrivalName = model.end_name;
    route.mileage = model.normal_distance;
    route.departureTimeStr = model.departure_time;
    route.arrivalTimeStr = model.finish_time;
    route.departureTime = model.departure_time;
    route.arrivalTime = model.finish_time;
    route.amount = model.actual_price;
    route.imported = model.imported;
    return route;
}

@end
