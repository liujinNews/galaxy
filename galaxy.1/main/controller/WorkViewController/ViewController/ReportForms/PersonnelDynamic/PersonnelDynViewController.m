//
//  PersonnelDynViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#define pageNum  (Main_Screen_Height-NavigationbarHeight)/70
//#import "mapViewController.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "NewAddressViewController.h"

#import "PersonnelDynViewController.h"
#import "personnalSynTableViewCell.h"
#import "personnalSynData.h"
#import "MLKMenuPopover.h"

@interface PersonnelDynViewController ()<UIScrollViewDelegate,GPClientDelegate,MLKMenuPopoverDelegate,chooseTravelDateViewDelegate,ByvalDelegate,NewAddressVCDelegate >

@property (nonatomic, strong) UIView *FilterView;//筛选视图
@property (nonatomic, strong) UIButton *btn_leaveSta;//出差状态按钮
@property (nonatomic, strong) NSArray *arr_leaveSta;//出差状态数
@property (nonatomic, strong) NSString *str_select_leaveSta;//当前选择的出差状态

@property (nonatomic, strong) UIButton *btn_leavePer;//出差人按钮
@property (nonatomic, strong) NSString *str_select_leavePer;//当前选择的出差人

@property (nonatomic, strong) UIButton *btn_leaveCity;//出差城市按钮
@property (nonatomic, strong) NSString *str_select_leaveCity;//当前选择的出差城市

@property (nonatomic, strong) UIButton *btn_map;//地图按钮
@property (nonatomic, strong) NSArray *arr_map;//地图数
@property (nonatomic, strong) NSString *str_select_map;//当前选择地图

@property (nonatomic, strong) NSString * chooseType;//选择状态

@property(nonatomic,strong) MLKMenuPopover *menuPopover;//1.3版本弹出窗
@property(nonatomic,strong)UIPickerView * pickerView;//弹出的时间图
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框

@property (nonatomic,strong)NSString * recordcount;
@property (assign, nonatomic)NSInteger totalPages;

@property(nonatomic,strong)UIView *noDateView;//无数据视图

@property (nonatomic,strong)UIImageView * downImage;
@property (nonatomic,strong)UIImageView * downImage2;
@property (nonatomic,strong)UIImageView * downImage3;
@property (nonatomic,strong)UIImageView * downImage5;

@property (nonatomic,strong)NSArray * cityArr;

@end

@implementation PersonnelDynViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"员工动向", nil) backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self initializeData];
    //创建筛选视图
    _FilterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    _FilterView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.view addSubview:_FilterView];
    [self updateMainView];
    self.currPage = 1;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}



//创建表头文件
-(UIView *)createHeadViewWithSection{
    UIView  * _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, Main_Screen_Width, 25)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 25)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_headView addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, Main_Screen_Width - 20, 20)];
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_headView addSubview:titleLabel];
    titleLabel.text= Custing(@"员工动向统计", nil);
    _headView.backgroundColor=Color_White_Same_20;
    return _headView;
}

#pragma mark 更新视图
//更新视图
-(void)updateMainView
{
    [self update_FilterView];
    [self updatetableView];
}

//更新员工动向视图
-(void)update_FilterView{
    
    //出差状态
    _btn_leaveSta =[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width/4, 44) action:@selector(btn_click:) delegate:self title:[NSString stringWithFormat:@"%@",_str_select_leaveSta] font:Font_Same_12_20 titleColor:Color_GrayDark_Same_20];
    _btn_leaveSta.tag = 100;
    _btn_leaveSta.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btn_leaveSta.contentEdgeInsets = UIEdgeInsetsMake(0,-5, 0, 0);
    [_btn_leaveSta setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_leaveSta];
    
    CGSize size = [NSString sizeWithText:_btn_leaveSta.titleLabel.text font:Font_Same_14_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.downImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/8+size.width/2-6, _btn_leaveSta.frame.origin.y+16, 15, 15)];
    self.downImage.image = [UIImage imageNamed:@"share_Open"];
    [_btn_leaveSta addSubview:self.downImage];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/4-1, 0, 1, 44)];
    line1.backgroundColor = Color_GrayLight_Same_20;
    [_btn_leaveSta addSubview:line1];
    
    //申请人
    _btn_leavePer = [GPUtils createButton:CGRectMake(Main_Screen_Width/4, 0, Main_Screen_Width/4, 44) action:@selector(btn_click:) delegate:self title:[NSString stringWithFormat:@"%@",_str_select_leavePer] font:Font_Same_12_20 titleColor:Color_GrayDark_Same_20];
    _btn_leavePer.tag = 101;
    _btn_leavePer.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btn_leavePer.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    [_btn_leavePer setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_leavePer];
    
    CGSize size2 = [NSString sizeWithText:_btn_leavePer.titleLabel.text font:Font_Same_14_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.downImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/8 +size2.width/2+2, _btn_leavePer.frame.origin.y+16, 15, 15)];
    self.downImage2.image = [UIImage imageNamed:@"share_Open"];
    [_btn_leavePer addSubview:self.downImage2];
    
    if (size2.width >= (Main_Screen_Width/4-20)) {
        _btn_leavePer.frame = CGRectMake(Main_Screen_Width/4, 0, Main_Screen_Width/4-16, 44);
        self.downImage2.frame = CGRectMake(Main_Screen_Width/4-20, _btn_leavePer.frame.origin.y+16, 15, 15);
    }else{
        self.downImage2.frame = CGRectMake(Main_Screen_Width/8+size2.width/2-3, _btn_leavePer.frame.origin.y+16, 15, 15);
    }
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/4-1, 0, 1, 44)];
    line2.backgroundColor = Color_GrayLight_Same_20;
    [_btn_leavePer addSubview:line2];
    
    //出差城市
    _btn_leaveCity = [GPUtils createButton:CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/4, 44) action:@selector(btn_click:) delegate:self title:[NSString stringWithFormat:@"%@",_str_select_leaveCity] font:Font_Same_12_20 titleColor:Color_GrayDark_Same_20];
    _btn_leaveCity.tag = 102;
    _btn_leaveCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btn_leaveCity.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    [_btn_leaveCity setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_leaveCity];
    
    CGSize size3 = [NSString sizeWithText:_btn_leaveCity.titleLabel.text font:Font_Same_14_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.downImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/8 +size3.width/2+2, _btn_leavePer.frame.origin.y+16, 15, 15)];
    self.downImage3.image = [UIImage imageNamed:@"share_Open"];
    [_btn_leaveCity addSubview:self.downImage3];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/4-1, 0, 1, 44)];
    line3.backgroundColor = Color_GrayLight_Same_20;
    [_btn_leaveCity addSubview:line3];
    
    //出差地图
    _btn_map = [GPUtils createButton:CGRectMake(Main_Screen_Width/4*3, 0, Main_Screen_Width/4, 44) action:@selector(btn_click:) delegate:self title:[NSString stringWithFormat:@"%@",_str_select_map] font:Font_Same_12_20 titleColor:Color_GrayDark_Same_20];
    _btn_map.tag = 103;
    _btn_map.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_map setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_map];
    
     CGSize size4 = [NSString sizeWithText:_btn_map.titleLabel.text font:Font_Same_14_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.downImage5 = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/8 +size4.width/2+2, _btn_leavePer.frame.origin.y+16, 15, 15)];
    self.downImage5.image = [UIImage imageNamed:@"share_Open"];
    [_btn_map addSubview:self.downImage5];
    
    if (size4.width >= (Main_Screen_Width/4-20)) {
        _btn_map.frame = CGRectMake(Main_Screen_Width/4*3, 0, Main_Screen_Width/4-16, 44);
        self.downImage5.frame = CGRectMake(Main_Screen_Width/4-16, _btn_map.frame.origin.y+16, 15, 15);
    }else{
        _btn_map.contentEdgeInsets = UIEdgeInsetsMake(0,-5, 0, 0);
        self.downImage5.frame = CGRectMake(Main_Screen_Width/8+size4.width/2-5, _btn_map.frame.origin.y+16, 15, 15);
    }
    
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/4-1, 0, 1, 44)];
    line5.backgroundColor = Color_GrayLight_Same_20;
    [_btn_map addSubview:line5];
    
    UIImageView * ling = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(_FilterView)-0.5, Main_Screen_Width, 0.5)];
    ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:ling];

}


//更新tableview
-(void)updatetableView{
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(44);
        
    }];
    self.tableView.tableHeaderView = [self createHeadViewWithSection];
    
}


#pragma mark 数据
//初始化数据
-(void)initializeData{
//    NSString * statusStr = @"出差中,计划出差";
//    self.arr_leaveSta = [statusStr componentsSeparatedByString:@","];
    self.arr_leaveSta = @[Custing(@"出差中", nil),Custing(@"计划出差", nil)];
    self.str_select_leaveSta = Custing(@"出差中", nil);
    self.str_select_leavePer = Custing(@"申请人", nil);
    
    self.str_select_leaveCity = Custing(@"城市", nil);

//    NSString * mapStr = @"统计表,地图";
//    self.arr_map = [mapStr componentsSeparatedByString:@","];
    self.arr_map = @[Custing(@"统计表", nil),Custing(@"地图", nil)];
    self.str_select_map = Custing(@"统计表", nil);


}


#pragma mark - action
-(void)btn_click:(UIButton *)btn
{
    [self.menuPopover dismissMenuPopover];
    if (btn.tag == 100) {
        if (self.menuPopover) {
            [self.menuPopover dismissMenuPopover];
            self.menuPopover = nil;
        }
        else
        {
            self.chooseType = @"100";
            self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44*_arr_leaveSta.count) menuItems:_arr_leaveSta];
            self.menuPopover.menuPopoverDelegate = self;
            [self.menuPopover showInView:self.view];
        }
    }
    if (btn.tag == 101) {
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"2";
        contactVC.Radio = @"1";
        contactVC.menutype = 1;
        contactVC.universalDelegate = self;
        [contactVC setBlock:^(NSMutableArray *array) {
            [self contactsVCClickedLoadBtn:array];
        }];
        contactVC.isAll = 1;
        [self.navigationController pushViewController:contactVC animated:YES];
        
    }
    
    if (btn.tag == 102) {
//        self.chooseType = @"102";
//        self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44*_arr_leaveCity.count) menuItems:_arr_leaveCity];
//        self.menuPopover.menuPopoverDelegate = self;
//        [self.menuPopover showInView:self.view];
        
        NewAddressViewController * address = [[NewAddressViewController alloc]init];
        address.status = @"1";
        address.Type=1;
        address.isGocity=@"2";
        address.isAll = 1;
        address.arr_Click_Citys = self.cityArr;
        address.delegate = self;
        [self.navigationController pushViewController:address animated:YES];
        
    }
    
    if (btn.tag == 103) {
//        self.chooseType = @"103";
//        self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44*_arr_map.count) menuItems:_arr_map];
//        self.menuPopover.menuPopoverDelegate = self;
//        [self.menuPopover showInView:self.view];
    }
    
}


-(void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if ([self.chooseType isEqualToString:@"100"]) {
        _str_select_leaveSta = [NSString stringWithFormat:@"%@",_arr_leaveSta[selectedIndex]];
        [_btn_leaveSta setTitle:_str_select_leaveSta forState:UIControlStateNormal];
        
        CGSize size = [NSString sizeWithText:_btn_leaveSta.titleLabel.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.downImage.frame = CGRectMake(Main_Screen_Width/8+size.width/2-1, _btn_leaveSta.frame.origin.y+16, 15, 15);
        
        [self requestGetbudgetDocument:self.currPage leaveSta:self.str_select_leaveSta leavePer:self.str_select_leavePer leaveCity:self.str_select_leaveCity];
    }else if ([self.chooseType isEqualToString:@"103"]){
        [YXSpritesLoadingView dismiss];
        _str_select_map = [NSString stringWithFormat:@"%@",_arr_map[selectedIndex]];
//        [_btn_map setTitle:_str_select_map forState:UIControlStateNormal];
        if ([self.str_select_map isEqualToString:Custing(@"地图", nil)]) {
//            NSString * numberStr;
//            if ([self.str_select_leaveSta isEqualToString:Custing(@"出差中", nil)]) {
//                numberStr = @"1";
//            }else{
//                numberStr = @"2";
//            }
//            mapViewController * map = [[mapViewController alloc]initWithType:numberStr];
//            [self.navigationController pushViewController:map animated:YES];
        }else{
            [self requestGetbudgetDocument:self.currPage leaveSta:self.str_select_leaveSta leavePer:self.str_select_leavePer leaveCity:self.str_select_leaveCity];
        }
    }
    
}


//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
}

//城市请求
-(void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array start:(NSString *)start
{
    //出发城市
    self.cityArr = array;
    if ([start isEqualToString:@"1"]) {
        NSMutableArray * cityArr = [NSMutableArray arrayWithArray:array];
        if (cityArr.count>0) {
            NSDictionary *dic = cityArr[0];
            self.str_select_leaveCity = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
            [_btn_leaveCity setTitle:_str_select_leaveCity forState:UIControlStateNormal];
        }
        else{
            self.str_select_leaveCity = @"";
            [_btn_leaveCity setTitle:Custing(@"城市", nil) forState:UIControlStateNormal];
        }
            CGSize size = [NSString sizeWithText:_btn_leaveCity.titleLabel.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            if (size.width >= (Main_Screen_Width/4-20)) {
                self.downImage3.frame = CGRectMake(Main_Screen_Width/4-16, _btn_leaveCity.frame.origin.y+16, 15, 15);
                _btn_leaveCity.frame = CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/4-16, 44);
            }else{
                self.downImage3.frame = CGRectMake(Main_Screen_Width/8+size.width/2-1, _btn_leaveCity.frame.origin.y+16, 15, 15);
            }
            [self requestGetbudgetDocument:self.currPage leaveSta:self.str_select_leaveSta leavePer:self.str_select_leavePer leaveCity:self.str_select_leaveCity];
    }
    
}

//MARK:-审批人选择代理
- (void)contactsVCClickedLoadBtn:(NSMutableArray *)array
{
    if (array.count>0) {
        buildCellInfo *people = array[0];
        self.str_select_leavePer = people.requestor;
        [_btn_leavePer setTitle:_str_select_leavePer forState:UIControlStateNormal];
    }
    else{
        self.str_select_leavePer = @"";
        [_btn_leavePer setTitle:Custing(@"申请人", nil) forState:UIControlStateNormal];
    }
    
    CGSize size = [NSString sizeWithText:_btn_leavePer.titleLabel.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (size.width >= (Main_Screen_Width/4-20)) {
        self.downImage2.frame = CGRectMake(Main_Screen_Width/4-20, _btn_leavePer.frame.origin.y+16, 15, 15);
        _btn_leavePer.frame = CGRectMake(Main_Screen_Width/4, 0, Main_Screen_Width/4-16, 44);
    }else{
        self.downImage2.frame = CGRectMake(Main_Screen_Width/8+size.width/2-5, _btn_leavePer.frame.origin.y+16, 15, 15);
    }
    
     [self requestGetbudgetDocument:self.currPage leaveSta:self.str_select_leaveSta leavePer:self.str_select_leavePer leaveCity:self.str_select_leaveCity];
   
}

#pragma mark 请求数据
//费用统计
-(void)loadData{
    [self requestGetbudgetDocument:self.currPage leaveSta:self.str_select_leaveSta leavePer:self.str_select_leavePer leaveCity:self.str_select_leaveCity];
}
-(void)requestGetbudgetDocument:(NSInteger)page leaveSta:(NSString *)leaveSta leavePer:(NSString *)leavePer leaveCity:(NSString *)leaveCity
{
    //修改下载的状态
    self.isLoading = YES;
    NSString * numberStr;
    if ([leaveSta isEqualToString:Custing(@"出差中", nil)]) {
        numberStr = @"1";
    }else{
        numberStr = @"2";
    }
    if ([leavePer isEqualToString:Custing(@"申请人", nil)]) {
        leavePer = @"";
    }
    if ([leaveCity isEqualToString:Custing(@"城市", nil)]) {
        leaveCity = @"";
    }
    NSDictionary *dic = @{@"ToCity":leaveCity,@"Requestor":leavePer,@"Number":numberStr,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"ToCity",@"IsAsc":@"desc"};
    
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetEmpTrendsList] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - delegate
//网络请求
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSLog(@"%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    if (serialNum == 0) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        self.recordcount = [NSString stringWithFormat:@"%@",[result objectForKey:@"recordcount"]];
        self.totalPages = [[result objectForKey:@"totalPages"] integerValue];
        if (self.currPage==1) {
            [self.resultArray removeAllObjects];
        }
        if (self.totalPages >= self.currPage) {
            NSDictionary * result = [responceDic objectForKey:@"result"];
            if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                return;
            }
            NSArray * items = [result objectForKey:@"items"];
            
            if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
                 [personnalSynData GetPersonnalSynDictionary:responceDic Array:self.resultArray];
                
            }
        }
        
        if (self.resultArray.count==0) {
            [self createNOdataView];
        }else{
            [self removeNodateViews];
        }
        //修改下载的状态
        self.isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];

    }

}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, 25, Main_Screen_Width, HEIGHT(self.tableView))];
        _noDateView.backgroundColor=Color_form_TextFieldBackgroundColor;
        [self.tableView addSubview:_noDateView];
        
        UIImageView *nodataView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 162, 84.5)];
        nodataView.center=CGPointMake(Main_Screen_Width/2, 100*SCALEH);
        nodataView.image=[UIImage imageNamed:@"TemporarilyNoData"];
        [_noDateView addSubview:nodataView];
        
        UILabel *title=[GPUtils createLable:CGRectMake(0, 0, 160, 18) text:nil font:Font_selectTitle_15 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentCenter];
        title.text = Custing(@"暂无数据", nil);
        title.center=CGPointMake(Main_Screen_Width/2, Y(nodataView)+HEIGHT(nodataView)+28);
        [_noDateView addSubview:title];
    }
}

//MARK:移除筛选无数据视图
-(void)removeNodateViews{
    if (_noDateView&&_noDateView!=nil) {
        [_noDateView removeFromSuperview];
        _noDateView=nil;
    }
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



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    
    personnalSynTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"personnalSynTableViewCell"];
    if (cell==nil) {
        cell=[[personnalSynTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personnalSynTableViewCell"];
    }
    personnalSynData *cellInfo = self.resultArray[indexPath.row];
    [cell configPersonnalSynDataCellInfo:cellInfo];
//    personnalSynData * hd = [self.resultArray lastObject];
//    if ([hd isEqual:cellInfo]) {
//        cell.line.hidden = YES;
//    }
    return cell;
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
