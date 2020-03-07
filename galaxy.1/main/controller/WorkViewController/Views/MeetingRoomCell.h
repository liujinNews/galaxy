//
//  MeetingRoomCell.h
//  galaxy
//
//  Created by hfk on 2017/12/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoomModel.h"
#import "MeetingDuringView.h"
@interface MeetingRoomCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_Name;
@property (nonatomic, strong) UILabel *lab_Capacity;
@property (nonatomic, strong) UIImageView *img_Equipment;
@property (nonatomic, strong) UILabel *lab_Equipment;
@property (nonatomic, strong) UIImageView *img_Location;
@property (nonatomic, strong) UILabel *lab_Location;
@property (nonatomic, strong) MeetingDuringView *view_MeetingDuringView;

-(void)configCellWithData:(MeetingRoomModel *)model;

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
