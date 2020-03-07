//
//  CalendarShowCell.h
//  galaxy
//
//  Created by hfk on 2018/1/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dashline.h"
#import "CalendarShowModel.h"
#import "NotifyMeCalendarModel.h"

@interface CalendarShowCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_Date;
@property (nonatomic, strong) UILabel *lab_timeType;
@property (nonatomic, strong) UILabel *lab_startTime;
@property (nonatomic, strong) UILabel *lab_endTime;
@property (nonatomic, strong) Dashline *view_line;
@property (nonatomic, strong) UIImageView *imv_circle;
@property (nonatomic, strong) UILabel *lab_Title;
@property (nonatomic, strong) UIImageView *imv_people;
@property (nonatomic, strong) UILabel *lab_Name;
@property (nonatomic, strong) UIButton *btn_Busy;



-(void)configCellWithObj:(id)obj WithType:(NSInteger)type;

+ (CGFloat)cellHeightWithObj:(id)obj WithType:(NSInteger)type;


-(void)configNotifyMeCellWithModel:(NotifyMeCalendarModel *)model WithBeforeModel:(NotifyMeCalendarModel *)beforeModel;

+ (CGFloat)cellNotifyMeHeightWithModel:(NotifyMeCalendarModel *)model WithBeforeModel:(NotifyMeCalendarModel *)beforeModel;

@end
