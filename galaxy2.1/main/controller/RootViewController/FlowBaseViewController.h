//
//  FlowBaseViewController.h
//  galaxy
//
//  Created by hfk on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "MyApplyModel.h"

@interface FlowBaseViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger currPage;
@property (nonatomic, strong) NSString *refreshStatus;


-(void)loadData;
-(id)initWithType:(NSString *)type;

@property(nonatomic,strong)NSString *pushController;
@property(nonatomic,strong)NSString *pushHasController;
@property(nonatomic,strong)NSString *pushAppoverEditController;

@property(nonatomic,strong)MyApplyModel *pushModel;

-(void)MyApplySelect:(MyApplyModel *)model WithIndex:(NSInteger)index;
-(void)requestGetReCallProcId;
-(void)requestJudgeRecall;
-(void)requestJudgeAppoverEdit;

-(void)dealWithReCallWithCall:(NSDictionary *)dict;
-(void)dealWithHasReCalled;
-(void)dealWithAppoverEdit:(NSString *)comeEditType WithStatus:(NSInteger)ApprovePay;

-(void)MyApproveSelect:(MyApplyModel *)model WithIndex:(NSInteger)index;

-(void)MyPaySelect:(MyApplyModel *)model WithIndex:(NSInteger)index;

-(void)MyApproveRemind:(NSDictionary *)dict;


@end
