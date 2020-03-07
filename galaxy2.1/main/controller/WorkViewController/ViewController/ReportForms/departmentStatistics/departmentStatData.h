//
//  departmentStatData.h
//  galaxy
//
//  Created by 赵碚 on 16/6/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, departmentCellType) {
    departmentCell,
    departmentCellAmount,
    departmentCellPerson,
    departmentCellDepart,
    departmentCellCategary,
} ;
@interface departmentStatData : NSObject
@property(nonatomic, assign)departmentCellType type;  //cell类型
@property(nonatomic,copy)NSString * groupId;
@property(nonatomic,copy)NSString * groupName;
@property(nonatomic,copy)NSString * totalAmount;
@property(nonatomic,copy)NSString * height;
@property(nonatomic,copy)NSString * gender;
@property(nonatomic,copy)NSString * photoGraph;
@property(nonatomic,copy)NSString * userDspName;
@property(nonatomic,copy)NSString * userId;

@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * expenseCode;
@property(nonatomic,copy)NSString * expenseDate;
@property(nonatomic,copy)NSString * expenseIcon;
@property(nonatomic,copy)NSString * expenseType;


//按员工费用统计
+ (void)GetDepartmentStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)groupsArray Array:(NSMutableArray *)groupMbrsArray Array:(NSMutableArray *)array;

//按费用类别统计
+ (void)GetDepartmentStatCategaryDictionary:(NSDictionary *)dic Array:(NSMutableArray *)groupsArray Array:(NSMutableArray *)groupMbrsArray Array:(NSMutableArray *)array;

@end
