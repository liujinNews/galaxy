//
//  StdBranchListController.m
//  galaxy
//
//  Created by hfk on 2019/4/23.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "StdBranchListController.h"
#import "InstructionsViewController.h"
#import "CostClassesCell.h"
#import "ReiStandardViewController.h"

@interface StdBranchListController ()<GPClientDelegate>

@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(nonatomic,strong)NSString *requestType;//请求类型
@property(nonatomic,strong)CostClassesCell *cell;


@end

@implementation StdBranchListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"报销标准", nil) backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];
    _requestType=@"0";
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"ForStand"];
    [self.navigationController pushViewController:INFO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([_requestType isEqualToString:@"1"]) {
        self.currPage = 1;
        [self requsetBranch];
    }
    _requestType=@"1";
}
//MARK:费用类别
-(void)requsetBranch{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url = [NSString stringWithFormat:@"%@",GETBRANCHLIST];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        if (![[responceDic objectForKey:@"msg"]isKindOfClass:[NSNull class]]) {
            NSString * error =[responceDic objectForKey:@"msg"];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
            [self dealWithData];
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

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:数据处理
-(void)dealWithData{
    NSDictionary *result = _resultDict[@"result"];
    _totalPage = [result[@"totalPages"] integerValue] ;
    if (self.currPage <= _totalPage) {
        NSArray *array = result[@"items"];
        for (NSDictionary *dict in array) {
            [self.resultArray addObject:dict];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            [self.resultArray addObject:dict];
        }
    }
    [self createNOdataView];
}
-(void)loadData{
    [self requsetBranch];
}
//MARK: UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width,0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"CostClassesCell"];
    if (_cell == nil) {
        _cell = [[CostClassesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CostClassesCell"];
    }
    NSDictionary *dict = self.resultArray[indexPath.row];
    [_cell configBranchViewWithDict:dict hideLine:indexPath.row == self.resultArray.count-1];
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReiStandardViewController *vc = [[ReiStandardViewController alloc]init];
    vc.dict = self.resultArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有设置分公司哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
