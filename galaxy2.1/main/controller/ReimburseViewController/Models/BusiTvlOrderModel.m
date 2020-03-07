//
//  BusiTvlOrderModel.m
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BusiTvlOrderModel.h"

@implementation BusiTvlOrderModel
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

+(RouteModel *)DidiChangeRouteModle:(BusiTvlOrderModel *)model{
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
