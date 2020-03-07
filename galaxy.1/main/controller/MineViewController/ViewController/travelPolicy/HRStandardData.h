//
//  HRStandardData.h
//  galaxy
//
//  Created by 赵碚 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, hrstCellType) {
    hrstCellTypeNo,
    hrstCellTypeYes,
    hrstCellTypeAll,
    ForStCellType
} ;
@interface HRStandardData : NSObject
@property(nonatomic, assign)hrstCellType type;  //cell类型

@property(nonatomic,copy)NSString * housePrice0;
@property(nonatomic,copy)NSString * housePrice1;
@property(nonatomic,copy)NSString * housePrice2;
@property(nonatomic,copy)NSString * housePrice3;
@property(nonatomic,copy)NSString * housePrice4;
@property(nonatomic,copy)NSString * housePrice5;
@property(nonatomic,copy)NSString * idd;
@property(nonatomic,copy)NSString * isLimit;
@property(nonatomic,copy)NSString * standard;
@property(nonatomic,copy)NSString * userLevel;
@property(nonatomic,copy)NSString * userLevelId;
@property(nonatomic,copy)NSString * cellHeight;
+ (void)GetUserLevelListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

//补贴标准列表
@property(nonatomic,strong)NSArray * StdAllowances;

+ (void)GetUserForStandardListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)hrstArray ;

@property(nonatomic, strong)NSString *expenseCode;    //
@property(nonatomic, strong)NSString *amount;   //金额
@property(nonatomic, strong)NSString *expenseType;     //类别
@property(nonatomic, strong)NSString *unit;     //年月日
//补贴标准修改
+ (void)GetUserGetStdAllowancesDictionary:(NSArray *)items Array:(NSMutableArray *)hrstArray;



@end
