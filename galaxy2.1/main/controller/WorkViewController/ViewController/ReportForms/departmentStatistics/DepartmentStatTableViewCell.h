//
//  DepartmentStatTableViewCell.h
//  galaxy
//
//  Created by 赵碚 on 16/6/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "departmentStatData.h"
@interface DepartmentStatTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *mainView;

- (void)configViewWithMineCellInfo:(departmentStatData *)cellInfo;
@end
