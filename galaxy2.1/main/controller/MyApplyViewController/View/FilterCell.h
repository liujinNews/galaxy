//
//  FilterCell.h
//  galaxy
//
//  Created by hfk on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property(nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIImageView * chooseImage;
//- (void)configViewWithCellInfo:(filterData *)cellInfo;
- (void)configViewWithString:(NSString *)data withChoose:(NSString *)choose;
@end
