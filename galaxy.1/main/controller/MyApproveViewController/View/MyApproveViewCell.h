//
//  MyApproveViewCell.h
//  galaxy
//
//  Created by hfk on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyApproveViewCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIImageView *typeImageView;
@property (nonatomic,strong)UILabel  * titleLabel;
@property (nonatomic,strong)UILabel  * nameLabel;
@property (nonatomic,strong)UILabel  * dataLabel;
@property (nonatomic,strong)UILabel  * statusLabel;
@property (nonatomic,strong)UIImageView *statusImageView;
@property (nonatomic,strong)UIImageView *selImage;
@property (nonatomic,strong)UILabel  * opinionLabel;
@property (nonatomic,strong)UILabel  *moneyLabel;
@property (nonatomic,strong)NSString  *status;

- (void)configViewNotApproveWithModel:(MyApplyModel *)model withStatus:(NSString *)status;
- (void)configViewNotApproveWithModel:(MyApplyModel *)model;
- (void)configViewHasApproveWithModel:(MyApplyModel *)model;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
