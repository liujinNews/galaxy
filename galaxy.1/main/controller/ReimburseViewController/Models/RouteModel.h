//
//  RouteModel.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteModel : NSObject

@property (nonatomic, strong) NSString *departureName;//出发地
@property (nonatomic, strong) NSString *arrivalName;//目的地
@property (nonatomic, strong) NSString *mileage;//里程
@property (nonatomic, strong) NSString *track;//轨迹
@property (nonatomic, strong) NSString *departureTimeStr;//出发时间
@property (nonatomic, strong) NSString *arrivalTimeStr;//到达时间
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *imported;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *createTime;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
