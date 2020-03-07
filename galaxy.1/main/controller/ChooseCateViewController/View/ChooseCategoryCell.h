//
//  ChooseCategoryCell.h
//  galaxy
//
//  Created by hfk on 16/4/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseCategoryModel.h"
#import "ChooseCateFreModel.h"
@interface ChooseCategoryCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  *TypeLabel;
@property(nonatomic,strong)UIImageView *selectImageView;
@property(nonatomic,strong)NSMutableArray *ChooseNamesArray;

//不带刷新样式
- (void)configViewWithModel:(ChooseCategoryModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type;
//获取选中标示
+(NSString *)getModelSignWithModel:(ChooseCategoryModel *)model WithType:(NSString *)type;


//带刷新样式(new支持多选)
- (void)configFreViewWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type;
//带刷新样式附带信息(new支持多选)
- (void)configFreViewHasSubInfoWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type;
//获取选中标示
+(NSString *)getFreModelSignWithModel:(ChooseCateFreModel *)model WithType:(NSString *)type;

//获取Model标识符
- (void)configFreViewWithString:(NSString *)str withIdStr:(NSString *)IdStr;

//费用类别显示方式
-(void)configCateShowTypeWith:(NSMutableArray *)showTitle index:(NSIndexPath *)index showType:(NSInteger)showType showDes:(NSInteger )showDes;
@end

