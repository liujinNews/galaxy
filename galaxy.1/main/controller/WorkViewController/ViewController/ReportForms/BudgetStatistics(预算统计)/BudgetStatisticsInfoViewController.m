//
//  BudgetStatisticsInfoViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BudgetStatisticsInfoViewController.h"
#import "BudgetStatisticsTableViewCell.h"

@interface BudgetStatisticsInfoViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *Arr_mainFld;//视图加载数据

@property (nonatomic, strong) NSDictionary *dic_requst;//视图加载数据

@end

@implementation BudgetStatisticsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"费用类别", nil) backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _tbv_tableview.dataSource = self;
    _tbv_tableview.delegate = self;
    _tbv_tableview.rowHeight = 78;
    _tbv_tableview.backgroundColor = Color_White_Same_20;
    _tbv_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self requestInitBudgetStatisticsRptSecond];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

#pragma mark - function
//预算统计
-(void)requestInitBudgetStatisticsRptSecond
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",InitBudgetStatisticsRptSecond] Parameters:@{@"Year":_year,@"Type":_type,@"CostCenterId":_Dic[@"costCenterId"],@"TotalAmount":_totalAmount} Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        [YXSpritesLoadingView dismiss];
        return;
    }
    if (serialNum == 0) {
        [YXSpritesLoadingView dismiss];
        _dic_requst = responceDic;
        _Arr_mainFld = responceDic[@"result"];
        [_tbv_tableview reloadData];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//表单加载
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _Arr_mainFld.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BudgetStatisticsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BudgetStatisticsTableViewCell"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetStatisticsTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    NSLog(@"%ld",(long)indexPath.row);
    cell.dic = _Arr_mainFld[indexPath.row];
//    if (![_str_Type isEqualToString:@"2"]) {
    cell.img_right.hidden = YES;
//    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
