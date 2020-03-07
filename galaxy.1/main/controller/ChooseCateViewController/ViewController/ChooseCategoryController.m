//
//  ChooseCategoryController.m
//  galaxy
//
//  Created by hfk on 16/4/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ChooseCategoryController.h"
#import "ChooseCategoryCell.h"
@interface ChooseCategoryController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
/**
 *  请求结果字典
 */
@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSMutableArray *ChoosedIdArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ChooseCategoryCell *cell;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UISearchBar *sea_searchbar;
@property (nonatomic, strong) NSMutableArray *arr_search;
@property (nonatomic, strong) ChooseCategoryModel *hotelSubmitModel;

@end

@implementation ChooseCategoryController
-(id)initWithType:(NSString *)type{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
-(NSMutableArray *)ChooseCategoryArray{
    if (!_ChooseCategoryArray) {
        _ChooseCategoryArray=[NSMutableArray array];
    }
    return _ChooseCategoryArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ChoosedIdArray=[NSMutableArray arrayWithArray:[NSString isEqualToNullAndZero:_ChooseCategoryId]?[[NSString stringWithFormat:@"%@",_ChooseCategoryId] componentsSeparatedByString:@","]:@[]];

    if ([_type isEqualToString:@"Department"]) {
        [self setTitle:Custing(@"选择部门", nil) backButton:YES ];
        [self requestUserDept];
    }else if ([_type isEqualToString:@"CARNO"]){
        [self setTitle:Custing(@"选择车辆", nil) backButton:YES ];
        [self requestCarList];
    }else if ([_type isEqualToString:@"ProductCat"]){
        [self setTitle:Custing(@"选择产品类型", nil) backButton:YES ];
        [self requestProductCat];
    }else if ([_type isEqualToString:@"VehicleTyp"]){
        [self setTitle:Custing(@"选择用车类型", nil) backButton:YES ];
        [self requestVehicleTyp];
    }else if ([_type isEqualToString:@"AttendanceRole"]){
        [self setTitle:Custing(@"选择参与角色", nil) backButton:YES ];
        [self requestAttendanceRole];
    }else if ([_type isEqualToString:@"SupplierCat"]){
        [self setTitle:Custing(@"选择供应商类别", nil) backButton:YES ];
        [self requestSupplierCat];
    }else if ([_type isEqualToString:@"GetProvinces"]){
        [self setTitle:Custing(@"选择省份", nil) backButton:YES ];
        [self requestProvinces];
    }else if ([_type isEqualToString:@"GetCitys"]){
        [self setTitle:Custing(@"选择城市", nil) backButton:YES ];
        [self requestCitys];
    }else{
        if ([_type isEqualToString:@"purchaseType"]) {
            [self setTitle:Custing(@"选择采购类型", nil) backButton:YES ];
        }else if ([_type isEqualToString:@"payWay"]){
            [self setTitle:Custing(@"选择支付方式", nil) backButton:YES ];
        }else if ([_type isEqualToString:@"HotelStand"]){
            [self setTitle:Custing(@"住宿提交限制", nil) backButton:YES ];
        }else if ([_type isEqualToString:@"ClaimType"]){
            [self setTitle:Custing(@"选择报销类型", nil) backButton:YES ];
        }else if ([_type isEqualToString:@"NewPayWay"]){
            [self setTitle:Custing(@"选择支付方式", nil) backButton:YES ];
        }
        [self createMainViewData];
    }
}
-(void)createMainViewData{
    [self createTableView];
    if ([_type isEqualToString:@"CARNO"]) {
        [self createSearchBar];
        self.sea_searchbar.placeholder = Custing(@"搜索车牌号", nil);
    }
    [self createNOdataView];
    if (_isMultiSelect) {
        [self createNavMutilSelectSure];
    }
    
}
//MARK:创建多选确定按钮
-(void)createNavMutilSelectSure{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(sureSelect:)];
}
//获取用户部门
-(void)requestUserDept{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetUSERDEPT];
    NSDictionary *Parameters=@{@"UserId":self.dict_Parameter ?self.dict_Parameter[@"userId"]:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求车辆列表
-(void)requestCarList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"%@",GetVehicleInfos] Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求产品分类
-(void)requestProductCat{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *Parameters=@{@"PageIndex":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GETPURCHASETYPELIST] Parameters:Parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求用车类型
-(void)requestVehicleTyp{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetVehicleTyps] Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求考勤角色
-(void)requestAttendanceRole{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",EditPower];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求供应商类别
-(void)requestSupplierCat{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETSUPPLIERCATS];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求省份
-(void)requestProvinces{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url = [NSString stringWithFormat:@"%@",GETPROVINCES];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求城市
-(void)requestCitys{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url = [NSString stringWithFormat:@"%@",GETCITYS];
    NSDictionary *Parameters = @{@"ProvinceCode":self.dict_Parameter ?self.dict_Parameter[@"ProvinceCode"]:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    switch (serialNum) {
        case 1:
        {
            NSMutableArray *arr=[NSMutableArray array];
            [arr addObject:_hotelSubmitModel];
            if (self.ChooseNormalCateBackBlock) {
                self.ChooseNormalCateBackBlock(arr, _type);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            [self dealWithData];
        }
            break;
        default:
            break;
    }
    
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
-(void)dealWithData{
    if ([_type isEqualToString:@"Department"]){
        [ChooseCategoryModel getDepartmentNewByDict:_resultDict Array:self.ChooseCategoryArray];
    }else if ([_type isEqualToString:@"CARNO"]){
        [ChooseCategoryModel getCarInfoByDict:_resultDict Array:self.ChooseCategoryArray];
    }else if ([_type isEqualToString:@"ProductCat"]){
        [ChooseCategoryModel getProductCatListByDict:_resultDict Array:self.ChooseCategoryArray];
    }else if ([_type isEqualToString:@"VehicleTyp"]){
        [ChooseCategoryModel getVehicleTypListByDict:_resultDict Array:self.ChooseCategoryArray];
    }else if ([_type isEqualToString:@"AttendanceRole"]){
        [ChooseCategoryModel getAttendanceRoleListByDict:_resultDict Array:self.ChooseCategoryArray];
    }else if ([_type isEqualToString:@"SupplierCat"]){
        [ChooseCategoryModel getSupplierCatsListByDict:_resultDict Array:self.ChooseCategoryArray];
    }else if ([_type isEqualToString:@"GetProvinces"]){
        [ChooseCategoryModel getProvincesListByDict:_resultDict Array:self.ChooseCategoryArray];
    }else if ([_type isEqualToString:@"GetCitys"]){
        [ChooseCategoryModel getCitysListByDict:_resultDict Array:self.ChooseCategoryArray];
    }
    [self createMainViewData];
}
//MARK:创建tableView
-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=Color_White_Same_20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
-(void)createSearchBar{
    if (_tableView) {
        _arr_search = [NSMutableArray arrayWithArray:self.ChooseCategoryArray];
        _sea_searchbar  = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
        _sea_searchbar.delegate = self;
        [self.view addSubview:_sea_searchbar];
        _tableView.frame = CGRectMake(0, 49, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49);
    }
}

//MARK:创建无数据视图
-(void)createNOdataView{
    
    NSString *tips;
    if ([NSString isEqualToNull:self.sea_searchbar.text]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else if ([_type isEqualToString:@"purchaseType"]) {
        tips=Custing(@"您还没有采购类型哦", nil);
    }else if ([_type isEqualToString:@"payWay"]){
        tips=Custing(@"您还没有支付方式哦", nil);
    }else if ([_type isEqualToString:@"Department"]){
        tips=Custing(@"您还没有部门哦", nil);
    }else if ([_type isEqualToString:@"ClaimType"]){
        tips=Custing(@"您还没有报销类型哦", nil);
    }else if ([_type isEqualToString:@"CARNO"]){
        tips=Custing(@"您还没有车辆哦", nil);
    }else if ([_type isEqualToString:@"SupplierCat"]){
        tips=Custing(@"您还没有供应商类别哦", nil);
    }else if ([_type isEqualToString:@"ProductCat"]){
        tips=Custing(@"您还没有采购分类哦", nil);
    }else if ([_type isEqualToString:@"NewPayWay"]){
        tips=Custing(@"您还没有支付方式哦", nil);
    }else if ([_type isEqualToString:@"VehicleTyp"]){
        tips=Custing(@"您还没有用车类型哦", nil);
    }else if ([_type isEqualToString:@"AttendanceRole"]){
        tips=Custing(@"您还没有角色哦", nil);
    }else if ([_type isEqualToString:@"GetProvinces"]){
        tips=Custing(@"您还没有省份哦", nil);
    }else if ([_type isEqualToString:@"GetCitys"]){
        tips=Custing(@"您还没有城市哦", nil);
    }
    [_tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.ChooseCategoryArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

//MARK:tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.ChooseCategoryArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if ([_type isEqualToString:@"purchaseType"]||[_type isEqualToString:@"payWay"]) {
            return 60;
        }else{
            return 0.01;
        }
    }else{
        return 0.5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if ([_type isEqualToString:@"purchaseType"]||[_type isEqualToString:@"payWay"]) {
            UIView *view=[[UIView alloc]init];
            view.frame=CGRectMake(0, 0, Main_Screen_Width,60);
            view.backgroundColor=Color_White_Same_20;
            
            UIView *downView=[[UIView alloc]init];
            downView.frame=CGRectMake(0, 10, Main_Screen_Width,50);
            downView.backgroundColor=Color_form_TextFieldBackgroundColor;
            [view addSubview:downView];
            
            _selectedImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
            _selectedImg.center=CGPointMake(25, 25);
            _selectedImg.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
            [downView addSubview:_selectedImg];
            
            UILabel *label = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width/3*2, 50) text:Custing(@"无", nil) font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
            [downView addSubview:label];
            
            UIButton *selectBtn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 50) action:@selector(selectNoDate:) delegate:self];
            [downView addSubview:selectBtn];
        
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(50, 49.5, Main_Screen_Width-50, 0.5)];
            lineview.backgroundColor =Color_GrayLight_Same_20;
            [downView addSubview:lineview];
            return view;
        }else{
            UIView *view=[[UIView alloc]init];
            view.frame=CGRectMake(0, 0, Main_Screen_Width,0.01);
            view.backgroundColor=Color_White_Same_20;
            return view;
        }
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
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell创建
    _cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseCategoryCell"];
    if (_cell==nil) {
        _cell=[[ChooseCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCategoryCell"];
    }
    ChooseCategoryModel *model=(ChooseCategoryModel *)self.ChooseCategoryArray[indexPath.section];
    [_cell configViewWithModel:model withIdArray:_ChoosedIdArray withType:_type];
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_type isEqualToString:@"HotelStand"]){
        _hotelSubmitModel=self.ChooseCategoryArray[indexPath.section];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSDictionary *parameters = @{@"ParamName":@"HotelLimitMode",@"ParamValue":[NSString isEqualToNull:_hotelSubmitModel.addCostCode]?_hotelSubmitModel.addCostCode:@""};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SaveHotelSubmit] Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    }else{
        if (_isMultiSelect) {
            ChooseCategoryModel *model=(ChooseCategoryModel *)self.ChooseCategoryArray[indexPath.section];
            NSString *MarkId=[ChooseCategoryCell getModelSignWithModel:model WithType:_type];
            if ([_ChoosedIdArray containsObject:MarkId]) {
                [_ChoosedIdArray removeObject:MarkId];
            }else{
                [_ChoosedIdArray addObject:MarkId];
            }
            [_tableView reloadData];
        }else{
            if ([_type isEqualToString:@"GetProvinces"]) {
                ChooseCategoryModel *model = self.ChooseCategoryArray[indexPath.section];
                ChooseCategoryController *choose = [[ChooseCategoryController alloc]initWithType:@"GetCitys"];
                choose.dict_Parameter = @{@"ProvinceCode":model.provinceCode};
                choose.dict_BankOutlets = self.dict_BankOutlets;
                choose.ChooseBankOutletsBlock = self.ChooseBankOutletsBlock;
                [self.navigationController pushViewController:choose animated:YES];
            }else if ([_type isEqualToString:@"GetCitys"]){
                ChooseCategoryModel *model = self.ChooseCategoryArray[indexPath.section];
                ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"BankOutlets"];
                vc.dict_otherPars=@{@"ClearingBankCode":self.dict_BankOutlets[@"ClearingBankCode"],@"CityCode":model.cityCode};
                vc.ChooseBankOutletsBlock = self.ChooseBankOutletsBlock;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSMutableArray *arr=[NSMutableArray array];
                [arr addObject:self.ChooseCategoryArray[indexPath.section]];
                if (self.ChooseNormalCateBackBlock) {
                    self.ChooseNormalCateBackBlock(arr, _type);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
-(void)selectNoDate:(UIButton *)btn{
    if (self.ChooseNormalCateBackBlock) {
        self.ChooseNormalCateBackBlock(nil, _type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:确认选择
-(void)sureSelect:(id)obj{
    NSMutableArray *arr=[NSMutableArray array];
    for (ChooseCategoryModel *model in self.ChooseCategoryArray) {
        NSString *MarkId=[ChooseCategoryCell getModelSignWithModel:model WithType:_type];
        if ([_ChoosedIdArray containsObject:MarkId]) {
            [arr addObject:model];
        }
    }
    if (self.ChooseNormalCateBackBlock) {
        self.ChooseNormalCateBackBlock(arr, _type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self keyClose];
    [self.ChooseCategoryArray removeAllObjects];
    if ([searchBar.text isEqualToString:@""]) {
        self.ChooseCategoryArray = _arr_search;
    }else{
        for (int i = 0; i<_arr_search.count; i++) {
            ChooseCategoryModel *model = _arr_search[i];
            if ([_type isEqualToString:@"CARNO"]&&(([model.carNo rangeOfString:searchBar.text].location != NSNotFound)))
            {
                [self.ChooseCategoryArray addObject:model];
            }
        }
    }
    [self createNOdataView];
    [_tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.ChooseCategoryArray = _arr_search;
    }else{
        self.ChooseCategoryArray = [NSMutableArray array];
        for (int i = 0; i<_arr_search.count; i++) {
            ChooseCategoryModel *model = _arr_search[i];
            if ([_type isEqualToString:@"CARNO"]&&(([model.carNo rangeOfString:searchBar.text].location != NSNotFound)))
            {
                [self.ChooseCategoryArray addObject:model];
            }
        }
    }
    [self createNOdataView];
    [_tableView reloadData];
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
