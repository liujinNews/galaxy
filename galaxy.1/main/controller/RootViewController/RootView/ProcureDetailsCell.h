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
#import "OverTimeDeatil.h"
#import "AddReimShareModel.h"
#import "ContractTermDetail.h"
#import "ContractPayMethodDetail.h"
#import "WareHouseEntryDetail.h"
#import "ContractYearExpDetail.h"

@interface ProcureDetailsCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIButton * LookMore;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)NSMutableArray *arr_IsCrossD;


//采购领用
-(void)configCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)ProcureAndArticleCellHeightWithArray:(NSMutableArray *)arr WithModel:(DeatilsModel *)CellModel;
+(NSString *)ProcureAndArticleContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(DeatilsModel *)contentModel;

//物品领用
-(void)configItemCellWithArray:(NSMutableArray *)array withDetailsModel:(ItemRequestDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
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

//加班明细
-(void)configOverTimeCellWithArray:(NSMutableArray *)array withDetailsModel:(OverTimeDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)OverTimeCellHeightWithArray:(NSMutableArray *)arr WithModel:(OverTimeDeatil *)CellModel;
+(NSString *)OverTimeContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(OverTimeDeatil *)contentModel;


//记一笔分摊明细
-(void)configAddReimShareCellWithArray:(NSMutableArray *)array withDetailsModel:(AddReimShareModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)AddReimShareCellHeightWithArray:(NSMutableArray *)arr WithModel:(AddReimShareModel *)CellModel;
+(NSString *)AddReimShareContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(AddReimShareModel *)contentModel;

//合同条款明细
-(void)configContractTermCellWithArray:(NSMutableArray *)array withDetailsModel:(ContractTermDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)ContractTermCellHeightWithArray:(NSMutableArray *)arr WithModel:(ContractTermDetail *)CellModel;
+(NSString *)ContractTermContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ContractTermDetail *)contentModel;
//付款方式明细
-(void)configContractPayMethodCellWithArray:(NSMutableArray *)array withDetailsModel:(ContractPayMethodDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)ContractPayMethodCellHeightWithArray:(NSMutableArray *)arr WithModel:(ContractPayMethodDetail *)CellModel;
+(NSString *)ContractPayMethodContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ContractPayMethodDetail *)contentModel;


//入库单明细
-(void)configWareHouseEntryCellWithArray:(NSMutableArray *)array withDetailsModel:(WareHouseEntryDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)WareHouseEntryCellHeightWithArray:(NSMutableArray *)arr WithModel:(WareHouseEntryDetail *)CellModel;
+(NSString *)WareHouseEntryContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(WareHouseEntryDetail *)contentModel;


//合同审批新增年度费用
-(void)configContractYearExpCellWithArray:(NSMutableArray *)array withDetailsModel:(ContractYearExpDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
+(CGFloat)ContractYearExpCellHeightWithArray:(NSMutableArray *)arr WithModel:(ContractYearExpDetail *)CellModel;
+(NSString *)ContractYearExpContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ContractYearExpDetail *)contentModel;


//礼品费
-(void)configGiftFeeCellWithArray:(NSMutableArray *)array withDetailsModel:(GiftFeeDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;

+(CGFloat)GiftFeeAppCellHeightWithArray:(NSMutableArray *)arr WithModel:(GiftFeeDetail *)CellModel;
+(NSString *)GiftFeeAppContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(GiftFeeDetail *)contentModel;

//MARK:采购金额明细
-(void)configPurAmCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
//MARK:采购内容明细
-(void)configPurBuCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
//MARK:单一采购来源清单
-(void)configPurSoCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;
@end

