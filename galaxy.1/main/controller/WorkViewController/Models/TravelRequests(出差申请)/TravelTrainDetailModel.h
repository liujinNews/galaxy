//
//  TravelTrainDetailModel.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelTrainDetailModel : NSObject

@property(nonatomic,copy)NSString *departuredate;
@property(nonatomic,copy)NSString *fromcitycode;
@property(nonatomic,copy)NSString *fromcity;
@property(nonatomic,copy)NSString *fromcitytype;
@property(nonatomic,copy)NSString *tocitycode;
@property(nonatomic,copy)NSString *tocity;
@property(nonatomic,copy)NSString *tocitytype;
@property(nonatomic,copy)NSString *passenger;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic, copy)NSString *indexid;

-(TravelTrainDetailModel *)initDicToModel:(NSDictionary *)dic;

@end
