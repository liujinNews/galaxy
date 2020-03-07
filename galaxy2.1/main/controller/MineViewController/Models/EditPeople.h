//
//  EditPeople.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userGroup.h"

@interface EditPeople : NSObject

@property (nonatomic, strong) NSMutableArray *userGroup;

@property (nonatomic, copy) NSString *bankAccountInfo;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *branchName;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *costCenter;
@property (nonatomic, copy) NSString *costCenterId;
@property (nonatomic, copy) NSString *costCenters;
@property (nonatomic, copy) NSString *credentialType;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *identityCardId;
@property (nonatomic, copy) NSString *isEmailVerified;
@property (nonatomic, copy) NSString *isExp;
@property (nonatomic, copy) NSString *isMobileHide;
@property (nonatomic, copy) NSString *isMobileVerified;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *photoGraph;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, copy) NSString *userAccount;
@property (nonatomic, copy) NSString *userDspName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userLevel;
@property (nonatomic, copy) NSString *userLevels;
@property (nonatomic, copy) NSString *userLevelId;
@property (nonatomic, copy) NSString *viewRptPer;
@property (nonatomic, copy) NSString *hrid;
@property (nonatomic, copy) NSString *busDepartment;
@property (nonatomic, copy) NSString *busDepartmentName;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *locationName;


@property (nonatomic, copy) NSString *lineManagerId;
@property (nonatomic, copy) NSString *lineManager;
@property (nonatomic, copy) NSString *approverId1;
@property (nonatomic, copy) NSString *approver1;
@property (nonatomic, copy) NSString *approverId2;
@property (nonatomic, copy) NSString *approver2;
@property (nonatomic, copy) NSString *approverId3;
@property (nonatomic, copy) NSString *approver3;
@property (nonatomic, copy) NSString *approverId4;
@property (nonatomic, copy) NSString *approver4;
@property (nonatomic, copy) NSString *approverId5;
@property (nonatomic, copy) NSString *approver5;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *subAccountName;

- (instancetype)initWithBydic:(NSDictionary *)dict;


@end
