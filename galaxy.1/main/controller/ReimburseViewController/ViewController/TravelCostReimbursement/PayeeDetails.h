//
//  PayeeDetails.h
//  galaxy
//
//  Created by hfk on 2018/8/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayeeDetails : NSObject

@property (nonatomic, copy) NSString * Payee;
@property (nonatomic, copy) NSString * CredentialType;
@property (nonatomic, copy) NSString * IdentityCardId;
@property (nonatomic, copy) NSString * DepositBank;
@property (nonatomic, copy) NSString * BankAccount;
@property (nonatomic, copy) NSString * Amount;
@property (nonatomic, copy) NSString * BankNo;
@property (nonatomic, copy) NSString * BankCode;
@property (nonatomic, copy) NSString * CNAPS;
@property (nonatomic, copy) NSString * BankOutlets;
@property (nonatomic, copy) NSString * BankProvinceCode;
@property (nonatomic, copy) NSString * BankProvince;
@property (nonatomic, copy) NSString * BankCityCode;
@property (nonatomic, copy) NSString * BankCity;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(PayeeDetails *)model;

@end
