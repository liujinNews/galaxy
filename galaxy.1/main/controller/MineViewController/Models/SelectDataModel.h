//
//  SelectDataModel.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectDataModel : NSObject

@property (nonatomic, copy)NSString *active;
@property (nonatomic, copy)NSString *companyId;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *creater;
@property (nonatomic, copy)NSString *ids;
@property (nonatomic, copy)NSString *jobTitle;
@property (nonatomic, copy)NSString *jobTitleCode;
@property (nonatomic, copy)NSString *jobTitleEn;
@property (nonatomic, copy)NSString *updateTime;
@property (nonatomic, copy)NSString *updater;

@property (nonatomic, copy)NSString *descriptions;
@property (nonatomic, copy)NSString *total;
@property (nonatomic, copy)NSString *userLevel;
@property (nonatomic, copy)NSString *userLevelEn;

@property (nonatomic, copy)NSString *costCenter;

@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, copy)NSString *isCheck;

@property (nonatomic, copy)NSString *nodeId;
@property (nonatomic, copy)NSString *nodeName;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *no;

@property (nonatomic, copy) NSString *contractTyp;

@property (nonatomic, copy) NSString *contractName;
@property (nonatomic, copy) NSString *contractNo;
@property (nonatomic, copy) NSString *serialNo;
@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, copy) NSString *carDesc;
@property (nonatomic, copy) NSString *carNo;

- (instancetype)initWithBydic:(NSDictionary *)dict;

@end
