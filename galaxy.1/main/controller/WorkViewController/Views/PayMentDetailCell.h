//
//  PayMentDetailCell.h
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMentDetailModel.h"
@interface PayMentDetailCell : UITableViewCell
@property (nonatomic,strong)UILabel  * ReasonLabel;
@property (nonatomic,strong)UILabel  * nameLabel;
@property (nonatomic,strong)UILabel  * bankLabel;
@property (nonatomic,strong)UILabel  * cardLabel;
@property (nonatomic,strong)UILabel  * amountLabel;
@property (nonatomic,strong)UIImageView  *typeImg;
@property (nonatomic,strong)UIView  *lineView;
@property (nonatomic,strong)PayMentDetailModel  *model;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
