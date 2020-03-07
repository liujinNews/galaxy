//
//  InvoiceAppData.m
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "InvoiceAppData.h"

@implementation InvoiceAppData

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

+ (NSMutableDictionary *)initDicByModel:(InvoiceAppData *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}


@end
