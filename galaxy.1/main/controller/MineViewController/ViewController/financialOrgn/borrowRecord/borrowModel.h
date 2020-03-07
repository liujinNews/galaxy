//
//  borrowModel.h
//  galaxy
//
//  Created by 赵碚 on 16/1/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface borrowModel : NSObject

@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * comment;
@property(nonatomic,copy)NSString * idd;
@property(nonatomic,copy)NSString * operators;
@property(nonatomic,copy)NSString * operatorDate;
@property(nonatomic,copy)NSString * requestor;

@property(nonatomic,copy)NSString * repayAmount;
@property(nonatomic,copy)NSString * requestorDate;
@property(nonatomic,copy)NSString * requestorUserId;
@property(nonatomic,copy)NSString * type;

@property(nonatomic,copy)NSString * requestorDept;
@property(nonatomic,copy)NSString * requestorDeptId;

@property(nonatomic,copy)NSString * taskId;
@property(nonatomic,copy)NSString * flowCode;

@property(nonatomic,copy)NSString * Id;
@property(nonatomic,copy)NSString *operator;

+ (void)GetBorrowRecordDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@property(nonatomic,copy)NSString * currencyCode;
@property(nonatomic,copy)NSString * reason;
@property(nonatomic,copy)NSString * repayDate;
//账单详情
+ (void)GetRepaymentListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
