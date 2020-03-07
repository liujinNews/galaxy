//
//  projectManagerModel.h
//  galaxy
//
//  Created by 赵碚 on 16/2/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface projectManagerModel : NSObject
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *idd;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *projMgr;
@property (nonatomic, copy) NSString *projMgrUserId;
@property (nonatomic, copy) NSString *projName;
@property (nonatomic, copy) NSString *projNameEn;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *funder;
@property (nonatomic, copy) NSString *projTyp;
@property (nonatomic, copy) NSString *projTypId;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *costCenterId;
@property (nonatomic, copy) NSString *costCenter;

+ (void)GetProjectManagerDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;


@end
