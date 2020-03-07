//
//  TravelHotelDetailModel.m
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "TravelHotelDetailModel.h"

@implementation TravelHotelDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(TravelHotelDetailModel *)initDicToModel:(NSDictionary *)dic
{
    TravelHotelDetailModel *model = [[TravelHotelDetailModel alloc]init];
    if (dic!=nil) {
        model.checkindate = dic[@"checkInDate"];
        model.checkincitycode = dic[@"checkInCityCode"];
        model.checkincity = dic[@"checkInCity"];
        model.citytype = [NSString isEqualToNull:dic[@"cityType"]] ? [NSString stringWithFormat:@"%@",dic[@"cityType"]]:@"1";
        model.checkoutdate = dic[@"checkOutDate"];
        model.numberofrooms = dic[@"numberOfRooms"];
        model.remark = dic[@"remark"];
    }
    return model;
}

@end
