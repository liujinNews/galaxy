//
//  CtripLeadController.m
//  galaxy
//
//  Created by hfk on 2016/10/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CtripLeadController.h"
#import "CtripLeadModel.h"
#import "CtripLoadInViewController.h"
#import "CtripLeadCell.h"

#define pageNum  (Main_Screen_Height-NavigationbarHeight-44)/70+6
@interface CtripLeadController ()<GPClientDelegate,TouchLabelDelegate>

@property (nonatomic, assign) NSInteger totalPage;//系统分页数
@property (nonatomic, strong) NSDictionary *resultDict;//下载成功字典
@property (nonatomic, assign) NSInteger segIndex;//分段器当前选择
@property (nonatomic, assign) BOOL requestType;
@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign) BOOL  isEditing;
@property (nonatomic, strong) UIBarButtonItem *rightBtn1;
@property (nonatomic, strong) UIBarButtonItem *rightBtn2;
@property (nonatomic, strong) DoneBtnView *dockView;
@property (nonatomic, copy) NSString *str_chooseType;


@end

@implementation CtripLeadController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"携程商旅", nil) backButton:YES ];
    self.segIndex = 0;
    self.segIndex = 0;
    [self createViews];
    self.requestType = NO;
}

//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.requestType) {
        self.currPage = 1;
        [self requestCtripLead];
    }
    self.requestType = YES;
}
//MARK:创建分段器
-(void)createViews{
    self.rightBtn1 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"批量导入", nil) titleColor:self.userdatas.SystemType == 1 ? Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(rightClick:)];
    self.rightBtn2 = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType == 1 ? Color_form_TextFieldBackgroundColor:Noraml_NavBar_TitleGray_20 titleIndex:0 imageName:nil target:self action:@selector(rightClick:)];
    
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type = @"1";
    _segementView.titleArray = @[Custing(@"未导入", nil) ,Custing(@"已导入", nil)];
    _segementView.titleColor = Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor = Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont = 13.f;
    [self.view addSubview:_segementView];
    
    self.dockView = [[DoneBtnView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled = YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.dockView.mas_top);
    }];
    
    [self.dockView updateBatchBtnWithTitle:Custing(@"批量导入", nil)];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"isChoosed MATCHES %@", @"0"];
            NSArray *filterArray = [weakSelf.resultArray filteredArrayUsingPredicate:pred];
        
            NSString *str = @"0";
            if (filterArray.count > 0) {
                str = @"1";
            }
            for (CtripLeadModel * model in weakSelf.resultArray) {
                model.isChoosed = str;
            }
            [weakSelf changeDockTitleWithReload:YES];
        }else if (index==1){
            [weakSelf batchImport:nil];
        }
    };
}
-(void)DealWithNavBtns{
    if (_segIndex == 0) {
        self.navigationItem.rightBarButtonItems = self.isEditing ? @[_rightBtn2]:@[_rightBtn1];
    }
}
- (void)touchLabelWithIndex:(NSInteger)index{
    if (index == self.segIndex) {
        return;
    }
    _segIndex = index;
    self.currPage = 1;
    [self requestCtripLead];
    self.navigationItem.rightBarButtonItems = nil;
    self.isEditing = NO;
    [self changeDockViewFrame];
}
//MARK:添加网络数据
-(void)requestCtripLead{
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],
                                 @"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum]
                                 };
    [[GPClient shareGPClient]REquestByPostWithPath:_segIndex == 0 ? XB_CtripNoImport:XB_CtripImport Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    self.resultDict = responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        self.dockView.userInteractionEnabled = YES;
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading = NO;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (self.currPage == 1 && self.isLoading) {
        [self.resultArray removeAllObjects];
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
        {
            self.dockView.userInteractionEnabled = YES;
            self.currPage = 1;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"导入成功", nil) duration:1.0];
            __weak typeof(self) weakSelf = self;
            [self performBlock:^{
                [weakSelf loadData];
            } afterDelay:1];
        }
            break;
        default:
            break;
    }
}
//MARK:数据处理
-(void)dealWithData{
    NSDictionary *result = self.resultDict[@"result"];
    self.totalPage = [result[@"totalPages"] integerValue] ;
    if (self.currPage <= _totalPage) {
        NSArray *array = result[@"items"];
        for (NSDictionary *dict in array) {
            CtripLeadModel *model = [[CtripLeadModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            model.isChoosed = @"0";
            [self.resultArray addObject:model];
        }
    }
}
//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.dockView.userInteractionEnabled = YES;
    self.isLoading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)loadData{
    [self requestCtripLead];
}
//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor = Color_White_Same_20;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CtripLeadModel * model = (CtripLeadModel *)self.resultArray[indexPath.section];
    return [CtripLeadCell cellHeightWithModel:model];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CtripLeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CtripLeadCell"];
    if (cell == nil) {
        cell = [[CtripLeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CtripLeadCell"];
    }
    CtripLeadModel * model = (CtripLeadModel *)self.resultArray[indexPath.section];
    [cell configCtripViewCellWithModel:model withIsEdit:self.isEditing withIndex:self.segIndex];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segIndex != 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"记录不能被导入", nil) duration:2.0];
        return;
    }
    CtripLeadModel *leadModel = self.resultArray[indexPath.section];
    if (self.isEditing) {
        if ([leadModel.isChoosed isEqualToString:@"1"]) {
            leadModel.isChoosed = @"0";
        }else{
            leadModel.isChoosed = @"1";
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self changeDockTitleWithReload:NO];
    }else{
        AddDetailsModel *model = [[AddDetailsModel alloc]init];
        model.reimbursementTyp = [NSString stringWithIdOnNO:leadModel.reimbursementTyp];
        model.reimbursementTypId = [NSString stringWithIdOnNO:leadModel.reimbursementTypId];
        model.expenseCode = [NSString stringWithIdOnNO:leadModel.expenseCode];
        model.expenseType = [NSString stringWithIdOnNO:leadModel.expenseType];
        model.expenseIcon = [NSString stringWithIdOnNO:leadModel.expenseIcon];
        model.expenseCatCode = [NSString stringWithIdOnNO:leadModel.expenseCatCode];
        model.expenseCat = [NSString stringWithIdOnNO:leadModel.expenseCat];
        model.expenseDate = [NSString stringWithIdOnNO:leadModel.createTime];
        model.cityCode = [NSString stringWithIdOnNO:leadModel.cityCode];
        model.cityName = [NSString stringWithIdOnNO:leadModel.cityName];
        model.remark = [NSString stringWithFormat:@"%@\n%@",leadModel.name,leadModel.orderDate];
        model.OrderId = [NSString stringWithIdOnNO:leadModel.orderID];
        model.invoiceType = [NSString stringWithIdOnNO:leadModel.invoiceType];
        model.invoiceTypeCode = [NSString stringWithIdOnNO:leadModel.invoiceTypeCode];
        model.invoiceTypeName = [NSString stringWithIdOnNO:leadModel.invoiceTypeName];
        model.taxRate = [NSString stringWithIdOnNO:leadModel.taxRate];
        model.airlineFuelFee = [NSString stringWithIdOnNO:leadModel.airlineFuelFee];
        model.airTicketPrice = [NSString stringWithIdOnNO:leadModel.airTicketPrice];
        model.developmentFund = [NSString stringWithIdOnNO:leadModel.developmentFund];
        model.fuelSurcharge = [NSString stringWithIdOnNO:leadModel.fuelSurcharge];
        model.otherTaxes = [NSString stringWithIdOnNO:leadModel.otherTaxes];
        model.amount = [NSString stringWithIdOnNO:leadModel.amount];
        model.tag = [NSString stringWithIdOnNO:leadModel.tag];
        if ([[NSString stringWithFormat:@"%@",leadModel.orderType]isEqualToString:@"4"] && leadModel.orderDate.length > 20 && [leadModel.orderDate containsString:@"-"]) {
            NSArray *arr = [leadModel.orderDate componentsSeparatedByString:@"-"];
            if (arr.count == 2) {
                model.checkInDate = [arr[0] substringToIndex:10];
                model.checkOutDate = [arr[1] substringToIndex:10];
                NSInteger date = [NSString datebydays:model.checkOutDate date2:model.checkInDate];
                model.totalDays = [NSString stringWithFormat:@"%ld",(long)date];
            }
        }
        
        NewAddCostViewController * add = [[NewAddCostViewController alloc]init];
        add.Action = 1;
        add.Enabled_addAgain = 1;
        add.dateSource = @"10";
        add.model_addDetail = model;
        [self.navigationController pushViewController:add animated:YES];
    }
}
//MARK:编辑按钮
-(void)rightClick:(UIButton *)btn{
    self.isEditing = !self.isEditing;
    for (CtripLeadModel *model in self.resultArray) {
        model.isChoosed = @"0";
    }
    [self DealWithNavBtns];
    [self changeDockViewFrame];
    [self changeDockTitleWithReload:YES];
}
-(void)changeDockViewFrame{
    __weak typeof(self) weakSelf = self;
    [self.dockView updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(Main_Screen_Width, (weakSelf.isEditing && weakSelf.segIndex == 0) ? 50:0));
    }];
}
-(void)changeDockTitleWithReload:(BOOL)reload{
    if (self.segIndex == 0 && self.isEditing) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"isChoosed MATCHES %@", @"1"];
        NSArray *filterArray = [self.resultArray filteredArrayUsingPredicate:pred];
        [self.dockView updateSelectAllBtnWithTitle:[NSString stringWithFormat:@"%lu/%lu",(unsigned long)filterArray.count,(unsigned long)self.resultArray.count] withSelected:(filterArray.count == self.resultArray.count)];
    }
    if (reload) {
        [self.tableView reloadData];
    }
}
//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if (_segIndex==0) {
        tips=Custing(@"您还没有未导入记录哦", nil) ;
    }else if (_segIndex==1){
        tips=Custing(@"您还没有已导入记录哦", nil) ;
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}


//MARK:批量同意操作
-(void)batchImport:(UIButton *)btn{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isChoosed MATCHES %@", @"1"];
    NSArray *filterArray = [self.resultArray filteredArrayUsingPredicate:pred];
    if (filterArray.count == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"至少选择一条导入", nil) duration:2.0];
        return;
    }
    self.dockView.userInteractionEnabled = NO;
    NSMutableArray *array  = [NSMutableArray array];
    for (CtripLeadModel *leadModel in filterArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringIsExist:leadModel.reimbursementTyp] forKey:@"reimbursementTyp"];
        [dict setObject:[NSString stringIsExist:leadModel.reimbursementTypId] forKey:@"reimbursementTypId"];
        [dict setObject:[NSString stringIsExist:leadModel.reimbursementTypId] forKey:@"type"];
        [dict setObject:[NSString stringIsExist:leadModel.expenseCode] forKey:@"expenseCode"];
        [dict setObject:[NSString stringIsExist:leadModel.expenseType] forKey:@"expenseType"];
        [dict setObject:[NSString stringIsExist:leadModel.expenseIcon] forKey:@"expenseIcon"];
        [dict setObject:[NSString stringIsExist:leadModel.expenseCatCode] forKey:@"expenseCatCode"];
        [dict setObject:[NSString stringIsExist:leadModel.expenseCat] forKey:@"expenseCat"];
        [dict setObject:[NSString stringIsExist:leadModel.createTime] forKey:@"expenseDate"];
        [dict setObject:[NSString stringIsExist:leadModel.cityCode] forKey:@"cityCode"];
        [dict setObject:[NSString stringIsExist:leadModel.cityName] forKey:@"cityName"];
        [dict setObject:[NSString stringWithFormat:@"%@\n%@",leadModel.name,leadModel.orderDate] forKey:@"remark"];
        [dict setObject:[NSString stringIsExist:leadModel.orderID] forKey:@"OrderId"];
        [dict setObject:[NSString stringIsExist:leadModel.invoiceType] forKey:@"invoiceType"];
        [dict setObject:[NSString stringIsExist:leadModel.invoiceTypeCode] forKey:@"invoiceTypeCode"];
        [dict setObject:[NSString stringIsExist:leadModel.invoiceTypeName] forKey:@"invoiceTypeName"];
        [dict setObject:[NSString stringIsExist:leadModel.taxRate] forKey:@"taxRate"];
        [dict setObject:[NSString stringIsExist:leadModel.amount] forKey:@"amount"];
        [dict setObject:[NSString stringIsExist:leadModel.tag] forKey:@"tag"];
        [dict setObject:@"10" forKey:@"DataSource"];
        if ([[NSString stringWithFormat:@"%@",leadModel.orderType]isEqualToString:@"2"]) {
            [dict setObject:[NSString stringIsExist:leadModel.airlineFuelFee] forKey:@"airlineFuelFee"];
            [dict setObject:[NSString stringIsExist:leadModel.developmentFund] forKey:@"developmentFund"];
            [dict setObject:[NSString stringIsExist:leadModel.airTicketPrice] forKey:@"airTicketPrice"];
            [dict setObject:[NSString stringIsExist:leadModel.fuelSurcharge] forKey:@"fuelSurcharge"];
            [dict setObject:[NSString stringIsExist:leadModel.otherTaxes] forKey:@"otherTaxes"];
        }
        if ([[NSString stringWithFormat:@"%@",leadModel.orderType]isEqualToString:@"4"] && leadModel.orderDate.length > 20 && [leadModel.orderDate containsString:@"-"]) {
            NSArray *arr = [leadModel.orderDate componentsSeparatedByString:@"-"];
            if (arr.count == 2) {
                [dict setObject:[arr[0] substringToIndex:10] forKey:@"checkInDate"];
                [dict setObject:[arr[1] substringToIndex:10] forKey:@"checkOutDate"];
                NSInteger date = [NSString datebydays:[arr[1] substringToIndex:10] date2:[arr[0] substringToIndex:10]];
                [dict setObject:[NSString stringWithFormat:@"%ld",(long)date] forKey:@"totalDays"];
            }
        }
        [array addObject:dict];
    }
    NSDictionary *dic = @{@"Data":[NSString transformToJson:array]};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_BatchImportCtrip Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
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
