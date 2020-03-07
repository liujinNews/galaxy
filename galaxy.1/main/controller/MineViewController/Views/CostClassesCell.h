//
//  CostClassesCell.h
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CostClassesModel.h"
@interface CostClassesCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIImageView *statusImgView;
@property(nonatomic,strong)UILabel *numLable;
@property(nonatomic,strong)UIView *lineView;

-(void)configViewWithModel:(CostClassesModel *)model withType:(NSString *)type withStatus:(NSInteger)status;

-(void)configBranchViewWithDict:(NSDictionary *)dict hideLine:(BOOL)hideLine;


@end
