//
//  ConferenceDeatil.h
//  galaxy
//
//  Created by hfk on 2017/12/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConferenceDeatil : NSObject

@property (nonatomic,copy)NSString *Subject;
@property (nonatomic,copy)NSString *Spokesman;
@property (nonatomic,copy)NSString *Remark;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(ConferenceDeatil *)model;

@end
