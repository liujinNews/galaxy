//
//  AddPayCompanyViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/2/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface AddPayCompanyViewController : VoiceBaseController

@property (nonatomic, strong) NSDictionary *SupDict;
@property (nonatomic, assign) NSInteger returnNumber;
@property (nonatomic,copy) void(^ChooseCateFreBlock)(ChooseCateFreModel *model, NSString *type);
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger codeIsSystem;

@end
