//
//  DelegateSelfCell.h
//  galaxy
//
//  Created by hfk on 2018/8/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelegateSelfCell : UITableViewCell

@property (nonatomic, strong) UIView *view_headLine;
@property (nonatomic, strong) UILabel *lab_dele;
@property (nonatomic, strong) UILabel *lab_deleValue;
@property (nonatomic, strong) UIView *view_line;
@property (nonatomic, strong) UILabel *lab_power;
@property (nonatomic, strong) UILabel *lab_powerValue;

@property (nonatomic, strong) NSDictionary *dict;


@end
