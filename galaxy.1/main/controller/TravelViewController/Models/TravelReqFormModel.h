//
//  TravelReqFormModel.h
//  galaxy
//
//  Created by hfk on 2018/5/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelReqFormModel : NSObject

@property (nonatomic,copy)NSString *serialNo;
@property (nonatomic,copy)NSString *taskId;
@property (nonatomic,copy)NSString *userDspName;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *expiredTime;

//酒店
@property (nonatomic,copy)NSString *checkInCity;
@property (nonatomic,copy)NSString *checkInDateStr;
@property (nonatomic,copy)NSString *checkOutDateStr;
@property (nonatomic,copy)NSString *numberOfRooms;

//火车票机票
@property (nonatomic,copy)NSString *departureDateStr;
@property (nonatomic,copy)NSString *fromCity;
@property (nonatomic,copy)NSString *toCity;
@property (nonatomic,copy)NSString *passenger;
@property (nonatomic,copy)NSString *flyPeople;

//@property (nonatomic,copy)NSString *gridOrder;
//@property (nonatomic,copy)NSString *orderNumber;
//@property (nonatomic,copy)NSString *requestor;
//@property (nonatomic,copy)NSString *isTicket;
//@property (nonatomic,copy)NSString *isExist;
//@property (nonatomic,copy)NSString *expiredTime;
//@property (nonatomic,copy)NSString *checkInDate;
//@property (nonatomic,copy)NSString *checkOutDate;
//@property (nonatomic,copy)NSString *departureDate;


@end
