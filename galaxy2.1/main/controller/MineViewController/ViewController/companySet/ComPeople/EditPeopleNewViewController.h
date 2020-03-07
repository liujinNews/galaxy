//
//  EditPeopleNewViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/6/23.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface EditPeopleNewViewController : VoiceBaseController

@property (weak, nonatomic) IBOutlet UIButton *btn_close;

@property (weak, nonatomic) IBOutlet UIButton *btn_OK;


@property (weak, nonatomic) IBOutlet UIView *view_RootView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_close_width;

@property (weak, nonatomic) IBOutlet UIImageView *img_close;


@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) NSInteger isNowPeople;

@property (nonatomic, strong) NSString *DeparTitle;

@property (nonatomic, strong) NSString *DeparId;

@property (nonatomic, strong) NSString *DeparCode;

@end
