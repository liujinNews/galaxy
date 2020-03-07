//
//  ClientViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/4/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ClientViewController.h"
#import "AddClientViewController.h"

@interface ClientViewController ()<GPClientDelegate,UISearchBarDelegate>
@property (assign, nonatomic)NSInteger totalPages;
@property (nonatomic,strong)UIButton * addCVBtn;

@property(nonatomic,strong)UISearchBar * searchbar;
@property (nonatomic, assign) NSInteger codeIsSystem;

@end

@implementation ClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"客户", nil) backButton:YES];
    
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(49);
        make.bottom.equalTo(self.view.bottom).offset(-49);
        
    }];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [self createAddProjectDock];
    [self createSearchBarHeader];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    self.currPage = 1;
    [self requestGetClientList:self.currPage];
}

#pragma mark - function
-(void)createAddProjectDock{
    self.addCVBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 49 - NavigationbarHeight, ScreenRect.size.width, 49) action:@selector(createAddCurrencyData:) delegate:self title:Custing(@"添加", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    self.addCVBtn.backgroundColor =Color_Blue_Important_20;
    [self.view addSubview:self.addCVBtn];
}

//添加搜索框
-(void)createSearchBarHeader{
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    self.searchbar.placeholder = Custing(@"搜索", nil);
    self.searchbar.delegate = self;
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
}

-(void)loadData{
    [self requestGetClientList:self.currPage];
}

////MARK:创建无数据视图
-(void)createNOdataView{
    
    NSString *tips;
    if ([NSString isEqualToNull:_searchbar.text]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else{
        tips=Custing(@"您还没有添加客户哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];

}


-(void)requestGetClientList:(NSInteger)page{
    self.isLoading = YES;
    NSDictionary * dic =@{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",15],@"Name":_searchbar.text};
    NSString *url;
    if (_isUser>0) {
        url=[NSString stringWithFormat:@"%@",clientGetClientListByUserId];
    }else{
        url=[NSString stringWithFormat:@"%@",GetClientList];
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];

    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)requestDeleteClient:(NSString *)ids{
    NSDictionary * dic =@{@"Id":ids};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",DeleteClient] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

#pragma mark - action
-(void)createAddCurrencyData:(UIButton *)btn{
    AddClientViewController *add= [[AddClientViewController alloc]init];
    add.codeIsSystem = self.codeIsSystem;
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            NSDictionary *result = [responceDic objectForKey:@"result"];
            _totalPages = [[result objectForKey:@"totalPages"] integerValue];
            _codeIsSystem = [result[@"clientCodeIsSystem"]integerValue];
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPages >= self.currPage) {
                if (self.userdatas.userId) {
                    NSArray *arr = responceDic[@"result"][@"items"];
                    if (arr.count>0) {
                        [self.resultArray addObjectsFromArray:arr];
                    }
                }
            }
        }
            break;
        case 1:
            [self requestGetClientList:self.currPage];
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
        return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.resultArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.textColor = Color_Black_Important_20;
    cell.textLabel.text =[GPUtils getSelectResultWithArray:@[dic[@"code"],dic[@"name"]]];
    cell.textLabel.font = Font_Same_14_20;
    
    if (indexPath.row!=self.resultArray.count-1) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 48.5, Main_Screen_Width-15, 0.5)];
        image.backgroundColor = Color_GrayLight_Same_20;
        [cell addSubview:image];
    }
    
    return cell;
}
//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    AddClientViewController *add = [[AddClientViewController alloc]init];
    add.codeIsSystem = self.codeIsSystem;
    NSDictionary *dic = self.resultArray[indexPath.row];
    add.ClickId = dic[@"id"];
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = self.resultArray[indexPath.row];
        [self requestDeleteClient:dic[@"id"]];
    }
}
#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.currPage = 1;
        [self requestGetClientList:1];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.currPage=1;
    [self requestGetClientList:1];
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
