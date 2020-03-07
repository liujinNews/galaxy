//
//  CtripDetailController.h
//  galaxy
//
//  Created by hfk on 2016/10/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface CtripDetailController : RootViewController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>
/**
 *  请求数据
 */
@property (nonatomic,strong)NSDictionary *resultDict;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)UIView *contentView;
/**
 *  酒店视图
 */
@property (nonatomic,strong)UIView *HotelView;
/**
 *  机票视图
 */
@property (nonatomic,strong)UIView *FlightView;
/**
 *  火车票图片
 */
@property (nonatomic,strong)UIView *TrainView;
/**
 *  taskId
 */
@property (nonatomic,strong)NSString *taskId;
/**
 *  来自哪里
 */
@property (nonatomic,strong)NSString *type;

-(id)initWithType:(NSString *)type;
@end
