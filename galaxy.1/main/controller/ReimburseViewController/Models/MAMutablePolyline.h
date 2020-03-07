//
//  MAMutablePolyline.h
//  galaxy
//
//  Created by hfk on 2017/8/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAOverlay.h>
@interface MAMutablePolyline : NSObject<MAOverlay>

/* save MAMapPoints by NSValue */
@property (nonatomic, strong) NSMutableArray *pointArray;

- (instancetype)initWithPoints:(NSArray *)nsvaluePoints;

- (MAMapRect)showRect;

- (MAMapPoint)mapPointForPointAt:(NSUInteger)index;

- (void)updatePoints:(NSArray *)points;

- (void)appendPoint:(MAMapPoint)point;

@end
