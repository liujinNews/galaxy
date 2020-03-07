//
//  UIViewController+Push.h
//  galaxy
//
//  Created by hfk on 2017/6/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Push)
@property (nonatomic, copy) NSString *pushUserId;
@property (nonatomic, copy) NSString *pushTaskId;
@property (nonatomic, copy) NSString *pushProcId;
@property (nonatomic, copy) NSString *pushFlowGuid;
@property (nonatomic, copy) NSString *pushFlowCode;
@property (nonatomic, copy) NSString *pushExpenseCode;
@property (nonatomic, copy) NSString *pushComeStatus;
@property (nonatomic, copy) NSString *pushBackIndex;
@property (nonatomic, copy) NSString *pushComeEditType;

@property (nonatomic,assign) NSInteger testInteger;


@end
void swizzleAllViewController(void);
