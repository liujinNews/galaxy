//
//  MyChopDeatil.h
//  galaxy
//
//  Created by hfk on 2017/12/8.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyChopDeatil : NSObject
@property (nonatomic,copy)NSString *SealTypeId;
@property (nonatomic,copy)NSString *SealType;
@property (nonatomic,copy)NSString *Qty;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(MyChopDeatil *)model;

@end
