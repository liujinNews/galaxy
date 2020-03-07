//
//  CarFilterViewController.h
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface CarFilterViewController : VoiceBaseController

@property (nonatomic,copy) void(^filterCarBlock)(NSDictionary *dict);

@end
