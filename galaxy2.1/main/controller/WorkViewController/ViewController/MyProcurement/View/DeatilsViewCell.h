//
//  DeatilsViewCell.h
//  galaxy
//
//  Created by hfk on 16/4/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProcurementModel.h"
#import "DeatilsModel.h"
#import "ItemRequestDetail.h"
#import "FeeAppDeatil.h"
#import "MyChopDeatil.h"
#import "ConferenceDeatil.h"
#import "EntertainmentDeatil.h"
#import "EntertainmentSchDeatil.h"
#import "VehicleRepairDeatil.h"
#import "SupplierDetail.h"
#import "EntertainmentVisitorDeatil.h"
#import "pmtMethodDetail.h"
#import "SpecialReqestDetail.h"
#import "EmployeeTrainDetail.h"
#import "PayeeDetails.h"


@interface DeatilsViewCell : UITableViewCell<UITextFieldDelegate,chooseTravelDateViewDelegate>
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  *titleLabel;
@property (nonatomic,strong)UITextField * NameTextField;
@property (copy, nonatomic) void(^NameCellClickedBlock)(NSIndexPath *index,UITextField *tf);
@property (nonatomic,strong)UIButton * NameBtn;
@property (nonatomic,strong)UITextField * BrandTextField;
@property (nonatomic,strong)UITextField * SizeTextField;
@property (nonatomic,strong)UITextField * QtyTextField;
@property (nonatomic,strong)UITextField * UnitTextField;
@property (nonatomic,strong)UITextField * PriceTextField;
@property (nonatomic,strong)UITextField * RemarkTextField;
@property (nonatomic,strong)UITextField * SupplierTextField;
@property (nonatomic,strong)UIButton * SupplierBtn;
@property (nonatomic,strong)NSIndexPath *IndexPath;
@property (copy, nonatomic) void(^CellClickedBlock)(NSIndexPath *index,UITextField *tf);

@property (nonatomic,strong)MyProcurementModel *model;
@property (copy, nonatomic) void(^CellClickedWithModelBlock)(NSIndexPath *index,UITextField *tf, MyProcurementModel *model);


@property (nonatomic,strong)UITextField *ExpenseTypeTF;
@property (nonatomic,strong)UIImageView *ExpenseTypeImg;
@property (nonatomic,strong)UIButton *ExpenseTypeBtn;
@property (nonatomic,strong)UITextField *ExpenseDescTF;
@property (nonatomic,strong)UITextField *AmountTF;


@property (nonatomic,strong)UITextField *SubjectTF;
@property (nonatomic,strong)UITextField *SpokesmanTF;

@property (nonatomic,copy) void(^ExpenseBtnClickedBlock)(id sender);


//选择日期
@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)chooseTravelDateView *DateChooseView;
/**
 *  日期选择结果
 */
@property(nonatomic,strong)NSString *selectDataString;
@property (nonatomic,strong)UITextField * DateTextField;
@property (nonatomic,strong)UIButton * DateBtn;
@property (nonatomic,strong)UITextField *AddressTF;
@property (nonatomic,strong)UITextField *ContentTF;



-(void)configCellWithModel:(MyProcurementModel *)model withDetailsModel:(DeatilsModel *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configItemCellWithModel:(MyProcurementModel *)model withDetailsModel:(ItemRequestDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configFeeCellWithModel:(MyProcurementModel *)model withDetailsModel:(FeeAppDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configChopCellWithModel:(MyProcurementModel *)model withDetailsModel:(MyChopDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configConferenceCellWithModel:(MyProcurementModel *)model withDetailsModel:(ConferenceDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configEntertainmentDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(id)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configVehicleRepairDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(VehicleRepairDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;


-(void)configSupplierApplyDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(SupplierDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configEntertainVistorDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(EntertainmentVisitorDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configPmtMethodDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(pmtMethodDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configSpecialReqestDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(SpecialReqestDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;


-(void)configEmployeeTrainDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(EmployeeTrainDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

-(void)configPayeeDeatilCellWithModel:(MyProcurementModel *)model withDetailsModel:(PayeeDetails *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

@end
