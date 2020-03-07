//
//  addTravelAndDayCateryData.h
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addTravelAndDayCateryData : NSObject

@property(nonatomic,copy)NSString * Idd;//类别Id

@property(nonatomic,copy)NSString * ExpenseType;//费用父类别

@property(nonatomic,copy)NSString * ExpenseCode;//费用父编码

@property(nonatomic,copy)NSString * ExpenseIcon;//费用图标

@property(nonatomic,strong)NSMutableArray * GetExpTypeList;//费用子类别集合

//
@property(nonatomic,assign)CGSize sizes;
@property(nonatomic,strong)NSString * expenstr;
+ (void)GetTravelAndDayCateryDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@property (nonatomic, copy) NSString * isTravelApp;//是否为出差申请 0:否，1是
@property (nonatomic, copy) NSString * isDaily;//是否为日常费 0:否，1是
@property (nonatomic, copy) NSString * isTravel;//是否为差旅费 0:否，1是
@property (nonatomic, copy) NSString * isApproval;//是否为专项 0:否，1是
@property (nonatomic, copy) NSString * isPayment;//是否为付款 0:否，1是
@property (nonatomic, copy) NSString * isContract;//是否为合同 0:否，1是
@property (nonatomic, copy) NSString * tax;//是否有税额 0:没有，1有

@property(nonatomic,copy)NSString * coId;//子类别Id
@property(nonatomic,copy)NSString * coExpenseType;//子费用类别
+(void)getResultDate:(NSDictionary *)dict WithArray:(NSMutableArray *)array;
//费用类别collection
+ (void)GetCollectionAddTravelAndDayCateryDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;
//提交数组
+(void)getSubmitData:(NSMutableArray *)sourceArr WithResultArr:(NSMutableArray *)aimArr;
@end
