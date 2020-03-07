//
//  AddReimShareModel.h
//  galaxy
//
//  Created by hfk on 2018/10/11.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddReimShareModel : NSObject

@property (nonatomic, copy) NSString *BranchId;
@property (nonatomic, copy) NSString *Branch;
@property (nonatomic, copy) NSString *RequestorDeptId;
@property (nonatomic, copy) NSString *RequestorDept;
@property (nonatomic, copy) NSString *RequestorBusDeptId;
@property (nonatomic, copy) NSString *RequestorBusDept;
@property (nonatomic, copy) NSString *CostCenterId;
@property (nonatomic, copy) NSString *CostCenter;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *ShareRatio;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Reserved1;
@property (nonatomic, copy) NSString *Reserved2;
@property (nonatomic, copy) NSString *Reserved3;
@property (nonatomic, copy) NSString *Reserved4;
@property (nonatomic, copy) NSString *Reserved5;
@property (nonatomic, copy) NSString *ShareType;

//礼品费字段
@property (nonatomic, copy) NSString *TCompanyName;  //对方公司名称
@property (nonatomic, copy) NSString *TRecipient;  //对方人员名称
@property (nonatomic, copy) NSString *GiftName; //物品名称

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(AddReimShareModel*)model;

@end

NS_ASSUME_NONNULL_END
