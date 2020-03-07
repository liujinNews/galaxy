//
//  PowerMembersCell.h
//  galaxy
//
//  Created by hfk on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerMembersCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *lineView;
-(void)configWithDict:(NSDictionary *)dict;
@end
