//
//  WorkViewController.h
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "WorkCateCell.h"
#import "MyCollectionHeadView.h"
#import "WorkShowModel.h"
#import "MyApplyViewController.h"
#import "MyApproveViewController.h"
#import "ReportFormMainController.h"
//微应用
#import "MicroAppViewController.h"
//支付
#import "PayMentApproveController.h"
//借还款
#import "BorrowRecordViewController.h"
//发票管家
#import "InvoiceManagerController.h"
#import "CalendarMainController.h"
#import "AnnouncementListController.h"

@interface WorkViewController : RootViewController
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
/**
 工作页面显示模块数组
 */
@property(nonatomic,strong)NSMutableArray *WorkShowArray;
/**
 工作模块显示数据数组
 */
@property(nonatomic,strong)NSMutableArray *WorkShowDataArray;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,strong)NSString *requestType;
/**
 *  网格视图
 */
@property(nonatomic,strong)UICollectionView *collView;
/**
 *  网格规则
 */
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;
/**
 *  网格cell
 */
@property(nonatomic,strong)WorkCateCell *cell;
/**
 节假日视图
 */
@property(nonatomic,strong)UIView *GuideView;
@end

