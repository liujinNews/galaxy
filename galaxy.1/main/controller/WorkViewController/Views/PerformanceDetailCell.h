//
//  PerformanceDetailCell.h
//  galaxy
//
//  Created by hfk on 2018/1/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceDetail.h"
@interface PerformanceDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_Content;//内容

@property (nonatomic, strong) UILabel *lab_SelfTitle;//自评分标题

@property (nonatomic, strong) UILabel *lab_SelfScore;//自评分分数

@property (nonatomic, strong) UIImageView *img_ScoreLine;//分数分割线

@property (nonatomic, strong) UILabel *lab_LeaderTitle;//领导评分标题

@property (nonatomic, strong) UILabel *lab_LeaderScore;//领导评分分数

@property (nonatomic, strong) UIButton *btn_ScoreSelect;//分数选择按钮

@property (nonatomic, strong) UIImageView *img_BottomLine;//底部分割线

@property (nonatomic, strong) UILabel *lab_Weigth;//权重显示

@property (nonatomic, strong) UIView *view_Segment;//底部分割块


@property (nonatomic, strong) NSMutableArray *arr_data;

@property (nonatomic, strong)NSIndexPath *IndexPath;

@property (nonatomic, strong)PerformanceDetailSub *subModel;

@property (nonatomic, strong) NSMutableArray *arr_score;

@property (copy, nonatomic) void(^ScoreChangeBlock)(NSInteger type);
//填写页面
//自评    分数         PerformanceMode=0,2     1
//领导评论  分数        PerformanceMode=1       2
//查看页面
//自评  领导评论  分数   PerformanceMode=2       3
//自评                 PerformanceMode=0      4
//领导评论              PerformanceMode=1      5
//自评    领导评论      PerformanceMode=2       6
@property (nonatomic, assign) NSInteger int_type;



-(void)configCellWithDataArray:(NSMutableArray *)dateArray WithType:(NSInteger)type;

+ (CGFloat)cellHeightWithObj:(id)obj IsLast:(BOOL)isLast;

@end
