//
//  PayMentDetailController.m
//  galaxy
//
//  Created by hfk on 2017/5/26.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentDetailController.h"
#import "PayMentDetailCell.h"
#import "PayMentBankCell.h"
#import "PayMentDetailModel.h"
#import "PayMentBankModel.h"
#import "STOnePickView.h"
#import "MyApplyModel.h"
#import "PayMentResultController.h"
@interface PayMentDetailController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *meItemArray;
@property(nonatomic,strong)NSMutableArray *bankArray;
@property(nonatomic,strong)UIView  *headView;
@property(nonatomic,strong)UILabel *payWayLal;
@property(nonatomic,strong)NSString  *payWay;
@property(nonatomic,strong)UIButton *sureBtn;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
@property (nonatomic,strong)NSString *totalAmount;
@end

@implementation PayMentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"支付详情", nil) backButton:YES];
    self.view.backgroundColor=Color_White_Same_20;
    _bankArray=[NSMutableArray array];
    [PayMentBankModel getPayMentBankArray:_bankArray];
    _meItemArray=[NSMutableArray array];
    _payWay=@"1";
    [self requestPayDate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:请求数据
-(void)requestPayDate
{
    NSMutableArray *payArray=[NSMutableArray array];
    for (MyApplyModel *model in _batchPayArray) {
        [payArray addObject:[NSString stringWithFormat:@"%@",model.taskId]];
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",PAYMENTDATE];
    NSDictionary *parameters = @{@"PageIndex":@"1",@"PageSize":@"1000",@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"StrTaskId":[payArray componentsJoinedByString:@","]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
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
            _totalAmount=[PayMentDetailModel getTaskDateWithArray:_meItemArray withSource:_resultDict];
            [self createTableView];
        }
            break;
        case 1:
        {
            if (![_resultDict[@"result"] isKindOfClass:[NSNull class]]) {
                NSString *retCode=_resultDict[@"result"][@"retCode"];
                if ([retCode isEqualToString:@"200"]) {
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"支付成功", nil)];
                    [self performBlock:^{
                        //        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    } afterDelay:1];
                }else if ([retCode isEqualToString:@"300"]){
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"支付失败", nil)];
                }else if ([retCode isEqualToString:@"-9"]){
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"未设置支付账号", nil)];
                }else{
                    if (![_resultDict[@"result"][@"opResult"] isKindOfClass:[NSNull class]]) {
                        NSArray *arr=_resultDict[@"result"][@"opResult"];
                        PayMentResultController *vc=[[PayMentResultController alloc]init];
                        vc.dateArray=[NSMutableArray arrayWithArray:arr];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                
                }
            }
        }
            break;
        default:
            break;
    }
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}
//MARK:创建tableView
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    _sureBtn=[GPUtils createButton:CGRectMake(0,Main_Screen_Height -50 - NavigationbarHeight, Main_Screen_Width, 50)action:@selector(PayMent_SureClick:) delegate:self];
    _sureBtn.tag=1;
    _sureBtn.backgroundColor =Color_Blue_Important_20;
    [_sureBtn setTitle:[NSString stringWithFormat:@"%@ %@",Custing(@"确认支付", nil),[GPUtils transformNsNumber:_totalAmount]] forState:UIControlStateNormal];
    _sureBtn.titleLabel.font=Font_filterTitle_17;
    [_sureBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.view addSubview:_sureBtn];
}

//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.meItemArray.count;
    }else{
        return self.bankArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }else{
        return 110;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width, 0.01);
        return view;
    }else{
        [self createHeadView];
        return _headView;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return [PayMentDetailCell cellHeightWithObj:self.meItemArray[indexPath.row]];
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        PayMentDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PayMentDetailCell"];
        if (cell==nil) {
            cell=[[PayMentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayMentDetailCell"];
        }
        cell.model=self.meItemArray[indexPath.row];
        return cell;
    }else{
        PayMentBankCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PayMentBankCell"];
        if (cell==nil) {
            cell=[[PayMentBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayMentBankCell"];
        }
        cell.model=self.bankArray[indexPath.row];
        return cell;
    }
}
//MARK:代理

-(void)createHeadView{
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 110)];
    _headView.backgroundColor=Color_form_TextFieldBackgroundColor;
    
    UILabel *titleAmount=[GPUtils createLable:CGRectMake(15, 0, 100, 50) text:Custing(@"合计金额", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [_headView addSubview:titleAmount];
    
    UILabel *Amount=[GPUtils createLable:CGRectMake(115, 0, Main_Screen_Width-130, 50) text:[GPUtils transformNsNumber:_totalAmount] font:Font_Important_15_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentRight];
    [_headView addSubview:Amount];
    
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 50, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    [_headView addSubview:view];
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0.1, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineUp];
    
    UIView *lineDown=[[UIView alloc]initWithFrame:CGRectMake(0,9.5, Main_Screen_Width,0.5)];
    lineDown.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineDown];
    
    
    UILabel *titleWay=[GPUtils createLable:CGRectMake(15, 60, 120, 50) text:Custing(@"支付方式", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
//    titleWay.backgroundColor=[UIColor cyanColor];
    [_headView addSubview:titleWay];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-30, 76, 18, 18)];
    skipImage.image =[UIImage imageNamed:@"skipImage"];
    [_headView addSubview:skipImage];
    
    _payWayLal=[GPUtils createLable:CGRectMake(135, 60, Main_Screen_Width-165, 50) text:[_payWay isEqualToString:@"1"]?Custing(@"线上支付", nil):Custing(@"线下支付", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
//    _payWayLal.backgroundColor=[UIColor redColor];
    [_headView addSubview:_payWayLal];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(100, 60, Main_Screen_Width, 50) action:@selector(PayMent_SureClick:) delegate:self];
    btn.tag=2;
    [_headView addSubview:btn];

    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,109.5, Main_Screen_Width,0.5)];
    line.backgroundColor=Color_GrayLight_Same_20;
    [_headView addSubview:line];

}
-(void)PayMent_SureClick:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            if ([_payWay isEqualToString:@"1"]) {
                for (PayMentDetailModel *Paymodel in _meItemArray) {
                    if (Paymodel.bankAccount.length<7) {
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"银行卡号不能为空", nil)];
                        return;
                    }
                }
            }
            
            NSMutableArray *array=[NSMutableArray array];
            for (MyApplyModel *model in _batchPayArray) {
                NSDictionary *dict=@{@"ActionLinkName":@"同意",@"Comment":@"",@"TaskId":[NSString stringWithFormat:@"%@",model.taskId],@"ProcId":[NSString stringWithFormat:@"%@",model.procId],@"FormData":@"",@"ExpIds":@"",@"MainForm":_dic_AgreeAmount?[self transformToJson:_dic_AgreeAmount]:@"",@"FlowCode":_flowCode?_flowCode:@""};
                [array addObject:dict];
            }
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSDictionary *dict=@{@"List":array,@"PayMode":[_payWay isEqualToString:@"1"]?@"002":@"001"};
            NSDictionary * parameters = @{@"input":[self transformToJson:dict]};
            NSString *url=[NSString stringWithFormat:@"%@",PAYDO];
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];

        }
            break;
        case 2:
        {
            STOnePickView *picker = [[STOnePickView alloc]init];
            __weak typeof(self) weakSelf = self;
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                weakSelf.payWay=Model.Id;
                [weakSelf.bankArray removeAllObjects];
                if ([weakSelf.payWay isEqualToString:@"1"]) {
                    [PayMentBankModel getPayMentBankArray:weakSelf.bankArray];
                }
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                [weakSelf scrollTableToFoot:NO];
            }];
            picker.typeTitle=Custing(@"支付方式", nil);
            NSMutableArray *arr=[NSMutableArray array];
            [STOnePickModel getPayWay:arr];
            picker.DateSourceArray=[NSMutableArray arrayWithArray:arr];
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Id=[NSString isEqualToNull: _payWay]?_payWay:@"1";
            picker.Model=model;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }
            break;
        default:
            break;
    }
}
#pragma mark  - 滑到最底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
