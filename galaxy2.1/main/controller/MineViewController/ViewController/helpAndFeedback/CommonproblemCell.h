//
//  CommonproblemCell.h
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonproblemCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIImageView *InImageView;
@property(nonatomic,strong)UIView *lineView;
-(void)configCellWithDict:(NSDictionary *)dict;
@end
