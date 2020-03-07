//
//  costCenterCell.h
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "costCenterData.h"

@interface costCenterCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIView * line;

-(void)configCostCenterCellInfo:(costCenterData *)cellInfo;

-(void)configProcurementTypeCellInfo:(costCenterData *)cellInfo;

-(void)configTravelTypeTypeCellInfo:(costCenterData *)cellInfo;

-(void)configFinancialOrgnTypeCellInfo:(NSArray *)arr WithIndex:(NSInteger)index;

-(void)configCompanySwitchCellInfo:(NSDictionary *)titleDic;

-(void)configNormalCompanyTypeCellInfo:(NSDictionary *)titleDic;

@end
