//
//  PerformanceDetail.m
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PerformanceDetail.h"

@implementation PerformanceDetail
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+(void)getPerformanceDetailWithDict:(NSDictionary *)result WithResultArray:(NSMutableArray *)resultArray{
    if ([result[@"performanceDetails"]isKindOfClass:[NSArray class]]) {
        NSArray *performanceDetails=result[@"performanceDetails"];
        for (NSDictionary *dict in performanceDetails) {
            PerformanceDetail *model=[[PerformanceDetail alloc]init];
            model.weight=[NSString isEqualToNull:dict[@"weight"]]?[NSString stringWithFormat:@" %@%%",dict[@"weight"]]:@"0%";
            model.weightName=[NSString isEqualToNull:dict[@"weightName"]]?[NSString stringWithFormat:@"%@ ",dict[@"weightName"]]:@"";
            model.performanceDetailItem=[NSMutableArray array];
            if ([dict[@"performanceDetailItem"] isKindOfClass:[NSArray class]]) {
                NSArray *arr=dict[@"performanceDetailItem"];
                if (arr.count>0) {
                    [PerformanceDetailSub getSubPerformanceDetailByArray:arr withResult:model.performanceDetailItem];
                }
            }
            [resultArray addObject:model];
        }
    }
}

@end


@implementation PerformanceDetailSub

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableDictionary *)initDicByModel:(PerformanceDetailSub *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

+(void)getSubPerformanceDetailByArray:(NSArray *)array withResult:(NSMutableArray *)resultarray{
    for (NSDictionary *dict in array) {
        PerformanceDetailSub *model=[[PerformanceDetailSub alloc]init];
        model.itemId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"itemId"]];
        model.itemName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"itemName"]];
        model.itemWeight=[NSString stringWithFormat:@"%@",[dict objectForKey:@"itemWeight"]];
        model.selfScore=[NSString stringWithFormat:@"%@",[dict objectForKey:@"selfScore"]];
        model.stdScore=[NSString stringWithFormat:@"%@",[dict objectForKey:@"stdScore"]];
        model.leaderScore=[NSString stringWithFormat:@"%@",[dict objectForKey:@"leaderScore"]];
        model.weight=[NSString stringWithFormat:@"%@",[dict objectForKey:@"weight"]];
        model.weightName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"weightName"]];
        model.weightId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"weightId"]];
        [resultarray addObject:model];
    }

    
}

@end
