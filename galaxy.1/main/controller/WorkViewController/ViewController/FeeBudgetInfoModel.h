//
//  FeeBudgetInfoModel.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeeBudgetInfoModel : NSObject

@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *InterTransFee;
@property (nonatomic, copy) NSString *InterTransDay;
@property (nonatomic, copy) NSString *CityTransFee;
@property (nonatomic, copy) NSString *CityTransDay;
@property (nonatomic, copy) NSString *HotelFee;
@property (nonatomic, copy) NSString *HotelDay;
@property (nonatomic, copy) NSString *EntertainmentFee;
@property (nonatomic, copy) NSString *EntertainmentDay;
@property (nonatomic, copy) NSString *MealFee;
@property (nonatomic, copy) NSString *MealDay;
@property (nonatomic, copy) NSString *CommunicationFee;
@property (nonatomic, copy) NSString *CommunicationDay;
@property (nonatomic, copy) NSString *TravelAllowance;
@property (nonatomic, copy) NSString *TravelAllowanceDay;
@property (nonatomic, copy) NSString *OverseasAllowance;
@property (nonatomic, copy) NSString *OverseasAllowanceDay;
@property (nonatomic, copy) NSString *OtherFee;
@property (nonatomic, copy) NSString *OtherDay;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *Remark;

+ (NSMutableDictionary *) initDicByModel:(FeeBudgetInfoModel *)model;

@end
