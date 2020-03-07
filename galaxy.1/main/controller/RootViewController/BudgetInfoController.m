//
//  BudgetInfoController.m
//  galaxy
//
//  Created by hfk on 2017/6/28.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "BudgetInfoController.h"
#import "BudgetCostCenterDetailCell.h"
#import "BudgetProjectDetailCell.h"

@interface BudgetInfoController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  主视图tableView
 */
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *ProjArr;//项目预算
@property(nonatomic,strong)NSMutableArray *CostArr;//成本中心预算
@property(nonatomic,strong)NSMutableArray *actItemArr;//辅助核算项目预算

@end

@implementation BudgetInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White_Same_20;
    [self setTitle:Custing(@"预算详情", nil) backButton:YES];
    [self dealWithDate];
    if (self.ProjArr.count > 0 || self.CostArr.count > 0 || self.actItemArr.count > 0) {
        [self createTab];
    }
}

-(void)dealWithDate{
    self.ProjArr = [NSMutableArray arrayWithArray:self.budgetInfoDict[@"proj"]];
    self.actItemArr = [NSMutableArray arrayWithArray:self.budgetInfoDict[@"actItem"]];
    self.CostArr = [NSMutableArray arrayWithArray:self.budgetInfoDict[@"cost"]];
}
-(void)createTab{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = Color_White_Same_20;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.CostArr.count;
    }else if (section == 1){
        return self.actItemArr.count;
    }else{
        return self.ProjArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger height = 0;
    if (indexPath.section == 0) {
        if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",self.CostArr[indexPath.row][@"dimType"]]]) {
            height = 165;
        }else{
            height = 140;
        }
        if (self.CostArr.count - 1 != indexPath.row) {
            height += 10;
        }
    }else if (indexPath.section == 1){
        height = 165;
        if (self.actItemArr.count - 1 != indexPath.row) {
            height += 10;
        }
    }else{
       height = 145;
        if (self.ProjArr.count - 1 != indexPath.row) {
            height += 10;
        }
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BudgetCostCenterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetCostCenterDetailCell"];
        if (cell == nil) {
            cell = [[BudgetCostCenterDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BudgetCostCenterDetailCell"];
        }
        [cell configCellWithDict:self.CostArr[indexPath.row] withType:1];
        return cell;
    }else if (indexPath.section == 1){
        BudgetCostCenterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetCostCenterDetailCell"];
        if (cell == nil) {
            cell = [[BudgetCostCenterDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BudgetCostCenterDetailCell"];
        }
        [cell configCellWithDict:self.actItemArr[indexPath.row] withType:2];
        return cell;
    }else{
        BudgetProjectDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetProjectDetailCell"];
        if (cell == nil) {
            cell = [[BudgetProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BudgetProjectDetailCell"];
        }
        [cell configCellWithDict:self.ProjArr[indexPath.row]];
        return cell;
    }
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
