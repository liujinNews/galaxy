//
//  MyApproveViewController.m
//  galaxy
//
//  Created by hfk on 15/10/27.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "MyApproveViewController.h"
#import "MyApproveViewCell.h"
#import "XFSegementView.h"
#import "FilterBaseViewController.h"


#define pageNum  (Main_Screen_Height-NavigationbarHeight-44)/80+6


@interface MyApproveViewController ()<GPClientDelegate,TouchLabelDelegate>
@property (nonatomic,strong)NSString * approvalStatus;//角色登陆区分
@property (nonatomic, strong) UIView *dockView;//底部按钮
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)MyApproveViewCell *cell;
@property(nonatomic,assign)NSInteger segIndex;//分段器当前选择
@property(nonatomic,strong)NSMutableArray *chooseArray;//记录批量点击
@property(nonatomic,strong)NSMutableArray *taskIdArray;//记录taskId
@property(nonatomic,strong)NSMutableArray *procIdArray;//记录procId
@property(nonatomic,strong)NSMutableArray *agreeArray;
@property(nonatomic,strong)NSString *toApprovalNum;
@property(nonatomic,strong)NSString *toPayNum;

@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据

@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign) BOOL  isEditing;
@property(nonatomic,strong)UIBarButtonItem* rightBtn1;
@property(nonatomic,strong)UIBarButtonItem* rightBtn2;
@property(nonatomic,strong)UIBarButtonItem* rightBtn3;


@end

@implementation MyApproveViewController


-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.approvalStatus=type;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"我的审批", nil) backButton:YES ];
    [self createSegment];
    [self createEditAndFilterCancel];
    _chooseArray=[NSMutableArray array];
    _taskIdArray=[NSMutableArray array];
    _procIdArray=[NSMutableArray array];
    _requestType=@"1";
}

////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        [self changetableFrame];
        self.currPage=1;
        if (_segIndex==0) {
            _segIndex=0;
            [self requestWaitApproval];
        }else if (_segIndex==1) {
            _segIndex=1;
            [self requestHasApproval];
        }else if (_segIndex==2){
            _segIndex=2;
            [self requestCCTOME];
        }
    }
    _requestType=@"0";
    self.dockView.userInteractionEnabled=YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

//MARK:分段器创建
-(void)createSegment
{
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type=@"1";
    _segementView.titleArray = @[Custing(@"待审批", nil),Custing(@"已审批",nil),Custing(@"抄送我的",nil)];
    _segementView.titleColor=Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor=Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont=13.f;
    [self.view addSubview:_segementView];
}
//MARK:创建编辑筛选按钮
-(void)createEditAndFilterCancel{
    _rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(search:)];
    _rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"Share_AgentEdit":@"NavBarImg_Edit" target:self action:@selector(edit:)];
    _rightBtn3 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Noraml_NavBar_TitleGray_20 titleIndex:0 imageName:nil target:self action:@selector(cancle:)];
}
-(void)DealWithNavBtns{
    if (_segIndex==0) {
        if (_isEditing==NO) {
            self.navigationItem.rightBarButtonItems = @[_rightBtn1,_rightBtn2];
        }else if (_isEditing==YES){
            self.navigationItem.rightBarButtonItems = @[_rightBtn3];
        }
    }else if (_segIndex==1){
        self.navigationItem.rightBarButtonItems = @[_rightBtn1];
        
    }else if (_segIndex==2){
        self.navigationItem.rightBarButtonItems = @[_rightBtn1];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    NSLog(@"我是第%ld个label",(long)index);
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            self.navigationItem.rightBarButtonItems =nil;
            //界面切换将底部清空
            _isEditing=NO;
            [self changetableFrame];
            _segIndex=0;
            self.currPage=1;
            [self requestWaitApproval];
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            self.navigationItem.rightBarButtonItems =nil;
            _isEditing=NO;
            [self changetableFrame];
            _segIndex=1;
            self.currPage=1;
            [self requestHasApproval];
            break;
        case 2:
            if (_segIndex==2) {
                return;
            }
            self.navigationItem.rightBarButtonItems =nil;
            _isEditing=NO;
            [self changetableFrame];
            _segIndex=2;
            self.currPage=1;
            [self requestCCTOME];
            break;
        default:
            break;
    }
}

//MARK:待审批数据处理
-(void)requestWaitApproval
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalWAITAPPROVAL];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"TaskName":@""};
    //    NSLog(@"1111111111111%@",parameters);
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:审批完成
-(void)requestHasApproval
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalHASAPPROVAL];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"TaskName":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:抄送给我
-(void)requestCCTOME
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalCCTOME];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"TaskName":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:批量同意
-(void)requestAgree{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * parameters = @{@"input":[NSString transformToJsonWithOutEnter:_agreeArray]};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",approvalAGREELIST];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
    
}

//MARK:获取单据数量Work
-(void)requestNum{
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalGetNum];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
    
}
//MARK:审批人是否能编辑页面
-(void)requestJudgeAppoverEdit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",ApproverEdit];
    NSDictionary *parameters = @{@"ProcId":[NSString stringWithFormat:@"%@",self.pushModel.procId],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}

//MARK:判断是否有撤回
-(void)requestJudgeRecall{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",JudgeRecall];
    NSDictionary *parameters = @{@"FlowCode":[NSString stringWithFormat:@"%@",self.pushModel.flowCode],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId],@"RecallType":@"2"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
        [_chooseArray removeAllObjects];
        [_taskIdArray removeAllObjects];
        [_procIdArray removeAllObjects];
    }
    
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading=NO;
        self.dockView.userInteractionEnabled=YES;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        if (serialNum==2) {
            self.currPage=1;
            [self requestWaitApproval];
            [self changetableFrame];
        }
        return;
    }
    
    switch (serialNum) {
        case 0:
            [self DealWithNavBtns];
            [self dealWithData];
            [self createNOdataView];
            [self requestNum];
            
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
            break;
        case 2:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            self.dockView.userInteractionEnabled=YES;
            self.currPage = 1;
            [self requestWaitApproval];
        }
            break;
        case 3:
            [self dealWithNumData];
            [self reviseSegTitle];
            break;
        case 4:
            [self dealWithAppoverEdit:[NSString isEqualToNull:_resultDict[@"result"]]?[NSString stringWithFormat:@"%@",_resultDict[@"result"]]:@"0" WithStatus:1];
            break;
        case 5:
        {
            NSDictionary *dict = @{@"type":@"2",
                                   @"hasCall":[[NSString stringWithFormat:@"%@",_resultDict[@"result"]]isEqualToString:@"1"] ? @"1":@"0"                                   };
            [self dealWithReCallWithCall:dict];
        }
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
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            //            if ([model.status integerValue]==2) {
            //                model.comment=@"我哦啊哦搜嫂嫂撒搜啊骚骚骚骚骚骚骚骚骚哦搜哦啊搜啊是";
            //            }
            [self.resultArray addObject:model];
            
            [_taskIdArray addObject:[dict objectForKey:@"taskId"]];
            [_procIdArray addObject:[dict objectForKey:@"procId"]];
            if (_segIndex==0) {
                [_chooseArray addObject:@"0"];
            }
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
            [_taskIdArray addObject:[dict objectForKey:@"taskId"]];
            [_procIdArray addObject:[dict objectForKey:@"procId"]];
            if (_segIndex==0) {
                [_chooseArray addObject:@"0"];
            }
        }
    }
}

//MARK:任务数量处理
-(void)dealWithNumData
{
    NSDictionary *result=_resultDict[@"result"];
    _toApprovalNum=result[@"myToDoNum"];
    self.userdatas.work_waitNum=[NSString stringWithFormat:@"%@",_toApprovalNum];
    _toPayNum=result[@"unpaidNum"];
}
//MARK:修改分段器标题
-(void)reviseSegTitle
{
    _segementView.otherTitles=@[[NSString stringWithFormat:@"%@(%@)",Custing(@"待审批", nil),_toApprovalNum],Custing(@"已审批", nil),Custing(@"抄送我的", nil)];
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    self.dockView.userInteractionEnabled=YES;
    [self.resultArray removeAllObjects];
    [_chooseArray removeAllObjects];
    [_taskIdArray removeAllObjects];
    [_procIdArray removeAllObjects];
    _segementView.otherTitles = @[Custing(@"待审批", nil),Custing(@"已审批",nil),Custing(@"抄送我的", nil)];
    self.isLoading = NO;
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
    return [MyApproveViewCell cellHeightWithObj:model];
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
    _cell=[tableView dequeueReusableCellWithIdentifier:@"MyApproveViewCell"];
    if (_cell==nil) {
        _cell=[[MyApproveViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyApproveViewCell"];
    }
    _cell.tag=indexPath.row+400;
    MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
    if (_segIndex==0) {
        if (_isEditing==YES) {
            NSString *str=_chooseArray[indexPath.section];
            [_cell configViewNotApproveWithModel:model withStatus:str];
        }else{
            [_cell configViewNotApproveWithModel:model];
        }
    }else if(_segIndex==1||_segIndex==2){
        [_cell configViewHasApproveWithModel:model];
    }
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segIndex==0&&_isEditing==YES) {
        NSString *chooseStr=_chooseArray[indexPath.section];
        if ([chooseStr isEqualToString:@"1"] ){
            [_chooseArray replaceObjectAtIndex:indexPath.section withObject:@"0"];
        }else{
            [_chooseArray replaceObjectAtIndex:indexPath.section withObject:@"1"];
        }
        [self.tableView reloadData];
    }else{
        self.pushModel=self.resultArray[indexPath.section];
        [self MyApproveSelect:self.pushModel WithIndex:_segIndex];
    }
}


//MARK:批量同意
-(void)setDockViewOnTitle:(NSString *)title{
    
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [GPUtils colorHString:ColorPink];
    self.dockView.layer.borderWidth = 1;
    self.dockView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.dockView.frame = CGRectMake(0, ScreenRect.size.height - 50 - NavigationbarHeight, Main_Screen_Width,50);
    [self.view addSubview:self.dockView];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        
    }];
    
    
    UIButton * protelBtn = [GPUtils createButton:CGRectMake(0, 0, WIDTH(self.dockView), HEIGHT(self.dockView)) action:nil delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:title font:Font_filterTitle_17 color:Color_form_TextFieldBackgroundColor];
    [protelBtn setBackgroundColor:Color_Blue_Important_20];
    
    [protelBtn addTarget:self action:@selector(batchAgree:) forControlEvents:UIControlEventTouchUpInside];
    [self.dockView addSubview:protelBtn];
    
}


//MARK:批量同意操作
-(void)batchAgree:(UIButton *)btn
{
    if ([_chooseArray containsObject:@"1"]==NO) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择", nil)];
        return;
    }
    self.dockView.userInteractionEnabled=NO;
    _agreeArray=[NSMutableArray array];
    NSInteger count=0;
    for (NSString *str in _chooseArray) {
        if ([str isEqualToString:@"1"]) {
            NSDictionary *dict=@{@"ActionLinkName":@"同意",@"Comment":@"",@"TaskId":[NSString stringWithFormat:@"%@",_taskIdArray[count]],@"ProcId":[NSString stringWithFormat:@"%@",_procIdArray[count]],@"FormData":@"",@"ExpIds":@""};
            [_agreeArray addObject:dict];
        }
        count++;
    }
    [self requestAgree];
    
}
-(void)loadData{
    if (_segIndex==0) {
        [self requestWaitApproval];
    }else if (_segIndex==1){
        [self requestHasApproval];
    }else if (_segIndex==2){
        [self requestCCTOME];
    }
    
}

//MARK:-搜索
-(void)search:(UIButton *)btn
{
    if (_segIndex==0) {
        FilterBaseViewController  *SubmitFilter=[[FilterBaseViewController alloc]initWithType:@"WorkWaitApprove"];
        [self.navigationController pushViewController:SubmitFilter animated:YES];
    }else if (_segIndex==1){
        FilterBaseViewController  *SubmitFilter=[[FilterBaseViewController alloc]initWithType:@"WorkHasApprove"];
        [self.navigationController pushViewController:SubmitFilter animated:YES];
    }else if (_segIndex==2){
        FilterBaseViewController  *SubmitFilter=[[FilterBaseViewController alloc]initWithType:@"WorkCCTOME"];
        [self.navigationController pushViewController:SubmitFilter animated:YES];
    }
}


//MARK:编辑按钮
-(void)edit:(UIButton *)btn{
    NSLog(@"编辑");
    _isEditing=YES;
    [self DealWithNavBtns];
    
    [self setDockViewOnTitle:Custing(@"批量同意", nil)];
    [self.tableView reloadData];
    
}
//MARK:取消按钮
-(void)cancle:(UIButton *)btn{
    _isEditing=NO;
    [_chooseArray removeAllObjects];
    for (int i=0; i<self.resultArray.count; i++) {
        [_chooseArray addObject:@"0"];
    }
    [self changetableFrame];
    [self DealWithNavBtns];
    [self.tableView reloadData];
}


-(void)changetableFrame{
    if (self.dockView&&_isEditing==NO) {
        [self.dockView removeFromSuperview];
        self.dockView=nil;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }
}


//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if (_segIndex==0) {
        tips=Custing(@"您还没有待审批记录哦", nil);
    }else if (_segIndex==1){
        tips=Custing(@"您还没有已审批记录哦", nil);
    }else if (_segIndex==2){
        tips=Custing(@"您还没有抄送记录哦", nil);
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
