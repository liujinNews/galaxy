//
//  CostClassesModel.h
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostClassesModel : NSObject
@property(nonatomic, strong)NSString *companyId;
@property(nonatomic, strong)NSString *expenseCode;
@property(nonatomic, strong)NSString *expenseIcon;
@property(nonatomic, strong)NSString *expenseLevel;
@property(nonatomic, strong)NSString *expenseType;
@property(nonatomic, strong)NSString *expenseTypeEn;
@property(nonatomic, strong)NSString *expenseTypeName;
@property(nonatomic, strong)NSString *expenseDesc;
@property(nonatomic, strong)NSString *expenseDescEn;
@property(nonatomic, strong)NSString *Id;
@property(nonatomic, strong)NSString *isTemplate;
@property(nonatomic, strong)NSString *no;
@property(nonatomic, strong)NSString *parentId;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *isApproval;
@property(nonatomic, strong)NSString *isChecked;
@property(nonatomic, strong)NSString *isDaily;
@property(nonatomic, strong)NSString *isTravel;
@end
