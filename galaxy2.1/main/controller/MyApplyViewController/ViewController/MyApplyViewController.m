//
//  submitViewController.m
//  galaxy
//
//  Created by hfk on 15/10/28.
//  Copyright © 2015年 赵碚. All rights reserved.
//
#import "MyApplyViewController.h"
#import "MyApplyModel.h"
#import "MyApplyViewCell.h"
#import "XFSegementView.h"
#import "FilterBaseViewController.h"
#import "CtripDetailController.h"
#define pageNum  (Main_Screen_Height-NavigationbarHeight-44)/70+6

@interface MyApplyViewController ()<GPClientDelegate,TouchLabelDelegate>

@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property (assign, nonatomic)NSInteger IsUrge;//是否有催办

@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)MyApplyViewCell *cell;
@property(nonatomic,assign)NSInteger segIndex;//分段器当前选择
@property(nonatomic,strong)UIButton *rightSearchBtn;
@property(nonatomic,strong)NSString *notSubmitNum;//未提交数量
@property(nonatomic,strong)NSString *backSubmitNum;//退单数量

@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据


@property(nonatomic,strong)NSString *reCallTaskId;//判断撤回后TaskId
@property(nonatomic,strong)NSString *reCallUserId;//判断撤回后UserId
@property(nonatomic,strong)NSString *reCallProcId;//判断撤回后ProcId
@property(nonatomic,strong)NSString *reCallFlowCode;//判断撤回后FlowCode

@property(nonatomic,strong)NSString *reCallState;//判断撤回当前任务状态

@property (nonatomic, strong) XFSegementView *segementView;
@property(nonatomic,strong)NSString *reCallExpenseCode;//判断撤回后FlowCode

@end

@implementation MyApplyViewController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"我的申请", nil) backButton:YES ];
    [self createFilter];
    //分段器
    [self createSegment];
    _requestType=@"1";
    _IsUrge = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (![_requestType isEqualToString:@"1"]) {
        if (_segIndex==0){
            self.currPage=1;
            _segIndex=0;
            [self requestHasSubmit];
        }else if (_segIndex==1)
        {
            self.currPage=1;
            _segIndex=1;
            [self requestNoSubmit];
        }
    }
    _requestType=@"0";
}
-(void)createFilter
{
    _rightSearchBtn = [[UIButton alloc]init];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:_rightSearchBtn title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(filter:)];
}
//MARK:创建分段器
-(void)createSegment
{
    
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type=@"1";
    _segementView.titleArray = @[Custing(@"已提交", nil),Custing(@"草稿箱",nil)];
    _segementView.titleColor=Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor=Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont=13.f;
    [self.view addSubview:_segementView];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    NSLog(@"我是第%ld个label",(long)index);
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            self.currPage=1;
            _rightSearchBtn.hidden=NO;
            [self requestHasSubmit];
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            self.currPage=1;
            _rightSearchBtn.hidden=YES;
            [self requestNoSubmit];
            break;
        default:
            break;
    }
}



#pragma mark 添加网络数据

//MARK:已提交
-(void)requestHasSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorksubmitGetcreatedbyme];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"RequestorDate",@"IsAsc":@"desc",@"TaskName":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:未提交
-(void)requestNoSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorksubmitGetmydraft];
    
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"RequestorDate",@"IsAsc":@"desc",@"TaskName":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:获取单据数量
-(void)requestNum{
    NSString *url=[NSString stringWithFormat:@"%@",WorksubmitGetNum];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
}

//MARK:判断是否有撤回
-(void)requestJudgeRecall{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",JudgeRecall];
    NSDictionary *parameters = @{@"FlowCode":[NSString stringWithFormat:@"%@",self.pushModel.flowCode],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId],@"RecallType":@"1"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}
//MARK:获取撤回ProcId
-(void)requestGetReCallProcId{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetReCallProcId];
    NSDictionary *parameters = @{@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
    
}

//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
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
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
        {
            [self dealWithData];
            [self createNOdataView];
            [self requestNum];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
            break;
        case 2:
            self.currPage=1;
            [self requestNoSubmit];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil)];
            break;
        case 3:
            [self dealWithNumData];
            [self reviseSegTitle];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            break;
        case 4:
        {
            NSDictionary *dict = @{@"type":@"1",
                                   @"hasCall":[[NSString stringWithFormat:@"%@",_resultDict[@"result"]]isEqualToString:@"1"] ? @"1":@"0",
                                   @"canUrge": (_IsUrge == 1&&([self.pushModel.status integerValue]==1||[self.pushModel.paymentStatus integerValue]==1)) ? @"1":@"0"
                                   };
            [self dealWithReCallWithCall:dict];
        }
            break;
        case 5:
            self.pushModel.procId=[NSString stringWithFormat:@"%@",_resultDict[@"result"]];
            [self dealWithHasReCalled];
            
            break;
        case 6:
            self.currPage=1;
            [self requestHasSubmit];
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
    _totalPage=[result[@"totalPages"] integerValue] ;
    _IsUrge = [[NSString stringWithFormat:@"%@",result[@"isUrge"]]isEqualToString:@"1"] ? 1:0;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            //            if ([model.status integerValue]==2) {
            //                model.comment=@"我哦啊哦搜嫂嫂撒搜啊骚骚骚骚骚骚骚骚骚哦搜哦啊搜啊是";
            //            }
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

//MARK:任务数量处理
-(void)dealWithNumData
{
    NSDictionary *result=_resultDict[@"result"];
    _notSubmitNum=result[@"myDraftNum"];
    _backSubmitNum=result[@"recedeFormNum"];
}
//MARK:修改分段器标题
-(void)reviseSegTitle
{
    _segementView.otherTitles=@[Custing(@"已提交", nil),[NSString stringWithFormat:@"%@(%@)",Custing(@"草稿箱",nil),_notSubmitNum]];
}
//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    _segementView.otherTitles = @[Custing(@"已提交", nil),Custing(@"草稿箱",nil)];
    //    self.isLoading=NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"MyApplyViewCell"];
    if (_cell==nil) {
        _cell=[[ MyApplyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyApplyViewCell"];
    }
    MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
    if (_segIndex==0) {
        [_cell configViewHasSubmitWithModel:model];
    }else if(_segIndex==1){
        [_cell configViewNotSubmitWithModel:model];
    }
    [_cell.DetaileBtn addTarget:self action:@selector(SeeDetails:) forControlEvents:UIControlEventTouchUpInside];
    _cell.DetaileBtn.tag=indexPath.section+100;
    return _cell;
}

//是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加删除按钮
    MyApplyModel *model=self.resultArray[indexPath.section];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        if (self.segIndex==0) {
            if ([model.status integerValue]==2||[model.status integerValue]==6) {
                NSString *url=[NSString stringWithFormat:@"%@", SubmiterDelete];
                NSDictionary *parameters = @{@"TaskId":model.taskId,@"FlowCode":model.flowCode};
                [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:6 IfUserCache:NO];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"不能删除", nil) duration:2.0];
            }
        }else{
            NSString *url=[NSString stringWithFormat:@"%@", submitDeletedraft];
            NSDictionary *parameters = @{@"TaskId":model.taskId,@"FlowCode":model.flowCode};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
        }
    }];
    if (_segIndex==0&&[model.status integerValue]!=2&&[model.status integerValue]!=6) {
        deleteRowAction.backgroundColor = [UIColor grayColor];
    }else{
        deleteRowAction.backgroundColor = [UIColor redColor];
    }
    return @[deleteRowAction];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.pushModel=self.resultArray[indexPath.section];
    [self MyApplySelect:self.pushModel WithIndex:_segIndex];

    
}
-(void)loadData{
    if (_segIndex==0) {
        [self requestHasSubmit];
    }else if (_segIndex==1){
        [self requestNoSubmit];
    }
}
//MARK:筛选按钮点击事件
-(void)filter:(UIButton *)btn
{
    NSLog(@"筛选");
    FilterBaseViewController  *SubmitFilter=[[FilterBaseViewController alloc]initWithType:@"WorkHasSubmit"];
    [self.navigationController pushViewController:SubmitFilter animated:YES];
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
    NSString *tips;
    if (_segIndex==0) {
        tips=Custing(@"您还没有已提交记录哦", nil);
    }else if (_segIndex==1){
        tips=Custing(@"您还没有未提交记录哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
