//
//  travelPlanViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/10.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelFlightDetailModel.h"
#import "TravelHotelDetailModel.h"
#import "TravelTrainDetailModel.h"

@interface travelPlanViewCell : UITableViewCell

@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  * cityLabel;
@property (nonatomic,strong)UILabel  * dayLabel;
@property (nonatomic,strong)UILabel  * dateLabel;

@property (nonatomic, assign) NSInteger type;

-(travelPlanViewCell *)initModelwithByFlightCell:(TravelFlightDetailModel *)model;

-(travelPlanViewCell *)initModelwithByHomeCell:(TravelHotelDetailModel *)model;
-(travelPlanViewCell *)initModelwithByHomeCellInLook:(TravelHotelDetailModel *)model;

-(travelPlanViewCell *)initModelwithByTrainCell:(TravelTrainDetailModel *)model;

@end
