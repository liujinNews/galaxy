//
//  SpecialReqestDetail.h
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialReqestDetail : NSObject

@property (nonatomic, copy) NSString *StdTypeId;
@property (nonatomic, copy) NSString *StdType;
@property (nonatomic, copy) NSString *Standard;
@property (nonatomic, copy) NSString *ActualExecution;
@property (nonatomic, copy) NSString *Reason;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(SpecialReqestDetail *)model;


@end
