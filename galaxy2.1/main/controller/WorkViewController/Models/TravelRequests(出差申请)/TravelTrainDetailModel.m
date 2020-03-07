//
//  TravelTrainDetailModel.m
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "TravelTrainDetailModel.h"

@implementation TravelTrainDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(TravelTrainDetailModel *)initDicToModel:(NSDictionary *)dic
{
    TravelTrainDetailModel *model = [[TravelTrainDetailModel alloc]init];
    if (dic!=nil) {
        model.departuredate = dic[@"departureDate"];
        model.fromcitycode = dic[@"fromCityCode"];
        model.fromcity = dic[@"fromCity"];
        model.fromcitytype = [NSString isEqualToNull:dic[@"fromCityType"]] ? [NSString stringWithFormat:@"%@",dic[@"fromCityType"]]:@"1";
        model.tocitycode = dic[@"toCityCode"];
        model.tocity = dic[@"toCity"];
        model.tocitytype = [NSString isEqualToNull:dic[@"toCityType"]] ? [NSString stringWithFormat:@"%@",dic[@"toCityType"]]:@"1";
        model.passenger = dic[@"passenger"];
        model.remark = dic[@"remark"];
    }
    return model;
}

@end
