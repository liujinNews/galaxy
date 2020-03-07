//
//  FilterBaseCell.h
//  galaxy
//
//  Created by hfk on 16/8/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterBaseCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *titleLabel;
-(void)configCollectCellWithData:(NSMutableArray *)array WithType:(NSString *)type WithFirstChoosed:(NSString *)firChoosed WithSecondChoosed:(NSString *)secChoosed WithThirdChoosed:(NSString *)thirChoosed WithIndex:(NSIndexPath *)indexPath;
@end

