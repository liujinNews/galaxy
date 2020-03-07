//
//  AccruedTableViewCell.h
//  galaxy
//
//  Created by APPLE on 2020/1/2.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccruedDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccruedTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  *TypeLabel;
@property(nonatomic,strong)UIImageView *selectImageView;
@property(nonatomic,strong)NSMutableArray *ChooseNamesArray;
//预提明细描述
@property (nonatomic,strong)UILabel  *descriptionLabel;
//预提明细类别
@property (nonatomic,strong)UILabel  *categoryLabel;
//时间
@property (nonatomic,strong)UILabel  *dateLabel;
//部门（人员）
@property (nonatomic,strong)UILabel  *departLabel;
//公司
@property (nonatomic,strong)UILabel  *companyLabel;
//创建分割线
@property (nonatomic,strong)UIView  *gapLineView;
//预提金额
@property (nonatomic,strong)UILabel  *accruedAmountLabel;
//已冲销金额
@property (nonatomic,strong)UILabel  *writeOffsLabel;
//剩余金额
@property (nonatomic,strong)UILabel  *surplusLabel;

//不带刷新样式
- (void)configViewWithModel:(AccruedDetailModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type;
//获取选中标示
+(NSString *)getModelSignWithModel:(AccruedDetailModel *)model WithType:(NSString *)type;


////带刷新样式(new支持多选)
//- (void)configFreViewWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type;
////带刷新样式附带信息(new支持多选)
//- (void)configFreViewHasSubInfoWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type;
////获取选中标示
//+(NSString *)getFreModelSignWithModel:(ChooseCateFreModel *)model WithType:(NSString *)type;
//
////获取Model标识符
//- (void)configFreViewWithString:(NSString *)str withIdStr:(NSString *)IdStr;
//
////费用类别显示方式
//-(void)configCateShowTypeWith:(NSMutableArray *)showTitle index:(NSIndexPath *)index showType:(NSInteger)showType showDes:(NSInteger )showDes;
@end

NS_ASSUME_NONNULL_END
