//
//  ByCarOrderController.m
//  galaxy
//
//  Created by APPLE on 2019/12/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "ByCarOrderController.h"
#import "TravelCarDetail.h"
#import "TravelCarDetailCell.h"
//#import "DiDiOrderController.h"
#import "TravelOneController.h"
@interface ByCarOrderController ()

@end

@implementation ByCarOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"用车需求单", nil) backButton:YES ];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _requestType = NO;
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [self requestData];
    }
    _requestType = YES;
}
//MARK:添加网络数据
-(void)requestData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url = [NSString stringWithFormat:@"%@",DIDICARORDER];
    NSDictionary *parameters = @{@"VehicleDate":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@"20"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    _resultDict = responceDic;
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
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
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
        default:
            break;
    }
}
//MARK:数据处理
-(void)dealWithData
{
    NSDictionary *result = _resultDict[@"result"];
    _totalPage = [result[@"totalPages"] integerValue] ;
    if (self.currPage <= _totalPage) {
        NSArray *array = result[@"items"];
        for (NSDictionary *dict in array) {
            TravelCarDetail *model = [[TravelCarDetail alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array = nil;
        for (NSDictionary *dict in array) {
            TravelCarDetail *model = [[TravelCarDetail alloc]init];
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
    self.isLoading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)loadData{
    [self requestData];
}
//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelCarDetail * model = (TravelCarDetail *)self.resultArray[indexPath.section];
    return [TravelCarDetailCell cellHeightWithModel:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCarDetailCell"];
    if (cell == nil) {
        cell = [[TravelCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelCarDetailCell"];
    }
    TravelCarDetail * model = (TravelCarDetail *)self.resultArray[indexPath.section];
    [cell configCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelCarDetail * model = (TravelCarDetail *)self.resultArray[indexPath.section];
    TravelOneController *vc = [[TravelOneController alloc]init];
    vc.model = model;
    vc.type = @"20";
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有行程单哦", nil) hasData:(self.resultArray.count != 0) hasError:NO reloadButtonBlock:nil];
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
