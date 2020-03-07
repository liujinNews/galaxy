//
//  RouteViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/14.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RouteViewController.h"
#import "RouteModel.h"
#import "RouteTableViewCell.h"
#import "XFSegementView.h"
#import "RouteImportViewController.h"
#import "NewAddCostViewController.h"
#import "RouteDiDiDateView.h"
#import "RouteDidiModel.h"

@interface RouteViewController ()<GPClientDelegate,TouchLabelDelegate>

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSDictionary *dic_request;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger segIndex;//分段器当前选择
@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, strong) UIButton *left_btn;
@property (nonatomic, strong) NSMutableArray *muarr_id;
@property (nonatomic, strong) NSMutableArray *muarr_mileage;
@property (nonatomic, strong) NSMutableArray *muarr_sACityName;
@property (nonatomic, strong) NSMutableArray *muarr_sDCityName;

@property (nonatomic, strong) NSMutableArray *arr_BatchDidi;

@property (nonatomic, strong) RouteModel *model_route;
@property (nonatomic, strong) RouteDidiModel *model_didi;
@property (nonatomic, strong) UIView *view_bottomBtn;

@property (nonatomic, strong) UIView *view_SelectTime;

@property (nonatomic, strong) UITextField *txf_state_date;
@property (nonatomic, strong) UITextField *txf_end_date;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"我的行程", nil) backButton:YES];
    [self initializeData];
    
    [self createRightBtn];
    
    [self createMainView];
    [self createSegment];
    [self updateLoadView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    self.currPage = 1;
    [self requestDriveCarGetDriveCarList];
}

#pragma mark - function
//初始化数据
-(void)initializeData{
    _isEdit = NO;
    self.currPage =1;
    _totalPages = 0;
    _segIndex = 0;
    _dic_request = [NSDictionary new];
    _muarr_id = [NSMutableArray array];
    _muarr_mileage = [NSMutableArray array];
    _muarr_sACityName = [NSMutableArray array];
    _muarr_sDCityName = [NSMutableArray array];
    _arr_BatchDidi = [NSMutableArray array];
    _model_route = [[RouteModel alloc]init];
}

-(void)createRightBtn{
    _left_btn = [GPUtils createButton:CGRectMake(0, 0, 60, 40) action:@selector(btn_click:) delegate:self title:Custing(@"批量导入", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    _left_btn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0,-10);
    UIBarButtonItem *right_btn = [[UIBarButtonItem alloc]initWithCustomView:_left_btn];
    [self.navigationItem setRightBarButtonItem:right_btn];
    _left_btn.hidden = NO;
}

-(void)createMainView{
    _view_SelectTime  = [[UIView alloc]init];
    [self.view addSubview:_view_SelectTime];
    [_view_SelectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(@44);
        make.top.equalTo(self.view_SelectTime.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    self.tableView.allowsMultipleSelection = YES;
    
    _view_bottomBtn = [[UIView alloc]init];
    _view_bottomBtn.backgroundColor=Color_White_Same_20;
    [self.view addSubview:_view_bottomBtn];
    [_view_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
}


-(void)createSegment
{
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type=@"1";
    _segementView.titleArray = @[Custing(@"已完成",nil),Custing(@"未完成", nil)];
    _segementView.titleColor=Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor=Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont=13.f;
    [self.view addSubview:_segementView];
}

//MARK:更新批量导入按钮
-(void)updateLoadView{
    [_view_bottomBtn updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    UIButton * importBtn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 49) action:@selector(importElectInvoice) delegate:self title:Custing(@"批量导入", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [importBtn setBackgroundColor:Color_Blue_Important_20];
    [_view_bottomBtn addSubview:importBtn];
}



//创建无数据视图
-(void)createNOdataView{
    
    NSString *tips;
    if (_segIndex==0) {
        tips = Custing(@"您还没有已完成行程哦", nil);
    }else if (_segIndex==1){
        tips= Custing(@"您还没有未完成行程哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

//下拉上拉
-(void)loadData
{
    [self requestDriveCarGetDriveCarList];
}

-(void)requestDriveCarGetDriveCarList {
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",DriveCarGetDriveCarList];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Status":[NSNumber numberWithInteger:_segIndex==0?1:0]} Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)requestDidiGetOrders{
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",DidiGetOrders];
    NSDictionary *dic = @{@"call_phone":_str_phone,@"start_date":_txf_state_date.text,@"end_date":_txf_end_date.text,@"Imported":[NSNumber numberWithInteger:_segIndex],@"pageindex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"pagesize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:2 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)requestDriveImportDriveCar:(RouteModel *)model {
    NSString *url=[NSString stringWithFormat:@"%@",DriveCarGetExpTypByDriveCar];
//    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"Id":model.Id} Delegate:self SerialNum:1 IfUserCache:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{} Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)dealWithData
{
    NSDictionary *result = _dic_request[@"result"];
    if (self.currPage <= _totalPages) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            RouteModel *model = [RouteModel modelWithDict:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            RouteModel *model = [RouteModel modelWithDict:dict];
            [self.resultArray addObject:model];
        }
    }
}

-(void)dealWithDataByDidi:(NSDictionary *)dic
{
    NSDictionary *result = dic[@"result"];
    if (self.currPage<=_totalPages) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            RouteDidiModel *model = [RouteDidiModel modelWithDict:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            RouteDidiModel *model = [RouteDidiModel modelWithDict:dict];
            [self.resultArray addObject:model];
        }
    }
}

#pragma mark - action
-(void)btn_click:(UIButton *)btn{
    _isEdit = _isEdit?NO:YES;
    [self.tableView reloadData];
    if (_isEdit) {
        [btn setTitle:Custing(@"取消", nil) forState:UIControlStateNormal];
        [_view_bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@49);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(@-49);
        }];
    }else{
        [btn setTitle:Custing(@"批量导入", nil) forState:UIControlStateNormal];
        [_view_bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(@0);
        }];
        _muarr_id = [NSMutableArray array];
        _muarr_mileage = [NSMutableArray array];
        _muarr_sACityName = [NSMutableArray array];
        _muarr_sDCityName = [NSMutableArray array];
        [_arr_BatchDidi removeAllObjects];
    }
}

-(void)importElectInvoice{
    if (_muarr_id.count>0 || _arr_BatchDidi.count > 0) {
        RouteImportViewController *route = [[RouteImportViewController alloc]init];
        route.Arr_Id = _muarr_id;
        route.Arr_Mileage = _muarr_mileage;
        route.Arr_sACityName = _muarr_sACityName;
        route.Arr_sDCityName = _muarr_sDCityName;
        [self.navigationController pushViewController:route animated:YES];
    }else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"至少选择一条导入", nil) duration:2.0];
    }
    
}

#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    _dic_request = responceDic;
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        if (serialNum == 1) {
            NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
            add.dateSource = @"13";
            add.model_route = _model_route;
            add.dic_route = [NSDictionary dictionary];
            [self.navigationController pushViewController:add animated:YES];
            return;
        }else{
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    }
    
    if (serialNum ==0 || serialNum == 2) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        self.totalPages = [[result objectForKey:@"totalPages"] integerValue];
    }
    switch (serialNum) {
        case 0:
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPages >= self.currPage) {
                [self dealWithData];
            }
            break;
        case 1:
        {
            NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
            add.dateSource = @"13";
            add.model_route = _model_route;
            add.dic_route = responceDic[@"result"];
            [self.navigationController pushViewController:add animated:YES];
            break;
        }
        case 2:
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPages >= self.currPage) {
                [self dealWithDataByDidi:responceDic];
            }
            break;
        case 3:
            self.currPage=1;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"导入成功", nil) duration:2.0];
            [self loadData];
            break;
        default:
            break;
    }
    if (serialNum == 0 || serialNum == 2) {
        [self createNOdataView];
        //修改下载的状态
        self.isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark  tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    RouteTableViewCell *cell = [[RouteTableViewCell alloc]initViewWithModel:self.resultArray[indexPath.row] isEdit:_isEdit];
    [cell setBtn_click:^(RouteModel *model){
        weakSelf.model_route = self.resultArray[indexPath.row];
        [weakSelf requestDriveImportDriveCar:weakSelf.model_route];
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    RouteModel *model=self.resultArray[indexPath.row];
    
    if (_isEdit) {
        if ([model.imported integerValue]==1) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"已导入不能再次导入", nil) duration:2.0];
            return;
        }
        BOOL isadd = YES;
        for (int i = 0; i<_muarr_id.count; i++) {
            NSInteger ids = [_muarr_id[i] integerValue];
            if (ids == [model.Id integerValue]) {
                isadd = NO;
            }
        }
        if (isadd) {
            [_muarr_id addObject:model.Id];
            [_muarr_mileage addObject:model.mileage];
            [_muarr_sDCityName addObject:model.departureName];
            [_muarr_sACityName addObject:model.arrivalName];
        }
    }else{
        if (_segIndex==1) {
            MapTrackController *vc=[[MapTrackController alloc]init];
            vc.model=model;
            vc.type=@"UnFinsh";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (_segIndex==0){
            MapRecordController *vc=[[MapRecordController alloc]init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isEdit) {
        RouteModel *model=self.resultArray[indexPath.row];
        for (int i = 0; i<_muarr_id.count; i++) {
            NSInteger ids = [_muarr_id[i] integerValue];
            if (ids == [model.Id integerValue]) {
                [_muarr_id removeObjectAtIndex:i];
                [_muarr_mileage removeObjectAtIndex:i];
                [_muarr_sDCityName removeObjectAtIndex:i];
                [_muarr_sACityName removeObjectAtIndex:i];
            }
        }
    }
}


#pragma mark - 3class

- (void)touchLabelWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            if (_segIndex==0) {
                return;
            }
            _isEdit = NO;
            _left_btn.hidden = NO;
            [_left_btn setTitle:Custing(@"批量导入", nil) forState:UIControlStateNormal];
            [_view_bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(@0);
            }];
            _segIndex=0;
            self.currPage=1;
            [self requestDriveCarGetDriveCarList];
            break;
        }
        case 1:
        {
            if (_segIndex==1) {
                return;
            }
            _isEdit = NO;
            _left_btn.hidden = YES;
            [_view_bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(@0);
            }];
            _muarr_id = [NSMutableArray array];
            _muarr_mileage = [NSMutableArray array];
            _muarr_sDCityName = [NSMutableArray array];
            _muarr_sACityName = [NSMutableArray array];
            _segIndex=1;
            self.currPage=1;
            [self requestDriveCarGetDriveCarList];
            break;
        }
        default:
            break;
    }
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
