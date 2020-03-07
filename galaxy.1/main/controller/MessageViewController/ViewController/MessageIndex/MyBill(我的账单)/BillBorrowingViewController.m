//
//  BillBorrowingViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/17.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BillBorrowingViewController.h"
#import "BillBorrowingTableViewCell.h"

@interface BillBorrowingViewController ()<GPClientDelegate>

@property (nonatomic, strong) NSDictionary *resultDict;

@property (assign, nonatomic)NSInteger totalPage;//系统分页数

@end

@implementation BillBorrowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"我的借款", nil)  backButton:YES];
    [self initContentView];
    [self requestGetmyloanhist];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - function
//初始化页面
-(void)initContentView
{
    self.currPage = 1;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@74);
    }];
    self.tableView.backgroundColor = Color_White_Same_20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lab_needMoney.text = Custing(@"需还款金额", nil);
}

-(void)requestGetmyloanhist
{
    self.isLoading = YES;
    NSDictionary *dic = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",15],@"OrderBy":@"operatorDate",@"IsAsc":@"desc"};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",analyDetailGetmyloanhist] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _lab_cound.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",result[@"totalAmount"]]]];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *arr = result[@"items"];
        for (int i = 0; i<arr.count ; i++) {
            [self.resultArray addObject:arr[i]];
        }
    }
}

//下拉上拉
-(void)loadData
{
    [self requestGetmyloanhist];
}

#pragma mark - 代理
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        [YXSpritesLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    //下拉刷新
    if (self.currPage == 1 ) {
        [self.resultArray removeAllObjects];
    }
    if (serialNum == 0) {
        [YXSpritesLoadingView dismiss];
        _resultDict = responceDic;
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

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillBorrowingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BillBorrowingTableViewCell"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BillBorrowingTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    cell.dic = self.resultArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
