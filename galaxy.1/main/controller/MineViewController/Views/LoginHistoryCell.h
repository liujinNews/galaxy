//
//  LoginHistoryCell.h
//  galaxy
//
//  Created by hfk on 2018/4/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginHistoryCell : UITableViewCell
@property (nonatomic, strong) UILabel *lab_Date;
@property (nonatomic, strong) UILabel *lab_Time;
@property (nonatomic, strong) UILabel *lab_Name;
@property (nonatomic, strong) UILabel *lab_Ip;
@property (nonatomic, strong) UIView *view_Line;

-(void)configCellWithArray:(NSMutableArray *)dataArray WithIndex:(NSIndexPath *)index;

@end
