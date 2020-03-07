//
//  BorrowRecordViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "RepaymentListViewController.h"
#define pageNum  (Main_Screen_Height-NavigationbarHeight-44)/70
#import "infoViewController.h"
#import "XFSegementView.h"
#import "borrowModel.h"
#import "borrowViewCell.h"
#import "BorrowRecordViewController.h"
#import "InstructionsViewController.h"
@interface BorrowRecordViewController ()<GPClientDelegate,TouchLabelDelegate>
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property (nonatomic, strong) XFSegementView *segementView;
@property(nonatomic,assign)NSInteger segIndex;//分段器当前选择
@property (assign, nonatomic)NSInteger totalPages;//系统分页数
@property(nonatomic,strong)NSMutableArray *chooseArray;//记录批量点击
@property (nonatomic,strong)UIButton * rightSearchBtn;
@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据
@property (nonatomic, assign) BOOL  isEditing;
@property(nonatomic,strong)UIBarButtonItem* rightBtn1;
@property(nonatomic,strong)UIBarButtonItem* rightBtn2;
@property(nonatomic,strong)UIBarButtonItem* rightBtn3;
@property (nonatomic,strong)DoneBtnView * dockView;
@property(nonatomic,strong)NSMutableArray *arr_Message;//催款数组

@end

@implementation BorrowRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self setTitle:Custing(@"借还款", nil) backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];
    [self createSegment];
    [self createEditAndFilterCancel];
    [self createDockView];
    _chooseArray=[NSMutableArray array];
    _requestType=@"1";
    [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.dockView.top);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (![_requestType isEqualToString:@"1"]) {
        self.currPage = 1;
        [self requestGetgetuserloansData:self.currPage];
    }
    _requestType=@"0";
}
-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"borrowRecord"];
    [self.navigationController pushViewController:INFO animated:YES];
}
//MARK:分段器创建
-(void)createSegment
{
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type=@"1";
    _segementView.titleArray = @[Custing(@"员工借款", nil),Custing(@"借款记录", nil)];
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
    _rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"Share_AgentSearch":@"NavBarImg_Search" target:self action:@selector(search:)];
    _rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"Share_AgentEdit":@"NavBarImg_Edit" target:self action:@selector(edit:)];
    _rightBtn3 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Noraml_NavBar_TitleGray_20 titleIndex:0 imageName:nil target:self action:@selector(cancle:)];
}

-(void)createDockView{
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.width.mas_equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
        make.height.equalTo(@0);
    }];
    
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"批量催款", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf messageToBorrower];
        }
    };
}

- (void)touchLabelWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            break;
        default:
            break;
    }
    self.currPage=1;
    _isEditing=NO;
    self.navigationItem.rightBarButtonItems =nil;
    [self changetableDockView];
    [self requestGetgetuserloansData:self.currPage];
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
        
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//MARK:员工借款查询/员工借款记录
-(void)requestGetgetuserloansData:(NSInteger)page {
    self.isLoading = YES;
    if (self.segIndex ==0) {
        NSDictionary * dic =@{@"Requestor":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"Requestor desc",@"IsAsc":@""};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getuserloans] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else{
        NSDictionary * dic =@{@"Requestor":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"operatordate desc",@"IsAsc":@""};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getuserloanhist] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
//MARK:催款
-(void)requestMessageAmount{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * dic =@{@"Input":[NSString transformToJson:_arr_Message]};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",MESSAGEAMOUNT] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
}
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
        [_chooseArray removeAllObjects];
    }
    _resultDict=responceDic;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stri);
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
        if (serialNum==1) {
            self.currPage=1;
            [self requestGetgetuserloansData:self.currPage];
        }
        return;
    }
    switch (serialNum) {
        case 0:
            [self DealWithNavBtns];
            [self dealWithData];
            
            [self createNOdataView];

            
            break;
        case 1:
        {
            if ([_resultDict[@"result"]floatValue]>0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"催款成功", nil) duration:2.0];
                self.dockView.userInteractionEnabled=YES;
                self.currPage=1;
                [self requestGetgetuserloansData:self.currPage];
            }
        }
            break;
        default:
            break;
    }
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}
//MARK:数据处理
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPages=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPages) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            borrowModel *model=[[borrowModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
            if (_segIndex==0) {
                [_chooseArray addObject:@"0"];
            }
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            borrowModel *model=[[borrowModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
            if (_segIndex==0) {
                [_chooseArray addObject:@"0"];
            }
        }
    }
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{

    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    self.dockView.userInteractionEnabled=YES;
    [self.resultArray removeAllObjects];
    [_chooseArray removeAllObjects];
    self.isLoading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)loadData{
    [self requestGetgetuserloansData:self.currPage];
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
    return 70;
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
    view.backgroundColor=[UIColor clearColor];
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
    borrowViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"borrowViewCell"];
    if (cell==nil) {
        cell=[[borrowViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"borrowViewCell"];
    }
    borrowModel *cellInfo = self.resultArray[indexPath.section];
    if (self.segIndex ==0) {
        if (_isEditing) {
            NSString *str=_chooseArray[indexPath.section];
            [cell configEditBorrowRecordCellInfo:cellInfo withStatus:str];
        }else{
            [cell configBorrowRecordCellInfo:cellInfo];
        }
    }else{
        [cell configItsEmployeeRecordsCellInfo:cellInfo];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    borrowModel *cellInfo = self.resultArray[indexPath.section];
    if (self.segIndex ==0) {
        if (_isEditing) {
            NSString *chooseStr=_chooseArray[indexPath.section];
            if ([chooseStr isEqualToString:@"1"] ){
                [_chooseArray replaceObjectAtIndex:indexPath.section withObject:@"0"];
            }else{
                [_chooseArray replaceObjectAtIndex:indexPath.section withObject:@"1"];
            }
            [self.tableView reloadData];
        }else{
            NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%@",cellInfo.Id],@"amount":[NSString stringWithFormat:@"%@",cellInfo.amount],@"requestor":cellInfo.requestor,@"requestorUserId":[NSString stringWithFormat:@"%@",cellInfo.requestorUserId]};
            RepaymentListViewController * reimburs = [[RepaymentListViewController alloc]initWithType:parameters Name:@"borrowRecord"];
            [self.navigationController pushViewController:reimburs animated:YES];
        }
    }
}

-(void)changetableDockView{
    [self.dockView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.isEditing?@50:@0));
    }];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if (_segIndex==0) {
        tips=Custing(@"您还没有借款记录哦", nil);
    }else if (_segIndex==1){
        tips=Custing(@"您还没有历史记录哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

//MARK:-搜索
-(void)search:(UIButton *)btn
{
    BorrowRecordSearchController *search=[[BorrowRecordSearchController alloc]initWithType:_segIndex];
    [self.navigationController pushViewController:search animated:YES];
}
-(void)edit:(id)obj{
    _isEditing=YES;
    [self DealWithNavBtns];
    [self changetableDockView];
    [self.tableView reloadData];
}
-(void)cancle:(id)obj{
    _isEditing=NO;
    [_chooseArray removeAllObjects];
    for (int i=0; i<self.resultArray.count; i++) {
        [_chooseArray addObject:@"0"];
    }
    [self changetableDockView];
    [self DealWithNavBtns];
    [self.tableView reloadData];
}
-(void)messageToBorrower{
    if ([_chooseArray containsObject:@"1"]==NO) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择", nil)];
        return;
    }
    self.dockView.userInteractionEnabled=NO;
    _arr_Message=[NSMutableArray array];
    for (NSInteger i=0; i<_chooseArray.count; i++) {
        NSString *str=_chooseArray[i];
        if ([str isEqualToString:@"1"]) {
            borrowModel *cellInfo = self.resultArray[i];
            NSDictionary *dict=@{
                                 @"UserId":[NSString isEqualToNull:cellInfo.requestorUserId]?[NSString stringWithFormat:@"%@",cellInfo.requestorUserId]:(id)[NSNull null],
                                 @"Reason":[NSString isEqualToNull:cellInfo.amount]?[NSString stringWithFormat:@"%@",cellInfo.amount]:(id)[NSNull null],
                                 @"Requestor":[NSString isEqualToNull:cellInfo.requestor]?[NSString stringWithFormat:@"%@",cellInfo.requestor]:(id)[NSNull null],
                                 @"RequestorDate":[NSString isEqualToNull:cellInfo.requestorDate]?[NSString stringWithFormat:@"%@",cellInfo.requestorDate]:(id)[NSNull null],
                                 @"Module":@"repayment",
                                 @"TaskId":(id)[NSNull null],
                                 @"ProcId":(id)[NSNull null]
                                 };
            [_arr_Message addObject:dict];
        }
    }
    [self requestMessageAmount];
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
