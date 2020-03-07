//
//  AddTravelPeopleInfoController.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "TravelPeopleInfoModel.h"

@interface AddTravelPeopleInfoController : VoiceBaseController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSMutableArray *arr_Main;

@property (nonatomic, strong) TravelPeopleInfoModel *model;

@property (copy, nonatomic) void(^SaveBackBlock)(TravelPeopleInfoModel *model, NSInteger type);


@end
