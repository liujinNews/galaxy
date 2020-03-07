//
//  TravelCarDetail.h
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TravelCarDetail : NSObject

@property (nonatomic, copy) NSString *TaskId;
@property (nonatomic, copy) NSString *FromCity;
@property (nonatomic, copy) NSString *FromCityCode;
@property (nonatomic, copy) NSString *ToCity;
@property (nonatomic, copy) NSString *ToCityCode;
@property (nonatomic, copy) NSString *VehicleDate;
@property (nonatomic, copy) NSString *Destination;
@property (nonatomic, copy) NSString *FromLocation;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Departure;
@property (nonatomic, copy) NSString *ToLocation;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(TravelCarDetail *)model;


@end

NS_ASSUME_NONNULL_END
