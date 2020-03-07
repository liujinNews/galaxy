//
//  SecCostClassesController.m
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "SecCostClassesController.h"
#import "CostClassesCell.h"
#import "AddCostClassesController.h"
#import "EditCostClassesController.h"

#define pageNum (Main_Screen_Height-NavigationbarHeight-50)/34+6
@interface SecCostClassesController ()<GPClientDelegate>
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(nonatomic,strong)CostClassesCell *cell;
@property (nonatomic, strong) UIView *dockView;//底部视图
@property(nonatomic,strong)UIButton *addBtn;//添加按钮
@property(nonatomic,strong)NSString *requestType;//请求类型

@end

@implementation SecCostClassesController
-(id)initWithType:(NSString *)type
{
    self=[super initWithType:@"1"];
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * expenseStr;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",_costModel.expenseType]]) {
        expenseStr = [NSString stringWithFormat:@"%@ - %@",_costModel.expenseType,Custing(@"子类别", nil)];
    }else{
        expenseStr = Custing(@"子类别", nil);
    }
    [self setTitle:expenseStr backButton:YES ];
    [self createAddBtn];
    _requestType=@"0";
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(@-50);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self requsetSecCostClasses];
    }
    _requestType=@"1";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:创建添加按钮
-(void)createAddBtn{
    
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    _addBtn=[GPUtils createButton:CGRectMake(0, 0, ScreenRect.size.width, 50)action:@selector(addSecInfo) delegate:self];
    _addBtn.backgroundColor =Color_Blue_Important_20;
    [_addBtn setTitle:Custing(@"添加", nil) forState:UIControlStateNormal];
    _addBtn.titleLabel.font=Font_filterTitle_17 ;
    [_addBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:_addBtn];
}

//MARK:费用类别
-(void)requsetSecCostClasses{
     [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",COSTClasses];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"Status desc,No",@"IsAsc":@"",@"parentid":_costModel.Id};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:添加二级费用类别
-(void)addSecInfo{
    AddCostClassesController *addCostVC=[[AddCostClassesController alloc]initWithType:@"2"];
    addCostVC.superId=_costModel.Id;
    [self.navigationController pushViewController:addCostVC animated:YES];
}
//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        if (![[responceDic objectForKey:@"msg"]isKindOfClass:[NSNull class]]) {
            NSString * error =[responceDic objectForKey:@"msg"];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
            [self dealWithData];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            break;
        case 1:
            self.currPage=1;
            [self requsetSecCostClasses];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil)];
            break;
        case 2:
            self.currPage=1;
            [self requsetSecCostClasses];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"启用成功", nil)];
            break;
        case 3:
            self.currPage=1;
            [self requsetSecCostClasses];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"禁用成功", nil)];
            break;
        default:
            break;
    }
    
    
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

}
//MARK:数据处理
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            CostClassesModel *model=[[CostClassesModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            CostClassesModel *model=[[CostClassesModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
    
    [self createNOdataView];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有添加费用类别哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

#pragma mark - UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width,0.01)];
    return view;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

//是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//删除模式
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CostClassesModel *model=self.resultArray[indexPath.row];
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url=[NSString stringWithFormat:@"%@",deleteCostClasses];
        NSDictionary *parameters =@{@"id":model.Id,@"ExpenseCode":model.expenseCode};;
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
//    // 启用一个置顶按钮
//    UITableViewRowAction *openRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"启用", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//
//        NSString *url=[NSString stringWithFormat:@"%@",updatestatus];
//        NSDictionary *parameters = @{@"Id":model.Id,@"Status": @"1"};
//        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
//
//        NSLog(@"The action to top");
//        NSLog(@"The action to top");
//    }];
//    openRowAction.backgroundColor = [UIColor redColor];
//
//    // 禁用一个置顶按钮
//    UITableViewRowAction *closeRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"禁用", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        NSString *url=[NSString stringWithFormat:@"%@",updatestatus];
//        NSDictionary *parameters = @{@"Id":model.Id,@"Status": @"0"};
//        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
//        NSLog(@"The action to top");
//    }];
//    closeRowAction.backgroundColor = [UIColor redColor];
//
//    // 将设置好的按钮放到数组中返回
//    NSInteger temp = [model.isTemplate integerValue];
//    NSInteger state = [model.status integerValue];
//    if (temp == 1) {
//        if (state == 1) {
//            return @[closeRowAction];
//        }
//        return @[openRowAction];
//    }
    return @[deleteRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}
//处理删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        CostClassesModel *model=self.resultArray[indexPath.row];
        NSString *url=[NSString stringWithFormat:@"%@",deleteCostClasses];
        NSDictionary *parameters =@{@"id":model.Id,@"ExpenseCode":model.expenseCode};;
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"CostClassesCell"];
    if (_cell==nil) {
        _cell=[[CostClassesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CostClassesCell"];
    }
    CostClassesModel *model=(CostClassesModel  *)self.resultArray[indexPath.row];
    NSInteger state = [model.status integerValue];
    [_cell configViewWithModel:model withType:@"2" withStatus:state];
    if (indexPath.row==self.resultArray.count-1) {
        _cell.lineView.hidden=YES;
    }
    if (state == 0) {
        _cell.titleLable.textColor = [UIColor grayColor];
    }
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CostClassesModel * model = _resultArray[indexPath.row];
//    NSInteger Template = [model.isTemplate integerValue];
//    if (Template == 1) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"系统类别，无法修改名称！", nil) duration:1.5];
//        return;
//    }
    
    EditCostClassesController *editVC=[[EditCostClassesController alloc]initWithType:@"2"];
    editVC.editModel=self.resultArray[indexPath.row];
    [self.navigationController pushViewController:editVC animated:YES];
    

}
-(void)loadData{
    [self requsetSecCostClasses];
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
