//
//  STNewPickModel.m
//  galaxy
//
//  Created by hfk on 2018/1/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "STNewPickModel.h"

@implementation STNewPickModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSMutableArray *)getYearDataArray{
    NSMutableArray *array=[NSMutableArray array];
    for (NSInteger i=2017; i<=2030; i++) {
        STNewPickModel *model=[[STNewPickModel alloc]init];
        model.Type=[NSString stringWithFormat:@"%ld",i];
        [array addObject:model];
    }
    return array;
}
+(NSMutableArray *)getYearMonthDataArray{
    NSMutableArray *array=[NSMutableArray array];
    for (NSInteger i=2017; i<=2030; i++) {
        STNewPickModel *model=[[STNewPickModel alloc]init];
        model.Type=[NSString stringWithFormat:@"%ld",i];
        model.SubDataArray=[NSMutableArray array];
        for (int j=1; j<=12; j++) {
            STNewPickSubModel *sub=[[STNewPickSubModel alloc]init];
            sub.Type=[NSString stringWithFormat:@"%d",j];
            [model.SubDataArray addObject:sub];
        }
        [array addObject:model];
    }
    return array;
}
+(NSMutableArray *)getYearQuarterDataArray{
    NSMutableArray *array=[NSMutableArray array];
    for (NSInteger i=2017; i<=2030; i++) {
        STNewPickModel *model=[[STNewPickModel alloc]init];
        model.Type=[NSString stringWithFormat:@"%ld",i];
        model.SubDataArray=[NSMutableArray array];
        for (int j=1; j<=4; j++) {
            STNewPickSubModel *sub=[[STNewPickSubModel alloc]init];
            sub.Type=[NSString stringWithFormat:@"%d",j];
            [model.SubDataArray addObject:sub];
        }
        [array addObject:model];
    }
    return array;
}
@end

@implementation STNewPickSubModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
