//
//  TravelPeopleInfoModel.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelPeopleInfoModel : NSObject

@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *IdNumber;
@property (nonatomic, copy) NSString *UserDeptId;
@property (nonatomic, copy) NSString *UserDept;
@property (nonatomic, copy) NSString *JobTitleCode;
@property (nonatomic, copy) NSString *JobTitle;
@property (nonatomic, copy) NSString *UserLevelId;
@property (nonatomic, copy) NSString *UserLevel;
@property (nonatomic, copy) NSString *TravelPurpose;
@property (nonatomic, copy) NSString *TravelAddr;
@property (nonatomic, copy) NSString *TravelTime;


+ (NSMutableDictionary *) initDicByModel:(TravelPeopleInfoModel *)model;

@end
