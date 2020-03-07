//
//  NSArray+safe.m
//  galaxy
//
//  Created by hfk on 2017/8/4.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NSArray+safe.h"

@implementation NSArray (safe)
+(instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt{
    NSMutableArray *validobject = [NSMutableArray array];
    for (NSUInteger i = 0; i < cnt; i ++) {
        if (objects[i]) {
            [validobject addObject:objects[i]];
        }
    }
    return validobject;
    
}

@end
