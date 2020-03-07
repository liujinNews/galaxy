//
//  PayeesChooseViewController.m
//  galaxy
//
//  Created by hfk on 2018/8/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PayeesChooseViewController.h"
#import "PayeesChooseCell.h"
#import "XFSegementView.h"
#import "PayeesEditViewController.h"
#import "PayeesManagerViewController.h"

@interface PayeesChooseViewController ()<UISearchBarDelegate,GPClientDelegate,TouchLabelDelegate>

@property (nonatomic, strong)NSDictionary *resultDict;//下载成功字典
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) UISearchBar * searchbar;
@property (nonatomic, copy) NSString *searchAim;
@property (nonatomic,strong) PayeesChooseCell *cell;
@property(nonatomic,strong)UIButton *rightItemBtn;
@property(nonatomic,assign)NSInteger segIndex;//分段器当前选择
@property (nonatomic, strong) XFSegementView *segementView;

/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL requestType;

@property (nonatomic, strong) DoneBtnView *dockView;

@end

@implementation PayeesChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"选择收款人", nil) backButton:YES];
    _requestType=NO;
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_requestType) {
        self.currPage=1;
        [self loadData];
    }
    _requestType = YES;
}

-(void)createUI{
    _rightItemBtn = [[UIButton alloc]init];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:_rightItemBtn title:Custing(@"管理", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(ManageClick:)];
    _rightItemBtn.hidden = YES;
    
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type=@"1";
    _segementView.titleArray = @[Custing(@"内部收款人", nil),Custing(@"外部收款人",nil)];
    _segementView.titleColor=Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor=Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont=13.f;
    [self.view addSubview:_segementView];
    
    _searchAim=@"";
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, Main_Screen_Width, 49)];
//    判断iOS的版本是否大于13.0
    if (@available(iOS 13.0, *)) {
        UIView *backGroundView = [[[self.searchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
        backGroundView.alpha = 0;
        self.searchbar.searchTextField.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.searchbar.searchTextField.textColor = Color_Unsel_TitleColor;
        self.searchbar.searchTextField.placeholder = Custing(@"搜索收款人", nil);
        UIImage *searchIcon = [UIImage imageNamed:@"searchIcon"];
        
        [self.searchbar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
        [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
        self.searchbar.placeholder = Custing(@"搜索收款人", nil);
    }
    
    self.searchbar.delegate = self;
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.equalTo(@0);
    }];
    __weak typeof(self) weakSelf = self;
    [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"新增收款人", nil)]];
    self.dockView.btnClickBlock = ^(NSInteger index) {
        PayeesEditViewController * vc = [[PayeesEditViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self updateTableView];
}

-(void)updateTableView{
    if (self.segIndex == 0) {
        [self.tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(@93);
            make.bottom.equalTo(self.view);
        }];
        
        [self.dockView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        self.dockView.hidden = YES;
        
    }else if (self.segIndex ==1){
        [self.tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(@93);
            make.bottom.equalTo(self.view).offset(@-50);
        }];
        [self.dockView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        self.dockView.hidden = NO;
    }
}

- (void)touchLabelWithIndex:(NSInteger)index{
    NSLog(@"我是第%ld个label",(long)index);
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            _rightItemBtn.hidden = YES;
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            _rightItemBtn.hidden = NO;
            break;
        default:
            break;
    }
    self.currPage=1;
    [self updateTableView];
    [self loadData];
}

-(void)ManageClick:(id)obj{
    PayeesManagerViewController * vc = [[PayeesManagerViewController alloc]init];
    vc.isUser = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

//收款人列表
-(void)requestPayeeBank{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETALLPAYEE];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Name":_searchAim,@"Type":[NSString stringWithFormat:@"%ld",(long)_segIndex]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    //下拉刷新
    if (self.currPage == 1) {
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
    if (self.totalPages >= self.currPage) {
        [ChooseCateFreModel GetAllPayeesListDictionary:_resultDict Array:self.resultArray];
    }
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
        return 0.5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width,0.01)];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        view.backgroundColor =Color_form_TextFieldBackgroundColor;
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(50, 0, Main_Screen_Width-50, 0.5)];
        lineview.backgroundColor =Color_GrayLight_Same_20;
        [view addSubview:lineview];
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"PayeesChooseCell"];
    if (_cell==nil) {
        _cell=[[PayeesChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayeesChooseCell"];
    }
    
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    [_cell configPayeesChoosesWithModel:model];
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    if (self.PayeesChooseBlock) {
        self.PayeesChooseBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData{
    [self requestPayeeBank];
}
#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        _searchAim=@"";
        self.currPage=1;
        [self loadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    self.currPage=1;
    [self loadData];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有收款人哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
