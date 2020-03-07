//
//  ReimShareCell.h
//  galaxy
//
//  Created by hfk on 2017/9/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProcurementModel.h"
#import "ReimShareModel.h"

@interface ReimShareCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;

-(void)configReimShareCellWithArray:(NSMutableArray *)array withDetailsModel:(ReimShareModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count;

+(CGFloat)ReimShareCellHeightWithArray:(NSMutableArray *)arr WithModel:(ReimShareModel *)CellModel;
+(NSString *)getContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ReimShareModel *)contentModel;
@end
