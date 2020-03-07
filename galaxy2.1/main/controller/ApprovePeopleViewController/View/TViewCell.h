//
//  TViewCell.h
//  galaxy
//
//  Created by 赵碚 on 15/7/31.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "buildCellInfo.h"
@interface TViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UILabel *detailLbl;
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIImageView * chooseImage;
@property (copy,nonatomic)NSString* isRemember;
@property (nonatomic,copy)NSString * isRememberPwd;
@property (nonatomic,strong)UIView *lineView;

@property (nonatomic, assign)NSInteger apply;

- (void)configViewWithCellInfo:(buildCellInfo *)cellInfo;

//- (void)configCompanyAddressViewWithCellInfo:(buildCellInfo *)cellInfo;
@end
