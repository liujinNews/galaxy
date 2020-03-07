//
//  Record.h
//  galaxy
//
//  Created by hfk on 2017/8/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface Record : NSObject
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *startplace;
@property (nonatomic, strong) NSString *endPlace;
@property (nonatomic, strong) NSMutableArray *locationsArray;



- (void)addLocation:(CLLocation *)location;

- (NSInteger)numOfLocations;

- (CLLocation *)startLocation;

- (CLLocation *)endLocation;

- (CLLocationCoordinate2D *)coordinates;

- (CLLocationDistance)totalDistance;

//- (NSArray *)totalDuration;

@end
