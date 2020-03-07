//
//  currencyViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define pageNum  (Main_Screen_Height-NavigationbarHeight-49)/49
#import "infoViewController.h"

#import "currencyData.h"
#import "currencyListCell.h"
#import "ModifyCurrencyController.h"
#import "currencyViewController.h"
#import "InstructionsViewController.h"
@interface currencyViewController ()<GPClientDelegate>
@property(nonatomic,strong)NSString * paramValue;
@property (nonatomic,strong)NSString * returnStr;
@property (nonatomic,strong)NSString * recordcount;
@property (assign, nonatomic)NSInteger totalPages;
@property (nonatomic,strong)UIButton * addCVBtn;
@property(nonatomic,strong)UISwitch * currerySw;

@end

@implementation currencyViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.paramValue = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([self.returnStr isEqualToString:@"bouu"]) {
        self.currPage = 1;
        if ([self.paramValue isEqualToString:@"0"]) {
            self.resultArray = nil;
        }else{
            [self requestcurrencyData:self.currPage];
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"币种", nil) backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];

    [self createAddCurrencyDock];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        
    }];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.currPage =1;
    if (![self.paramValue isEqualToString:@"0"]) {
        [self requestcurrencyData:self.currPage];
    }
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
}

-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"currency"];
    [self.navigationController pushViewController:INFO animated:YES];
}

//添加币种
-(void)createAddCurrencyDock{
    
    self.addCVBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 49 - NavigationbarHeight, ScreenRect.size.width, 49) action:@selector(createAddCurrencyData:) delegate:self title:Custing(@"添加", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    self.addCVBtn.backgroundColor =Color_Blue_Important_20;
    [self.view addSubview:self.addCVBtn];
    if ([self.paramValue isEqualToString:@"0"]) {
        self.addCVBtn.hidden = YES;
    }
    
}
-(void)createAddCurrencyData:(UIButton *)btn{
    self.returnStr = @"bouu";
    ModifyCurrencyController * reimburs = [[ModifyCurrencyController alloc]initWithType:nil Name:@"addCurrency"];
    [self.navigationController pushViewController:reimburs animated:YES];
}

-(void)loadData{
    if ([self.paramValue isEqualToString:@"0"]) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //修改下载的状态
        self.isLoading = NO;
        self.addCVBtn.hidden = YES;
    }else{
        self.isLoading = YES;
        [self requestcurrencyData:self.currPage];
    }
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
    
    currencyListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"currencyListCell"];
    if (cell==nil) {
        cell=[[currencyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currencyListCell"];
    }
    currencyData *cellInfo = self.resultArray[indexPath.row];
    [cell configCurrencyCellInfo:cellInfo];
    
    if (indexPath.row==self.resultArray.count-1) {
        cell.line.hidden=YES;
    }
    return cell;
}
//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    self.returnStr = @"bouu";
    currencyData *cellInfo = self.resultArray[indexPath.row];
    if ([cellInfo.currencyCode isEqualToString:@"CNY"]||[cellInfo.currency isEqualToString:@"人民币"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"人民币不能修改", nil) duration:2.0];
        return;
    }else{
        NSDictionary *parameters = @{@"idd":[NSString stringWithFormat:@"%@",cellInfo.idd],@"currency":[NSString stringWithFormat:@"%@",cellInfo.currency],@"currencyCode":[NSString stringWithFormat:@"%@",cellInfo.currencyCode],@"ExchangeRate":[NSString stringWithFormat:@"%@",cellInfo.ExchangeRate],@"no":[NSString stringWithFormat:@"%@",cellInfo.no]};
        ModifyCurrencyController * reimburs = [[ModifyCurrencyController alloc]initWithType:parameters Name:@"ModifyCurrency"];
        [self.navigationController pushViewController:reimburs animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *copyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"设为本位币", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        currencyData *data= self.resultArray[indexPath.row];
        NSDictionary *parameters = @{@"id":data.idd};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@", SETSTANDARDCUR] Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
    }];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        currencyData *data= self.resultArray[indexPath.row];
        if ([data.stdMoney isEqualToString:@"1"]) {
            return ;
        }
        [self deleteCurrencyList:data];
       
    }];
    copyRowAction.backgroundColor = Color_Sideslip_TableView;
    
    return @[deleteRowAction,copyRowAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    currencyData *data= self.resultArray[indexPath.row];
    if ([data.stdMoney isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"本位币不能删除", nil) duration:2.0];
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
    
}

//币种列表
-(void)requestcurrencyData:(NSInteger)page {
    
    NSDictionary * dic =@{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"id",@"IsAsc":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcurrencies] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//删除币种
-(void)deleteCurrencyList:(currencyData* )data
{
    NSDictionary *parameters = @{@"id":data.idd};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@", deletecurrency] Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
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
            if (self.totalPages >= self.currPage) {
                
                [currencyData GetCurrencyListDictionary:responceDic Array:self.resultArray];
            }
            [self createNOdataView];
            break;
        case 1:
            [self requestcurrencyData:self.currPage];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
            break;
        case 2:
            self.currPage=1;
            [self requestcurrencyData:self.currPage];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:2.0];
            break;
        default:
            break;
    }
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
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有币种哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
