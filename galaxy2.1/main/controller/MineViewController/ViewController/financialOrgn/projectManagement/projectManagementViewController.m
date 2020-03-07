//
//  projectManagementViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define pageNum  (Main_Screen_Height-NavigationbarHeight-49)/49
#import "ZFProjectMangViewController.h"
#import "infoViewController.h"

#import "projectManagerModel.h"
#import "projectManagementVCell.h"
#import "projectManagementViewController.h"
#import "InstructionsViewController.h"
@interface projectManagementViewController ()<GPClientDelegate,UISearchBarDelegate>
@property (nonatomic,strong)NSString * returnStr;
@property (nonatomic,strong)NSString * recordcount;
@property (assign, nonatomic)NSInteger totalPages;
@property (nonatomic,strong)UIButton * addCVBtn;

@property(nonatomic,strong)UISearchBar * searchbar;
@property(nonatomic,strong)NSString *searchAim;

@property (nonatomic, assign) NSInteger codeIsSystem;

@end

@implementation projectManagementViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([self.returnStr isEqualToString:@"bouu"]) {
        self.currPage = 1;
        self.searchbar.text = @"";
        [self.searchbar resignFirstResponder];
        [self requestProjectManagementListData:self.currPage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"项目", nil) backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];
    [self createAddProjectDock];
    [self createSearchBarHeader];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(49);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        
    }];
    self.currPage =1;
    [self requestProjectManagementListData:self.currPage];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        // Do any additional setup after loading the view.
}

-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"ProjectManagement"];
    [self.navigationController pushViewController:INFO animated:YES];
}

//添加搜索框
-(void)createSearchBarHeader{
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
//    [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
//    self.searchbar.backgroundColor = [UIColor clearColor];
//    判断iOS的版本是否大于13.0
    if (@available(iOS 13.0, *)) {
        UIView *backGroundView = [[[self.searchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
        backGroundView.alpha = 0;
        self.searchbar.searchTextField.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.searchbar.searchTextField.textColor = Color_Unsel_TitleColor;
        self.searchbar.searchTextField.placeholder = Custing(@"搜索编号/名称/类型", nil);
        UIImage *searchIcon = [UIImage imageNamed:@"searchIcon"];
        [self.searchbar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
    } else {
        // Fallback on earlier versions
        [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
        self.searchbar.placeholder = Custing(@"搜索编号/名称/类型", nil);
    }

//    self.searchbar.placeholder = Custing(@"搜索编号/名称/类型", nil);
    self.searchbar.delegate = self;
    _searchAim=@"";
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    self.currPage=1;
    [self requestProjectManagementListData:self.currPage];
}

//搜索代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if ([searchText isEqualToString:@""]) {
        _searchAim=@"";
        self.currPage=1;
        [self requestProjectManagementListData:self.currPage];
    }
}


//添加项目
-(void)createAddProjectDock{
    
    self.addCVBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 49 - NavigationbarHeight, ScreenRect.size.width, 49) action:@selector(createAddCurrencyData:) delegate:self title:Custing(@"添加", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    self.addCVBtn.backgroundColor =Color_Blue_Important_20;
    [self.view addSubview:self.addCVBtn];
    
}
-(void)createAddCurrencyData:(UIButton *)btn{
    self.returnStr = @"bouu";
    ZFProjectMangViewController * reimburs = [[ZFProjectMangViewController alloc]init];
    reimburs.codeIsSystem = self.codeIsSystem;
    [self.navigationController pushViewController:reimburs animated:YES];
}

-(void)loadData{
    [self requestProjectManagementListData:self.currPage];
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
    
    projectManagementVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"projectManagementVCell"];
    if (cell==nil) {
        cell=[[projectManagementVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"projectManagementVCell"];
    }
    projectManagerModel *cellInfo = self.resultArray[indexPath.row];
    [cell configProjectManagementCellInfo:cellInfo];
    
    if (indexPath.row == self.resultArray.count-1) {
        cell.line.hidden = YES;
    }
    return cell;
}
//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.searchbar resignFirstResponder];
    [self.view endEditing:YES];
    self.returnStr = @"bouu";
    projectManagerModel *cellInfo = self.resultArray[indexPath.row];
   
    ZFProjectMangViewController * project = [[ZFProjectMangViewController alloc]init];
    project.codeIsSystem = self.codeIsSystem;
    project.model = cellInfo;
    [self.navigationController pushViewController:project animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        projectManagerModel *data= self.resultArray[indexPath.row];
        [self deleteProjectManagementList:data];
        
    }
}

//请求项目管理列表
-(void)requestProjectManagementListData:(NSInteger)page{
 
    self.isLoading = YES;
    NSString *url;
    NSDictionary * dic;
    if (_isUser > 0) {
        url = [NSString stringWithFormat:@"%@",getProjsBYUSEID];
        dic =@{@"Requestor":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"ProjName",@"IsAsc":@"",@"ProjName":_searchAim};

    }else{
        url = [NSString stringWithFormat:@"%@",getProjs];
        dic =@{@"Requestor":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"ProjName",@"IsAsc":@"",@"ProjName":_searchAim,@"RequestSource":@"maintain"};
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

//删除项目管理列表
-(void)deleteProjectManagementList:(projectManagerModel *)data{
    NSDictionary *parameters = @{@"id":data.idd};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",deleteproj] Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
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
            _codeIsSystem = [responceDic[@"result"][@"procCodeIsSyStem"] integerValue];
            if (self.totalPages >= self.currPage) {
                [projectManagerModel GetProjectManagerDictionary:responceDic Array:self.resultArray];
            }
            
            break;
        case 1:
            [self requestProjectManagementListData:self.currPage];
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

//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([NSString isEqualToNull:_searchAim]) {
        tips=Custing(@"您还没有相关记录哦", nil);
    }else{
        tips=Custing(@"您还没有添加项目哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
