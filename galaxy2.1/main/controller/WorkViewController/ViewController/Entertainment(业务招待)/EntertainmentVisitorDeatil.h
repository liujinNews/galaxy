//
//  EntertainmentVisitorDeatil.h
//  galaxy
//
//  Created by hfk on 2018/6/29.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntertainmentVisitorDeatil : NSObject

@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *JobTitle;
@property (nonatomic,copy) NSString *Department;
@property (nonatomic,copy) NSString *VisitDate;
@property (nonatomic,copy) NSString *LeaveDate;
@property (nonatomic,copy) NSString *CostCenter;
@property (nonatomic,copy) NSString *CostCenterId;
@property (nonatomic,copy) NSString *BudgetAmt;
@property (nonatomic,copy) NSString *Remark;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(EntertainmentVisitorDeatil *)model;


@end
