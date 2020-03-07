//
//  WorkCateCell.h
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkShowModel.h"
@interface WorkCateCell : UICollectionViewCell


@property (nonatomic,strong)UIImageView * iconImgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *NewImageView;
@property(nonatomic,strong)UILabel *TipsLabel;
@property(nonatomic,strong)UIView *downLine;
@property(nonatomic,strong)UIView *rightLine;

-(void)configCcellWithArrat:(NSMutableArray *)arr WithindexPath:(NSIndexPath *)indexPath;
+(CGSize)ccellSizeWithObj:(WorkShowModel *)model;

@end

