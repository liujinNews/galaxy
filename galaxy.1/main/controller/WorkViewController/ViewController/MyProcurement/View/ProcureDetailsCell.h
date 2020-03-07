//
//  ProcureDetailsCell.h
//  galaxy
//
//  Created by hfk on 16/4/20.
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


@interface ProcureDetailsCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIButton * LookMore;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,assign)BOOL isOpen;


//采购领用
-(void)configCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count withComePlace:(NSString *)place;
+(CGFloat)ProcureAndArticleCellHeightWithArray:(NSMutableArray *)arr WithModel:(DeatilsModel *)CellModel;
+(NSString *)ProcureAndArticleContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(DeatilsModel *)contentModel;

//物品领用
-(void)configItemCellWithArray:(NSMutableArray *)array withDetailsModel:(ItemRequestDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count withComePlace:(NSString *)place;
+(CGFloat)ItemCellHeightWithArray:(NSMutableArray *)arr WithModel:(ItemRequestDetail *)CellModel;
+(NSString *)ItemContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ItemRequestDetail *)contentModel;

//费用申请
-(void)configFeeCellWithArray:(NSMutableArray *)array withDetailsModel:(FeeAppDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)FeeAppCellHeightWithArray:(NSMutableArray *)arr WithModel:(FeeAppDeatil *)CellModel;
+(NSString *)FeeAppContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(FeeAppDeatil *)contentModel;


//用印
-(void)configMyChopCellWithArray:(NSMutableArray *)array withDetailsModel:(MyChopDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)MyChopCellHeightWithArray:(NSMutableArray *)arr WithModel:(MyChopDeatil *)CellModel;
+(NSString *)MyChopContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(MyChopDeatil *)contentModel;

//会议预订
-(void)configConferenceCellWithArray:(NSMutableArray *)array withDetailsModel:(ConferenceDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)ConferenceCellHeightWithArray:(NSMutableArray *)arr WithModel:(ConferenceDeatil *)CellModel;
+(NSString *)ConferenceContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ConferenceDeatil *)contentModel;


//业务招待
-(void)configEntertainmentCellWithArray:(NSMutableArray *)array withDetailsModel:(id)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)EntertainmentCellHeightWithArray:(NSMutableArray *)arr WithModel:(id)CellModel;
+(NSString *)EntertainmentContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(id )contentModel;
//来访人员
-(void)configEntertainmentVisitorCellWithArray:(NSMutableArray *)array withDetailsModel:(EntertainmentVisitorDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)EntertainmentVisitorCellHeightWithArray:(NSMutableArray *)arr WithModel:(EntertainmentVisitorDeatil *)CellModel;
+(NSString *)EntertainmentVisitorContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(EntertainmentVisitorDeatil *)contentModel;


//车辆维修
-(void)configVehicleRepairCellWithArray:(NSMutableArray *)array withDetailsModel:(VehicleRepairDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)VehicleRepairCellHeightWithArray:(NSMutableArray *)arr WithModel:(VehicleRepairDeatil *)CellModel;
+(NSString *)VehicleRepairContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(VehicleRepairDeatil *)contentModel;

//回款信息
-(void)configHasReturnAmountDetailCellWithDict:(NSDictionary *)infodict withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)HasReturnAmountCellHeightWithDict:(NSDictionary *)infodict;


//供应商申请
-(void)configSupplierApplyCellWithArray:(NSMutableArray *)array withDetailsModel:(SupplierDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)SupplierApplyCellHeightWithArray:(NSMutableArray *)arr WithModel:(SupplierDetail *)CellModel;
+(NSString *)SupplierApplyContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(SupplierDetail *)contentModel;


//开票历史
-(void)configApplicationFormHistoryDetailCellWithDict:(NSDictionary *)infodict withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)ApplicationFormHistoryCellHeightWithDict:(NSDictionary *)infodict;


//结算方式
-(void)configPmtMethodCellWithArray:(NSMutableArray *)array withDetailsModel:(pmtMethodDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)PmtMethodCellHeightWithArray:(NSMutableArray *)arr WithModel:(pmtMethodDetail *)CellModel;
+(NSString *)PmtMethodContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(pmtMethodDetail *)contentModel;


//超标信息
-(void)configSpecialOverStdCellWithArray:(NSMutableArray *)array withDetailsModel:(SpecialReqestDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)SpecialOverStdCellHeightWithArray:(NSMutableArray *)arr WithModel:(SpecialReqestDetail *)CellModel;
+(NSString *)SpecialOverStdContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(SpecialReqestDetail *)contentModel;


//参训人员名单
-(void)configEmployeeTrainingStaffCellWithArray:(NSMutableArray *)array withDetailsModel:(EmployeeTrainDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)EmployeeTrainingStaffCellHeightWithArray:(NSMutableArray *)arr WithModel:(EmployeeTrainDetail *)CellModel;
+(NSString *)EmployeeTrainingStaffContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(EmployeeTrainDetail *)contentModel;


//收款人明细
-(void)configPayeeDetailCellWithArray:(NSMutableArray *)array withDetailsModel:(PayeeDetails *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)PayeeDetailCellHeightWithArray:(NSMutableArray *)arr WithModel:(PayeeDetails *)CellModel;
+(NSString *)PayeeDetailContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(PayeeDetails *)contentModel;


@end

