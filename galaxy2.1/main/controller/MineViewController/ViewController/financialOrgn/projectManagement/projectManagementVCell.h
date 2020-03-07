//
//  projectManagementVCell.h
//  galaxy
//
//  Created by 赵碚 on 16/2/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectManagerModel.h"

@interface projectManagementVCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIView * line;

-(void)configProjectManagementCellInfo:(projectManagerModel *)cellInfo;
@end
