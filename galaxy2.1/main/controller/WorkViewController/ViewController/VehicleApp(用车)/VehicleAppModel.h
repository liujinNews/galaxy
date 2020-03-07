//
//  VehhicleAppModel.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/28.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleAppModel : NSObject

@property (nonatomic, strong) NSString *RequestorUserId;	//申请人
@property (nonatomic, strong) NSString *RequestorDeptId;	//部门
@property (nonatomic, strong) NSString *HRID;	//员工工号
@property (nonatomic, assign) NSInteger BranchId;	//分公司
@property (nonatomic, strong) NSString *Branch;	//分公司
@property (nonatomic, assign) NSInteger RequestorBusDeptId;	//业务部门
@property (nonatomic, strong) NSString *RequestorBusDept;
@property (nonatomic, strong) NSString *RequestorDate;	//申请日期

@property (nonatomic, strong) NSString *UserReserved1;	//用户自定义字段
@property (nonatomic, strong) NSString *UserReserved2;	//用户自定义字段
@property (nonatomic, strong) NSString *UserReserved3;	//用户自定义字段
@property (nonatomic, strong) NSString *UserReserved4;	//用户自定义字段
@property (nonatomic, strong) NSString *UserReserved5;	//用户自定义字段

//@property(nonatomic,copy)NSString *ApproverId1;
//@property(nonatomic,copy)NSString *ApproverId2;
//@property(nonatomic,copy)NSString *ApproverId3;
//@property(nonatomic,copy)NSString *ApproverId4;
//@property(nonatomic,copy)NSString *ApproverId5;
@property(nonatomic,copy)NSString *UserLevelNo;


@property (nonatomic, strong) NSString *Reason;	//用车事由
@property (nonatomic, strong) NSString *DepartCity;	//出发地
@property (nonatomic, strong) NSString *BackCity;	//返回地点
@property (nonatomic, strong) NSString *VehicleDate;	//用车时间
@property (nonatomic, strong) NSString *BackDate;	//返回时间
@property (nonatomic, assign) NSInteger VehicleStaffId;	//同车人员
@property (nonatomic, strong) NSString *VehicleStaff;
@property (nonatomic, strong) NSString *ProjId;	//项目名称
@property (nonatomic, strong) NSString *ProjName;
@property (nonatomic, assign) NSInteger ClientId; //客户
@property (nonatomic, strong) NSString *ClientName ; //客户
@property (nonatomic, assign) NSInteger SupplierId;	//供应商
@property (nonatomic, strong) NSString *SupplierName;
@property (nonatomic, strong) NSString *CarNo;	//车辆
@property (nonatomic, strong) NSString *Driver;	//司机
@property (nonatomic, strong) NSString *DriverTel;	//司机电话
@property (nonatomic, strong) NSString *Mileage;	//行驶里程(KM)
@property (nonatomic, strong) NSString *Remark;	//备注
@property (nonatomic, strong) NSString *Attachments;	//附件

@property (nonatomic, strong) NSString *Reserved1;
@property (nonatomic, strong) NSString *Reserved2;
@property (nonatomic, strong) NSString *Reserved3;
@property (nonatomic, strong) NSString *Reserved4;
@property (nonatomic, strong) NSString *Reserved5;
@property (nonatomic, strong) NSString *Reserved6;
@property (nonatomic, strong) NSString *Reserved7;
@property (nonatomic, strong) NSString *Reserved8;
@property (nonatomic, strong) NSString *Reserved9;
@property (nonatomic, strong) NSString *Reserved10;

@property (nonatomic, strong) NSString *FirstHandlerUserId;
@property (nonatomic, strong) NSString *FirstHandlerUserName;
@property (nonatomic, strong) NSString *JobTitleCode;
@property (nonatomic, strong) NSString *JobTitle;
@property (nonatomic, strong) NSString *UserLevelId;
@property (nonatomic, strong) NSString *UserLevel;
@property (nonatomic, strong) NSString *Area;
@property (nonatomic, strong) NSString *AreaId;

@property (nonatomic, strong) NSString *RequestorAccount;
@property (nonatomic, strong) NSString *Requestor;
@property (nonatomic, strong) NSString *RequestorDept;
@property (nonatomic, strong) NSString *CompanyId;
@property (nonatomic, strong) NSString *TwohandlerUserId;
@property (nonatomic, strong) NSString *TwohandlerUserName;

@end
