//
//  ReservedView.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProcurementModel.h"

typedef void(^SelectListViewBlock)(MyProcurementModel *model,UITextField *contextFiled);

typedef void(^SelectListViewHeightBlock)(NSInteger height);

@interface ReservedView : UIView <chooseTravelDateViewDelegate>

@property (nonatomic, strong) UITextField *txf_content;
@property (nonatomic, strong) UILabel *lab_title;
@property (nonatomic, assign) NSInteger int_height;
@property (nonatomic, strong) MyProcurementModel *model;

@property (nonatomic, strong) UIDatePicker *dap_ExpenseDate;//
@property (nonatomic, strong) chooseTravelDateView *cho_datelView;//选择弹出框

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model block:(SelectListViewHeightBlock)block;

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model Y:(NSInteger)Y block:(SelectListViewHeightBlock)block txfblock:(SelectListViewBlock)txfblock;

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidth:(float)width block:(SelectListViewBlock)block;

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidth:(float)width Y:(NSInteger)Y block:(SelectListViewBlock)block;

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidth:(float)width Y:(NSInteger)Y MAXLength:(NSInteger)lenght block:(SelectListViewBlock)block;

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidthNoChangeContent:(float)width block:(SelectListViewBlock)block;

@end
