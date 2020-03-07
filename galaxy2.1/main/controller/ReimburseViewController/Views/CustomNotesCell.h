//
//  CustomNotesCell.h
//  galaxy
//
//  Created by hfk on 16/4/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDetailsModel.h"
#import "LeadHotelModel.h"
#import "CtripLeadModel.h"
@interface CustomNotesCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  * titleLabel;
@property (nonatomic,strong)UILabel  * datesLabel;
@property (nonatomic,strong)UILabel  * moneyLabel;
@property (nonatomic,strong)UILabel  * CurrCodeLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel  * statusLabel;
@property (nonatomic,strong)UIImageView  *MarkImageView;
@property (nonatomic,strong)UILabel  *MarkLabel;
@property (nonatomic,strong)UIImageView  *MarkIconImg;
- (void)configViewWithCellInfo:(AddDetailsModel *)model;
- (void)configViewWithCellInfo:(AddDetailsModel *)model WithCleck:(NSString *)check;
- (void)configLeadHotelViewWithCellInfo:(LeadHotelModel *)model withIndex:(NSInteger)index;
- (void)configDetailCtripViewWithCellInfo:(CtripLeadModel *)model withIndex:(NSInteger)index;
@end
