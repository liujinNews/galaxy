//
//  ProcurementStatisticCell.h
//  galaxy
//
//  Created by hfk on 16/6/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcurementStatisticCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
-(void)configCellWithIndex:(NSInteger)index WithAmount:(NSString *)amount WithHeight:(NSInteger)height WithArray:(NSMutableArray *)array;
@end
