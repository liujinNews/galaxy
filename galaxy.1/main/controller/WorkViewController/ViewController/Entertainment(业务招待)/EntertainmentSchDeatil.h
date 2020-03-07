//
//  EntertainmentSchDeatil.h
//  galaxy
//
//  Created by hfk on 2018/4/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntertainmentSchDeatil : NSObject

@property (nonatomic,copy)NSString *EntertainDate;
@property (nonatomic,copy)NSString *EntertainAddr;
@property (nonatomic,copy)NSString *EntertainContent;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(EntertainmentSchDeatil *)model;


@end
