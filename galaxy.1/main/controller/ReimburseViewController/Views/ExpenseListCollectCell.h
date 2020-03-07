//
//  ExpenseListCollectCell.h
//  galaxy
//
//  Created by hfk on 2018/5/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseListCollectCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *titleLabel;

-(void)configCollectCellWithData:(NSMutableArray *)array  withIndex:(NSIndexPath *)indexPath;

@end
