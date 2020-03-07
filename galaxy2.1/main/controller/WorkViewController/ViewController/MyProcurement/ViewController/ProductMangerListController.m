//
//  ProductMangerListController.m
//  galaxy
//
//  Created by hfk on 2018/6/28.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ProductMangerListController.h"
#import "ProductEditController.h"

@interface ProductMangerListController ()<GPClientDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSDictionary *resultDict;//下载成功字典
@property (nonatomic, assign) NSInteger totalPage;//系统分页数
@property (nonatomic, assign) BOOL requestType;
@property (nonatomic, strong)DoneBtnView * dockView;
@property (nonatomic, strong) NSString *searchAim;
@property (nonatomic, strong) UISearchBar * searchbar;


@end

@implementation ProductMangerListController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"管理产品", nil) backButton:YES ];
    [self createViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType) {
        _currPage=1;
        [self loadData];
    }
    _requestType=YES;
}

-(void)createViews{
    _searchAim=@"";
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    self.searchbar.delegate = self;
    self.searchbar.placeholder=[NSString stringWithFormat:@"%@%@",Custing(@"搜索", nil),Custing(@"产品", nil)];
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
    
    [_tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-50);
    }];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavBarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"新增产品", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        ProductEditController * vc = [[ProductEditController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

-(void)requestPurchaseItem{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETPURCHASEITEMS];
    NSDictionary * dic =@{@"Type":self.isUser > 0 ? @"1":@"2" ,@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)_currPage],@"PageSize":@20,@"OrderBy":@"",@"IsAsc":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    
    [YXSpritesLoadingView dismiss];
    _resultDict = responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    //下拉刷新
    if (_currPage == 1 && _isLoading == YES) {
        [_resultArray removeAllObjects];
    }

    switch (serialNum) {
        case 0:
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            _isLoading = NO;
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
            break;
        case 1:
        {
            if ([NSString isEqualToNull:_resultDict[@"result"]]&&[_resultDict[@"result"] floatValue]>0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
                _currPage = 1;
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
    [_resultArray removeAllObjects];
    _isLoading=NO;
    [_tableView reloadData];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}
-(void)dealWithData{
    
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue];
    if (_totalPage>=_currPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            [_resultArray addObject:dict];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            [_resultArray addObject:dict];
        }
    }
}

-(void)loadData{
    [self requestPurchaseItem];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        view.backgroundColor =[UIColor whiteColor];
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
        lineview.backgroundColor =Color_GrayLight_Same_20;
        [view addSubview:lineview];
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-40, 49) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    NSDictionary *dic = _resultArray[indexPath.section];
    lab.text =[GPUtils getSelectResultWithArray:@[dic[@"code"],dic[@"name"]]];;
    [cell addSubview:lab];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    NSDictionary *dic = _resultArray[indexPath.section];
    ProductEditController *edit = [[ProductEditController alloc]init];
    edit.dict_Edit=dic;
    [self.navigationController pushViewController:edit animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _resultArray[indexPath.section];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSString *url=[NSString stringWithFormat:@"%@",DELLETEPURCHASE];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"Id":[NSString isEqualToNull:dic[@"id"]]?dic[@"id"]:@"0"} Delegate:self SerialNum:1 IfUserCache:NO];
    }];
    return @[deleteRowAction];
}

#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        _searchAim=@"";
        _currPage=1;
        [self loadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    _currPage=1;
    [self loadData];
}

//创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([NSString isEqualToNull:_searchAim]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else{
        tips=Custing(@"您还没有产品哦", nil);
    }
    [_tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(_resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
