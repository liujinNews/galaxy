//
//  UIViewController+Push.m
//  galaxy
//
//  Created by hfk on 2017/6/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "UIViewController+Push.h"
#import "ObjcRuntime.h"
#import "RDVTabBarController.h"

static const void *userIdKey = &userIdKey;
static const void *taskIdKey = &taskIdKey;
static const void *procIdKey = &procIdKey;
static const void *flowGuidKey = &flowGuidKey;
static const void *flowCodeKey = &flowCodeKey;
static const void *expenseCodeKey = &expenseCodeKey;
static const void *comeStatusKey = &comeStatusKey;
static const void *backIndexKey = &backIndexKey;
static const void *comeEditTypeKey = &comeEditTypeKey;

static const void *testIntegerKey = &testIntegerKey;


@implementation UIViewController (Push)
- (NSString *)pushUserId {
    return objc_getAssociatedObject(self, userIdKey);
}

- (void)setPushUserId:(NSString *)pushUserId {
    objc_setAssociatedObject(self, userIdKey, pushUserId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)pushTaskId {
    return objc_getAssociatedObject(self, taskIdKey);
}

- (void)setPushTaskId:(NSString *)pushTaskId {
    objc_setAssociatedObject(self, taskIdKey, pushTaskId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)pushProcId {
    return objc_getAssociatedObject(self, procIdKey);
}

- (void)setPushProcId:(NSString *)pushProcId {
    objc_setAssociatedObject(self, procIdKey, pushProcId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)pushFlowGuid {
    return objc_getAssociatedObject(self, flowGuidKey);
}

- (void)setPushFlowGuid:(NSString *)pushFlowGuid {
    objc_setAssociatedObject(self, flowGuidKey, pushFlowGuid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)pushFlowCode {
    return objc_getAssociatedObject(self, flowCodeKey);
}

- (void)setPushFlowCode:(NSString *)pushFlowCode {
    objc_setAssociatedObject(self, flowCodeKey, pushFlowCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)pushExpenseCode {
    return objc_getAssociatedObject(self, expenseCodeKey);
}

- (void)setPushExpenseCode:(NSString *)pushExpenseCode {
    objc_setAssociatedObject(self, expenseCodeKey, pushExpenseCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)pushComeStatus{
    return objc_getAssociatedObject(self, comeStatusKey);
}
- (void)setPushComeStatus:(NSString *)pushComeStatus {
    objc_setAssociatedObject(self, comeStatusKey, pushComeStatus, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)pushBackIndex{
    return objc_getAssociatedObject(self, backIndexKey);
}
- (void)setPushBackIndex:(NSString *)pushBackIndex{
    objc_setAssociatedObject(self, backIndexKey, pushBackIndex, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)pushComeEditType{
    return objc_getAssociatedObject(self, comeEditTypeKey);
}
-(void)setPushComeEditType:(NSString *)pushComeEditType{
    objc_setAssociatedObject(self, comeEditTypeKey, pushComeEditType, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSInteger)testInteger{
    return [objc_getAssociatedObject(self, testIntegerKey) integerValue];
}
-(void)setTestInteger:(NSInteger)testInteger{
    NSString * value = [NSString stringWithFormat:@"%ld",(long)testInteger];
    objc_setAssociatedObject(self, testIntegerKey,value,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)customViewDidAppear:(BOOL)animated{
    if (([NSStringFromClass([self class]) rangeOfString:@"MessageViewController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"TravelMainController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"ReimburseViewController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"WorkViewController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"MineViewController"].location != NSNotFound)) {
        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
        DebugLog(@"setTabBarHidden:NO --- customViewDidAppear : %@", NSStringFromClass([self class]));
    }
    [self customViewDidAppear:animated];
}

- (void)customViewWillDisappear:(BOOL)animated{
    [self customViewWillDisappear:animated];
}

- (void)customviewWillAppear:(BOOL)animated{
    if ([[self.navigationController childViewControllers] count] >1) {
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
        DebugLog(@"setTabBarHidden:YES --- customviewWillAppear : %@", NSStringFromClass([self class]));
    }else if (([NSStringFromClass([self class]) rangeOfString:@"MessageViewController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"TravelMainController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"ReimburseViewController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"WorkViewController"].location != NSNotFound)||([NSStringFromClass([self class]) rangeOfString:@"MineViewController"].location != NSNotFound)) {
        [[UnReadManager shareManager] updateUnRead];
        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
        DebugLog(@"setTabBarHidden:NO --- customViewDidAppear : %@", NSStringFromClass([self class]));
    }
    [self customviewWillAppear:animated];
}

+ (void)load{
    swizzleAllViewController();
}


@end

void swizzleAllViewController(void)
{
    Swizzle([UIViewController class], @selector(viewDidAppear:), @selector(customViewDidAppear:));
    Swizzle([UIViewController class], @selector(viewWillDisappear:), @selector(customViewWillDisappear:));
    Swizzle([UIViewController class], @selector(viewWillAppear:), @selector(customviewWillAppear:));
}
