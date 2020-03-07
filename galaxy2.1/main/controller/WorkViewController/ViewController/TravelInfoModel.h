//
//  TravelInfoModel.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelInfoModel : NSObject

@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *Departure;
@property (nonatomic, copy) NSString *DepartureAmt;
@property (nonatomic, copy) NSString *ReturnAddr;
@property (nonatomic, copy) NSString *ReturnAmt;
@property (nonatomic, copy) NSString *TotalAmount;

+ (NSMutableDictionary *) initDicByModel:(TravelInfoModel *)model;

@end
