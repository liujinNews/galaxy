//
//  MeetingRoomModel.h
//  galaxy
//
//  Created by hfk on 2017/12/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingRoomModel : NSObject
@property (nonatomic, strong) NSString *nameCh;
@property (nonatomic, strong) NSString *nameEn;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *capacity;
@property (nonatomic, strong) NSMutableArray *meetingBookings;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *equipment;

+(void)getMeetRoomDateWithDict:(NSDictionary *)dic withResult:(NSMutableArray *)array;

@end


@interface MeetingRoomSubModel : NSObject
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *startTimeStr;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *endTimeStr;
@property (nonatomic, strong) NSString *startTime;
+(void)getMeetRoomDuringWithArray:(NSArray *)array withResult:(NSMutableArray *)resultarray;

@end
