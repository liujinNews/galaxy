//
//  NewAddressViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "NewAddressViewController.h"
#import "XFSegementView.h"
#import "CityTableViewCell.h"

@interface NewAddressViewController ()<UISearchBarDelegate,TouchLabelDelegate,UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
{
    NSDictionary *dic_base_city_request;//获取城市数据存储
    NSDictionary *dic_ofter_city_request;//获取常用城市数据存储
    NSDictionary *dic_hot_city_request;//获取热门城市数据存储
    NSMutableArray *arr_inland_city_show;//国内显示用数据
    NSMutableArray *arr_foreign_city_show;//国外显示用数据
    NSMutableArray *arr_hot_city_show;//热门显示用数据
    NSMutableArray *arr_other_city_show;//常用显示用数据
    NSString *Searchtext;//搜索的文字
    NSInteger Index_Type;//当前选择的类型
} 

@property (nonatomic, strong) UISearchBar *searchbar;//搜索条
@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *col_other;//常用城市显示
@property (nonatomic, strong) UICollectionView *col_hot;//热门城市显示

@end

@implementation NewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化页面
    if ([_isGocity isEqualToString:@"1"]) {
        [self setTitle:Custing(@"选择出发地", nil) backButton:YES ];
    }else if ([_isGocity isEqualToString:@"2"]){
        [self setTitle:Custing(@"选择目的地", nil) backButton:YES ];
    }else{
        [self setTitle:Custing(@"选择城市", nil) backButton:YES ];
    }
    
    if (_isXiecheng) {
        NSLog(@"yes");
    }else{
        NSLog(@"no");
    }
    
    [self createMainView];
    [self createSegment];
    [self createBaseVar];
    //初始化 请求 数据
    //    self.userdatas.local03 = nil;
    if (_isXiecheng) {
        [self requestTravelAppGetCtripFlightCities];
    }else{
        if (self.userdatas.local03&&self.userdatas.cache03) {
            if (![self.userdatas.local03 isEqualToString:self.userdatas.cache03]) {
                [self getCity_BaseData];
            }else{
                dic_base_city_request = self.userdatas.localFile03;
                if (!dic_base_city_request) {
                    [self getCity_BaseData];
                }else{
                    [self getHotCityData];
                }
            }
        }else{
            [self getCity_BaseData];
        }
    }
}

#pragma mark - funtion 
//创建视图内容
- (void) createMainView{
    //添加搜索框
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    
    if ([_isGocity isEqualToString:@"1"]) {
        self.searchbar.placeholder = [NSString stringWithFormat:@"%@ %@",Custing(@"搜索", nil),Custing(@"出发地", nil)];
    }else if ([_isGocity isEqualToString:@"2"]){
        self.searchbar.placeholder = [NSString stringWithFormat:@"%@ %@",Custing(@"搜索", nil),Custing(@"目的地", nil)];
    }else{
        self.searchbar.placeholder = [NSString stringWithFormat:@"%@ %@",Custing(@"搜索", nil),Custing(@"城市", nil)];
    }
    
    self.searchbar.delegate = self;
    self.searchbar.barStyle = UISearchBarStyleDefault;
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchbar];
    // 右侧按钮
    if (self.Type == 2) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_left_click:)];
    }
    //添加table
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _OnlyInternal?44:88, Main_Screen_Width, Main_Screen_Height-(_OnlyInternal?44:88)) style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.allowsMultipleSelection = YES;//设置可以多选高亮
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
}

//创建分段器
-(void)createSegment
{
    if (!_OnlyInternal) {
        _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 44, ScreenRect.size.width, 44)];
        _segementView.type=@"2";
        _segementView.titleArray = @[Custing(@"国内", nil),Custing(@"国际",nil)];
        _segementView.titleColor=Color_GrayDark_Same_20;
        [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
        _segementView.titleSelectedColor = Color_Blue_Important_20;
        _segementView.backgroundColor=Color_form_TextFieldBackgroundColor;
        _segementView.touchDelegate = self;
        _segementView.titleFont=14;
        [self.view addSubview:_segementView];
    }
}

//初始化变量
-(void) createBaseVar
{
    dic_base_city_request = [NSDictionary dictionary];
    dic_ofter_city_request = [NSDictionary dictionary];
    dic_hot_city_request = [NSDictionary dictionary];
    arr_inland_city_show = [NSMutableArray array];
    arr_foreign_city_show = [NSMutableArray array];
    arr_hot_city_show = [NSMutableArray array];
    arr_other_city_show = [NSMutableArray array];
    Index_Type = 0;
}

//获取城市数据
-(void)getCity_BaseData
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",getcitys_2];
    if (!_isGocity) {
        _isGocity = @"1";
    }
    userData * datas = [userData shareUserData];
    NSDictionary *parameters = @{@"UserId":datas.userId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取热门城市数据
-(void)getHotCityData
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",gethotcities];
    NSDictionary *parameters = @{@"CityName":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
}

//获取常用城市数据
-(void)getofterCityData
{
    if (!_isGocity) {
        _isGocity = @"1";
    }
    NSString *url;
    NSDictionary *parameters;
    if ([_isGocity isEqualToString:@"1"]) {
        url = [NSString stringWithFormat:@"%@",getfromcity];
        userData * datas = [userData shareUserData];
        parameters = @{@"UserId":datas.userId};
    }else if ([_isGocity isEqualToString:@"3"]){
        url = [NSString stringWithFormat:@"%@",GETADDCOSTOFTENCITY];
        parameters = @{@"Type":@"0"};
    }else if ([_isGocity isEqualToString:@"4"]){
        url = [NSString stringWithFormat:@"%@",GETADDCOSTOFTENCITY];
        parameters = @{@"Type":@"1"};

    }else if ([_isGocity isEqualToString:@"5"]){
        url = [NSString stringWithFormat:@"%@",GETADDCOSTOFTENCITY];
       parameters = @{@"Type":@"2"};
    }else{
        url = [NSString stringWithFormat:@"%@",gettocity];
        userData * datas = [userData shareUserData];
        parameters = @{@"UserId":datas.userId};
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:8 IfUserCache:NO];
}

//获取携程城市数据
-(void)requestTravelAppGetCtripFlightCities
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",TravelAppGetCtripFlightCities];
    NSDictionary *parameters;
    if ([NSString isEqualToNull:_searchbar.text]) {
        parameters = @{@"Type":[NSNumber numberWithInteger:Index_Type+1],@"CityName":_searchbar.text};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
    }else{
        parameters = @{@"Type":[NSNumber numberWithInteger:Index_Type+1]};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    }
}

//获取搜索城市数据
-(void)requestTravelAppGetCities
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",TravelAppGetCities_V4];
    NSDictionary *parameters = @{@"Type":[NSNumber numberWithInteger:Index_Type+1],@"CityName":_searchbar.text};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}

-(void)analysisXiechengRequestData:(NSDictionary *)responceDic{
    arr_inland_city_show = [NSMutableArray array];
    arr_foreign_city_show = [NSMutableArray array];
    NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
    [mds setObject:@"" forKey:@"title"];
    [mds setObject:responceDic[@"result"] forKey:@"array"];
    if (Index_Type == 0) {
        [arr_inland_city_show insertObject:mds atIndex:0];
    }
    if (Index_Type == 1) {
        [arr_foreign_city_show insertObject:mds atIndex:0];
    }
    [_tableView reloadData];
}

-(void)analysisXiechengSecRequestData:(NSDictionary *)responceDic{
    arr_inland_city_show = [NSMutableArray array];
    arr_foreign_city_show = [NSMutableArray array];
    NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
    [mds setObject:@"🔍" forKey:@"title"];
    [mds setObject:responceDic[@"result"] forKey:@"array"];
    if (Index_Type == 0) {
        [arr_inland_city_show insertObject:mds atIndex:0];
    }
    if (Index_Type == 1) {
        [arr_foreign_city_show insertObject:mds atIndex:0];
    }
    [_tableView reloadData];
}

-(void)analysisSearchRequestData:(NSDictionary *)responceDic{
    arr_inland_city_show = [NSMutableArray array];
    arr_foreign_city_show = [NSMutableArray array];
    NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
    if (Index_Type == 0) {
        [mds setObject:@"🔍" forKey:@"title"];
        [mds setObject:responceDic[@"result"][@"home"] forKey:@"array"];
        [arr_inland_city_show insertObject:mds atIndex:0];
    }
    if (Index_Type == 1) {
        [mds setObject:@"🔍" forKey:@"title"];
        [mds setObject:responceDic[@"result"][@"abroad"] forKey:@"array"];
        [arr_foreign_city_show insertObject:mds atIndex:0];
    }
    [_tableView reloadData];
}

//将原始dic数据转换为显示arr数据
- (void)dispose_request_dic
{
    //运行到这里已经获取到全部数据
    [YXSpritesLoadingView dismiss];
    //1,解析基础城市数据
    //国内数据
    NSMutableArray *arrProvince  = [NSMutableArray arrayWithArray:dic_base_city_request[@"result"][@"home"]];
    NSMutableArray *ma = [[NSMutableArray alloc]init];
    for (int i = 0; i<arrProvince.count; i++) {
        NSMutableDictionary *mtdic = [NSMutableDictionary dictionaryWithDictionary:arrProvince[i]];
        [mtdic setValue:@"0" forKey:@"isClick"];
        [mtdic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
        if ([NSString isEqualToNull:Searchtext]) {
            if ([mtdic[@"cityName"] rangeOfString:Searchtext].location != NSNotFound)
            {
                [ma addObject: mtdic];
            }else if ([[NSString stringWithFormat:@"%@",mtdic[@"cityNameEn"]].lowercaseString rangeOfString:Searchtext.lowercaseString].location != NSNotFound)
            {
                [ma addObject: mtdic];
            }
        }else{
            [ma addObject: mtdic];
        }
    }
    arrProvince = ma;
    //国外数据
    NSMutableArray *arr_abroad_download = [NSMutableArray arrayWithArray:dic_base_city_request[@"result"][@"abroad"]];
    NSMutableArray *abroad = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr_abroad_download.count; i++) {
        NSMutableDictionary *mtdic = [NSMutableDictionary dictionaryWithDictionary:arr_abroad_download[i]];
        [mtdic setValue:@"0" forKey:@"isClick"];
        [mtdic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
        if ([NSString isEqualToNull:Searchtext]) {
            if ([mtdic[@"cityName"] rangeOfString:Searchtext].location != NSNotFound)
            {
                [abroad addObject:mtdic];
            }else
            if ([[NSString stringWithFormat:@"%@",mtdic[@"cityNameEn"]].lowercaseString rangeOfString:Searchtext.lowercaseString].location != NSNotFound)
            {
                [abroad addObject:mtdic];
            }
        }else{
            [abroad addObject:mtdic];
        }
    }
    arr_abroad_download = abroad;
    
    //2,解析常用城市数据
    NSDictionary *arrProvinceOften = [dic_ofter_city_request[@"result"]isEqual:[NSNull null]]?[NSDictionary dictionary]:dic_ofter_city_request[@"result"];
    NSMutableArray *arr_abroadCity_oftem = [arrProvinceOften[@"abroadCity"] isKindOfClass:[NSArray class]] ? [NSMutableArray arrayWithArray:arrProvinceOften[@"abroadCity"]]:[NSMutableArray array];
    NSMutableArray *arr_internalCity_oftem = [arrProvinceOften[@"internalCity"] isKindOfClass:[NSArray class]] ? [NSMutableArray arrayWithArray:arrProvinceOften[@"internalCity"]]:[NSMutableArray array];
    //国内常用
    NSMutableArray *maoften = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr_abroadCity_oftem.count; i++) {
        NSMutableDictionary *mtdic = [NSMutableDictionary dictionaryWithDictionary:arr_abroadCity_oftem[i]];
        [mtdic setValue:@"0" forKey:@"isClick"];
        [mtdic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
        if ([NSString isEqualToNull:Searchtext]) {
            if ([[NSString isEqualToNull:mtdic[@"cityName"]]?mtdic[@"cityName"]:@"" rangeOfString:Searchtext].location != NSNotFound)
            {
                [maoften addObject:mtdic];
            }else
            if ([[NSString isEqualToNull:mtdic[@"cityNameEn"]]?[NSString stringWithFormat:@"%@",mtdic[@"cityNameEn"]].lowercaseString:@"" rangeOfString:Searchtext.lowercaseString].location != NSNotFound)
            {
                [maoften addObject:mtdic];
            }
        }else{
            [maoften addObject:mtdic];
        }
    }
    arr_abroadCity_oftem = maoften;
    //国际常用
    NSMutableArray *inter_often = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr_internalCity_oftem.count; i++) {
        NSMutableDictionary *mtdic = [NSMutableDictionary dictionaryWithDictionary:arr_internalCity_oftem[i]];
        [mtdic setValue:@"0" forKey:@"isClick"];
        [mtdic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
        if ([NSString isEqualToNull:Searchtext]) {
            if ([[NSString isEqualToNull:mtdic[@"cityName"]]?mtdic[@"cityName"]:@"" rangeOfString:Searchtext].location != NSNotFound)
            {
                [inter_often addObject: mtdic];
            }else
            if ([[NSString isEqualToNull:mtdic[@"cityNameEn"]]?[NSString stringWithFormat:@"%@",mtdic[@"cityNameEn"]].lowercaseString:@"" rangeOfString:Searchtext.lowercaseString].location != NSNotFound)
            {
                [inter_often addObject: mtdic];
            }
        }else{
            [inter_often addObject: mtdic];
        }
    }
    arr_internalCity_oftem = inter_often;
    
    //3,解析热门城市数据
    NSDictionary *dic_hotCity = [dic_hot_city_request[@"result"]isEqual:[NSNull null]]?[NSMutableArray array]:dic_hot_city_request[@"result"];
    NSMutableArray *arr_hot_abroadCity_city = [NSMutableArray arrayWithArray:dic_hotCity[@"abroadCity"]];
    NSMutableArray *arr_hot_internalCity_city = [NSMutableArray arrayWithArray:dic_hotCity[@"internalCity"]];
    //国内热门
    NSMutableArray *ma_hotcity_arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr_hot_abroadCity_city.count; i++) {
        NSMutableDictionary *mtdic = [NSMutableDictionary dictionaryWithDictionary:arr_hot_abroadCity_city[i]];
        [mtdic setValue:@"0" forKey:@"isClick"];
        [mtdic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
        if ([NSString isEqualToNull:Searchtext]) {
            if ([[NSString isEqualToNull:mtdic[@"cityName"]]?mtdic[@"cityName"]:@"" rangeOfString:Searchtext].location != NSNotFound)
            {
                [ma_hotcity_arr addObject:mtdic];
            }else
            if ([[NSString isEqualToNull:mtdic[@"cityNameEn"]]?[NSString stringWithFormat:@"%@",mtdic[@"cityNameEn"]].lowercaseString:@"" rangeOfString:Searchtext.lowercaseString].location != NSNotFound)
            {
                [ma_hotcity_arr addObject:mtdic];
            }
        }else{
            [ma_hotcity_arr addObject:mtdic];
        }
    }
    arr_hot_abroadCity_city = ma_hotcity_arr;
    //国外热门
    NSMutableArray *ma_hot_internalCity_city_arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<ma_hot_internalCity_city_arr.count; i++) {
        NSMutableDictionary *mtdic = [NSMutableDictionary dictionaryWithDictionary:ma_hot_internalCity_city_arr[i]];
        [mtdic setValue:@"0" forKey:@"isClick"];
        [mtdic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
        if ([NSString isEqualToNull:Searchtext]) {
            if ([[NSString isEqualToNull:mtdic[@"cityName"]]?mtdic[@"cityName"]:@"" rangeOfString:Searchtext].location != NSNotFound)
            {
                [ma_hotcity_arr addObject:mtdic];
            }else 
            if ([[NSString isEqualToNull:mtdic[@"cityNameEn"]]?[NSString stringWithFormat:@"%@",mtdic[@"cityNameEn"]].lowercaseString:@"" rangeOfString:Searchtext.lowercaseString].location != NSNotFound)
            {
                [ma_hotcity_arr addObject:mtdic];
            }
        }else{
            [ma_hotcity_arr addObject:mtdic];
        }
    }
    ma_hot_internalCity_city_arr = ma_hotcity_arr;
    
    //4，将已经选择的数据变更到基础数据中
    if (_arr_Click_Citys.count>0) {
        for (int i = 0 ; i < _arr_Click_Citys.count; i++) {
            NSDictionary * idic = _arr_Click_Citys[i];
            for (int a = 0; a < arrProvince.count; a++) {
                NSMutableDictionary *adic = [NSMutableDictionary dictionaryWithDictionary:arrProvince[a]];
                if ([idic[@"cityCode"]isEqualToString:adic[@"cityCode"]]) {
                    adic[@"isClick"] = @"1";
                    arrProvince[a] = adic;
                }
            }
            for (int a = 0; a < arr_abroad_download.count; a++) {
                NSMutableDictionary *adic = [NSMutableDictionary dictionaryWithDictionary:arr_abroad_download[a]];
                if ([idic[@"cityCode"]isEqualToString:adic[@"cityCode"]]) {
                    adic[@"isClick"] = @"1";
                    arr_abroad_download[a] = adic;
                }
            }
            for (int a = 0; a < arr_abroadCity_oftem.count; a++) {
                NSMutableDictionary *adic = [NSMutableDictionary dictionaryWithDictionary:arr_abroadCity_oftem[a]];
                if ([idic[@"cityCode"]isEqualToString:adic[@"cityCode"]]) {
                    adic[@"isClick"] = @"1";
                    arr_abroadCity_oftem[a] = adic;
                }
            }
            for (int a = 0; a < arr_internalCity_oftem.count; a++) {
                NSMutableDictionary *adic = [NSMutableDictionary dictionaryWithDictionary:arr_internalCity_oftem[a]];
                if ([idic[@"cityCode"]isEqualToString:adic[@"cityCode"]]) {
                    adic[@"isClick"] = @"1";
                    arr_internalCity_oftem[a] = adic;
                }
            }
            for (int a = 0; a<arr_hot_abroadCity_city.count; a++) {
                NSMutableDictionary *adic = [NSMutableDictionary dictionaryWithDictionary:arr_hot_abroadCity_city[a]];
                if ([idic[@"cityCode"]isEqualToString:adic[@"cityCode"]]) {
                    adic[@"isClick"] = @"1";
                    arr_hot_abroadCity_city[a] = adic;
                }
            }
            for (int a = 0; a<arr_hot_internalCity_city.count; a++) {
                NSMutableDictionary *adic = [NSMutableDictionary dictionaryWithDictionary:arr_hot_internalCity_city[a]];
                if ([idic[@"cityCode"]isEqualToString:adic[@"cityCode"]]) {
                    adic[@"isClick"] = @"1";
                    arr_hot_internalCity_city[a] = adic;
                }
            }
            for (int a = 0; a<arr_abroad_download.count; a++) {
                NSMutableDictionary *adic = [NSMutableDictionary dictionaryWithDictionary:arr_abroad_download[a]];
                if ([idic[@"cityCode"]isEqualToString:adic[@"cityCode"]]) {
                    adic[@"isClick"] = @"1";
                    arr_abroad_download[a] = adic;
                }
            }
        }
    }
    
    //5,对基础数据进行排序
    [self city_orderBy:arrProvince];
    [self city_orderBy:arr_abroad_download];
    
    //6,拼接将要显示的数据
    arr_foreign_city_show = [self baseCity_change_showCity:arr_abroad_download];
    arr_inland_city_show = [self baseCity_change_showCity:arrProvince];
    
    if (![_isGocity isEqualToString:@"1"]||![_isGocity isEqualToString:@"2"]) {
        [self add_otherAndHot_city:arr_hot_abroadCity_city arr_other:arr_abroadCity_oftem type:0];
        [self add_otherAndHot_city:arr_hot_internalCity_city arr_other:arr_internalCity_oftem type:1];
    }
    [_tableView reloadData];
    
}

//将数据进行排序
-(void)city_orderBy:(NSMutableArray *)arr
{
    if ([self.userdatas.language isEqualToString:@"ch"]) {
        [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            NSMutableDictionary *dic1 = obj1;
            NSMutableDictionary *dic2 = obj2;
            NSString *str1=dic1[@"cityInitial"];
            NSString *str2=dic2[@"cityInitial"];
            return [str1 compare:str2];
        }];
    }else{
        [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            NSMutableDictionary *dic1 = obj1;
            NSMutableDictionary *dic2 = obj2;
            NSString *str1=dic1[@"cityInitialEn"];
            NSString *str2=dic2[@"cityInitialEn"];
            return [str1 compare:str2];
        }];
    }
}

//将基础数据转换为显示用基础数据
-(NSMutableArray *)baseCity_change_showCity:(NSMutableArray *)arr
{
    NSMutableArray *Temporary = [[NSMutableArray alloc]init];
    NSMutableArray *ma_show = [[NSMutableArray alloc]init];
    NSMutableDictionary *md = [[NSMutableDictionary alloc]init];
    NSString *oneguihua = @"";
    //常规用户 中文
    if ([self.userdatas.language isEqualToString:@"ch"]) {
        for (int i = 0; i<arr.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
            if ([oneguihua isEqualToString:dic[@"cityInitial"]]) {
                [ma_show addObject:dic];
            }
            else
            {
                if (i>0) {
                    [md setObject:ma_show forKey:@"array"];
                    [Temporary addObject:md];
                }
                oneguihua = dic[@"cityInitial"];
                ma_show =[[NSMutableArray alloc]init];
                md =[[NSMutableDictionary alloc]init];
                [ma_show addObject:dic];
                [md setObject:dic[@"cityInitial"] forKey:@"title"];
            }
            if (i==arr.count-1) {
                [md setObject:ma_show forKey:@"array"];
                [Temporary addObject:md];
            }
        }
    }else{
        for (int i = 0; i<arr.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
            if ([oneguihua isEqualToString:dic[@"cityInitialEn"]]) {
                [ma_show addObject:dic];
            }
            else
            {
                if (i>0) {
                    [md setObject:ma_show forKey:@"array"];
                    [Temporary addObject:md];
                }
                oneguihua = dic[@"cityInitialEn"];
                ma_show =[[NSMutableArray alloc]init];
                md =[[NSMutableDictionary alloc]init];
                [ma_show addObject:dic];
                [md setObject:dic[@"cityInitialEn"] forKey:@"title"];
            }
            if (i==arr.count-1) {
                [md setObject:ma_show forKey:@"array"];
                [Temporary addObject:md];
            }
        }
    }
    [Temporary sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *str1=(NSString *)[obj1 objectForKey:@"title"];
        NSString *str2=(NSString *)[obj2 objectForKey:@"title"];
        return [str1 compare:str2];
    }];
    return Temporary;
}

-(void)add_otherAndHot_city:(NSMutableArray *)arr_hot arr_other:(NSMutableArray *)arr_other type:(NSInteger)type{
    if (arr_hot.count>0 && ![NSString isEqualToNull:Searchtext]&&_isAll!=1) {
        //热门城市
        NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
        [mds setObject:@"#" forKey:@"title"];
        [mds setObject:arr_hot forKey:@"array"];
        if (type==1) {
            [arr_inland_city_show insertObject:mds atIndex:0];
        }else{
            [arr_foreign_city_show insertObject:mds atIndex:0];
        }
    }
    
    if (arr_other.count>0&&Index_Type!=1) {
        //常用联系人
        NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
        [mds setObject:@"☆" forKey:@"title"];
        [mds setObject:arr_other forKey:@"array"];
        if (type==1) {
            [arr_inland_city_show insertObject:mds atIndex:0];
        }else{
            [arr_foreign_city_show insertObject:mds atIndex:0];
        }
    }
    if (_isAll == 1) {
        NSMutableDictionary *mds = [[NSMutableDictionary alloc]init];
        [mds setObject:@"" forKey:@"title"];
        [mds setObject:@[@{@"cityCode":@"0",@"cityInitial":@"",@"cityName":Custing(@"全部", nil),@"cityNameEn":@"",@"id":@"0",@"isClick":@"0"}] forKey:@"array"];
        if (type==1) {
            [arr_inland_city_show insertObject:mds atIndex:0];
        }else{
            [arr_foreign_city_show insertObject:mds atIndex:0];
        }
    }
}

//更新cell的高亮状态
-(void)updateTableViewCellStyle:(NSDictionary *)city
{
    NSString *zimu = Index_Type==0?city[@"cityInitial"]:city[@"cityInitialEn"];
    if ([NSString isEqualToNull:zimu]) {
        int Section = 0;
        int row = 0;
        if (Index_Type==0) {
            for (int s = 0; s<arr_inland_city_show.count; s++) {
                NSArray *citySection = arr_inland_city_show[s][@"array"];
                NSString *title = arr_inland_city_show[s][@"title"];
                if ([title isEqualToString:zimu]) {
                    Section = s;
                    for (int r = 0; r<citySection.count; r++) {
                        NSDictionary *dic_row = citySection[r];
                        if ([dic_row[@"cityCode"]isEqualToString:city[@"cityCode"]]) {
                            row = 0;
                        }
                    }
                }
            }
        }else{
            for (int s = 0; s<arr_foreign_city_show.count; s++) {
                NSArray *citySection = arr_foreign_city_show[s][@"array"];
                NSString *title = arr_foreign_city_show[s][@"title"];
                if ([title isEqualToString:zimu]) {
                    Section = s;
                    for (int r = 0; r<citySection.count; r++) {
                        NSDictionary *dic_row = citySection[r];
                        if ([dic_row[@"cityCode"]isEqualToString:city[@"cityCode"]]) {
                            row = 0;
                        }
                    }
                }
            }
        }
        if (row!=0&&Section!=0) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:row inSection:Section];
            if ([city[@"isClick"]isEqualToString:@"1"]) {
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }else{
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
        }
    }
}

-(void)popToView{
    [self.delegate NewaddressVCDelegatellClickedLoadBtn:self.arr_Click_Citys start:self.status];
    if (self.selectAddressBlock) {
        self.selectAddressBlock(self.arr_Click_Citys, self.status);
    }
    [self returnBack];
}

#pragma mark - action
-(void)btn_left_click:(UIButton *)btn{
    [self popToView];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        return;
    }
    
    if (serialNum == 0) {
        NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
        if ([success isEqualToString:@"0"]) {
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            return;
        }
        
        dic_base_city_request = [NSDictionary dictionaryWithDictionary:responceDic];
        
        if (!self.userdatas.cache03) {
            self.userdatas.cache03 = [NSString GetstringFromDate];
        }
        self.userdatas.local03 = self.userdatas.cache03;
        self.userdatas.localFile03 = responceDic;
        [self.userdatas storeUserInfo];
        [userData savelocalFile:responceDic type:3];
        [self getHotCityData];
        if (_isGocity!=0) {
            [self getHotCityData];
        }else{
            [self dispose_request_dic];
        }
    }else if (serialNum == 1) {
        [self analysisXiechengRequestData:responceDic];
    }else if (serialNum == 5) {
        dic_hot_city_request = [NSDictionary dictionaryWithDictionary:responceDic];
        [self getofterCityData];
    }else if (serialNum == 8) {
        if (!self.notOften) {
            dic_ofter_city_request = [NSDictionary dictionaryWithDictionary:responceDic];
        }else{
            dic_ofter_city_request=[NSDictionary dictionary];
        }
        [self dispose_request_dic];
    }else if (serialNum == 3) {
        [self analysisXiechengSecRequestData:responceDic];
    }else if (serialNum == 4) {
        [self analysisSearchRequestData:responceDic];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 25)];
    view.backgroundColor = Color_White_Same_20;
    UILabel *titleLabel= [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-15, 25) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    NSDictionary *travel;
    if (Index_Type==0) {
        travel = arr_inland_city_show[section];
    }else{
        travel = arr_foreign_city_show[section];
    }
    if ([travel[@"title"]isEqualToString:@"☆"]) {
        titleLabel.text = Custing(@"常用城市", nil);
    }
    else if ([travel[@"title"]isEqualToString:@"#"]||[travel[@"title"]isEqualToString:@""]) {
        titleLabel.text = Custing(@"热门城市",nil);
    }else if ([travel[@"title"]isEqualToString:@""]) {
        titleLabel.text = Custing(@"全部", nil);
    }
    else
    {
        if ([travel[@"title"] isEqualToString:@"🔍"]) {
            titleLabel.text = Custing(@"搜索", nil);
        }else{
            titleLabel.text = travel[@"title"];
        }
    }
    [view addSubview:titleLabel];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 25)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [view addSubview:ImgView];
    return view;
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Index_Type==0?arr_inland_city_show.count:arr_foreign_city_show.count;
}

//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = Index_Type==0?arr_inland_city_show[section]:arr_foreign_city_show[section];
    if ([dic[@"title"] isEqualToString:@"☆"]||[dic[@"title"] isEqualToString:@"#"]||[dic[@"title"] isEqualToString:@""]||[dic[@"title"] isEqualToString:@""]) {
        return 1;
    }
    NSArray *arr = dic[@"array"];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = Index_Type==0?arr_inland_city_show[indexPath.section]:arr_foreign_city_show[indexPath.section];
    if ([dic[@"title"] isEqualToString:@"☆"]||[dic[@"title"] isEqualToString:@"#"]||[dic[@"title"] isEqualToString:@""]||[dic[@"title"] isEqualToString:@""]) {
        NSArray *arr = dic[@"array"];
        float a = (float)arr.count/3.0;
        NSInteger index = ceil(a);
        return index>1?(index)*40+10:1*40+10;
    }
    return 44;
}

//快捷检索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [Index_Type==0?arr_inland_city_show:arr_foreign_city_show valueForKeyPath:@"title"];
}

//每一行的显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //    [self.view endEditing:YES];
    NSArray *citySection = Index_Type==0?arr_inland_city_show[indexPath.section][@"array"]:arr_foreign_city_show[indexPath.section][@"array"];
    NSString *title = Index_Type==0?arr_inland_city_show[indexPath.section][@"title"]:arr_foreign_city_show[indexPath.section][@"title"];
    NSDictionary *dic = citySection[indexPath.row];
    NSString *key;
    if ([title isEqualToString:@"#"]||[title isEqualToString:@""]||[title isEqualToString:@"☆"]||[title isEqualToString:@""]) {
        CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
        if (!cell) {
            __weak typeof(self) weakSelf = self;
            cell = [[CityTableViewCell alloc] initWithReuseIdentifier:@"CityTableViewCell"];
            cell.selectCity = ^(NSDictionary *cityName){
                NSMutableArray *muarr = [NSMutableArray arrayWithArray:weakSelf.arr_Click_Citys];
                //1.单选且是选中状态直接返回
                if ([cityName[@"isClick" ]isEqualToString:@"1"]) {
                    if (weakSelf.Type == 1) {
                        [weakSelf.delegate NewaddressVCDelegatellClickedLoadBtn:@[cityName] start:weakSelf.status];
                        if (weakSelf.selectAddressBlock) {
                            weakSelf.selectAddressBlock(@[cityName], weakSelf.status);
                        }
                        [weakSelf returnBack];
                        return ;
                    }
                    //2.选中数据加入选中数字中
                    int is_add= 0;
                    for (int i = 0; i<muarr.count; i++) {
                        NSDictionary *dic = muarr[i];
                        if ([NSString isEqualToNull:dic[@"cityCode"]]&&[NSString isEqualToNull:cityName[@"cityCode"]]) {
                            if ([dic[@"cityCode"]isEqualToString:cityName[@"cityCode"]]) {
                                is_add =1;
                            }
                        }
                    }
                    if (is_add==0) {
                        [muarr addObject:cityName];
                    }
                }else{
                    //3.如过取消，剔除
                    for (int i = 0; i<muarr.count; i++) {
                        NSDictionary *dic = muarr[i];
                        if ([dic[@"cityCode"]isEqualToString:cityName[@"cityCode"]]) {
                            [muarr removeObjectAtIndex:i];
                        }
                    }
                }
                weakSelf.arr_Click_Citys = muarr;
                [self updateTableViewCellStyle:cityName];
                [self keyClose];
            };
        }
        cell.citys = Index_Type==0?arr_inland_city_show[indexPath.section][@"array"]:arr_foreign_city_show[indexPath.section][@"array"];
        return cell;
    }else{
        key = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:dic[@"cityNameEn"];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        [cell.imageView setImage:[UIImage imageNamed:@"MyApprove_UnSelect"]];
        [cell.imageView setHighlightedImage:[UIImage imageNamed:@"MyApprove_Select"]];
        
        
        [cell.textLabel setTextColor:Color_Unsel_TitleColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    if ([dic[@"isClick"] isEqualToString:@"1"]) {
//        cell.imageView.highlighted = YES;
//        cell.selected = YES;
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    cell.textLabel.text = [NSString isEqualToNull:key]?key:@"";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self keyClose];
    NSArray *citySection = Index_Type==0?arr_inland_city_show[indexPath.section][@"array"]:arr_foreign_city_show[indexPath.section][@"array"];
//    NSString *title = Index_Type==0?arr_inland_city_show[indexPath.section][@"title"]:arr_foreign_city_show[indexPath.section][@"title"];
    NSMutableDictionary *dic_select = [NSMutableDictionary dictionaryWithDictionary:citySection[indexPath.row]];
    dic_select[@"isClick"] = @"1";
    if ([dic_select[@"isClick" ]isEqualToString:@"1"]) {
        if (self.Type == 1) {
            [self.delegate NewaddressVCDelegatellClickedLoadBtn:@[dic_select] start:self.status];
            if (self.selectAddressBlock) {
                self.selectAddressBlock(@[dic_select], self.status);
            }
            [self returnBack];
            return;
        }
    }
    
    NSMutableArray *muarr = [NSMutableArray arrayWithArray:self.arr_Click_Citys];
    int is_add= 0;
    for (int i = 0; i<muarr.count; i++) {
        NSDictionary *dic = muarr[i];
        if ([dic[@"cityCode"]isEqualToString:dic_select[@"cityCode"]]) {
            is_add =1;
        }
    }
    if (is_add==0) {
        [muarr addObject:dic_select];
    }
    self.arr_Click_Citys = muarr;
}

//取消点击
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self keyClose];
    NSArray *citySection = Index_Type==0?arr_inland_city_show[indexPath.section][@"array"]:arr_foreign_city_show[indexPath.section][@"array"];
    NSMutableDictionary *dic_select = [NSMutableDictionary dictionaryWithDictionary:citySection[indexPath.row]];
    dic_select[@"isClick"] = @"0";
    
    NSMutableArray *muarr = [NSMutableArray arrayWithArray:self.arr_Click_Citys];
    for (int i = 0; i<muarr.count; i++) {
        NSDictionary *dic = muarr[i];
        if ([dic[@"cityCode"]isEqualToString:dic_select[@"cityCode"]]) {
            [muarr removeObjectAtIndex:i];
        }
    }
    self.arr_Click_Citys = muarr;
}

-(void)touchLabelWithIndex:(NSInteger)index{
    Index_Type = index;
    if (_isXiecheng) {
        [self requestTravelAppGetCtripFlightCities];
    }else{
        [self.tableView reloadData];
    }
}

//搜索代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (_isXiecheng) {
        [self requestTravelAppGetCtripFlightCities];
    }else{
        Searchtext = @"";
        [self dispose_request_dic];
        [self.tableView reloadData];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (_isXiecheng) {
        [self requestTravelAppGetCtripFlightCities];
    }else{
        [self requestTravelAppGetCities];
    }
    [self keyClose];
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
