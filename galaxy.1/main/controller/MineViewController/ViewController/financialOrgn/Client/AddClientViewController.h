//
//  AddClientViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/4/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface AddClientViewController : VoiceBaseController

@property (nonatomic, strong) NSString *ClickId;

@property (nonatomic, assign) NSInteger returnNumber;
@property (nonatomic,copy) void(^MultiChooseCateFreBlock)(NSMutableArray *array, NSString *type);
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger codeIsSystem;

@end
