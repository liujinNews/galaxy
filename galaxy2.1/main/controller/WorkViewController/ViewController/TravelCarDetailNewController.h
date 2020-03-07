//
//  TravelCarDetailNewController.h
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "TravelCarDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelCarDetailNewController : VoiceBaseController


/**
 显示信息
 */
@property (nonatomic, strong) NSMutableArray *arr_show;
/**
 数据信息
 */
@property (nonatomic, strong) TravelCarDetail *TravelCarDetail;
/**
 *  滚动视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic, strong) BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic, strong) DoneBtnView *dockView;
/**
 *  用车时间
 */
@property (nonatomic, strong) UIView *View_VehicleDate;
@property (nonatomic, strong) UITextField *txf_VehicleDate;
/**
 *  出发城市
 */
@property (nonatomic, strong) UIView *View_FromCity;
@property (nonatomic, strong) UITextField *txf_FromCity;
/**
 *  出发地
 */
@property (nonatomic, strong) UIView *View_Departure;
@property (nonatomic, strong) UITextField *txf_Departure;
/**
 *  到达城市
 */
@property (nonatomic, strong) UIView *View_ToCity;
@property (nonatomic, strong) UITextField *txf_ToCity;
/**
 *  目的地
 */
@property (nonatomic, strong) UIView *View_Destination;
@property (nonatomic, strong) UITextField *txf_Destination;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
@property(nonatomic,strong)UITextView *txv_Remark;


@property (nonatomic, copy) void(^TravelCarAddEditBlock)(TravelCarDetail *model, NSInteger type);

//1新增2修改
@property(nonatomic,assign)NSInteger type;



@end

NS_ASSUME_NONNULL_END
