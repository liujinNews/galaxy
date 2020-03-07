//
//  PerformanceDetail.h
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceDetail : NSObject
//@property(nonatomic,copy)NSString *gridOrder;
//@property(nonatomic,copy)NSString *weightId;
//@property(nonatomic,copy)NSString *taskId;
@property(nonatomic,copy)NSString *weight;
@property(nonatomic,copy)NSString *weightName;
@property(nonatomic,strong)NSMutableArray *performanceDetailItem;

+(void)getPerformanceDetailWithDict:(NSDictionary *)result WithResultArray:(NSMutableArray *)resultArray;

@end

@interface PerformanceDetailSub : NSObject

@property (nonatomic,strong) NSString *weight;
@property (nonatomic,strong) NSString *weightName;
@property (nonatomic,strong) NSString *weightId;
@property (nonatomic,strong) NSString *itemId;
@property (nonatomic,strong) NSString *itemName;
@property (nonatomic,strong) NSString *itemWeight;
@property (nonatomic,strong) NSString *selfScore;
@property (nonatomic,strong) NSString *stdScore;
@property (nonatomic,strong) NSString *leaderScore;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(PerformanceDetailSub *)model;

+(void)getSubPerformanceDetailByArray:(NSArray *)array withResult:(NSMutableArray *)resultarray;
@end
