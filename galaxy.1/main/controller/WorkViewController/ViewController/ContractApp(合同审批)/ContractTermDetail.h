//
//  ContractTermDetail.h
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractTermDetail : NSObject

@property (nonatomic, copy) NSString * No;
@property (nonatomic, copy) NSString * Terms;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(ContractTermDetail *)model;


@end

NS_ASSUME_NONNULL_END
