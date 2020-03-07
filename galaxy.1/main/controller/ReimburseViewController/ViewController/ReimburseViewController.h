//
//  ReimburseViewController.h
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "FestivalHeadView.h"
#import "FestivalNavView.h"
#import "PopMenu.h"
#import "LeadingViewController.h"
#import "ImportElInController.h"
#import "PayMentDetailController.h"
#import "ChooseCateFreshController.h"
#import "ManInputElecController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
@interface ReimburseViewController : RootViewController<GPClientDelegate,UIGestureRecognizerDelegate,FestivalNavView,WXApiManagerDelegate>
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,strong)NSString *requestType;

@property(nonatomic,strong)UIView *guideView;//导航页

@property (nonatomic,strong)  FestivalHeadView *festivalHead;
@property(nonatomic,strong)FestivalNavView *festivalNav;
/**
 节假日视图
 */
@property(nonatomic,strong)UIView *FestivalGuideView;
/**
 无专项费提示视图
 */
@property(nonatomic,strong)UIView *NoSpecialGuideView;

/**
 客服热线
 */
@property(nonatomic,strong)NSString *servicePhoneNo;

@end
