//
//  NoDataCell.h
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imv_NoData;
@property (nonatomic, strong) UILabel *lab_NoData;

-(void)ConfigNoDataViewWithCellHeight:(NSInteger)height WithImageName:(NSString *)imgName WithTitle:(NSString *)title;
@end
