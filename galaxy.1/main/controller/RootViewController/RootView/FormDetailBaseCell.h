//
//  FormDetailBaseCell.h
//  galaxy
//
//  Created by hfk on 2018/9/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverTimeDeatil.h"
#import "ItemRequestDetail.h"
#import "AddReimShareModel.h"
#import "ContractTermDetail.h"
#import "ContractPayMethodDetail.h"
#import "WareHouseEntryDetail.h"
#import "ContractYearExpDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormDetailBaseCell : UITableViewCell

@property (nonatomic, strong) UITextField *txf_Contet;

@property (nonatomic, strong) NSIndexPath *IndexPath;
@property (nonatomic, copy) void(^CellBackDataBlock)(NSIndexPath *index, UITextField *tf, MyProcurementModel *model, id dModel);
//加班明细
-(void)configOverTimeCellWithModel:(MyProcurementModel *)model withDetailsModel:(OverTimeDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;
+ (CGFloat)cellOverTimeDetailHeightWithWithModel:(MyProcurementModel *)model withDetailsModel:(OverTimeDeatil *)deModel;
//物品领用明细
-(void)configItemCellWithModel:(MyProcurementModel *)model withDetailsModel:(ItemRequestDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;
//记一笔费用分摊明细
-(void)configAddReimShareCellWithFormModel:(MyProcurementModel *)model withDataModel:(AddReimShareModel *)deModel;
//合同条款明细
-(void)configContractTermCellWithModel:(MyProcurementModel *)model withDetailsModel:(ContractTermDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;
//付款方式用明细
-(void)configContractPayMethodCellWithModel:(MyProcurementModel *)model withDetailsModel:(ContractPayMethodDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;
//入库物品明细
-(void)configWareHouseEntryCellWithModel:(MyProcurementModel *)model withDetailsModel:(WareHouseEntryDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;

//合同审批新增年度费用明细
-(void)configContractYearExpCellWithModel:(MyProcurementModel *)model withDetailsModel:(ContractYearExpDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index;
//礼品费明细
-(void)configAddReimGiftCellWithFormModel:(MyProcurementModel *)model withDataModel:(AddReimShareModel *)deModel;






@end

NS_ASSUME_NONNULL_END
