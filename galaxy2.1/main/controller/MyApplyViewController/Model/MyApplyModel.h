//
//  MyApplyModel.h
//  galaxy
//
//  Created by hfk on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyApplyModel : NSObject
@property (copy, nonatomic) NSString * taskId;         //ID
@property (copy, nonatomic) NSString * procId;       //
@property (copy, nonatomic) NSString * taskName;         //
@property (copy, nonatomic) NSString * flowGuid;     //
@property (copy, nonatomic) NSString * flowCode;     //费用类型
@property (copy, nonatomic) NSString * amount;
@property (copy, nonatomic) NSString * comment;
@property (copy, nonatomic) NSString * requestorUserId;
@property (copy, nonatomic) NSString * requestor;
@property (copy, nonatomic) NSString * requestorDate;
@property (copy, nonatomic) NSString * requestorDeptId;       //
@property (copy, nonatomic) NSString * requestorDept;      //
@property (copy, nonatomic) NSString * arrivalDate;
@property (copy, nonatomic) NSString * status;       //
@property (copy, nonatomic) NSString * paymentStatus;       //
@property (copy, nonatomic) NSString * paymentDate;
@property (copy, nonatomic) NSString * viewOrder;
@property (copy, nonatomic) NSString * expenseCode;
@property (copy, nonatomic) NSString * serialNo;
@property (copy, nonatomic) NSString * totalDays;

@property (copy, nonatomic) NSString * amountPayable;

@property (copy, nonatomic) NSString * bankAccount;
@property (copy, nonatomic) NSString * bankName;
@property (copy, nonatomic) NSString * finishDate;
@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * printed;
@property (copy, nonatomic) NSString * reserved1;
@property (copy, nonatomic) NSString * reserved2;
@property (copy, nonatomic) NSString * paymentAmount;











@end
