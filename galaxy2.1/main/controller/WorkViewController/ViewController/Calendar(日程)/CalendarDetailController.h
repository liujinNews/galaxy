//
//  CalendarDetailController.h
//  galaxy
//
//  Created by hfk on 2018/1/19.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface CalendarDetailController : VoiceBaseController

@property(nonatomic,strong)NSString *str_ScheduleId;

//1能处理 2不能处理
@property(nonatomic,assign)NSInteger int_status;
/**
 *  请求字典
 */
@property (nonatomic,strong)NSDictionary *dict_resultDict;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIView *View_Content;//内容

@property (nonatomic,strong)UIView *View_Notify;//知会

@property (nonatomic,strong)UIView *View_Project;//项目

@property (nonatomic,strong)UIView *View_Client;//客户

@property (nonatomic,strong)UIView *View_Supplier;//供应商
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;

/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;



@end
