//
//  AnnouncementListCell.h
//  galaxy
//
//  Created by hfk on 2018/2/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnouncementListModel.h"
@interface AnnouncementListCell : UITableViewCell
@property (nonatomic, strong) UILabel *lab_Title;
@property (nonatomic, strong) UILabel *lab_Draft;
@property (nonatomic, strong) UILabel *lab_TimeAndName;
@property (nonatomic, strong) UILabel *lab_Body;

-(void)configCellWithModel:(AnnouncementListModel *)model;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
