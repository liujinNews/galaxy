//
//  BatchPayCell.h
//  galaxy
//
//  Created by hfk on 15/11/19.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyApplyModel.h"
@interface BatchPayCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  *reasonLabel;
@property (nonatomic,strong)UILabel  *moneyLabel;
-(void)configViewWithModel:(MyApplyModel *)model withRow:(NSInteger)row withAllRow:(NSInteger)allRow  wintAmount:(NSString *)money;
@end
