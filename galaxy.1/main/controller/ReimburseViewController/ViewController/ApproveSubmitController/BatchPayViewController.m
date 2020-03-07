//
//  BatchPayViewController.m
//  galaxy
//
//  Created by hfk on 16/4/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BatchPayViewController.h"
#import "BatchPayCell.h"
#import "MyApplyModel.h"
@interface BatchPayViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)BatchPayCell *cell;
@property(nonatomic,strong)NSString *totalAmount;//总额
@property (nonatomic, strong) UIView *dockView;
@property(nonatomic,strong)UIButton *sureBtn;//确认付款
@property(nonatomic,strong)NSMutableArray *agreeArray;//确认支付数组
@property(nonatomic,strong)    NSDictionary *resultDict;
@end

@implementation BatchPayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"支付详情", nil) backButton:YES ];
    //    _totalAmount=@"";
    _resultDict=[[NSDictionary alloc]init];
    for (MyApplyModel *model in _batchPayArray) {
        _totalAmount=[GPUtils decimalNumberAddWithString:_totalAmount with:[NSString stringWithFormat:@"%@",model.amount]];
    }
    [self readlyPay];
    [self createTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}
//MARK:-创建确认支付
-(void)readlyPay
{
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [UIColor grayColor];
    self.dockView.frame = CGRectMake(0,ScreenRect.size.height - 49 - NavigationbarHeight, ScreenRect.size.width, 49);
    [self.view addSubview:self.dockView];
    _sureBtn=[GPUtils createButton:CGRectMake(0, 0, ScreenRect.size.width, 49)action:@selector(sureToPay:) delegate:self];
    _sureBtn.backgroundColor =Color_Blue_Important_20;
    [_sureBtn setTitle:Custing(@"确认支付", nil) forState:UIControlStateNormal];
    _sureBtn.titleLabel.font=Font_filterTitle_17;
    [_sureBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:_sureBtn];
    
}
//MARK:--创建tableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49)style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
//MARK:-确认支付按钮点击
-(void)sureToPay:(UIButton *)btn{
    _agreeArray=[NSMutableArray array];
    for (MyApplyModel *model in _batchPayArray) {
        NSDictionary *dict=@{@"ActionLinkName":@"同意",@"Comment":@"",@"TaskId":[NSString stringWithFormat:@"%@",model.taskId],@"ProcId":[NSString stringWithFormat:@"%@",model.procId],@"FlowCode":[NSString stringWithFormat:@"%@",model.flowCode],@"FormData":@"",@"ExpIds":@""};
        [_agreeArray addObject:dict];
    }
    [self requestSurePay];
}

-(void)requestSurePay
{
    NSDictionary * parameters = @{@"input":[NSString transformToJsonWithOutEnter:_agreeArray]};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",BatchPayAGREELIST];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    
}



//MARK:table代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _batchPayArray.count+1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"BatchPayCell"];
    if (_cell==nil) {
        _cell=[[BatchPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BatchPayCell"];
    }
    
    MyApplyModel *model;
    if (indexPath.row<_batchPayArray.count) {
        model=(MyApplyModel *)_batchPayArray[indexPath.row];
    }else{
        model=nil;
    }
    [_cell configViewWithModel:model withRow:indexPath.row withAllRow:_batchPayArray.count wintAmount:_totalAmount];
    
    return _cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_batchPayArray.count) {
        return YES;
    }else{
        return NO;
    }
    
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
        MyApplyModel *model=(MyApplyModel *)_batchPayArray[indexPath.row];
        _totalAmount=[GPUtils decimalNumberSubWithString:_totalAmount with:[NSString stringWithFormat:@"%@",model.amount]];
        [_batchPayArray removeObjectAtIndex:indexPath.row];
        if (_batchPayArray.count==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [_tableView reloadData];
    }
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //    NSLog(@"====%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    
    switch (serialNum) {
        case 0:{
            NSString * successRespone = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(goBack) userInfo:nil repeats:NO];
        }
            break;
        default:
            break;
    }
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
