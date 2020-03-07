//
//  ComPeopleModel.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComPeopleModel : NSObject

@property (nonatomic, copy)NSString *companyId;
@property (nonatomic, copy)NSString *jobTitle;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *photoGraph;
@property (nonatomic, copy)NSString *userDspName;
@property (nonatomic, copy)NSString *userId;

@property (nonatomic, copy)NSString *groupCode;
@property (nonatomic, copy)NSString *groupLevel;
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, copy)NSString *mbrs;
@property (nonatomic, copy)NSString *parentId;

//搜索用数据
@property (nonatomic, copy)NSString *contact;
@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *gender;
@property (nonatomic, copy)NSString *jobTitleCode;
@property (nonatomic, copy)NSString *requestor;
@property (nonatomic, copy)NSString *requestorAccount;

@property (nonatomic, copy)NSString *requestorDept;
@property (nonatomic, copy)NSString *requestorDeptId;
@property (nonatomic, copy)NSString *requestorHRID;
@property (nonatomic, copy)NSString *requestorUserId;

@property (nonatomic, copy)NSString *isNow;

- (instancetype)initWithBydic:(NSDictionary *)dict;

@end
