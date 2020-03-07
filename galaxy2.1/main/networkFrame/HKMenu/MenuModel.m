//
//  MenuModel.m
//  PopMenuTableView
//
//  Created by hfk on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)MenuModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
