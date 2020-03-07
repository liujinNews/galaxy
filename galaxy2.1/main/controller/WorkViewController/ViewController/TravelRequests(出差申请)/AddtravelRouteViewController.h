//
//  AddtravelRouteViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@protocol AddtravelRouteViewControllerDelegate <NSObject>

-(void)AddtravelRouteViewController_save:(NSDictionary *)dic;

@end

@interface AddtravelRouteViewController : VoiceBaseController

@property (nonatomic, strong) NSDictionary *dic_load;
@property (nonatomic, weak) id<AddtravelRouteViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *arr_ShowArray;
@property (nonatomic, strong) UITextView *txv_Content;

@end
