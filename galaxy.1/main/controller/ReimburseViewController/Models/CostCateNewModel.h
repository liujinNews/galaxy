//
//  CostCateNewModel.h
//  galaxy
//
//  Created by hfk on 2018/1/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostCateNewModel : NSObject

@property (nonatomic,copy) NSString *tax;
@property (nonatomic,copy) NSString *expenseType;
@property (nonatomic,copy) NSString *expenseCode;
@property (nonatomic,copy) NSString *expenseIcon;
@property (nonatomic,copy) NSString *expenseDesc;
@property (nonatomic,copy) NSString *expenseCat;//费用类别大类
@property (nonatomic,copy) NSString *expenseCatCode;
@property (nonatomic,copy) NSString *parentCode;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *isTravel;
@property (nonatomic,copy) NSString *isDaily;
@property (nonatomic,copy) NSString *isApproval;
@property (nonatomic,copy) NSString *isPayment;
@property (nonatomic,copy) NSString *isContract;
@property (nonatomic,copy) NSString *accountItemCode;
@property (nonatomic,copy) NSString *accountItem;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,strong) NSMutableArray *getExpTypeList;
@property (nonatomic,copy) NSString *expenseLevel;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *expenseTypeEn;
@property (nonatomic,copy) NSString *no;
@property (nonatomic,copy) NSString *expenseTypeName;
@property (nonatomic,copy) NSString *isTemplate;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *catNo;


//消费记录筛选
+ (void)getTypeByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

/**
 费用类别数据处理
 
 @param reqDict 请求返回数据
 @param resultArr 费用类别数组
 @param type 1记一笔等(collectionview,滚动,列表) 2费用申请等(只显示滚动式)
 @return 返回显示参数
 */
+(NSDictionary *)getCostCateByDict:(NSDictionary *)reqDict array:(NSMutableArray *)resultArr withType:(NSInteger)type;


/**
 获取滚轮式费用类别数据
 */
+(void)getCostCate:(NSArray *)array  result:(NSMutableArray *)resultarr;


@end


@interface CostCateNewSubModel : NSObject

@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *isTravel;
@property (nonatomic,strong) NSString *isDaily;
@property (nonatomic,strong) NSString *isApproval;
@property (nonatomic,strong) NSString *isPayment;
@property (nonatomic,strong) NSString *isContract;
@property (nonatomic,strong) NSString *tax;
@property (nonatomic,strong) NSString *expenseType;
@property (nonatomic,strong) NSString *expenseCode;
@property (nonatomic,strong) NSString *expenseIcon;
@property (nonatomic,strong) NSString *expenseDesc;
@property (nonatomic,strong) NSString *expenseCat;//费用类别大类
@property (nonatomic,strong) NSString *expenseCatCode;
@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSString *no;
@property (nonatomic,strong) NSString *catNo;
@property (nonatomic,strong) NSString *parentId;
@property (nonatomic,copy) NSString *accountItemCode;
@property (nonatomic,copy) NSString *accountItem;

+(void)getSubCostCateByArray:(NSArray *)array withResult:(NSMutableArray *)resultarray;


@end


