//
//  MasterListCell.h
//  galaxy
//
//  Created by hfk on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterListModel.h"
@interface MasterListCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  *TypeLabel;
@property(nonatomic,strong)UIImageView *selectImageView;
- (void)configViewWithModel:(MasterListModel *)model withStr:(NSString *)IdStr withType:(NSString *)type;
@end
