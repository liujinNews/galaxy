//
//  ColleagueListCell.h
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColleagueListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *img_UserPho;
@property (nonatomic, strong) UILabel *lab_Name;
@property (nonatomic, strong) UILabel *lab_Job;
@property (nonatomic, strong) UIView *view_Line;
@property (nonatomic, strong) NSDictionary *dict_data;
@property (nonatomic, assign) BOOL bool_hasLine;

@end
