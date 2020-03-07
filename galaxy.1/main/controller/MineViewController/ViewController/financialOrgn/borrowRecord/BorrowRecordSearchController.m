//
//  BorrowRecordSearchController.m
//  galaxy
//
//  Created by hfk on 2017/3/8.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "BorrowRecordSearchController.h"
#import "borrowModel.h"
#import "borrowViewCell.h"
#import "RepaymentListViewController.h"
#import "TravelReqFormModel.h"
#import "TravelReqFormCell.h"
#import "TravelReqFormInfoController.h"

#define pageNum (Main_Screen_Height-NavigationbarHeight)/80+6
@interface BorrowRecordSearchController ()<UISearchBarDelegate,GPClientDelegate>
@property(nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,assign)NSInteger  approvalStatus;
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)NSString *searchAim;//搜索目标
@property(nonatomic,strong)NSString *searchStatus;//搜索状态
@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据
@property (nonatomic,strong)NSString * recordcount;
@property (nonatomic,strong)NSString * totalAmount;

@end

@implementation BorrowRecordSearchController
-(id)initWithType:(NSInteger )type
{
    self=[super initWithType:@"0"];
    if (self) {
        self.approvalStatus=type;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:nil backButton:NO ];
    [self createSearchView];
    [self setNavigationBar];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _requestType=@"1";
    self.tableView.userInteractionEnabled=NO;
    _searchAim=@"";
    _searchStatus=@"1";
    [_searchBar becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (![_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        if (self.approvalStatus>=50&&self.approvalStatus<=52) {
            [self requestList];
        }else{
            [self requestGetgetuserloans];
        }
    }
    _requestType=@"0";
}
-(void)createSearchView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 36)];//allocate titleView
    titleView.backgroundColor=Color_form_TextFieldBackgroundColor;
    titleView.layer.cornerRadius =8.0f;
    titleView.layer.masksToBounds = YES;
    titleView.layer.borderWidth=1;
    self.navigationItem.titleView = titleView;
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, 0, Main_Screen_Width-70, 36);
    [[[[ _searchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    _searchBar.delegate = self;
    if (self.approvalStatus>=50&&self.approvalStatus<=52) {
        _searchBar.placeholder = Custing(@"搜索申请人", nil);
    }else{
        _searchBar.placeholder = Custing(@"搜索借款人", nil);
    }
    _searchBar.showsCancelButton = NO;
    
    if (self.userdatas.SystemType==1) {
        titleView.layer.borderColor=Color_form_TextFieldBackgroundColor.CGColor;
        _searchBar.tintColor=Color_form_TextFieldBackgroundColor;
    }else{
        titleView.layer.borderColor=Normal_NavBar_TitleBlue_20.CGColor;
        _searchBar.tintColor=Color_Blue_Important_20;
    }
    [titleView addSubview:_searchBar];
}

//MARK:取消按钮
-(void)setNavigationBar{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(searchCancleClick:)];
}

//员工借款查询/员工借款记录
-(void)requestGetgetuserloans{
    self.isLoading=YES;
    if (self.approvalStatus ==0) {
        NSDictionary * dic =@{@"Requestor":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"Requestor desc",@"IsAsc":@""};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getuserloans] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else{
        NSDictionary * dic =@{@"Requestor":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"operatordate desc",@"IsAsc":@""};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getuserloanhist] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
//MARK:机票酒店火车
-(void)requestList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url;
    NSInteger index=self.approvalStatus-50;
    if (index==0) {
        url=[NSString stringWithFormat:@"%@",CtripFlightORDER];
    }else if (index==1){
        url=[NSString stringWithFormat:@"%@",CtripHotelORDER];
    }else if (index==2){
        url=[NSString stringWithFormat:@"%@",CtripTrainORDER];
    }
    NSDictionary *parameters = @{@"UserDspName":_searchAim,@"OrderBy":@"TaskId",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"IsAsc":@"desc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading=NO;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
        {
            NSDictionary *result=_resultDict[@"result"];
            self.recordcount = [NSString stringWithFormat:@"%@",[result objectForKey:@"recordcount"]];
            self.totalAmount = [NSString stringWithFormat:@"%@",[result objectForKey:@"totalAmount"]];
            self.totalPage = [[result objectForKey:@"totalPages"] integerValue];
            if (self.totalPage >= self.currPage) {
                
                [borrowModel GetBorrowRecordDictionary:responceDic Array:self.resultArray];
            }
        }
            break;
        case 1:
        {
            [self dealWithData];
        }
            break;
        default:
            break;
    }
    [self createNOdataViewWithHasData:(self.resultArray.count!=0)];
    self.tableView.userInteractionEnabled=YES;
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
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
//MARK:数据处理
-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            TravelReqFormModel *model=[[TravelReqFormModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            TravelReqFormModel *model=[[TravelReqFormModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
}

-(void)loadData{
    if (self.approvalStatus>=50&&self.approvalStatus<=52) {
        [self requestList];
    }else{
        [self requestGetgetuserloans];
    }
}
//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.approvalStatus>=50&&self.approvalStatus<=52) {
        TravelReqFormModel * model =self.resultArray[indexPath.section];
        return [TravelReqFormCell cellHeightWithObj:model withIndex:self.approvalStatus-50];
    }else{
        return 70;
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
    if (self.approvalStatus>=50&&self.approvalStatus<=52) {
        TravelReqFormCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TravelReqFormCell"];
        if (cell==nil) {
            cell=[[TravelReqFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelReqFormCell"];
        }
        TravelReqFormModel * model = self.resultArray[indexPath.section];
        [cell configTravelReqFormCellWithModel:model withIndex:self.approvalStatus-50];
        return cell;
    }else{
        borrowViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"borrowViewCell"];
        if (cell==nil) {
            cell=[[borrowViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"borrowViewCell"];
        }
        borrowModel *cellInfo = self.resultArray[indexPath.section];
        if (self.approvalStatus ==0) {
            [cell configBorrowRecordCellInfo:cellInfo];
        }else{
            [cell configItsEmployeeRecordsCellInfo:cellInfo];
            
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (self.approvalStatus>=50&&self.approvalStatus<=52) {
        TravelReqFormModel * model = self.resultArray[indexPath.section];
        TravelReqFormInfoController *vc=[[TravelReqFormInfoController alloc]init];
        vc.model_Data=model;
        vc.int_Type=self.approvalStatus-50;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        borrowModel *cellInfo = self.resultArray[indexPath.section];
        if (self.approvalStatus ==0) {
            NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%@",cellInfo.idd],@"amount":[NSString stringWithFormat:@"%@",cellInfo.amount],@"requestor":cellInfo.requestor,@"requestorUserId":[NSString stringWithFormat:@"%@",cellInfo.requestorUserId]};
            RepaymentListViewController * reimburs = [[RepaymentListViewController alloc]initWithType:parameters Name:@"borrowRecord"];
            [self.navigationController pushViewController:reimburs animated:YES];
        }
    }
}
//MARK:取消按钮被点击
-(void)searchCancleClick:(UIButton *)btn
{
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.tableView.userInteractionEnabled=NO;
        _searchStatus=@"1";
        [self.resultArray removeAllObjects];
        [self createNOdataViewWithHasData:YES];
        [self.tableView reloadData];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    if (![_searchAim isEqualToString:@""]) {
        _searchStatus=@"0";
    }
    if ([_searchStatus isEqualToString:@"1"]) {
        return;
    }
    [self loadData];
    
}

//MARK:创建无数据视图
-(void)createNOdataViewWithHasData:(BOOL)hasData{
    
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有相关数据哦", nil) hasData:hasData hasError:NO reloadButtonBlock:nil];
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
