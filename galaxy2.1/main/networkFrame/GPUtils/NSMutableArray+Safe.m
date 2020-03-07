//
//  NSMutableArray+Safe.m
//  galaxy
//
//  Created by hfk on 2017/7/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        Method sourceMethod1 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
        //        Method destMethod1 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(safeObjectAtIndex:));
        //        method_exchangeImplementations(sourceMethod1, destMethod1);
        Swizzle(objc_getClass("__NSArrayM"),@selector(objectAtIndex:),@selector(safeObjectAtIndex:));
        
        
        //        Method sourceMethod2 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(removeObjectAtIndex:));
        //        Method destMethod2 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(safeRemoveObjectAtIndex:));
        //        method_exchangeImplementations(sourceMethod2, destMethod2);
        Swizzle(objc_getClass("__NSArrayM"),@selector(removeObjectAtIndex:),@selector(safeRemoveObjectAtIndex:));
        
        
        //        Method sourceMethod3 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(insertObject:atIndex:));
        //        Method destMethod3 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(safeInsertObject:atIndex:));
        //        method_exchangeImplementations(sourceMethod3, destMethod3);
        Swizzle(objc_getClass("__NSArrayM"),@selector(insertObject:atIndex:),@selector(safeInsertObject:atIndex:));
        
        //        Method sourceMethod4 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(replaceObjectAtIndex:withObject:));
        //        Method destMethod4 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(safeReplaceObjectAtIndex:withObject:));
        //        method_exchangeImplementations(sourceMethod4, destMethod4);
        Swizzle(objc_getClass("__NSArrayM"),@selector(replaceObjectAtIndex:withObject:),@selector(safeReplaceObjectAtIndex:withObject:));
        
    });
}
#pragma mark - 数组的安全处理
-(instancetype)safeObjectAtIndex:(NSInteger)index
{
    if (self.count <=index) {
        NSLog(@"Runtime Warning:index %li out of bound",index);
        return nil;
    }
    
    return [self safeObjectAtIndex:index];
}
-(void)safeRemoveObjectAtIndex:(NSInteger)index
{
    if (self.count <= index) {
        NSLog(@"Runtime Warning:index %li out of bound",index);
        return;
    }
    
    [self safeRemoveObjectAtIndex:index];
}
-(void)safeInsertObject:(id)object atIndex:(NSInteger)index
{
    if (!object) {
        NSLog(@"Runtime Warning:insert object can not be nil");
        return;
    }
    
    if (self.count < index) {
        NSLog(@"Runtime Warning:insert object at index %li out of bound",index);
        return;
    }
    
    [self safeInsertObject:object atIndex:index];
}
-(void)safeReplaceObjectAtIndex:(NSInteger)index withObject:(id)object
{
    if ( self.count <= index) {
        NSLog(@"Runtime Warning:index %li out of bound",index);
        return;
    }
    
    if (!object) {
        NSLog(@"Runtime Warning:object can not be empty");
        return;
    }
    
    [self safeReplaceObjectAtIndex:index withObject:object];
}
@end
