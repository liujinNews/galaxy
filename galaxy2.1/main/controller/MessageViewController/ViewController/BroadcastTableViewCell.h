//
//  BroadcastTableViewCell.h
//  galaxy
//
//  Created by 赵碚 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroadcastData.h"
@interface BroadcastTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel * TitleLa;

-(void)configBroadcastCellInfo:(BroadcastData *)cellInfo;

@end
