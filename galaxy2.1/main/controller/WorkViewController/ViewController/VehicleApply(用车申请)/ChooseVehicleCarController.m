//
//  ChooseVehicleCarController.m
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ChooseVehicleCarController.h"
#import "ChooseVehicleCarCell.h"
#import "AddAndEditCarController.h"
#import "CarFilterViewController.h"

@interface ChooseVehicleCarController ()

@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property (nonatomic, strong) DoneBtnView *dockView;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL requestType;
@property (nonatomic, strong) NSString *str_CarModel;
@property (nonatomic, strong) NSString *str_Seats;
@property (nonatomic, assign) NSInteger paramValue;


@end

@implementation ChooseVehicleCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _requestType=NO;
    [self setTitle:Custing(@"选择车辆", nil) backButton:YES];
    _str_CarModel = @"";
    _str_Seats = @"";
    _paramValue = 0;
    [self updateTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_requestType) {
        [self loadData];
    }
    _requestType=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _str_Seats =@"";
    _str_CarModel=@"";
}
-(void)updateTable{
    [self.tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
-(void)createDockView{
    __weak typeof(self) weakSelf = self;
    NSInteger height = 0;
    if (_bool_HasManager) {
        if (_paramValue == 1) {
            UIBarButtonItem *rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(filter:)];
            UIBarButtonItem *rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"管理", nil) titleColor:Color_Blue_Important_20 titleIndex:0 imageName:nil target:self action:@selector(manager:)];
            self.navigationItem.rightBarButtonItems = @[rightBtn1,rightBtn2];
            height = 50;
        }else{
            UIBarButtonItem *rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(filter:)];
            self.navigationItem.rightBarButtonItems = @[rightBtn1];
        }
    }else{
        height = 50;
    }
    
    if (height > 0) {
        [self.tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-50);
        }];
        self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
        self.dockView.userInteractionEnabled=YES;
        [self.view addSubview:self.dockView];
        [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.height.equalTo(@50);
        }];
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"新增车辆", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                AddAndEditCarController *vc = [[AddAndEditCarController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
    }
}


-(void)requestCarList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary * dic =@{@"PageIndex":[NSString stringWithFormat:@"%ld",self.currPage],@"PageSize":@"20",@"Type":_bool_HasManager ? @"0":@"2",@"CarModel":_str_CarModel,@"Seats":_str_Seats,@"TaskId":[NSString stringWithIdOnNO:self.str_taskId]};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetVehicleRecords] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            if ([NSString isEqualToNull:responceDic[@"result"]]&&[responceDic[@"result"]floatValue]>0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
                self.currPage =1;
                [self loadData];
            }
        }
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView reloadData];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}
-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _totalPages=[result[@"totalPages"] integerValue];
    _paramValue = [result[@"paramValue"] integerValue];
    if (self.currPage<=_totalPages) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            [self.resultArray addObject:dict];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            [self.resultArray addObject:dict];
        }
    }
    [self createDockView];
}
//MARK:tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        view.backgroundColor =Color_White_Same_20;
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.resultArray[indexPath.section];
    return [ChooseVehicleCarCell cellHeightWithObj:dict];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseVehicleCarCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseVehicleCarCell"];
    if (cell==nil) {
        cell=[[ChooseVehicleCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseVehicleCarCell"];
    }
    NSDictionary *dict = self.resultArray[indexPath.section];
    cell.dict_carInfo = dict;
    return cell;
    return [UITableViewCell new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.resultArray[indexPath.section];
    if (_bool_HasManager) {
        if (self.chooseCarBlock) {
            self.chooseCarBlock(dict);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        AddAndEditCarController *vc = [[AddAndEditCarController alloc]init];
        vc.dict_Info = dict;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return !_bool_HasManager;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dict = self.resultArray[indexPath.row];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        self.isLoading = YES;
        NSDictionary * dic =@{@"id":[NSString stringWithIdOnNO:dict[@"id"]]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",DeleteVehicleInfo] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }
}

-(void)loadData{
    [self requestCarList];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有车辆哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

-(void)manager:(id)sender{
    ChooseVehicleCarController *vc =[[ChooseVehicleCarController alloc]init];
    vc.bool_HasManager = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)filter:(id)sender{
    CarFilterViewController *vc = [[CarFilterViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.filterCarBlock = ^(NSDictionary *dict) {
        weakSelf.str_CarModel = dict[@"model"];
        weakSelf.str_Seats = dict[@"seats"];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
