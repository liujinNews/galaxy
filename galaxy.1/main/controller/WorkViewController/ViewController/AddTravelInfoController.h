//
//  AddTravelInfoController.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "TravelInfoModel.h"

@interface AddTravelInfoController : VoiceBaseController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSMutableArray *arr_Main;

@property (nonatomic, strong) TravelInfoModel *model;

@property (copy, nonatomic) void(^SaveBackBlock)(TravelInfoModel *model, NSInteger type);


@end
