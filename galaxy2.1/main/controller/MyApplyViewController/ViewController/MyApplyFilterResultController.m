//
//  MyApplyFilterResultController.m
//  galaxy
//
//  Created by hfk on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//
//物品领用

#import "MyApplyFilterResultController.h"
#import "MyApplyModel.h"
#import "MyApplyViewCell.h"
#import "CtripDetailController.h"

#define pageNum  (Main_Screen_Height-NavigationbarHeight)/70+6
@interface MyApplyFilterResultController ()<GPClientDelegate>
/**
 *  系统分页数
 */
@property (assign, nonatomic)NSInteger totalPage;
@property (assign, nonatomic)NSInteger IsUrge;//是否有催办

/**
 *  下载成功字典
 */
@property(assign,nonatomic)NSDictionary *resultDict;
@property(nonatomic,strong)MyApplyViewCell *cell;
@property(nonatomic,strong)UIButton *leftBackBtn;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,strong)NSString *requestType;
/**
 *  判断撤回后TaskId
 */
@property(nonatomic,strong)NSString *reCallTaskId;
/**
 *  判断撤回后UserId
 */
@property(nonatomic,strong)NSString *reCallUserId;
/**
 *  判断撤回后ProcId
 */
@property(nonatomic,strong)NSString *reCallProcId;
/**
 *  判断撤回后FlowCode
 */
@property(nonatomic,strong)NSString *reCallFlowCode;
/**
 *  判断是否有撤回
 */
@property(nonatomic,strong)NSString *reCallExpenseCode;//判断撤回后FlowCode

@end

@implementation MyApplyFilterResultController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"筛选结果", nil) backButton:YES];
    _requestType=@"1";
    _IsUrge = 0;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    
    if (![_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self requestHasApply];
    }
    _requestType=@"0";
}

-(void)requestHasApply{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    
    NSString *url=[NSString stringWithFormat:@"%@",WorksubmitGetcreatedbyme];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"RequestorDate",@"IsAsc":@"desc",@"TaskName":@"",@"FlowGuid":_dict_Parameters[@"flowGuid"],@"Status":_dict_Parameters[@"status"],@"PaymentStatus":_dict_Parameters[@"paymentStatus"],@"RequestorFromDate":_dict_Parameters[@"startTime"],@"RequestorToDate":_dict_Parameters[@"endTime"],@"serialNo":_dict_Parameters[@"serialNo"]};
    //    NSLog(@"%@",parameters);
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:判断是否有撤回
-(void)requestJudgeRecall{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",JudgeRecall];
    NSDictionary *parameters = @{@"FlowCode":[NSString stringWithFormat:@"%@",self.pushModel.flowCode],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId],@"RecallType":@"1"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}

//MARK:获取撤回ProcId
-(void)requestGetReCallProcId{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetReCallProcId];
    NSDictionary *parameters = @{@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
}

//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
//    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading=NO;
         if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        return;
    }
    
    //下拉刷新
    if (self.currPage == 1&&serialNum==0) {
        [self.resultArray removeAllObjects];
    }
    //    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    
    switch (serialNum) {
        case 0:
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];

            break;
        case 2:
        {
            NSDictionary *dict = @{@"type":@"1",
                                   @"hasCall":[[NSString stringWithFormat:@"%@",_resultDict[@"result"]]isEqualToString:@"1"] ? @"1":@"0",
                                   @"canUrge": (_IsUrge == 1&&([self.pushModel.status integerValue]==1||[self.pushModel.paymentStatus integerValue]==1)) ? @"1":@"0"
                                   };
            [self dealWithReCallWithCall:dict];
        }
            break;
        case 3:
            self.pushModel.procId=[NSString stringWithFormat:@"%@",_resultDict[@"result"]];
            [self dealWithHasReCalled];
            break;
        case 6:
            self.currPage=1;
            [self requestHasApply];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil)];
            break;
        default:
            break;
    }
}


//MARK:数据处理
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue];
    _IsUrge = [[NSString stringWithFormat:@"%@",result[@"isUrge"]]isEqualToString:@"1"] ? 1:0;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
}
//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}



//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyApplyModel *model=(MyApplyModel *)self.resultArray[indexPath.section];
    return [MyApplyViewCell cellHeightWithObj:model];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section!=0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
//是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyApplyModel *model=self.resultArray[indexPath.section];
    // 作废按钮
    UITableViewRowAction *abrogateRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        if ([model.status integerValue]==2||[model.status integerValue]==6) {
            NSString *url=[NSString stringWithFormat:@"%@", SubmiterDelete];
            NSDictionary *parameters = @{@"TaskId":model.taskId,@"FlowCode":model.flowCode};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:6 IfUserCache:NO];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"不能删除", nil) duration:2.0];
        }
    }];
    if ([model.status integerValue]!=2&&[model.status integerValue]!=6) {
        abrogateRowAction.backgroundColor = [UIColor grayColor];
    }else{
        abrogateRowAction.backgroundColor = [UIColor redColor];
    }
    return @[abrogateRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"MyApplyViewCell"];
    if (_cell==nil) {
        _cell=[[ MyApplyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyApplyViewCell"];
    }
    MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
    [_cell configViewHasSubmitWithModel:model];
    [_cell.DetaileBtn addTarget:self action:@selector(SeeDetails:) forControlEvents:UIControlEventTouchUpInside];
    _cell.DetaileBtn.tag=indexPath.section+100;
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.pushModel=self.resultArray[indexPath.section];
    [self MyApplySelect:self.pushModel WithIndex:0];

}

-(void)loadData{
    
    [self requestHasApply];
    
}

//MARK:查看详情
-(void)SeeDetails:(UIButton *)btn{
    NSLog(@"查看详情");
    //    NSLog(@"%ld",(long)btn.tag);
    MyApplyModel *model=(MyApplyModel *)self.resultArray[btn.tag-100];
    CtripDetailController *vc=[[CtripDetailController alloc]init];
    vc.taskId=[NSString stringWithFormat:@"%@",model.taskId];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有相关记录哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
