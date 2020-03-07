//
//  TravelCarChooseAddressController.h
//  galaxy
//
//  Created by hfk on 2019/3/26.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AttrndanceAddLocationBlock)(AMapPOI *Poi);

@interface TravelCarChooseAddressController : VoiceBaseController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) AttrndanceAddLocationBlock block;

@end

NS_ASSUME_NONNULL_END
