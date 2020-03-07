//
//  personnalSynData.h
//  galaxy
//
//  Created by 赵碚 on 16/5/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personnalSynData : NSObject
@property(nonatomic,copy)NSString * fromCity;
@property(nonatomic,copy)NSString * fromDate;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * photoGraph;
@property(nonatomic,copy)NSString * gender;
@property(nonatomic,copy)NSString * reason;
@property(nonatomic,copy)NSString * requestor;
@property(nonatomic,copy)NSString * requestorDept;
@property(nonatomic,copy)NSString * toCity;
@property(nonatomic,copy)NSString * toDate;
@property(nonatomic,copy)NSString * userDspName;
@property(nonatomic,copy)NSString * userId;
+ (void)GetPersonnalSynDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
