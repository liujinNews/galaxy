//
//  personnalSynTableViewCell.h
//  galaxy
//
//  Created by 赵碚 on 16/5/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personnalSynData.h"
@interface personnalSynTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIView * line;

-(void)configPersonnalSynDataCellInfo:(personnalSynData *)cellInfo;
@end
