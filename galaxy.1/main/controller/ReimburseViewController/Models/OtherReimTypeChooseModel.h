//
//  OtherReimTypeChooseModel.h
//  galaxy
//
//  Created by hfk on 2016/12/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherReimTypeChooseModel : NSObject
@property(nonatomic, strong)NSString *expenseCode;
@property(nonatomic, strong)NSString *expenseIcon;
@property(nonatomic, strong)NSString *expenseType;
@property(nonatomic, assign)BOOL isApproval;
@property(nonatomic, assign)BOOL isDaily;
@property(nonatomic, assign)BOOL isTravel;
@property(nonatomic, strong)NSString *parentCode;
@property(nonatomic, strong)NSNumber *parentId;
@end
