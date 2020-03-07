//
//  NSDictionary+EM.m
//  galaxy
//
//  Created by hfk on 2017/7/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NSDictionary+EM.h"

@implementation NSDictionary (EM)
+(instancetype)dictionaryWithObjects:(const id[])objects forKeys:(const id[])keys count:(NSUInteger)cnt
{
    NSMutableArray *validKeys = [NSMutableArray array];
    NSMutableArray *validObjs = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < cnt; i ++) {
        if (keys[i]) {
            if (objects[i]) {
                [validKeys addObject:keys[i]];
                [validObjs addObject:objects[i]];
            }else{
                [validKeys addObject:keys[i]];
                [validObjs addObject:@""];
            }
        }
    }
    
    return [self dictionaryWithObjects:validObjs forKeys:validKeys];
}
@end
