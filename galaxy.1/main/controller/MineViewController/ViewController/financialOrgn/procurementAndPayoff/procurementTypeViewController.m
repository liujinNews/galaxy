//
//  procurementTypeViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define pageNum  (Main_Screen_Height-NavigationbarHeight-49)/49
#import "reimburProcurementViewController.h"
#import "infoViewController.h"

#import "costCenterData.h"
#import "costCenterCell.h"
#import "procurementTypeViewController.h"
#import "InstructionsViewController.h"

@interface procurementTypeViewController ()<GPClientDelegate>
@property (nonatomic,strong)NSString * returnStr;
//@property (nonatomic,strong)NSString * recordcount;
//@property (assign, nonatomic)NSInteger totalPages;
@property (nonatomic,strong)UIButton * addCVBtn;

@property(nonatomic,strong)NSString * statusStr;

@end

@implementation procurementTypeViewController

-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.statusStr = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([self.returnStr isEqualToString:@"bouu"]) {
        [self requestProcurementTypeData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAddCostDock];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        
    }];
    [self requestProcurementTypeData];
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];

    
    NSString * titleStr;
    if ([self.statusStr isEqualToString:@"procurrement"]) {
        titleStr = Custing(@"采购类型", nil);
    }else{
        titleStr = Custing(@"支付方式", nil);
    }
    [self setTitle:titleStr backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];

    // Do any additional setup after loading the view.
}

-(void)loadData{
    
    [self requestProcurementTypeData];
}


-(void)ImageClicked:(id)obj{
    if ([self.statusStr isEqualToString:@"procurrement"]) {
        InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"procurrementInfo"];
        [self.navigationController pushViewController:INFO animated:YES];
    }else{
        InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"payoffWayInfo"];
        [self.navigationController pushViewController:INFO animated:YES];
    }
}

//添加成本中心
-(void)createAddCostDock{
    
    self.addCVBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 49 - NavigationbarHeight, ScreenRect.size.width, 49) action:@selector(addCostCenterData:) delegate:self title:Custing(@"添加", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    self.addCVBtn.backgroundColor =Color_Blue_Important_20;
    [self.view addSubview:self.addCVBtn];
    
}

-(void)addCostCenterData:(UIButton *)btn{
    self.returnStr = @"bouu";
    NSString * addWay;
    if ([self.statusStr isEqualToString:@"procurrement"]) {
        addWay = @"addProcurement";
    }else{
        addWay = @"addPayoffWay";
    }

    reimburProcurementViewController * reimburs = [[reimburProcurementViewController alloc]initWithType:nil Name:addWay];
    [self.navigationController pushViewController:reimburs animated:YES];
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
    
    costCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:@"costCenterCell"];
    if (cell==nil) {
        cell=[[costCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"costCenterCell"];
    }
    costCenterData *cellInfo = self.resultArray[indexPath.row];
    [cell configProcurementTypeCellInfo:cellInfo];
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
    costCenterData *cellInfo = self.resultArray[indexPath.row];
    NSString * reimbur;
    if ([self.statusStr isEqualToString:@"procurrement"]) {
        reimbur = @"procurement";
    }else{
        reimbur = @"payoffWay";
    }
    NSDictionary *parameters = @{@"idd":[NSString stringWithFormat:@"%@",cellInfo.idd],@"type":[NSString stringWithFormat:@"%@",cellInfo.type]};
    reimburProcurementViewController * reimburs = [[reimburProcurementViewController alloc]initWithType:parameters Name:reimbur];
    [self.navigationController pushViewController:reimburs animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        costCenterData *data= self.resultArray[indexPath.row];
        [self deleteProcurementList:data];
        
    }
}



//采购类型列表
-(void)requestProcurementTypeData {
    
    self.isLoading = YES;
//    NSDictionary * dic =@{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"id",@"IsAsc":@""};
    if ([self.statusStr isEqualToString:@"procurrement"]) {
       [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetPurchaseTypeList] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    }else{
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetPurchasePayList] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    }
    
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//删除采购类型
-(void)deleteProcurementList:(costCenterData* )data
{
    
    if ([self.statusStr isEqualToString:@"procurrement"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",DeletePurchaseType] Parameters:@{@"id":data.idd} Delegate:self SerialNum:1 IfUserCache:NO];
    }else{
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",DeletePurchasePay] Parameters:@{@"id":data.idd} Delegate:self SerialNum:1 IfUserCache:NO];
    }
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
//    if (serialNum ==0) {
//        NSDictionary *result = [responceDic objectForKey:@"result"];
//        self.recordcount = [NSString stringWithFormat:@"%@",[result objectForKey:@"recordcount"]];
//        self.totalPages = [[result objectForKey:@"totalPages"] integerValue];
//        
//    }
    
    
    switch (serialNum) {
        case 0:
            [self.resultArray removeAllObjects];
            [costCenterData GetProcurementListDictionary:responceDic Array:self.resultArray];
            
            break;
        case 1:
            [self requestProcurementTypeData];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
            break;
        default:
            break;
    }
    
    [self createNOdataView];

    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    //修改下载的状态
    self.isLoading = NO;
    
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([self.statusStr isEqualToString:@"procurrement"]) {
        tips=Custing(@"您还没有添加采购类型哦", nil);
    }else{
        tips=Custing(@"您还没有添加支付方式哦", nil);
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
