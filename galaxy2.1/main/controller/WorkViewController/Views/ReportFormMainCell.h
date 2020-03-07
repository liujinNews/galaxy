//
//  ReportFormMainCell.h
//  galaxy
//
//  Created by hfk on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportFormMainModel.h"
#import "DVLineChartView.h"
#import "UIView+ChartBase.h"
#import "UIColor+Hex.h"
#import "DVBarChartView.h"
@protocol FormTableViewCellDataSource;
@protocol FormTableViewCellDelegate;


@interface ReportFormMainCell : UITableViewCell <DVLineChartViewDelegate,DVBarChartViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) id <FormTableViewCellDataSource> dataSource;
@property (strong, nonatomic) id <FormTableViewCellDelegate> delegate;
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIView * ChartView;
//标记位置
@property (nonatomic,assign)NSInteger MarkIndex;

/**
 *  标题
 */
@property (nonatomic,strong)UILabel  * titleLabel;
@property (nonatomic,strong)UILabel  * name1Label;
@property (nonatomic,strong)UILabel  * name2Label;
@property (nonatomic,strong)UILabel  * name3Label;
@property (nonatomic,strong)UILabel  * numberLabel;
/**
 *  是否已经打开
 */
@property (assign, nonatomic) BOOL isOpenForm;
-(void)configViewWithModel:(ReportFormMainModel *)model;
/**
 *  构建下拉表格视图
 */
- (void)buildChartViewWithModel:(ReportFormMainModel *)model;
@end

//图表数据代理
@protocol FormTableViewCellDataSource <NSObject>
@required
- (NSMutableArray *)dataSourceForFormItem;
@end

//图表点击事件处理
@protocol FormTableViewCellDelegate <NSObject>
@optional
- (void)FormTableViewCell:(ReportFormMainCell *)FormTableViewCell didSeletedFormItemAtIndex:(NSInteger)Index;
@end
