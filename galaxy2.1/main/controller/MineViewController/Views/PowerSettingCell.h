//
//  PowerSettingCell.h
//  galaxy
//
//  Created by hfk on 16/5/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerSettingModel.h"
@interface PowerSettingCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  * roleNameLabel;
@property (nonatomic,strong)UILabel  * DescriptionLabel;
-(void)configViewWithModel:(PowerSettingModel *)model withIndex:(NSInteger)index;
@end
