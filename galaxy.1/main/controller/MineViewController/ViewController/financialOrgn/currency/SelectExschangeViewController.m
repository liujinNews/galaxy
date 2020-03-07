//
//  SelectExschangeViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/2/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "SelectExschangeViewController.h"

@interface SelectExschangeViewController ()<GPClientDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) NSDictionary *dic_request;

@property (assign, nonatomic) NSInteger totalPage;//系统分页数
@property (nonatomic, strong) NSString *requestType;//区分viewwillapper是否请求数据


@end

@implementation SelectExschangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"选择币种", nil) backButton:YES];
    
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(@44);
    }];
    
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    _search.searchBarStyle = UISearchBarStyleProminent;
    [_search setBackgroundImage:[UIImage new]];
    _search.barTintColor = Color_White_Same_20;
    [_search searchFieldBackgroundImageForState:UIControlStateNormal];
    _search.backgroundColor = Color_White_Same_20;
    _search.delegate = self;
    [self.view addSubview:_search];
    
    _dic_request = [NSDictionary dictionary];
    _requestType=@"1";
    
//    [self requestGetBeneficiary];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self requestGetBeneficiary];
    }
    _requestType=@"0";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - action

#pragma mark - funtion
-(void)requestGetBeneficiary{
    NSString *url=[NSString stringWithFormat:@"%@",GetCurrencyList];
    self.isLoading = YES;
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Currency":_search.text} Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)dealWithData
{
    NSDictionary *result = _dic_request[@"result"];
    _totalPage = [result[@"totalPages"] integerValue];
    
    if (self.currPage<=_totalPage) {
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
}

//下拉上拉
-(void)loadData
{
    [self requestGetBeneficiary];
}

//创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有币种哦",nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];

}


#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        //修改下载的状态
        self.isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    if (serialNum == 1) {
        _dic_request = responceDic;
        [self dealWithData];
        [self createNOdataView];

        //修改下载的状态
        self.isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }
    if (serialNum == 2) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.0];
        self.currPage = 1;
        [self.resultArray removeAllObjects];
        [self.tableView reloadData];
        [self requestGetBeneficiary];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
    selectImage.center = CGPointMake(25, 22.5);
    selectImage.image = [UIImage imageNamed:@"MyApprove_UnSelect"];
    selectImage.highlightedImage = [UIImage imageNamed:@"MyApprove_Select"];
    [cell addSubview:selectImage];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 45) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    NSDictionary *dic = self.resultArray[indexPath.row];
    lab.text = [NSString stringWithFormat:@"%@/%@",dic[@"currencyCode"],dic[@"currency"]];
    
    [cell addSubview:lab];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, Main_Screen_Width, 0.5)];
    image.backgroundColor = Color_White_Same_20;
    [cell addSubview:image];
    if ([dic[@"currencyCode"] isEqualToString:_ids]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate SelectExschangeViewControllerCellClick:self.resultArray[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self keyClose];
    [self requestGetBeneficiary];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@", searchText);
    [self requestGetBeneficiary];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        
    }
    return YES;
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
