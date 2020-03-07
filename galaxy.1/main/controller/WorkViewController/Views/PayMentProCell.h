//
//  PayMentProCell.h
//  galaxy
//
//  Created by hfk on 2017/6/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMentProModel.h"
@interface PayMentProCell : UITableViewCell
@property (nonatomic,strong)UIImageView  *typeImg;
@property (nonatomic,strong)UILabel  * reasonLabel;
@property (nonatomic,strong)UILabel  *moneyLabel;
@property (nonatomic,strong)UILabel  * statusLabel;
@property (nonatomic,strong)PayMentProModel *model;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
