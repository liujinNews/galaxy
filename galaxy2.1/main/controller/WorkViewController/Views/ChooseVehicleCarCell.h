//
//  ChooseVehicleCarCell.h
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseVehicleCarCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_carNo;//车牌
@property (nonatomic, strong) UILabel *lab_carModel;//车型
@property (nonatomic, strong) UILabel *lab_seatType;//座位和公私车
@property (nonatomic, strong) UILabel *lab_carDesc;//车辆描述
@property (nonatomic, strong) UIView *line_View;//分割线
@property (nonatomic, strong) UIImageView *image_Time;
@property (nonatomic, strong) UILabel *lab_TimeTitle;
@property (nonatomic, strong) UILabel *lab_Time;

@property (nonatomic, strong) NSDictionary *dict_carInfo;//车辆信息

+ (CGFloat)cellHeightWithObj:(NSDictionary *)obj;


@end
