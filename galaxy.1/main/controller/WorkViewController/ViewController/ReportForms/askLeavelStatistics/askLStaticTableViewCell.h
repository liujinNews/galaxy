//
//  askLStaticTableViewCell.h
//  galaxy
//
//  Created by 赵碚 on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface askLStaticTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView * line;
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIImageView * skipImage;

-(void)configAskLeavelStatisticsDataCellInfo:(NSDictionary *)cellInfo;

-(void)configAskLeavelStatisticsClassDataCellInfo:(NSDictionary *)cellInfo;

-(void)configBudgetStaticClassDataCellInfo:(NSDictionary *)cellInfo;

@end
