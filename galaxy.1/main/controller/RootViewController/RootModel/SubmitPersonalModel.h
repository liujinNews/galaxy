//
//  SubmitPersonalModel.h
//  galaxy
//
//  Created by hfk on 2017/12/2.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitPersonalModel : NSObject

/**
 填表人相关
 */
@property (nonatomic, copy) NSString *Operator;
@property (nonatomic, copy) NSString *OperatorUserId;
@property (nonatomic, copy) NSString *OperatorDeptId;
@property (nonatomic, copy) NSString *OperatorDept;

@property (nonatomic, copy) NSString *Requestor;
@property (nonatomic, copy) NSString *RequestorUserId;
@property (nonatomic, copy) NSString *Contact;
@property (nonatomic, copy) NSString *RequestorDeptId;
@property (nonatomic, copy) NSString *RequestorDept;
@property (nonatomic, copy) NSString *JobTitleCode;
@property (nonatomic, copy) NSString *JobTitle;
@property (nonatomic, copy) NSString *JobTitleLvl;
@property (nonatomic, copy) NSString *UserLevelId;
@property (nonatomic, copy) NSString *UserLevel;
@property (nonatomic, copy) NSString *CompanyId;


@property (nonatomic, copy) NSString *Hrid;
@property (nonatomic, copy) NSString *Branch;
@property (nonatomic, copy) NSString *BranchId;
@property (nonatomic, copy) NSString *CostCenterId;
@property (nonatomic, copy) NSString *CostCenter;
@property (nonatomic, copy) NSString *CostCenterMgrUserId;
@property (nonatomic, copy) NSString *CostCenterMgr;
@property (nonatomic, copy) NSString *RequestorBusDept;
@property (nonatomic, copy) NSString *RequestorBusDeptId;
@property (nonatomic, copy) NSString *AreaId;
@property (nonatomic, copy) NSString *Area;
@property (nonatomic, copy) NSString *LocationId;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *UserReserved1;
@property (nonatomic, copy) NSString *UserReserved2;
@property (nonatomic, copy) NSString *UserReserved3;
@property (nonatomic, copy) NSString *UserReserved4;
@property (nonatomic, copy) NSString *UserReserved5;
@property (nonatomic, copy) NSString *UserReserved6;
@property (nonatomic, copy) NSString *UserReserved7;
@property (nonatomic, copy) NSString *UserReserved8;
@property (nonatomic, copy) NSString *UserReserved9;
@property (nonatomic, copy) NSString *UserReserved10;
@property (nonatomic, copy) NSString *RequestorDate;

@property (nonatomic, copy) NSString *ApproverId1;
@property (nonatomic, copy) NSString *ApproverId2;
@property (nonatomic, copy) NSString *ApproverId3;
@property (nonatomic, copy) NSString *ApproverId4;
@property (nonatomic, copy) NSString *ApproverId5;
@property (nonatomic, copy) NSString *UserLevelNo;

@property (nonatomic, copy) NSString *RequestorPhotoGraph;
@property (nonatomic, copy) NSString *RequestorGender;
@property (nonatomic, copy) NSString *RequestorAccount;

//项目
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
//项目活动
@property (nonatomic, copy) NSString *ProjectActivityLv1;
@property (nonatomic, copy) NSString *ProjectActivityLv1Name;
@property (nonatomic, copy) NSString *ProjectActivityLv2;
@property (nonatomic, copy) NSString *ProjectActivityLv2Name;
//客户成本中心
@property (nonatomic, copy) NSString *ClientId;
@property (nonatomic, copy) NSString *ClientName;
@property (nonatomic, copy) NSString *SupplierId;
@property (nonatomic, copy) NSString *SupplierName;

@end
