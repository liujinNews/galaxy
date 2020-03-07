//
//  editPositionCell.h
//  galaxy
//
//  Created by 赵碚 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "editPositionData.h"
@interface editPositionCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIView * line;

-(void)configEditPositionCellInfo:(editPositionData *)cellInfo;

-(void)configEditUserLevelCellInfo:(editPositionData *)cellInfo;
@end
