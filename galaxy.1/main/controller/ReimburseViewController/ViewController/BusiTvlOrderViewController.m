//
//  BusiTvlOrderViewController.m
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BusiTvlOrderViewController.h"
#import "XFSegementView.h"
#import "RouteTableViewCell.h"
#import "NewAddCostViewController.h"
//#import "RouteDiDiDateView.h"
#import "RouteDidiModel.h"
//#import "DiDiImportCell.h"
#import "BusiTvlOrderDateView.h"
//#import "BusiTvlOrderModel.h"
#import "BusiTvlOrderCell.h"
#import "BusiImportViewController.h"
#import "OrderTypeModel.h"

#define R_DateW (525/750.0)
#define R_SepeW (1/750.0)
#define R_OdTyW (224/750.0)

@interface BusiTvlOrderViewController ()<GPClientDelegate,TouchLabelDelegate>

@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)BusiTvlOrderCell *cell;
@property(nonatomic,assign)NSInteger segIndex;//分段器当前选择
@property(nonatomic,strong)NSMutableArray *chooseArray;//记录批量点击


//区分viewwillapper是否请求数据
@property(nonatomic,assign)BOOL requestType;

@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign) BOOL  isEditing;
@property(nonatomic,strong)UIBarButtonItem* rightBtn1;
@property(nonatomic,strong)UIBarButtonItem* rightBtn2;
@property(nonatomic,strong)UIBarButtonItem* rightBtn3;

//订单类型tableview
@property (nonatomic,strong)UITableView *typeTable;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *typeDataArr;
//搜索输入框
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UILabel *searchLab;
@property (nonatomic,strong) UITextField *searchTxf;
@property (nonatomic,strong) UIButton *searchBtn;

/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView * dockView;

@property (nonatomic, strong) UITextField *txf_state_date;
@property (nonatomic, strong) UITextField *txf_end_date;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) BusiTvlOrderDateView *route;
@property (nonatomic, strong) UIView *seView;
@property (nonatomic, strong) UIButton *btnType;

@property (nonatomic, strong) NSMutableArray *orderTypeArr;

@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *orderTypeId;

@end

@implementation BusiTvlOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"商旅订单", nil) backButton:YES];
    _segIndex = 0;
    [self createViews];
    [self createRightBtns];
    _chooseArray=[NSMutableArray array];
    _requestType = NO;
}

////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType) {
        self.currPage=1;
        if (_segIndex==0) {
            _segIndex=0;
        }else if (_segIndex==1) {
            _segIndex=1;
        }
//        [self requestDidiGetOrders];
        [self requestBusiTvlOrders];
    }
    _requestType = YES;
    self.dockView.userInteractionEnabled=YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (NSMutableArray *)orderTypeArr{
    if (_orderTypeArr == nil) {
        _orderTypeArr = [NSMutableArray array];
        NSArray *idArr = @[@"1",@"2",@"3",@"4",@""];
        NSArray *typeArr = @[Custing(@"机票", nil),Custing(@"酒店", nil),Custing(@"火车票", nil),Custing(@"用车", nil),Custing(@"全部", nil)];
        for (int i = 0 ; i < idArr.count; i ++) {
            OrderTypeModel *orderModel = [[OrderTypeModel alloc] init];
            orderModel.orderTypeId = idArr[i];
            orderModel.orderType = typeArr[i];
            [_orderTypeArr addObject:orderModel];
        }
    }
    return _orderTypeArr;
}


//MARK:分段器创建
-(void)createViews{
    __weak typeof(self) weakSelf = self;
    
    //分段选择器
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type=@"1";
    _segementView.titleArray = @[Custing(@"未导入", nil),Custing(@"已导入",nil)];
    _segementView.titleColor=Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor=Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont=13.f;
    [self.view addSubview:_segementView];
    
    //日期选择视图
    self.txf_state_date = [UITextField new];
    self.txf_end_date = [UITextField new];
    BusiTvlOrderDateView *route = [[BusiTvlOrderDateView alloc]initView:_txf_state_date endTxf:_txf_end_date];
    route.block = ^{
        self.currPage=1;
//        [weakSelf requestDidiGetOrders];
        [weakSelf requestBusiTvlOrders];
    };
    [self.view addSubview:route];
    route.frame = CGRectMake(0, 44, Main_Screen_Width-135, 50);
    self.route = route;
//    [route mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(@44);
////        make.left.right.equalTo(self.view);
//        make.left.equalTo(self.view);
////        make.right.equalTo(self.view).offset(@-200);
//        make.height.equalTo(@64);
//    }];
    
    //竖向分割线
    UIView *seView = [[UIView alloc]init];
    seView.backgroundColor = Color_LineGray_Same_20;
    [self.seView addSubview:seView];
    seView.frame = CGRectMake(Main_Screen_Width - 120.5, 61.5, 1, 15);
    [self.view addSubview:seView];
    self.seView = seView;
    //订单类型button
    UIButton *btnType = [UIButton buttonWithType:UIButtonTypeSystem];
    btnType.frame = CGRectMake(Main_Screen_Width - 105, 44, 70, 50);
    [btnType setTitle:Custing(@"订单类型", nil) forState:UIControlStateNormal];
    [btnType setTitleColor:Color_Black_Important_20 forState:UIControlStateNormal];
    [btnType addTarget:self action:@selector(btnTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnType];
    self.btnType = btnType;
    //图片
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width - 27.5, 61.5, 15, 15)];
    arrowImg.image = [UIImage imageNamed:@"arrowDown"];
    self.isOpen = NO;
    [self.view addSubview:arrowImg];
    self.arrowImg = arrowImg;
    //订单类型表
    self.typeTable = [[UITableView alloc] init];
    _typeTable.frame = CGRectMake(Main_Screen_Width - 110, 94, 110, 0);
    self.typeTable.delegate = self;
    self.typeTable.dataSource = self;
    [self.view addSubview:_typeTable];

    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Color_LineGray_Same_20;
    [self.view addSubview:lineView];
    self.lineView = lineView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(94);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@0.3);
    }];
    //搜索框🔍
    _searchView = [[UIView alloc] init];
    _searchView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@94.3);
        make.left.right.equalTo(self.view);
        make.height.equalTo(50);
    }];
    _searchLab = [[UILabel alloc]init];
    _searchLab.frame = CGRectMake(10, 0, 70, 50);
    _searchLab.text = Custing(@"服务商", nil);
    _searchLab.textColor = Color_Black_Important_20;
    [_searchView addSubview:_searchLab];
    _searchLab.textAlignment = NSTextAlignmentLeft;
    _searchLab.font = [UIFont systemFontOfSize:15.0f];

    //输入框
    _searchTxf = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, Main_Screen_Width - 80-50, 50)];
    _searchTxf.borderStyle = UITextBorderStyleNone;
    _searchTxf.font = [UIFont systemFontOfSize:15.0];
    _searchTxf.placeholder = Custing(@"请输入服务商", nil);
    [_searchView addSubview:_searchTxf];
    //搜索按钮
    _searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchBtn.frame = CGRectMake(Main_Screen_Width-50, 10,50, 30);
    _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_searchBtn addTarget: self action:@selector(searchOrder:) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [_searchView addSubview:_searchBtn];
    
    //分割线
       UIView *lineTwoView = [[UIView alloc] init];
       lineTwoView.backgroundColor = Color_LineGray_Same_20;
       [self.view addSubview:lineTwoView];
       [lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view).offset(144.3);
           make.left.right.equalTo(self.view);
           make.height.equalTo(@0.3);
       }];
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView updateBatchBtnWithTitle:Custing(@"批量导入", nil)];
    
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@144.6);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.dockView.top);
        
    }];
    [self.dockView setBtnClickBlock:^(NSInteger index) {
        if (index==0) {
            NSString *str;
            if ([weakSelf.chooseArray containsObject:@"0"]) {
                str=@"1";
            }else{
                str=@"0";
            }
            NSInteger j=weakSelf.chooseArray.count;
            [weakSelf.chooseArray removeAllObjects];
            for (int i=0; i<j; i++) {
                [weakSelf.chooseArray addObject:str];
            }
            [weakSelf changeDockTitleWithReload:YES];
        }else if (index==1){
            [weakSelf batchImport:nil];
        }
    }];
}
- (void)btnTypeClick:(UIButton *)btn{
    self.isOpen = !self.isOpen;
    __weak typeof(self) weakSelf = self;
    if (self.isOpen) {
        [self.view bringSubviewToFront:self.typeTable];
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.typeTable.frame = CGRectMake(Main_Screen_Width - 110, 108, 110, 150);
            [weakSelf.typeTable reloadData];
        } completion:nil];
    }else{

        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.typeTable.frame = CGRectMake(Main_Screen_Width - 110, 108, 110, 0);
        } completion:nil];
    }
}

- (void)searchOrder:(UIButton *)btn{
    [self requestBusiTvlOrders];
}
//MARK:创建编辑筛选按钮
-(void)createRightBtns{
    _rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"批量导入", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(rightClick:)];
    _rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Noraml_NavBar_TitleGray_20 titleIndex:0 imageName:nil target:self action:@selector(rightClick:)];
}
-(void)DealWithNavBtns{
    if (_segIndex==0) {
        if (_isEditing==NO) {
            self.navigationItem.rightBarButtonItems = @[_rightBtn1];
        }else{
            self.navigationItem.rightBarButtonItems = @[_rightBtn2];
        }
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)touchLabelWithIndex:(NSInteger)index{

    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            self.currPage=1;
            self.searchBtn.alpha = 1;
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            self.currPage=1;
            self.searchBtn.alpha = 0;
            break;
        default:
            break;
    }
//    [self requestDidiGetOrders];
    [self requestBusiTvlOrders];
    self.navigationItem.rightBarButtonItems = nil;
    _isEditing=NO;
    [self changeDockViewFrame];
}
-(void)requestDidiGetOrders{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url = [NSString stringWithFormat:@"%@",DidiGetOrders];
    self.isLoading = YES;
    NSDictionary *dic = @{@"call_phone":self.str_phone,@"pay_type":self.str_payType,@"start_date":_txf_state_date.text,@"end_date":_txf_end_date.text,@"Imported":[NSNumber numberWithInteger:_segIndex],@"pageindex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"pagesize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
- (void)requestBusiTvlOrders{
    [YXSpritesLoadingView showWithText:Custing(@"光速加速中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url = [NSString stringWithFormat:@"%@",GetTmcOrder];
    self.isLoading = YES;
    NSDictionary *dic = @{@"pagesize":@20,@"pageindex":[NSString stringWithFormat:@"%ld",self.currPage],@"OrderTimeS":self.txf_state_date.text,@"OrderTimeE":self.txf_end_date.text,@"OrderType":_orderTypeId,@"Import":[NSNumber numberWithInteger:_segIndex]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
        [_chooseArray removeAllObjects];
    }
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading=NO;
        self.dockView.userInteractionEnabled=YES;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        return;
    }
    
    switch (serialNum) {
        case 0:
            [self DealWithNavBtns];
            [self dealWithData];
            [self createNOdataView];
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self changeDockTitleWithReload:YES];
            break;
        case 1:
            self.currPage=1;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"导入成功", nil) duration:2.0];
            [self loadData];
            break;
        case 2:
            [self DealWithNavBtns];
            [self dealWithData];
            [self createNOdataView];
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self changeDockTitleWithReload:YES];
        default:
            break;
    }
}

//MARK:数据处理
-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            RouteDidiModel *model=[[RouteDidiModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
            if (_segIndex==0) {
                [_chooseArray addObject:@"0"];
            }
        }
    }
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    self.dockView.userInteractionEnabled=YES;
    [self.resultArray removeAllObjects];
    [_chooseArray removeAllObjects];
    self.isLoading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableView == tableView) {
        return self.resultArray.count;
    }else if(tableView == self.typeTable){
        return self.orderTypeArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 198;
//    return 115;
    if (self.tableView == tableView) {
        return 115;
    }else if(tableView == self.typeTable){
        return 30;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   if (self.tableView == tableView) {
       NSString *chooseStr;
          if (_segIndex==0) {
              chooseStr=_chooseArray[indexPath.row];
          }else if(_segIndex==1){
              chooseStr = @"0";
          }
       _cell = [tableView dequeueReusableCellWithIdentifier:@"DiDiImportCell"];
       if (_cell==nil) {
           _cell=[[BusiTvlOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiDiImportCell"];
       }
       [_cell configCellWithModel:self.resultArray[indexPath.row]  isEdit:_isEditing isChoosed:chooseStr];
       return _cell;
   }else if(tableView == self.typeTable){
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
       if (cell==nil) {
           cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
           UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 70, 20)];
           label.textAlignment = NSTextAlignmentCenter;
           label.textColor = Color_Black_Important_20;
           OrderTypeModel *orderModel = self.orderTypeArr[indexPath.row];
           label.text = orderModel.orderType;
           [cell.contentView addSubview:label];
       }
       return cell;
   }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (_segIndex == 0) {
                RouteDidiModel *model = self.resultArray[indexPath.row];
                if (_isEditing) {
        //            if (![NSString isEqualToNullAndZero:model.reimbursementTypId]||![NSString isEqualToNull:model.expenseCode]) {
        //                [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"未关联数据,不能导入", nil) duration:2.0];
        //                return;
        //            }
                    NSString *chooseStr=_chooseArray[indexPath.row];
                    if ([chooseStr isEqualToString:@"1"] ){
                        [_chooseArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                    }else{
                        [_chooseArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                    }
                    BusiTvlOrderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    cell.choosed = _chooseArray[indexPath.row];
                    [self changeDockTitleWithReload:NO];
                }else{
        //            NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
        ////            add.dateSource = @"4";
        //            add.dateSource = @"9";
        //            add.model_didi = model;
        //            add.Enabled_addAgain = 1;
        //
        //            add.dic_route = [NSDictionary dictionary];
                    BusiImportViewController *vc = [[BusiImportViewController alloc] init];
                    vc.importModel = model;
                    vc.isMultiple = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
    }else if (tableView == self.typeTable){
        OrderTypeModel *orderModel = self.orderTypeArr[indexPath.row];
        self.orderType = orderModel.orderType;
        self.orderTypeId = orderModel.orderTypeId;
        [self.btnType setTitle:_orderType forState:UIControlStateNormal];
        [self btnTypeClick:self.btnType];
    }
    
}

//MARK:批量同意操作
-(void)batchImport:(UIButton *)btn{
    if ([_chooseArray containsObject:@"1"]==NO) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"至少选择一条导入", nil) duration:2.0];
        return;
    }
    self.dockView.userInteractionEnabled=NO;
//    NSMutableArray *array  = [NSMutableArray array];
//    for (int i=0; i<_chooseArray.count; i++) {
//        NSString *str=_chooseArray[i];
//        if ([str isEqualToString:@"1"]) {
//            RouteDidiModel *model = self.resultArray[i];
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [dict setValue:[NSString stringWithFormat:@"%@",model.reimbursementTypId] forKey:@"type"];
//            [dict setValue:@"29" forKey:@"dataSource"];
//            [dict setValue:[NSString stringWithIdOnNO:model.order_id] forKey:@"didiOrderId"];
//            [dict setValue:[NSString stringWithIdOnNO:model.expenseCat] forKey:@"expenseCat"];
//            [dict setValue:[NSString stringWithIdOnNO:model.expenseCatCode] forKey:@"expenseCatCode"];
//            [dict setValue:[NSString stringWithIdOnNO:model.expenseCode] forKey:@"expenseCode"];
//            [dict setValue:[NSString stringWithIdOnNO:model.expenseIcon] forKey:@"expenseIcon"];
//            [dict setValue:[NSString stringWithIdOnNO:model.expenseType] forKey:@"expenseType"];
//            [dict setValue:[NSString stringWithIdOnNO:model.remark] forKey:@"remark"];
//            [dict setValue:[NSString stringWithIdOnNO:model.tag] forKey:@"tag"];
//            if ([[NSString stringWithFormat:@"%@",model.pay_type]isEqualToString:@"1"]) {
//                [dict setValue:Custing(@"个人支付", nil) forKey:@"payType"];
//                [dict setValue: @"1" forKey:@"payTypeId"];
//                [dict setValue:[NSString isEqualToNull:model.personal_real_pay]?[NSString stringWithFormat:@"%@",model.personal_real_pay]:@"0" forKey:@"amount"];
//            }else{
//                [dict setValue:Custing(@"企业支付", nil) forKey:@"payType"];
//                [dict setValue: @"2" forKey:@"payTypeId"];
//                [dict setValue:[NSString isEqualToNull:model.company_real_pay]?[NSString stringWithFormat:@"%@",model.company_real_pay]:@"0" forKey:@"amount"];
//            }
//
//            NSString *departureTime = [[NSString stringWithIdOnNO:model.departure_time] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
//
//            NSString *departureDay = departureTime.length >10 ? [departureTime substringToIndex:10]:@"";
//            NSString *departureHour = departureTime.length >16 ? [departureTime substringToIndex:16]:@"";
//
//
//            NSString *finishTime = [[NSString stringWithIdOnNO:model.finish_time] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
//
////            NSString *finishDay = finishTime.length >10 ? [finishTime substringToIndex:10]:@"";
//            NSString *finishHour =finishTime.length >16 ? [finishTime substringToIndex:16]:@"";
//
//            if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Trans"]) {
//                [dict setValue:[NSString stringWithIdOnNO:model.start_name] forKey:@"transDCityName"];
//                [dict setValue:[NSString stringWithIdOnNO:model.end_name] forKey:@"transACityName"];
//                [dict setValue:departureHour forKey:@"transFromDate"];
//                [dict setValue:finishHour forKey:@"transToDate"];
//
//            }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Taxi"]){
//                [dict setValue:[NSString stringWithIdOnNO:model.start_name] forKey:@"taxiDCityName"];
//                [dict setValue:[NSString stringWithIdOnNO:model.end_name] forKey:@"taxiACityName"];
//                [dict setValue:departureHour forKey:@"taxiFromDate"];
//                [dict setValue:finishHour forKey:@"taxiToDate"];
//            }
//            [dict setValue:departureDay forKey:@"expenseDate"];
//            [array addObject:dict];
//        }
//    }
//    NSDictionary *dic = @{@"Data":[NSString transformToJson:array]};
//    [[GPClient shareGPClient]REquestByPostWithPath:XB_BatchImportDidi Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    BusiImportViewController *vc = [[BusiImportViewController alloc] init];
//    vc.dic = dic;
    vc.isMultiple = YES;
    vc.chooseArray = self.chooseArray;
    vc.resultArray = self.resultArray;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadData{
//    [self requestDidiGetOrders];
    [self requestBusiTvlOrders];
}

//MARK:编辑按钮
-(void)rightClick:(UIButton *)btn{
    _isEditing = !_isEditing;
    [_chooseArray removeAllObjects];
    for (int i=0; i<self.resultArray.count; i++) {
        [_chooseArray addObject:@"0"];
    }
    [self DealWithNavBtns];
    [self changeDockViewFrame];
    [self changeDockTitleWithReload:YES];
    
}
-(void)changeDockViewFrame{
    if (_isEditing) {
        [self.dockView updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(Main_Screen_Width, 50));
        }];
    }else{
        [self.dockView updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
    }
}
-(void)changeDockTitleWithReload:(BOOL)reload{
    if (_isEditing) {
        NSInteger i=0;
        for (NSString *str in _chooseArray) {
            if ([str isEqualToString:@"1"]) {
                i++;
            }
        }
        [self.dockView updateSelectAllBtnWithTitle:[NSString stringWithFormat:@"%ld/%ld",i,_chooseArray.count] withSelected:![_chooseArray containsObject:@"0"]];
    }
    if (reload) {
        [self.tableView reloadData];
    }
}
//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if (_segIndex==0) {
        tips=Custing(@"您还没有未导入订单哦", nil);
    }else if (_segIndex==1){
        tips=Custing(@"您还没有已导入订单哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

//- (NSMutableArray *)resultArray{
//    if (_resultArray == nil) {
//        _resultArray = [NSMutableArray array];
//        RouteDidiModel *model = [[RouteDidiModel alloc]init];
//        model.departure = @"北京天安门";
//        model.destination = @"";
//        model.startDate = @"2019-12-10 08:06";
//        model.endDate = @"2019/12/10 08:06";
//        model.amount = @"3000.00";
//        model.serviceProviderCode = @"LA517";
//        model.serviceProviderName = @"差旅壹号";
//        model.orderStatus = @"已付款";
//        model.orderType = @"6";
//        [_resultArray addObject:model];
//    }
//    return _resultarray;
//}


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
