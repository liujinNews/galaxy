//
//  NewBusinessPlanViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "TravelFlightDetailModel.h"
#import "TravelHotelDetailModel.h"
#import "TravelTrainDetailModel.h"

@protocol NewBusinessPlanViewControllerDelegate <NSObject>
@optional
-(void)NewBusinessPlanViewController_btnClick_Delegate:(NSArray *)arr Type:(NSInteger )type;

@end

@interface NewBusinessPlanViewController : VoiceBaseController

@property (nonatomic, strong) NSString *str_isRelateTravelForm;
@property (nonatomic, strong) NSArray *arr_Main;
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, weak) id<NewBusinessPlanViewControllerDelegate> delegate;

@property (nonatomic, strong) TravelFlightDetailModel *model_Show_flight;
@property (nonatomic, strong) TravelHotelDetailModel *model_Show_hotel;
@property (nonatomic, strong) TravelTrainDetailModel *model_Show_train;

@end
