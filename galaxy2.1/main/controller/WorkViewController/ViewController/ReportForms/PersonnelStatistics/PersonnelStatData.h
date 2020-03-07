//
//  PersonnelStatData.h
//  galaxy
//
//  Created by 赵碚 on 16/6/28.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonnelStatData : NSObject
@property(nonatomic,copy)NSString * expenseCode;
@property(nonatomic,copy)NSString * expenseDate;
@property(nonatomic,copy)NSString * expenseType;
@property(nonatomic,copy)NSString * requestor;
@property(nonatomic,copy)NSString * requestorDate;
@property(nonatomic,copy)NSString * requestorUserId;
@property(nonatomic,copy)NSString * totalAmount;

//员工费用统计、类别
+ (void)GetPersonnelStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

//项目费用统计
@property(nonatomic,copy)NSString * projName;
+ (void)GetProjectStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

//ZF项目费用统计
@property(nonatomic,copy)NSString * descriptino;
@property(nonatomic,copy)NSString * idd;
+ (void)GetZFProjectStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;


//部门员工费用统计
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * expenseIcon;
+ (void)GetDepartmentStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
