//
//  mineTVCell.h
//  galaxy
//
//  Created by 赵碚 on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mineModel.h"
@interface mineTVCell : UITableViewCell
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIButton * avatorImage;
@property (nonatomic, strong) UIButton * companyNameBtn;

- (void)configViewWithMineCellInfo:(mineModel *)cellInfo;

@end
