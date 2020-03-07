//
//  TravelFlightDetailModel.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/10.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelFlightDetailModel : NSObject

@property(nonatomic,copy)NSString *departuredate;
@property(nonatomic,copy)NSString *fromcitycode;
@property(nonatomic,copy)NSString *fromcity;
@property(nonatomic,copy)NSString *fromcitytype;
@property(nonatomic,copy)NSString *tocitycode;
@property(nonatomic,copy)NSString *tocity;
@property(nonatomic,copy)NSString *tocitytype;
@property(nonatomic,copy)NSString *flypeople;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic, copy)NSString *indexid;
@property (nonatomic, copy) NSString *isInternational;

-(TravelFlightDetailModel *)initDicToModel:(NSDictionary *)dic;

@end
