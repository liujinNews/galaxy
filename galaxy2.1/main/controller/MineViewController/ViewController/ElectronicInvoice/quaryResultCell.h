//
//  quaryResultCell.h
//  galaxy
//
//  Created by 赵碚 on 2016/12/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "quaryResultData.h"

@interface quaryResultCell : UITableViewCell
@property (nonatomic, strong) UIView *mainView;

- (void)configViewWithQuaryResultCellInfo:(quaryResultData *)cellInfo;

@end
