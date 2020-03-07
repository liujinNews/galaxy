//
//  projectCostTViewCell.h
//  galaxy
//
//  Created by 赵碚 on 16/6/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonnelStatData.h"
@interface projectCostTViewCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;

//物品领用
-(void)configProjectCostDataCellInfo:(NSDictionary *)cellInfo;

//员工费用类别
-(void)configPersonnelCostCategoryDataCellInfo:(PersonnelStatData *)cellInfo;
//项目费用类别
-(void)configProjectCostCategoryDataCellInfo:(PersonnelStatData *)cellInfo;

//部门员工费用类别
-(void)configDepartmentCategoryDataCellInfo:(PersonnelStatData *)cellInfo;

//员工费用统计
-(void)configPersonnelStatCellInfo:(PersonnelStatData *)cellInfo;

//项目费用统计
-(void)configProjectStatDataCellInfo:(PersonnelStatData *)cellInfo;

//ZF项目费用统计
-(void)configZFProjectStatDataCellInfo:(PersonnelStatData *)cellInfo;

@end
