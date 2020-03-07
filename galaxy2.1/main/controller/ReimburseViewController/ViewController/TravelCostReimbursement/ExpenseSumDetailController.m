//
//  ExpenseSumDetailController.m
//  galaxy
//
//  Created by hfk on 2018/4/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ExpenseSumDetailController.h"
#import "ExpenseSumDetailCell.h"
@interface ExpenseSumDetailController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray *arr_result;

@end

@implementation ExpenseSumDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"费用明细", nil) backButton:YES];
    [self createTableView];
    self.arr_result=[NSMutableArray array];
    [self getDate];
}
//MARK:创建tableView
-(void)createTableView{
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor=Color_White_Same_20;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)getDate{
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETDETAILEXP];
    NSDictionary *Parameters=@{@"TaskId":self.TaskId,@"ExpenseCat":self.ExpenseCat,@"ExpenseType":self.ExpenseType,@"FlowCode":self.FlowCode};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [_arr_result removeAllObjects];
            if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responceDic[@"result"]) {
                    HasSubmitDetailModel *model=[[HasSubmitDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
//                    model.expenseDesc=@"就撒娇就撒娇时间啊计算机按实际撒娇撒惊声尖叫撒娇撒娇撒娇就撒娇暗杀教室假按揭撕漫男马上你们三生那么你们仨明年三美女那是男是女";
                    [_arr_result addObject:model];
                }
            }
            [_tableView reloadData];
        }
            break;
        default:
            break;
    }
    
}

//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}


//MARK:-tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_result.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    view.backgroundColor=Color_form_TextFieldBackgroundColor;
    
    UILabel *title=[GPUtils createLable:CGRectMake(12, 0, 100, 44) text:Custing(@"合计", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:title];
    
    UILabel *amoutLab=[GPUtils createLable:CGRectMake(12+100, 0, Main_Screen_Width-100-24, 44) text:[GPUtils transformNsNumber:self.str_TotalAmount] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    [view addSubview:amoutLab];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HasSubmitDetailModel *model=self.arr_result[indexPath.row];
    return [ExpenseSumDetailCell cellHeightWithObj:model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpenseSumDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ExpenseSumDetailCell"];
    if (cell==nil) {
        cell=[[ExpenseSumDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpenseSumDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HasSubmitDetailModel *model=self.arr_result[indexPath.row];
    [cell configCellWithModel:model WithIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HasSubmitDetailModel *model=self.arr_result[indexPath.row];
    NewLookAddCostViewController *add = [[NewLookAddCostViewController alloc]init];
    add.dict_parameter = @{@"UserId":self.str_UserId,
                           @"OwnerUserId":self.str_OwerId,
                           @"ProcId":self.str_ProcId,
                           @"FlowGuid":self.str_FlowGuid,
                           @"Requestor":@""
                           };
    add.TaskId = model.taskId;
    add.Type = [self.FlowCode isEqualToString:@"F0002"] ? 1:2;
    add.Action = 3;
    add.GridOrder = model.gridOrder;
    add.dateSource = model.dataSource;
    add.model_has = model;
    [self.navigationController pushViewController:add animated:YES];
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
