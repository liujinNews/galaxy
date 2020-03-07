//
//  CustomNotesNewViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/26.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "CustomNotesNewViewController.h"

@interface CustomNotesNewViewController ()

//@property (nonatomic, strong) UIBarButtonItem* rightBtn1;
//@property (nonatomic, strong) UIBarButtonItem* rightBtn2;
//@property (nonatomic, strong) UIBarButtonItem* rightBtn3;

@property (nonatomic, strong) UIButton* rightBtn1;
@property (nonatomic, strong) UIButton* rightBtn2;
@property (nonatomic, strong) UIButton* rightBtn3;

@property (nonatomic, strong) UIButton *rightFiltBtn;
@property (nonatomic, strong) UIButton *rightMarkBtn;
@property (nonatomic, strong) UIButton *rightCanCelBtn;
@property (nonatomic, assign) BOOL hasMark;
@property (nonatomic, strong) NSMutableArray *CheckArray;

@property (nonatomic, strong) UIView *NavView;
@property (nonatomic, strong) UILabel *lab_Amount;

@end

@implementation CustomNotesNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, iPhoneX?148:126)];
    headerbg.image = GPImage(@"my_Headerbackground");
    [self.view addSubview:headerbg];
    
    _NavView = [[UIView alloc]initWithFrame:self.navigationController.navigationBar.frame];
    [self.view addSubview:_NavView];
    
    UIButton *NavBackBtn=[GPUtils createButton:CGRectMake(20,0, 40, 40) action:@selector(Navback) delegate:self];
    [NavBackBtn setImage:[UIImage imageNamed:@"Share_AgentGoBack"] forState:UIControlStateNormal];
    NavBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0,-30, 0, 0);
    [_NavView addSubview:NavBackBtn];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-50, 0, 100, HEIGHT(_NavView)) text:Custing(@"未提交费用", nil) font:Font_filterTitle_17 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
    [_NavView addSubview:lab];
    
    UILabel *lab_count = [GPUtils createLable:CGRectMake(15, iPhoneX?109:87, 30, 20) text:Custing(@"合计", nil) font:Font_Same_12_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
    [headerbg addSubview:lab_count];
    
    _lab_Amount = [GPUtils createLable:CGRectMake(45, iPhoneX?96:74, Main_Screen_Width-60, 35) text:@"0" font:[UIFont systemFontOfSize:30.f] textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
    _lab_Amount.text = [GPUtils transformNsNumber:_lab_Amount.text];
    [headerbg addSubview:_lab_Amount];
    
    
    [self createMarkAndFilterCancel];
    [self DealWithNavBtns];
    [self createTableView];
    [self createAddCostView];
    _filterType=@"0";//第一次进入筛选界面类型
    _filterCode=@"0";//第一次进入筛选界面类别
    _parameter=[[NSDictionary alloc]init];
    _parameter=nil;
    _requestType=@"1";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (![_requestType isEqualToString:@"1"]) {
        [self requestReserveList];
    }
    _requestType=@"0";
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - function
#pragma mark view
-(void)createMarkAndFilterCancel{
//    _rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(filter:)];
//    _rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:@"NavBarImg_AgentMyFilter" target:self action:@selector(filter:)];
    
    _rightBtn1 = [GPUtils createButton:CGRectMake(Main_Screen_Width-55, 2, 40, 40) action:@selector(filter:) delegate:self normalImage:[UIImage imageNamed:@"NavBarImg_AgentMyFilter"] highlightedImage:nil];
    
    
    
//    _rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"标记", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:1 imageName:nil target:self action:@selector(mark:)];
//    _rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"标记", nil) titleColor:Color_form_TextFieldBackgroundColor titleIndex:1 imageName:nil target:self action:@selector(mark:)];
    
    _rightBtn2 = [GPUtils createButton:CGRectMake(Main_Screen_Width-98, 2, 50, 40) action:@selector(mark:) delegate:self title:Custing(@"核对", nil) font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
    
//    _rightBtn3 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Noraml_NavBar_TitleGray_20 titleIndex:0 imageName:nil target:self action:@selector(Cancel:)];
//    _rightBtn3 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:Color_form_TextFieldBackgroundColor titleIndex:0 imageName:nil target:self action:@selector(Cancel:)];
    
    _rightBtn3 = [GPUtils createButton:CGRectMake(Main_Screen_Width-62, 2, 50, 40) action:@selector(Cancel:) delegate:self title:Custing(@"取消", nil)font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
}

-(void)DealWithNavBtns{
    if (_hasMark) {
        [_rightBtn1 removeFromSuperview];
        [_rightBtn2 removeFromSuperview];
        [_rightBtn3 removeFromSuperview];
        
        [_NavView addSubview:_rightBtn3];
        
//        self.navigationItem.rightBarButtonItems = @[_rightBtn3];
    }else{
        [_rightBtn1 removeFromSuperview];
        [_rightBtn2 removeFromSuperview];
        [_rightBtn3 removeFromSuperview];
        
        [_NavView addSubview:_rightBtn1];
        [_NavView addSubview:_rightBtn2];
//        self.navigationItem.rightBarButtonItems = @[_rightBtn1,_rightBtn2];
    }
}

//创建tableView
-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor=Color_White_Same_20;
    self.tableView.allowsMultipleSelection = YES;//设置可以多选高亮
//    self.tableView.editing = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iPhoneX?@148:@126);
        make.left.right.bottom.equalTo(self.view);
    }];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isLoading) {
            return;
        }
        weakSelf.currPage = 1;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(UIImage *)imageWithColor_Clean:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//记一笔按钮创建
-(void)createAddCostView{
    _AddButton=[[UIButton alloc]init];
    userData *userdata = [userData shareUserData];
    [_AddButton addTarget:self action:@selector(PushAddCost) forControlEvents:UIControlEventTouchUpInside];
    [_AddButton setBackgroundImage:([FestivalStyle isEqualToString:@"1"]&&userdata.SystemType==0)?[UIImage imageNamed:@"Reimburse_Add_Festival"]:[UIImage imageNamed:@"Reimburse_Add"] forState:UIControlStateNormal];
    [_AddButton setBackgroundImage:([FestivalStyle isEqualToString:@"1"]&&userdata.SystemType==0)?[UIImage imageNamed:@"Reimburse_Add_Festival"]:[UIImage imageNamed:@"Reimburse_Add"] forState:UIControlStateSelected];
    [self.view addSubview:_AddButton];
    
    [_AddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.bottom.equalTo(self.view.mas_bottom).offset(iPhoneX ? -102:-68);
        make.height.equalTo(@53);
        make.width.equalTo(@53);
    }];
}

//创建无数据视图
-(void)createNOdataViewWith:(NSInteger)type{
    NSString *tips;
    if (type==1) {
        tips=Custing(@"您还没有消费记录哦", nil);
    }else if (type==2){
        tips=Custing(@"您还没有相关记录哦", nil) ;
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(_meItemArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

#pragma mark network
//请求数据
-(void)requestReserveList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _isLoading = YES;
    NSString *url;
    if (_parameter==nil) {
        url=[NSString stringWithFormat:@"%@", homeRequestCostList];
        [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:_parameter Delegate:self SerialNum:0 IfUserCache:NO];
    }else{
        url=[NSString stringWithFormat:@"%@", homeRequestSearchList];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:_parameter Delegate:self SerialNum:0 IfUserCache:NO];
    }
}
//删除数据
-(void)deleteCostList:(AddDetailsModel* )model{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@", homeRequestDeleteList];
    NSDictionary *parameters = @{@"id":model.Id,@"type": model.type,@"DriveCarId":model.driveCarId,@"DidiOrderId":model.didiOrderId};
//    NSDictionary *parameters = @{@"orderid":[NSString stringWithIdOnNO:model.OrderId],@"datasource":[NSString stringWithIdOnNO:model.DataSource]};//[NSString stringWithIdOnNO:model.start_name];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

#pragma mark - action
//筛选操作
-(void)filter:(id)sender{
    FilterCustomController * filter = [[FilterCustomController alloc]init];
    filter.delegate=self;
    filter.FilterType=_filterType;
    filter.FilterCode=_filterCode;
    [self.navigationController pushViewController:filter animated:YES];
}

//标记操作
-(void)mark:(id)sender{
    _hasMark=YES;
    _AddButton.hidden=YES;
    [self DealWithNavBtns];
    [self.tableView reloadData];
}

-(void)Cancel:(UIButton *)btn{
    _hasMark=NO;
    _AddButton.hidden=NO;
    [self DealWithNavBtns];
    [self.tableView reloadData];
}

-(void)loadData{
    [self requestReserveList];
}

//记一笔
-(void)PushAddCost{
    NewAddCostViewController *add= [[NewAddCostViewController alloc]init];
    add.Action = 1;
    [self.navigationController pushViewController:add animated:YES];
}

-(void)Navback{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        _isLoading = NO;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            _parameter=nil;
            [self.tableView.mj_header endRefreshing];
        }
        return;
    }
    switch (serialNum) {
        case 0://获取抢单列表
        {
            self.meItemArray = [NSMutableArray array];
            NSString *count = @"0";
            _CheckArray=[NSMutableArray array];
            count = [AddDetailsModel getCostRecordDataByDictionary:responceDic Array:_meItemArray Click:_CheckArray amount:count];
            _lab_Amount.text = [GPUtils transformNsNumber:count]; ;
            if (_parameter==nil) {
                [self createNOdataViewWith:1];
            }else if (_parameter!=nil){
                [self createNOdataViewWith:2];
            }
            //修改下载的状态
            _isLoading = NO;
            _parameter=nil;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            self.tableView.userInteractionEnabled=YES;
        }
            break;
        case 1://获取抢单列表
        {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_meItemArray[_index.section]];
//            NSMutableArray *arr = [NSMutableArray arrayWithArray:dic[@"array"]];
//            [arr removeObjectAtIndex:_index.row];
//            [dic setObject:arr forKey:@"array"];
//            if (arr.count>0) {
//                [_meItemArray insertObject:dic atIndex:_index.section];
//            }else{
//                [_meItemArray removeObjectAtIndex:_index.section];
//            }
//            if (_meItemArray.count==0) {
//                [self createNOdataViewWith:1];
//            }else{
//                [self removeNodateViews];
//            }
//            [self.tableView reloadData];
            [self requestReserveList];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil)];
            break;
        }
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    if (serialNum==0) {
        _isLoading=NO;
        [_meItemArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.meItemArray&&_meItemArray.count>0) {
        return self.meItemArray.count;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _meItemArray[section];
    NSArray *arr = dic[@"array"];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.meItemArray&&self.meItemArray.count>0&&self.meItemArray[indexPath.section]) {
        NSDictionary *dic = _meItemArray[indexPath.section];
        NSArray *arr = dic[@"array"];
        AddDetailsModel * model = (AddDetailsModel *)arr[indexPath.row];
        CGSize size;
        if (_hasMark) {
            size= [model.expenseType sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-200, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            return 50+size.height;
        }else{
            size= [model.expenseType sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-225, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            return 50+size.height;
        }
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *_headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 27)];
//    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
//    ImgView.backgroundColor=Color_Blue_Important_20;
    [_headView addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+102, 13.5);
    titleLabel.font=Font_Same_12_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_GrayDark_Same_20;
    [_headView addSubview:titleLabel];
    
    NSDictionary *dic = _meItemArray[section];
    titleLabel.text = dic[@"date"];
    
    _headView.backgroundColor=Color_White_Same_20;
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [_headView addSubview:lineUp];
    
    UIView *downUp=[[UIView alloc]initWithFrame:CGRectMake(0,26.5, Main_Screen_Width,0.5)];
    downUp.backgroundColor=Color_GrayLight_Same_20;
    [_headView addSubview:downUp];
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomNotesCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CustomNotesCell"];
    if (cell==nil) {
        cell=[[CustomNotesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomNotesCell"];
    }
    if (self.meItemArray&&self.meItemArray.count>0&&self.meItemArray[indexPath.section]) {
        NSDictionary *dic = _meItemArray[indexPath.section];
        NSArray *arr = dic[@"array"];
        AddDetailsModel * model = (AddDetailsModel *)arr[indexPath.row];
        if (_hasMark) {
            [cell configViewWithCellInfo:model WithCleck:@"0"];
        }else{
            [cell configViewWithCellInfo:model];
        }
        if (arr.count != indexPath.row +1) {
            CGSize size;
            if (_hasMark) {
                size= [model.expenseType sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-200, 10000) lineBreakMode:NSLineBreakByCharWrapping];
                [cell addSubview:[self createLineViewOfHeight:50+size.height X:67]];
            }else{
                size= [model.expenseType sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-225, 10000) lineBreakMode:NSLineBreakByCharWrapping];
                [cell addSubview:[self createLineViewOfHeight:50+size.height X:67]];
            }
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_hasMark) {
//        NSDictionary *dic_click = _CheckArray[indexPath.section];
//        NSArray *arr_click = dic_click[@"array"];
//        if ([arr_click[indexPath.section]isEqualToString:@"0"]) {
//            [_CheckArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
//        }else{
//            [_CheckArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
//        }
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        NSDictionary *dic = _meItemArray[indexPath.section];
        NSArray *arr = dic[@"array"];
        AddDetailsModel *model= arr[indexPath.row];
        model.OrderId = [NSString stringWithIdOnNO:model.OrderId];
        NewAddCostViewController * add = [[NewAddCostViewController alloc]init];
        add.Id = [model.Id integerValue];
        add.Action = 2;
        add.Enabled_addAgain = 1;
        add.Type = [model.type integerValue];
        add.dateSource = model.DataSource;
        [self.navigationController pushViewController:add animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return !_hasMark;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *copyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"复制", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSDictionary *dic = self.meItemArray[indexPath.section];
        NSArray *arr = dic[@"array"];
        AddDetailsModel *model= arr[indexPath.row];
        model.OrderId = [NSString stringWithIdOnNO:model.OrderId];
        NewAddCostViewController * add = [[NewAddCostViewController alloc]init];
        add.Id = [model.Id integerValue];
        add.Action = 4;
        add.Enabled_addAgain = 1;
        add.Type = [model.type integerValue];
        add.dateSource = @"1";
        [self.navigationController pushViewController:add animated:YES];
        
    }];
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSDictionary *dic = self.meItemArray[indexPath.section];
        NSArray *arr = dic[@"array"];
        AddDetailsModel *model= arr[indexPath.row];
        self.index=indexPath;
        [self deleteCostList:model];
    }];
    copyRowAction.backgroundColor = Color_Sideslip_TableView;
    
    return @[deleteRowAction,copyRowAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;//删除cell
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
    }
}

//筛选代理
-(void)didFilterData:(NSString *)type expenseCode:(NSString *)code
{
    if ([type isEqualToString:@""]) {
        _filterType=@"0";
    }else{
        _filterType=type;
    }
    if ([code isEqualToString:@""]) {
        _filterCode=@"0";
    }else{
        _filterCode=code;
    }
    _parameter = @{@"Type":type,@"ExpenseCode":code};
}







































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
