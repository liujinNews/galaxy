//
//  PayMentApproveController.m
//  galaxy
//
//  Created by hfk on 2016/11/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PayMentApproveController.h"
#import "BatchPayViewController.h"
#import "PayMentDetailController.h"
#import "PayMentProModel.h"
#import "PayMentProCell.h"
#define pageNum  (Main_Screen_Height-NavigationbarHeight-44)/80+6
@interface PayMentApproveController ()
@property(nonatomic,strong)UIBarButtonItem* rightBtn1;
@property(nonatomic,strong)UIBarButtonItem* rightBtn2;
@property(nonatomic,strong)UIBarButtonItem* rightBtn3;

@end

@implementation PayMentApproveController

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
    [self setTitle:Custing(@"支付", nil) backButton:YES ];
    [self createSegment];
    [self createEditAndSearchBtns];
    _chooseArray=[NSMutableArray array];
    _requestType=@"1";
}

////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        _isEditing=NO;
        [self changetableFrame];
        if (_segIndex==0) {
            self.currPage=1;
            _segIndex=0;
            [self requestWaitPay];
        }else if (_segIndex==1) {
            self.currPage=1;
            _segIndex=1;
            [self requestHasPay];
        }else if (_segIndex==2) {
            self.currPage=1;
            _segIndex=2;
            [self requestPayProgress];
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
    _segementView.titleArray =[self.userdatas.isOnlinePay isEqualToString:@"1"]? @[Custing(@"待支付", nil),Custing(@"已支付", nil),Custing(@"支付进度", nil)]: @[Custing(@"待支付", nil),Custing(@"已支付", nil)];
    _segementView.titleColor=Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor=Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont=13.f;
    [self.view addSubview:_segementView];
}
//MARK:创建编辑搜索按钮
-(void)createEditAndSearchBtns{
    
    _rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(filter:)];
    
    _rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"Share_AgentEdit":@"NavBarImg_Edit" target:self action:@selector(edit:)];

    _rightBtn3 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Noraml_NavBar_TitleGray_20 titleIndex:0 imageName:nil target:self action:@selector(cancle:)];
}
-(void)DealWithNavBtns{
    if (_segIndex==0) {
        if (_isEditing) {
            self.navigationItem.rightBarButtonItems = @[_rightBtn3];
        }else{
            self.navigationItem.rightBarButtonItems = @[_rightBtn1,_rightBtn2];
        }
    }else{
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
            _isEditing=NO;
            [self changetableFrame];
            _segIndex=0;
            self.currPage=1;
            [self requestWaitPay];
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
            [self requestHasPay];
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
            [self requestPayProgress];
            break;
        default:
            break;
    }
}
//MARK:待支付数据
-(void)requestWaitPay
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",approvalWAITPAY];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"ArrivalDate",@"IsAsc":@"desc",@"TaskName":@""};
//    @"OrderBy":@"TaskId"
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:已支付数据
-(void)requestHasPay
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",approvalHASPAY];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"PaymentDate",@"IsAsc":@"desc",@"TaskName":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:支付进度
-(void)requestPayProgress{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",PAYProgress];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"Status":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取单据数量
-(void)requestNum{
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalGetNum];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:审批人是否能编辑页面
-(void)requestJudgeAppoverEdit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",ApproverEdit];
    NSDictionary *parameters = @{@"ProcId":[NSString stringWithFormat:@"%@",self.pushModel.procId],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
        [_chooseArray removeAllObjects];
    }
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
        self.dockView.userInteractionEnabled=YES;
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
        case 1:
            [self dealWithNumData];
            [self reviseSegTitle];
            break;
        case 2:
        {
            if (![_resultDict[@"result"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dict=_resultDict[@"result"];
                [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",dict[@"resultMessage"]] duration:2.0];
            }
        }
            break;
        case 3:
        {
            NSString *result=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_resultDict[@"result"]]]?[NSString stringWithFormat:@"%@",_resultDict[@"result"]]:@"";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:result duration:2.0];
        }
            break;
        case 4:
            [self dealWithAppoverEdit:[NSString isEqualToNull:_resultDict[@"result"]]?[NSString stringWithFormat:@"%@",_resultDict[@"result"]]:@"0" WithStatus:2];
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
            if (_segIndex==2) {
                PayMentProModel *model=[[PayMentProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
            }else{
                MyApplyModel *model=[[MyApplyModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
                if (_segIndex==0) {
                    [_chooseArray addObject:@"0"];
                }
            }
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            if (_segIndex==2) {
                PayMentProModel *model=[[PayMentProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
            }else{
                MyApplyModel *model=[[MyApplyModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
                if (_segIndex==0) {
                    [_chooseArray addObject:@"0"];
                }
            }
        }
    }
}

//MARK:任务数量处理
-(void)dealWithNumData
{
    NSDictionary *result=_resultDict[@"result"];
    _toApprovalNum=result[@"myToDoNum"];
    _toPayNum=result[@"unpaidNum"];
}

//MARK:修改分段器标题
-(void)reviseSegTitle
{
    _segementView.otherTitles=[self.userdatas.isOnlinePay isEqualToString:@"1"]?@[[NSString stringWithFormat:@"%@(%@)",Custing(@"待支付", nil),_toPayNum],Custing(@"已支付",nil),Custing(@"支付进度",nil)]:@[[NSString stringWithFormat:@"%@(%@)",Custing(@"待支付", nil),_toPayNum],Custing(@"已支付",nil)];
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    [_chooseArray removeAllObjects];
    _segementView.otherTitles=[self.userdatas.isOnlinePay isEqualToString:@"1"]?@[Custing(@"待支付", nil),Custing(@"已支付", nil),Custing(@"支付进度", nil)]:@[Custing(@"待支付", nil),Custing(@"已支付", nil)];
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
    if (_segIndex==2) {
        return [PayMentProCell cellHeightWithObj:self.resultArray[indexPath.section]];
    }else{
        MyApplyModel *model=(MyApplyModel *)self.resultArray[indexPath.section];
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.comment]]) {
            CGSize size = [model.comment sizeCalculateWithFont:Font_Same_11_20 constrainedToSize:CGSizeMake(Main_Screen_Width-130, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
            return 110+size.height;
        }else{
            return 94;
        }
    }
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
    if (_segIndex==2) {
        PayMentProCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PayMentProCell"];
        if (cell==nil) {
            cell=[[PayMentProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayMentProCell"];
        }
        cell.model = self.resultArray[indexPath.section];
        return cell;
    }else{
        _cell=[tableView dequeueReusableCellWithIdentifier:@"ApproveCell"];
        if (_cell==nil) {
            _cell=[[ApproveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApproveCell"];
        }
        _cell.tag=indexPath.row+400;
        MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
        if (_isEditing==YES) {
            NSString *str=_chooseArray[indexPath.section];
            [_cell configViewNotApproveWithModel:model withStatus:str];
        }else{
            [_cell configViewNotApproveWithModel:model];
        }
        return _cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((_segIndex==0&&_isEditing==YES)) {
        NSString *chooseStr=_chooseArray[indexPath.section];
        if ([chooseStr isEqualToString:@"1"] ){
            [_chooseArray replaceObjectAtIndex:indexPath.section withObject:@"0"];
        }else{
            [_chooseArray replaceObjectAtIndex:indexPath.section withObject:@"1"];
        }
        [self.tableView reloadData];
    }else if (_segIndex==2){
        PayMentProModel *model=self.resultArray[indexPath.section];
        [self dealWithPayWithModel:model];
    }else{
        if ([self.userdatas.isOpenChanPay isEqualToString:@"1"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请到PC端操作", nil) duration:2.0];
            return;
        }
        self.pushModel=self.resultArray[indexPath.section];
        [self MyPaySelect:self.pushModel WithIndex:_segIndex];
    }
}
//MARK:支付处理
-(void)dealWithPayWithModel:(PayMentProModel *)model{
    NSString *status=@"7";
    if ([status isEqualToString:@"0"]||[status isEqualToString:@"1"]||[status isEqualToString:@"2"]||[status isEqualToString:@"11"]||[status isEqualToString:@"12"]) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url;
        if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"1"]) {
            url=[NSString stringWithFormat:@"%@",PAYQuerySingle];
        }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"2"]){
            url=[NSString stringWithFormat:@"%@",PAYQueryMulti];
        }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"3"]){
            url=[NSString stringWithFormat:@"%@",PAYQueryDisMulti];
        }
        NSDictionary *parameters = @{@"OrderSerialNo":[NSString stringWithFormat:@"%@",model.serialNo],@"TaskId":[NSString stringWithFormat:@"%@",model.taskId]};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
    }else if ([status isEqualToString:@"3"]||[status isEqualToString:@"5"]||[status isEqualToString:@"6"]||[status isEqualToString:@"7"]||[status isEqualToString:@"8"]||[status isEqualToString:@"9"]||[status isEqualToString:@"10"]){
    
        UIAlertView *Aler=[[UIAlertView alloc]initWithTitle:@"" message:Custing(@"确认支付", nil) delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"确认",nil), nil];
        Aler.tag=[[NSString stringWithFormat:@"%@",model.taskId] integerValue];
        [Aler show];
    }
}
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url=[NSString stringWithFormat:@"%@",PAYAGAIN];
        NSDictionary *parameters = @{@"TaskId":[NSString stringWithFormat:@"%ld",(long)alertView.tag]};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
    }
}

//MARK:批量支付
-(void)setDockViewOnTitle:(NSString *)title{
    
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor =Color_Blue_Important_20;
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


//MARK:批量同意支付操作
-(void)batchAgree:(UIButton *)btn{
    
    if ([self.userdatas.isOpenChanPay isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请到PC端操作", nil) duration:2.0];
        return;
    }
    if ([_chooseArray containsObject:@"1"]==NO) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择", nil)];
        return;
    }
    self.dockView.userInteractionEnabled=NO;
    NSMutableArray *payArray=[NSMutableArray array];
    NSInteger count=0;
    for (NSString *str in _chooseArray) {
        if ([str isEqualToString:@"1"]) {
            [payArray addObject:self.resultArray[count]];
        }
        count++;
    }
//    self.userdatas.isOnlinePay=@"1";
    if ([self.userdatas.isOnlinePay isEqualToString:@"1"]) {
        PayMentDetailController *batch=[[PayMentDetailController alloc]init];
        batch.batchPayArray=[NSMutableArray arrayWithArray:payArray];
        [self.navigationController pushViewController:batch animated:YES];
    }else{
        BatchPayViewController *batch=[[BatchPayViewController alloc]init];
        batch.batchPayArray=[NSMutableArray arrayWithArray:payArray];
        [self.navigationController pushViewController:batch animated:YES];
    }
    
}
-(void)loadData{
    if (_segIndex==0){
        [self requestWaitPay];
    }else if (_segIndex==1){
        [self requestHasPay];
    }else if (_segIndex==2){
        [self requestPayProgress];
    }
}
//MARK:筛选
-(void)filter:(UIButton *)btn{
    FilterBaseViewController  *SubmitFilter=[[FilterBaseViewController alloc]initWithType:_segIndex==0 ? @"PayMengtWaitPay":(_segIndex == 1 ? @"PayMengtHasPay" : @"PayMengtPro")];
    [self.navigationController pushViewController:SubmitFilter animated:YES];
}
//MARK:编辑按钮
-(void)edit:(UIButton *)btn{
    NSLog(@"编辑");
    _isEditing=YES;
    [self DealWithNavBtns];
    [self setDockViewOnTitle:Custing(@"批量支付", nil)];
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
    if (_segIndex==0){
        tips=Custing(@"您还没有待支付记录哦", nil);
    }else if (_segIndex==1){
        tips=Custing(@"您还没有已支付记录哦", nil);
    }else if (_segIndex==2){
        tips=Custing(@"您还没有支付进度记录哦", nil);
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
