//
//  AddDetailsModel.m
//  galaxy
//
//  Created by hfk on 16/4/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "AddDetailsModel.h"

@implementation AddDetailsModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)getCostRecordDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSArray * carray = [dic objectForKey:@"result"];
    if ([carray isKindOfClass:[NSNull class]]||carray == nil||carray.count == 0||!carray){
        return;
    }
    for (NSDictionary * listDic in carray) {
        AddDetailsModel * data = [[AddDetailsModel alloc]init];
        [data setValuesForKeysWithDictionary:listDic];
        data.checked = [[NSString stringWithFormat:@"%@",listDic[@"checked"]]isEqualToString:@"1"] ? @"1":@"0";
        [array addObject:data];
        
    }
}

+ (NSString *)getCostRecordDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array Click:(NSMutableArray *)Click amount:(NSString *)amount{
    amount = @"0";
    NSArray * carray = [dic objectForKey:@"result"];
    if ([carray isKindOfClass:[NSNull class]]||carray == nil||carray.count == 0||!carray){
        return amount;
    }
    NSString *date = @"";
    NSMutableDictionary *mu_dic = [NSMutableDictionary dictionary];
    NSMutableArray *mu_arr = [NSMutableArray array];
//    NSMutableDictionary *mu_Clickdic = [NSMutableDictionary dictionary];
//    NSMutableArray *mu_Clickarr = [NSMutableArray array];
    for (int i = 0; i<carray.count; i++) {
        AddDetailsModel * model = [[AddDetailsModel alloc]init];
        [model setValuesForKeysWithDictionary:carray[i]];
        model.checked = [[NSString stringWithFormat:@"%@",carray[i][@"checked"]]isEqualToString:@"1"] ? @"1":@"0";
        amount = [GPUtils decimalNumberAddWithString:amount with:model.localCyAmount];
        if (i == 0) {
            date = model.expenseDate;
        }
        if ([model.expenseDate isEqualToString:date]) {
            [mu_arr addObject:model];
        }else{
            [mu_dic addString:date forKey:@"date"];
            [mu_dic addArray:mu_arr forKey:@"array"];
            [array addObject:mu_dic];
            mu_dic = [NSMutableDictionary dictionary];
            mu_arr = [NSMutableArray array];
            date = model.expenseDate;
            [mu_arr addObject:model];
        }
        if (i==carray.count-1) {
            if (mu_arr.count>0) {
                [mu_dic addString:date forKey:@"date"];
                [mu_dic addArray:mu_arr forKey:@"array"];
                [array addObject:mu_dic];
            }
        }
    }
    return amount;
}




+ (void)getCostOneDataByDictionary:(NSDictionary *)dic model:(AddDetailsModel *)data{
    if (![dic isKindOfClass:[NSNull class]]) {
        [data setValuesForKeysWithDictionary:dic];
        data.checked = [[NSString stringWithFormat:@"%@",dic[@"checked"]]isEqualToString:@"1"] ? @"1":@"0";
        
    }
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

+ (NSMutableDictionary *)initDicByModel:(AddDetailsModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
