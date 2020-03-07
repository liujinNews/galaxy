//
//  OtherReimTypeChooseCell.h
//  galaxy
//
//  Created by hfk on 2016/11/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherReimTypeChooseCell : UITableViewCell
@property (nonatomic,strong)UILabel  * titleLabel;
@property (nonatomic,strong)UIView  * LineView;
@property (nonatomic,strong)UIImageView *clickImageView;
-(void)configCellWithRows:(NSInteger)row WithResultArray:(NSMutableArray *)array;

-(void)configPerformanceCellWithRows:(NSInteger)row WithResultArray:(NSMutableArray *)array;

@end
