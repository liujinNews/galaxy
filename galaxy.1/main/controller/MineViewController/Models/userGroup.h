//
//  userGroup.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userGroup : NSObject

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *jobTitleCode;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSString *isPrimTerm;
@property (nonatomic, strong) NSString *isldSpv;

- (instancetype)initWithBydic:(NSDictionary *)dict;

@end
