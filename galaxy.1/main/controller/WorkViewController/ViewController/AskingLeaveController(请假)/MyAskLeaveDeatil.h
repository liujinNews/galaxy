//
//  MyAskLeaveDeatil.h
//  galaxy
//
//  Created by hfk on 2018/3/14.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAskLeaveDeatil : NSObject

@property (nonatomic,copy)NSString * UserId;
@property (nonatomic,copy)NSString * ObjectId;
@property (nonatomic,copy)NSString * WtYear;
@property (nonatomic,copy)NSString * WtMonth;
@property (nonatomic,copy)NSString * WtDate;
@property (nonatomic,copy)NSString * TimeUnit;
@property (nonatomic,copy)NSString * TotalTime;
@property (nonatomic,copy)NSString * FlowCode;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(MyAskLeaveDeatil *)model;

@end
