//
//  AccruedDetailViewController.m
//  galaxy
//
//  Created by APPLE on 2020/1/2.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "AccruedDetailViewController.h"

@interface AccruedDetailViewController ()

@property (nonatomic, strong) NSMutableArray *ChoosedIdArray;
@property (nonatomic, strong) NSMutableArray *ChoosedNameArray;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) UISearchBar * searchbar;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) AccruedTableViewCell *cell;
@property (nonatomic, strong)NSDictionary *resultDict;//下载成功字典
@property (nonatomic, strong)NSString *searchAim;
@property (nonatomic, assign)NSInteger offsetHight;
@property (nonatomic, strong)UIImageView *selectedImg;
@property (nonatomic, assign) NSInteger paramValue;
@property (nonatomic, assign) NSInteger codeIsSystem;//编号是否由系统生成(0系统 1自己输入)
@property (nonatomic, strong) DoneBtnView *dockView;
@property (nonatomic, copy) NSString *str_SearchTips;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL requestType;
/**
 采购选择的模板model
 */
@property (nonatomic, copy) ChooseCateFreModel *model_ItemTpl;


@end
@implementation AccruedDetailViewController

-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _offsetHight=0;
    _paramValue = 0;
    _codeIsSystem = 0;
    _requestType=NO;
    _ChoosedIdArray=[NSMutableArray arrayWithArray:[NSString isEqualToNullAndZero:_ChooseCategoryId]?[[NSString stringWithFormat:@"%@",_ChooseCategoryId] componentsSeparatedByString:@","]:@[]];
    
    if (_isMultiSelect) {
        _ChoosedNameArray=[NSMutableArray array];
    }else{
        _ChoosedNameArray=[NSMutableArray arrayWithArray:[NSString isEqualToNullAndZero:_ChooseCategoryName]?@[_ChooseCategoryName]:@[]];
    }
    if ([_type isEqualToString:@"accrued"]){
        [self setTitle:Custing(@"关联预提明细", nil) backButton:YES ];
        [self createSeachBar];
        self.str_SearchTips=Custing(@"预提明细", nil);
    }
    if (self.searchbar&&[NSString isEqualToNull:self.str_SearchTips]) {
        self.searchbar.placeholder =[self.userdatas.language isEqualToString:@"ch"]?[NSString stringWithFormat:@"%@%@",Custing(@"搜索", nil),self.str_SearchTips]:[NSString stringWithFormat:@"%@ %@",Custing(@"搜索", nil),self.str_SearchTips];
    }
    [self updateTable];
    
    if (_isMultiSelect) {
        [self createNavMutilSelectSure];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_requestType) {
        [self loadData];
    }
    _requestType=YES;
}
- (NSMutableArray *)chooseCateArr{
    if (!_chooseCategoryArr) {
        _chooseCategoryArr = [NSMutableArray arrayWithCapacity:42];
    }
    return _chooseCategoryArr;
}

//MARK:创建多选确定按钮
-(void)createNavMutilSelectSure{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(sureSelect:)];
}

-(void)createSeachBar{
    _searchAim=@"";
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
//    [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    //    判断iOS的版本是否大于13.0
    if (@available(iOS 13.0, *)) {
        UIView *backGroundView = [[[self.searchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
        backGroundView.alpha = 0;
        self.searchbar.searchTextField.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.searchbar.searchTextField.textColor = Color_Unsel_TitleColor;
        UIImage *searchIcon = [UIImage imageNamed:@"searchIcon"];
        
        [self.searchbar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
        [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    }
    self.searchbar.delegate = self;
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
    _offsetHight=_offsetHight+49;
}

-(void)createManageView{
    __weak typeof(self) weakSelf = self;
    if ([_type isEqualToString:@"Supplier"]||[_type isEqualToString:@"Client"]||[_type isEqualToString:@"projectName"]||[_type isEqualToString:@"PurchaseItems"]) {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"管理", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(ManageClick:)];

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
        
        NSArray *titles;
        if ([_type isEqualToString:@"Supplier"]) {
            titles=@[Custing(@"新增供应商", nil)];
        }else if ([_type isEqualToString:@"projectName"]){
            titles=@[Custing(@"新增项目", nil)];
        }else if ([_type isEqualToString:@"Client"]){
            if (_isMultiSelect) {
                titles=@[Custing(@"新增客户", nil),Custing(@"确定", nil)];
            }else{
                titles=@[Custing(@"新增客户", nil)];
            }
        }else if ([_type isEqualToString:@"PurchaseItems"]){
            titles=@[Custing(@"新增产品", nil)];
        }
        [self.dockView updateLookFormViewWithTitleArray:titles];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if ([weakSelf.type isEqualToString:@"Supplier"]) {
                if (index==0){
//                    AddPayCompanyViewController *add = [[AddPayCompanyViewController alloc]init];
//                    add.codeIsSystem = weakSelf.codeIsSystem;
//                    [weakSelf.navigationController pushViewController:add animated:YES];
                }
            }
        };
    }
}

-(void)updateTable{
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(self.offsetHight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

//获取预提明细列表
-(void)requestAccruedData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetAccruedList];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20,@"Filter":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
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
            NSMutableArray *array=[NSMutableArray array];
            [ChooseCateFreModel GetPurchaseItemsTplListDictionary:responceDic Array:array WithTplModel:_model_ItemTpl];
            if (self.ChooseFreshCateBackBlock) {
                self.ChooseFreshCateBackBlock(array, _type);
            }
            [self.navigationController popViewControllerAnimated:YES];
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
    if ([_type isEqualToString:@"projectName"]){
        _paramValue = [result[@"paramValue"] integerValue];
        _codeIsSystem = [result[@"procCodeIsSyStem"]integerValue];
    }else if ([_type isEqualToString:@"Client"]){
        _paramValue = [result[@"paramValue"] integerValue];
        _codeIsSystem = [result[@"clientCodeIsSystem"]integerValue];
    }else if ([_type isEqualToString:@"Supplier"]){
        _codeIsSystem = [result[@"suppCodeIsSystem"]integerValue];
    }else if ([_type isEqualToString:@"PurchaseItems"]){
        _paramValue = [result[@"paramValue"] integerValue];
    }
    if (self.totalPages >= self.currPage) {
        if ([_type isEqualToString:@"accrued"]){
            [AccruedDetailModel getAccruedDetailType:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"costCenter"]){
            [ChooseCateFreModel GetCostCenterDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"Client"]){
            [ChooseCateFreModel GetClientDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"Supplier"]){
            [ChooseCateFreModel GetSupplierDictionary:_resultDict Array:self.resultArray];
        }else if ([_type isEqualToString:@"area"]){
            [ChooseCateFreModel GetAreaDictionary:_resultDict Array:self.resultArray];
        }
    }
    
    if ([_type isEqualToString:@"Supplier"]){
        if (self.dict_otherPars && ![self.dict_otherPars[@"DateType"] isEqualToString:@"0"]) {
            [self createManageView];
        }
    }else if (_paramValue == 1){
        [self createManageView];
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
        return 10;
    }else{
        return 0.5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 197;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell创建
    _cell=[tableView dequeueReusableCellWithIdentifier:@"AccruedTableViewCell"];
    if (_cell==nil) {
        _cell=[[AccruedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccruedTableViewCell"];
    }
    
    AccruedDetailModel *model=(AccruedDetailModel *)self.resultArray[indexPath.section];
    _cell.ChooseNamesArray=self.ChoosedNameArray;
    [_cell configViewWithModel:model withIdArray:_ChoosedIdArray withType:_type];
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMultiSelect) {
        AccruedDetailModel *model=(AccruedDetailModel *)self.resultArray[indexPath.section];
        NSString *MarkId=[AccruedTableViewCell getModelSignWithModel:model WithType:_type];
        if ([_ChoosedIdArray containsObject:MarkId]) {
            [_ChoosedIdArray removeObject:MarkId];
        }else{
            [_ChoosedIdArray addObject:MarkId];
        }
       
        [self.tableView reloadData];
    }
    else{
        NSMutableArray *arr=[NSMutableArray array];
         [arr addObject:self.resultArray[indexPath.section]];
//         if (self.ChooseFreshCateBackBlock) {
//             self.ChooseFreshCateBackBlock(arr, _type);
//         }
        if (self.ChooseAccruedBackBlock) {
            self.ChooseAccruedBackBlock(arr, _type);
        }
         [self.navigationController popViewControllerAnimated:YES];
    }
}
//MARK:确认选择
-(void)sureSelect:(id)obj{
    NSMutableArray *arr=[NSMutableArray array];
    for (AccruedDetailModel *model in self.resultArray) {
        NSString *MarkId=[AccruedTableViewCell getModelSignWithModel:model WithType:_type];
        if ([_ChoosedIdArray containsObject:MarkId]) {
            [arr addObject:model];
        }
    }
    if (self.ChooseAccruedBackBlock) {
        self.ChooseAccruedBackBlock(arr, _type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:管理选择
-(void)ManageClick:(id)obj{
//    if ([self.type isEqualToString:@"Supplier"]) {
//        PayCompanyViewController *sp = [[PayCompanyViewController alloc]init];
//        sp.isUser = 1;
//        [self.navigationController pushViewController:sp animated:YES];
//    }
}

-(void)loadData{
    if ([_type isEqualToString:@"accrued"]){
        [self requestAccruedData];
    }
    
}
#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
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
    
    NSString *tips;
    if ([NSString isEqualToNull:_searchAim]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else if ([_type isEqualToString:@"accrued"]){
        tips=Custing(@"您还没有关联预提明细哦", nil);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


