//
//  MyApplyViewCell.h
//  galaxy
//
//  Created by hfk on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyApplyModel.h"
@interface MyApplyViewCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;

@property (nonatomic,strong)UIImageView *typeImageView;
@property (nonatomic,strong)UILabel  * titleLabel;
@property (nonatomic,strong)UILabel  * opinionLabel;
@property (nonatomic,strong)UILabel  * dataLabel;
@property (nonatomic,strong)UILabel  * statusLabel;
@property (nonatomic,strong)UIImageView  * statusImageView;
@property (nonatomic,strong)UIView  *lineView;
@property (nonatomic,strong)UILabel  *reSubmitLabel;
@property (nonatomic,strong)UIButton  *DetaileBtn;
@property (nonatomic,strong)UILabel  *moneyLabel;

- (void)configViewHasSubmitWithModel:(MyApplyModel*)model;
- (void)configViewNotSubmitWithModel:(MyApplyModel*)model;


+ (CGFloat)cellHeightWithObj:(id)obj;

@end
