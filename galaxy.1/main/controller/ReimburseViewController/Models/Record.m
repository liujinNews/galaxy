//
//  Record.m
//  galaxy
//
//  Created by hfk on 2017/8/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "Record.h"
@interface Record()<NSCoding>


@property (nonatomic, assign) double distance;

@property (nonatomic, assign) CLLocationCoordinate2D * coords;

@end

@implementation Record

#pragma mark - interface

- (NSInteger)numOfLocations;
{
    return self.locationsArray.count;
}

- (CLLocation *)startLocation
{
    return [self.locationsArray firstObject];
}

- (CLLocation *)endLocation
{
    return [self.locationsArray lastObject];
}

- (void)addLocation:(CLLocation *)location
{
    _endTime =[GPUtils getNowTimeDateWithFormatter:@"yyyy/MM/dd HH:mm"];
    [self.locationsArray addObject:location];
}

- (CLLocationCoordinate2D *)coordinates
{
    if (self.coords != NULL)
    {
        free(self.coords);
        self.coords = NULL;
    }
    
    self.coords = (CLLocationCoordinate2D *)malloc(self.locationsArray.count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < self.locationsArray.count; i++)
    {
        CLLocation *location = self.locationsArray[i];
        self.coords[i] = location.coordinate;
    }
    
    return self.coords;
}
- (CLLocationDistance)totalDistance
{
    CLLocationDistance distance = 0;
    
    if (self.locationsArray.count > 1)
    {
        CLLocation *currentLocation = [self.locationsArray firstObject];
        for (CLLocation *location in self.locationsArray)
        {
            distance += [location distanceFromLocation:currentLocation];
            currentLocation = location;
        }
    }
    
    return distance;
}

//- (NSArray *)totalDuration
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
//    NSInteger mySeconds=(NSInteger)([[dateFormatter dateFromString:self.endTime] timeIntervalSinceDate:[dateFormatter dateFromString:self.startTime]]);
//    NSString *min=[NSString stringWithFormat:@"%ld",(mySeconds / 60) % 60];
//    NSString *hour=[NSString stringWithFormat:@"%ld", mySeconds / 3600];
//    return @[hour,min];
//}


#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.locationsArray = [aDecoder decodeObjectForKey:@"locations"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.locationsArray forKey:@"locations"];
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _startTime = [GPUtils getNowTimeDateWithFormatter:@"yyyy/MM/dd HH:mm"];
        _endTime = (id)[NSNull null];
        _locationsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
