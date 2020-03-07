//
//  FlowChartView.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/7/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FlowChartView_btn_Click)(void);
typedef void(^FlowChartView_Height)(NSInteger height);

@interface FlowChartView : UIView <UITableViewDelegate,UITableViewDataSource>

-(FlowChartView *)init:(NSArray *)arr Y:(NSInteger)Y HeightBlock:(FlowChartView_Height)block BtnBlock:(FlowChartView_btn_Click)btnblock;

@property (nonatomic, copy) FlowChartView_btn_Click btnBlock;
@property (nonatomic, copy) FlowChartView_Height HeightBlock;
@property (nonatomic, copy) NSArray *array;

@property (nonatomic, assign) NSInteger NotesTableHeight;

//@property (nonatomic, strong) FlowChartView *View_flow;

@end
