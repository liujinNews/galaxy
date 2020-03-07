//
//  PayMentDetailModel.h
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayMentDetailModel : NSObject

@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *amountPayable;
@property (nonatomic,strong)NSString *arrivalDate;
@property (nonatomic,strong)NSString *bankAccount;
@property (nonatomic,strong)NSString *bankName;
@property (nonatomic,strong)NSString *comment;
@property (nonatomic,strong)NSString *expenseCode;
@property (nonatomic,strong)NSString *finishDate;
@property (nonatomic,strong)NSString *flowCode;
@property (nonatomic,strong)NSString *flowGuid;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *paymentDate;
@property (nonatomic,strong)NSString *paymentStatus;
@property (nonatomic,strong)NSString *printed;
@property (nonatomic,strong)NSString *procId;
@property (nonatomic,strong)NSString *requestor;
@property (nonatomic,strong)NSString *requestorDate;
@property (nonatomic,strong)NSString *requestorDept;
@property (nonatomic,strong)NSString *requestorDeptId;
@property (nonatomic,strong)NSString *requestorUserId;
@property (nonatomic,strong)NSString *serialNo;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *taskId;
@property (nonatomic,strong)NSString *taskName;
@property (nonatomic,strong)NSString *totalDays;
@property (nonatomic,strong)NSString *viewOrder;

+(NSString *)getTaskDateWithArray:(NSMutableArray *)arr withSource:(NSDictionary *)dict;
@end
