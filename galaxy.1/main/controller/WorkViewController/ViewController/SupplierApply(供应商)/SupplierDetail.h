//
//  SupplierDetail.h
//  galaxy
//
//  Created by hfk on 2018/6/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplierDetail : NSObject

@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Sex;
@property (nonatomic, copy) NSString *Dept;
@property (nonatomic, copy) NSString *JobTitle;
@property (nonatomic, copy) NSString *Tel;
@property (nonatomic, copy) NSString *Email;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(SupplierDetail *)model;


@end
