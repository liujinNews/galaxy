//
//  TravelFlightDetailModel.m
//  galaxy
//
//  Created by 贺一鸣 on 15/11/10.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "TravelFlightDetailModel.h"

@implementation TravelFlightDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(TravelFlightDetailModel *)initDicToModel:(NSDictionary *)dic
{
    TravelFlightDetailModel *model = [[TravelFlightDetailModel alloc]init];
    if (dic != nil) {
        model.departuredate = dic[@"departureDate"];
        model.fromcitycode = dic[@"fromCityCode"];
        model.fromcity = dic[@"fromCity"];
        model.fromcitytype = [NSString isEqualToNull:dic[@"fromCityType"]] ? [NSString stringWithFormat:@"%@",dic[@"fromCityType"]]:@"1";
        model.tocitycode = dic[@"toCityCode"];
        model.tocity = dic[@"toCity"];
        model.tocitytype = [NSString isEqualToNull:dic[@"toCityType"]] ? [NSString stringWithFormat:@"%@",dic[@"toCityType"]]:@"1";
        model.flypeople = dic[@"flyPeople"];
        model.remark = dic[@"remark"];
        model.isInternational = dic[@"isInternational"];
    }
    return model;
}

@end
