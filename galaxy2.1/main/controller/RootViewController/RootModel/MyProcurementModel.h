//
//  MyProcurementModel.h
//  galaxy
//
//  Created by hfk on 16/4/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProcurementModel : NSObject

@property (nonatomic,copy)NSString * Description;
@property (nonatomic,copy)NSString * fieldName;
@property (nonatomic,copy)NSString * fieldValue;
@property (nonatomic,copy)NSNumber * isRequired;
@property (nonatomic,copy)NSNumber * isShow;
@property (nonatomic,copy)NSString * tips;
@property (nonatomic,copy)NSString * ctrlTyp;
@property (nonatomic,copy)NSString * masterId;

@property (nonatomic,copy)NSString * isOnlyRead;//0可编辑 1不可编辑
@property (nonatomic,assign)NSInteger enterLimit;
@property (nonatomic,copy)NSString *isEdit;
@property (nonatomic,copy)NSString *isNotSelect;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(MyProcurementModel *)model;

@end
