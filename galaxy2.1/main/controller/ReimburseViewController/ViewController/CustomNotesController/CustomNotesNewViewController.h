//
//  CustomNotesNewViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/26.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "CustomNotesCell.h"
#import "AddDetailsModel.h"
#import "FilterCustomController.h"
#import "NewAddCostViewController.h"
#import "VoiceBaseController.h"

@interface CustomNotesNewViewController : VoiceBaseController<UITableViewDataSource,UITableViewDelegate,GPClientDelegate,FilterDataDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger currPage;


/**
 *  请求结果
 */
@property(nonatomic,strong)NSDictionary *resultDict;
/**
 *  请求参数
 */
@property(nonatomic,strong)NSDictionary *parameter;
/**
 *  请求数据数组
 */
@property(nonatomic,strong)NSMutableArray *meItemArray;
/**
 *  筛选类型
 */
@property(nonatomic,strong)NSString *filterType;
/**
 *  筛选类别
 */
@property(nonatomic,strong)NSString *filterCode;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,strong)NSString *requestType;
/**
 *  无数据视图
 */
@property(nonatomic,strong)UIView *noDateView;
/**
 *  筛选结果无数据
 */
@property(nonatomic,strong)UILabel *notFoundLal;
/**
 *  Add添加记一笔按钮
 */
@property(nonatomic,strong)UIButton *AddButton;

@property(nonatomic,strong)NSIndexPath *index;

@end
