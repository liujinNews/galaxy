//
//  personDocTVCell.h
//  galaxy
//
//  Created by 赵碚 on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personDocModel.h"

@interface personDocTVCell : UITableViewCell
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *HeadPortrait;
@property (nonatomic, strong) UILabel * nameLbl;
@property (nonatomic, strong) UIImageView * sexImage;
@property (nonatomic, strong) UILabel * sexLbl;
@property (nonatomic, strong) UILabel * phoneStr;
@property (nonatomic, strong) UILabel * emailLbl;
@property (nonatomic, strong) UILabel * hrid;

- (void)configViewWithPersonDocCellInfo:(personDocModel *)cellInfo;

@end
