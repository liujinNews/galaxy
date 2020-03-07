//
//  BudgetCostCenterDetailCell.h
//  galaxy
//
//  Created by hfk on 2019/1/16.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userData.h"
NS_ASSUME_NONNULL_BEGIN

@interface BudgetCostCenterDetailCell : UITableViewCell

@property (nonatomic,strong)UIView  *bgView;

@property (nonatomic,strong)UILabel  * TimeLalel;

@property (nonatomic,strong)UILabel  * TitleLal1;
@property (nonatomic,strong)UILabel  * SubLal1;

@property (nonatomic,strong)UILabel  * TitleLal2;
@property (nonatomic,strong)UILabel  * SubLal2;

@property (nonatomic,strong)UILabel  * TitleLal3;
@property (nonatomic,strong)UILabel  * SubLal3;

@property (nonatomic,strong)UILabel  * TitleLal4;
@property (nonatomic,strong)UILabel  * SubLal4;

@property (nonatomic,strong)UILabel  * TitleLal5;
@property (nonatomic,strong)UILabel  * SubLal5;

@property (nonatomic,strong)UILabel  * TitleLal6;
@property (nonatomic,strong)UILabel  * SubLal6;

@property (nonatomic,strong)userData * userdatas;

/**
 type  1成本中心 2辅助核算项目
 */
-(void)configCellWithDict:(NSDictionary *)dict withType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
