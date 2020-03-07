//
//  AddTravelRouteController.h
//  galaxy
//
//  Created by hfk on 2018/11/7.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddTravelRouteController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>

@property (nonatomic,copy) void(^addTravelRouteBlock)(NSIndexPath *index, NSDictionary *dict);

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSDictionary *dic_Data;

@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, strong) NSArray *arr_ShowArray;
/**
 *  滚动视图
 */
@property (nonatomic, strong) UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic, strong) BottomView *contentView;
/**
 *  日期视图
 */
@property (nonatomic, strong) UIView *View_TravelDate;
@property (nonatomic, strong) UITextField *txf_TravelDate;
/**
 *  时间视图
 */
@property (nonatomic, strong) UIView *View_TravelTime;
@property (nonatomic, strong) UITextField *txf_TravelTime;
@property (nonatomic, strong) NSString *str_TravelTime;
/**
 *  出发地视图
 */
@property (nonatomic, strong) UIView *View_FromCity;
@property (nonatomic, strong) UITextField *txf_FromCity;
@property (nonatomic, copy) NSString *str_FromCityCode;

/**
 *  目的地视图
 */
@property(nonatomic,strong)UIView *View_ToCity;
@property(nonatomic,strong)UITextField *txf_ToCity;
@property (nonatomic, copy) NSString *str_ToCityCode;
@property (nonatomic, copy) NSString *str_ToCityType;
/**
 *  住宿标准视图
 */
@property(nonatomic,strong)UIView *View_HotelStd;
@property(nonatomic,strong)GkTextField *txf_HotelStd;
/**
 *  交通工具视图
 */
@property(nonatomic,strong)UIView *View_TransName;
@property(nonatomic,strong)UITextField *txf_TransName;
@property (nonatomic, copy) NSString *str_TransId;
/**
 *  内容视图
 */
@property(nonatomic,strong)UIView *View_TravelContent;
@property(nonatomic,strong)UITextView *txv_TravelContent;


@end

NS_ASSUME_NONNULL_END
