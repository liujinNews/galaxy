//
//  ProcureCollectCell.h
//  galaxy
//
//  Created by hfk on 16/4/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcureCollectCell : UICollectionViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIImageView * PhotoImgView;
@property (nonatomic,strong)UILabel * titleLab;
-(void)configCellHasAddWith:(NSMutableArray *)imageArray withRow:(NSInteger)row;
-(void)configNoAddCellWith:(NSMutableArray *)imageArray withRow:(NSInteger)row;
@end
