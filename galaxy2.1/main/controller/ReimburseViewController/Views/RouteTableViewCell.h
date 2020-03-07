//
//  RouteTableViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteModel.h"
#import "RouteDidiModel.h"

@interface RouteTableViewCell : UITableViewCell

@property (nonatomic, strong) RouteModel *model;
@property (nonatomic, strong) RouteDidiModel *model_didi;
@property (nonatomic, assign) BOOL isDidi;
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy) void (^Btn_click)(RouteModel *model);

-(RouteTableViewCell *)initViewWithModel:(RouteModel *)model isEdit:(BOOL)isEdit;

-(RouteTableViewCell *)initViewWithModel_Bydidi:(RouteDidiModel *)model isEdit:(BOOL)isEdit isChoosed:(NSString *)choosed;

@end
