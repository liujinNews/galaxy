//
//  ExpenseTypeEditViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/7/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ExpenseTypeEditViewController.h"
#import "AddExpenseTypeViewController.h"


@interface ExpenseTypeEditViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,AddExpenseTypeDelegate>
{
    NSDictionary *dic_request;
    NSArray *arr_items;
    NSDictionary *dic_click;
}
@end

@implementation ExpenseTypeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Edit Expense Type/Purpose - Sub" backButton:YES];
    _tbv_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbv_tableview.delegate = self;
    _tbv_tableview.dataSource = self;
    dic_request = [NSDictionary dictionary];
    arr_items = [NSArray array];
    
    [self getGetTypPurpAll];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}


#pragma mark - 方法
//获取用户信息
-(void)getGetTypPurpAll
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetTypPurpAll];
    NSDictionary *parameters = @{@"ParentId":[NSString stringWithFormat:@"0"],@"PageIndex":@"1",@"PageSize": @"999",@"OrderBy":@"no",@"IsAsc":@"",@"TypPurp":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//更新类型
-(void)getTypPurpUpdate:(NSString *)str
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetTypPurpUpdate];
    NSDictionary *parameters = @{@"TypPurp":[NSString stringWithFormat:@"%@",str],@"ParentId":[NSString stringWithFormat:@"0"],@"Id":dic_click[@"id"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
}

//删除列表
-(void)getTypPurpDelete
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GetTypPurpDelete];
    NSDictionary *parameters = @{@"ParentId":[NSString stringWithFormat:@"0"],@"Id":dic_click[@"id"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}

#pragma mark - action
- (IBAction)btn_end_click:(UIButton *)sender {
    [self Navback];
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = arr_items[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [NSString isEqualToNull:dic[@"typPurp"]]?dic[@"typPurp"]:@"";
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 43, Main_Screen_Width-10, 1)];
    image.backgroundColor = Color_GrayLight_Same_20;
    [cell addSubview:image];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dic_click = arr_items[indexPath.row];
    AddExpenseTypeViewController *sub = [[AddExpenseTypeViewController alloc]init];
    sub.type = 2;
    sub.str_txf = [NSString isEqualToNull:dic_click[@"typPurp"]]?dic_click[@"typPurp"]:@"";
    sub.delegate = self;
    [self.navigationController pushViewController:sub animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        dic_click = arr_items[indexPath.row];
        [self getTypPurpDelete];
    }
}

-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"]intValue] == 0 ) {
        [YXSpritesLoadingView dismiss];
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum==0) {
        dic_request = responceDic;
        arr_items = dic_request[@"result"][@"items"];
        [_tbv_tableview reloadData];
    }
    if (serialNum==2) {
        [self getGetTypPurpAll];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.0];
    }
    if (serialNum==3) {
        [self getGetTypPurpAll];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:1.0];
    }
    if (serialNum==4) {
        [self getGetTypPurpAll];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.0];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
}

-(void)AddExpenseTypeBtn:(NSString *)str type:(int)type{
    if (type==2) {
        [self getTypPurpUpdate:str];
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
