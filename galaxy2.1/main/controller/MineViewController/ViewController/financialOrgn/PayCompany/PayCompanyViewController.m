//
//  PayCompanyViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/2/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayCompanyViewController.h"
#import "AddPayCompanyViewController.h"

@interface PayCompanyViewController ()<GPClientDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSString *returnStr;
@property (nonatomic, strong) NSString *recordcount;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) UIButton *addCVBtn;
@property (nonatomic, strong) NSDictionary *dic_request;
@property (nonatomic, strong) UISearchBar *sea_search;
@property (nonatomic, assign) NSInteger codeIsSystem;

@end

@implementation PayCompanyViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    self.currPage = 1;
    [self requestTravelTypeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"供应商", nil) backButton:YES ];
    [self createAddCostDock];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(@49);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    self.currPage =1;
    _dic_request = [NSDictionary new];
    [self createSearchBarHeader];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
}

#pragma mark - function
-(void)createAddCostDock{
    self.addCVBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 49 - NavigationbarHeight, ScreenRect.size.width, 49) action:@selector(addCostCenterData) delegate:self title:Custing(@"添加", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    self.addCVBtn.backgroundColor =Color_Blue_Important_20;
    [self.view addSubview:self.addCVBtn];
}

//添加搜索框
-(void)createSearchBarHeader{
    _sea_search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    _sea_search.placeholder = Custing(@"搜索", nil);
    _sea_search.delegate = self;
    _sea_search.keyboardType = UIKeyboardTypeDefault;
    _sea_search.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_sea_search];
}

-(void)requestTravelTypeData {
    self.isLoading = YES;
    NSString *url;
    if (_isUser>0) {
        url=[NSString stringWithFormat:@"%@",BeneficiaryBeneficiaryListByUserId];
    }else{
        url=[NSString stringWithFormat:@"%@",BeneficiaryList_B];
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"Name":_sea_search.text,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20} Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([NSString isEqualToNull:_sea_search.text]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else{
        tips=Custing(@"您还没有添加供应商哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}


-(void)dealWithData
{
    NSDictionary *result = _dic_request[@"result"];
    _totalPages = [result[@"totalPages"] integerValue];
    _codeIsSystem = [result[@"suppCodeIsSystem"]integerValue];
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
}

//下拉上拉
-(void)loadData
{
    [self requestTravelTypeData];
}

#pragma mark - action
-(void)addCostCenterData{
    AddPayCompanyViewController *add = [AddPayCompanyViewController new];
    add.codeIsSystem = self.codeIsSystem;
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    _dic_request = responceDic;
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        //修改下载的状态
        self.isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    if (serialNum ==0) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        self.recordcount = [NSString stringWithFormat:@"%@",[result objectForKey:@"recordcount"]];
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
            [self requestTravelTypeData];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
            break;
        default:
            break;
    }
    
    [self createNOdataView];

    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];

    
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
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
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=Color_White_Same_20;
    view.frame=CGRectMake(0, 0, Main_Screen_Width, 10);
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
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
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UILabel *lab = [GPUtils createLable:CGRectMake(20, 0, Main_Screen_Width-65, 48) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    NSDictionary *dic = self.resultArray[indexPath.row];
    lab.text =[GPUtils getSelectResultWithArray:@[dic[@"code"],dic[@"name"]]];
    [cell addSubview:lab];
    
    if (indexPath.row!=self.resultArray.count-1) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 48.5, Main_Screen_Width-12, 0.5)];
        image.backgroundColor = Color_GrayLight_Same_20;
        [cell addSubview:image];
    }
    
    return cell;
}
//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSDictionary *dic = self.resultArray[indexPath.row];
    AddPayCompanyViewController *add = [AddPayCompanyViewController new];
    add.codeIsSystem = self.codeIsSystem;
    add.SupDict = dic;
    [self.navigationController pushViewController:add animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //        NSLog(@"点击了删除");
        NSDictionary *dic = self.resultArray[indexPath.row];
        NSString *url=[NSString stringWithFormat:@"%@",DeleteBeneficiary_B];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"Id":dic[@"id"]} Delegate:self SerialNum:1 IfUserCache:NO];
        
    }];
    return @[deleteAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.currPage = 1;
        [self requestTravelTypeData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.currPage=1;
    [self requestTravelTypeData];
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
