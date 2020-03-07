//
//  FilterCustomController.h
//  galaxy
//
//  Created by hfk on 16/4/21.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "FilterCell.h"
//检索代理
@protocol FilterDataDelegate <NSObject>
- (void)didFilterData:(NSString *)type expenseCode:(NSString *)code;

@end

@interface FilterCustomController : RootViewController<UITableViewDataSource,UITableViewDelegate,GPClientDelegate>
@property (nonatomic,weak)id<FilterDataDelegate> delegate;
/**
 *  进来默认类别
 */
@property(nonatomic,strong)NSString *FilterType;
/**
 *  进来默认类型
 */
@property(nonatomic,strong)NSString *FilterCode;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray *meItemArray;
@property(nonatomic,strong)NSMutableArray *mainArray;
/**
 *  选中状态
 */
@property(nonatomic,strong)NSMutableArray *chooseArray;
@property(nonatomic,strong)NSMutableArray *firstArray;
@property(nonatomic,strong)NSMutableArray *secArray;
@property(nonatomic,strong)NSDictionary *resultDict;
@property(nonatomic,strong)FilterCell *cell;
/**
 *  确认筛选按钮
 */
@property(nonatomic,strong)UIButton *sureBtn;
@end
