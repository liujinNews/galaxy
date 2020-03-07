//
//  TravelHotelDetailModel.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelHotelDetailModel : NSObject

@property(nonatomic,copy)NSString *checkindate;
@property(nonatomic,copy)NSString *checkincitycode;
@property(nonatomic,copy)NSString *checkincity;
@property(nonatomic,copy)NSString *citytype;
@property(nonatomic,copy)NSString *checkoutdate;
@property(nonatomic,copy)NSString *numberofrooms;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic, copy)NSString *indexid;
@property (nonatomic, copy) NSString *isInternational;


-(TravelHotelDetailModel *)initDicToModel:(NSDictionary *)dic;

@end
