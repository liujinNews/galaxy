//
//  ReimShareModel.h
//  galaxy
//
//  Created by hfk on 2017/9/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReimShareModel : NSObject

@property(nonatomic,copy)NSString *BranchId;
@property(nonatomic,copy)NSString *Branch;
@property(nonatomic,copy)NSString *RequestorDeptId;
@property(nonatomic,copy)NSString *RequestorDept;
@property(nonatomic,copy)NSString *RequestorBusDeptId;
@property(nonatomic,copy)NSString *RequestorBusDept;
@property(nonatomic,copy)NSString *CostCenterId;
@property(nonatomic,copy)NSString *CostCenter;
@property(nonatomic,copy)NSString *ProjName;
@property(nonatomic,copy)NSString *ProjId;
@property(nonatomic,copy)NSString *ProjMgrUserId;
@property(nonatomic,copy)NSString *ProjMgr;
@property(nonatomic,copy)NSString *ExpenseCode;
@property(nonatomic,copy)NSString *ExpenseType;
@property(nonatomic,copy)NSString *ExpenseIcon;
@property(nonatomic,copy)NSString *ExpenseCatCode;
@property(nonatomic,copy)NSString *ExpenseCat;
@property(nonatomic,copy)NSString *Amount;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *Reserved1;
@property(nonatomic,copy)NSString *Reserved2;
@property(nonatomic,copy)NSString *Reserved3;
@property(nonatomic,copy)NSString *Reserved4;
@property(nonatomic,copy)NSString *Reserved5;
@property(nonatomic,copy)NSString *TaskId;
@property(nonatomic,copy)NSString *GridOrder;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(ReimShareModel*)model;

@end
