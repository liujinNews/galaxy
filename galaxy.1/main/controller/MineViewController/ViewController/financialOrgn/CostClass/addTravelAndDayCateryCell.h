//
//  addTravelAndDayCateryCell.h
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addTravelAndDayCateryData.h"

@interface addTravelAndDayCateryCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel * expenseLa;
//费用类别（差旅费、日常费添加左侧显示）
-(void)configAddTravelAndDayCateryCellInfo:(addTravelAndDayCateryData *)cellInfo withSelect:(BOOL)select;

//费用类别（差旅费、日常费）
-(void)configTravelAndDayCateryCellInfo:(addTravelAndDayCateryData *)cellInfo;

@end
