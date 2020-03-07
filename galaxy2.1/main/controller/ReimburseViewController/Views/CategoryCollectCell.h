//
//  CategoryCollectCell.h
//  galaxy
//
//  Created by hfk on 16/4/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CostCateNewModel.h"
@interface CategoryCollectCell : UICollectionViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIImageView * CategoryImgView;
@property (nonatomic,strong)UILabel * CateTitleLabel;
-(void)configWithArray:(NSMutableArray *)dateArray withRow:(NSInteger)row;
@end
