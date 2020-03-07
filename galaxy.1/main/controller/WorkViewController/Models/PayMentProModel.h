//
//  PayMentProModel.h
//  galaxy
//
//  Created by hfk on 2017/6/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayMentProModel : NSObject
@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *amountPayable;
@property (nonatomic,strong)NSString *companyId;
@property (nonatomic,strong)NSString *flowCode;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *payCode;
@property (nonatomic,strong)NSString *payEnpAccount;
@property (nonatomic,strong)NSString *payEnpName;
@property (nonatomic,strong)NSString *recAcctName;
@property (nonatomic,strong)NSString *recBankName;
@property (nonatomic,strong)NSString *recDepType;
@property (nonatomic,strong)NSString *recPerAccount;
@property (nonatomic,strong)NSString *requestor;
@property (nonatomic,strong)NSString *serialNo;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *statusStr;
@property (nonatomic,strong)NSString *taskId;
@property (nonatomic,strong)NSString *taskName;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *xSerialNo;

@end
