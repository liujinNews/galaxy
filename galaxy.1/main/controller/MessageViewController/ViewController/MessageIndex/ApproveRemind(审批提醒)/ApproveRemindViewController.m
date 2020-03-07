//
//  ApproveRemindViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ApproveRemindViewController.h"
#import "ApproveRemindTableViewCell.h"
#import "ApproveRemindByCityTableViewCell.h"
#import "ApproveSetterViewController.h"
//Bpm
#import "BpmRemindController.h"
#import "AnnouncementLookController.h"
#import "TravelReqFormController.h"
@interface ApproveRemindViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>

@property (assign, nonatomic)NSInteger totalPage;//系统分页数

@property (nonatomic, strong) NSDictionary *dic_request;//下载存储数据
@property (nonatomic, strong)NSMutableDictionary *DealDict;//点击处理字典

@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据

@end

@implementation ApproveRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([NSString isEqualToNull:self.str_Title]) {
        [self setTitle:self.str_Title  backButton:YES];
    }else{
        [self setTitle:Custing(@"消息提醒", nil)  backButton:YES];
    }
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.superview.backgroundColor = Color_White_Same_20;
    self.tableView.backgroundColor = Color_White_Same_20;
    [_view_tableview addSubview:self.tableView];

    _requestType=@"1";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:@"Message_Setter" target:self action:@selector(btn_right_click:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self requestGetHist_GetAll];
    }
    _requestType=@"0";

}

#pragma mark - function
-(void)requestGetHist_GetAll
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary *dic = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": @"15",@"CompanyId":self.userdatas.multCompanyId};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",Hist_GetAll] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:改变状态
-(void)requestGetmydistDocumentByread:(NSString *)index{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",MessageIsRead] Parameters:@{@"Id":index,@"CompanyId":self.userdatas.multCompanyId} Delegate:self SerialNum:2 IfUserCache:NO];
}

//获取最新状态
-(void)requestGetTaskformessage{
    NSString *taskid =[NSString stringWithFormat:@"%@",_DealDict[@"taskId"]];
    NSString *procid=[NSString stringWithFormat:@"%@",_DealDict[@"procId"]];
    [[GPClient shareGPClient]REquestByPostWithPath:XB_FormState Parameters:@{@"TaskId":taskid,@"ProcId":procid,@"CompanyId":self.userdatas.multCompanyId} Delegate:self SerialNum:3 IfUserCache:NO];
}


-(void)dealWithData
{
    NSDictionary *result = _dic_request[@"result"];
    _totalPage = [result[@"totalPages"] integerValue];
    
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            [self.resultArray addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
        }
    }else{
        NSArray *array=nil;
        for (NSMutableDictionary *dict in array) {
            [self.resultArray addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
        }
    }
}

//下拉上拉
-(void)loadData
{
    [self requestGetHist_GetAll];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有消息提醒哦",nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}


#pragma mark - action 
-(void)btn_right_click:(UIButton *)btn{
    ApproveSetterViewController *app = [[ApproveSetterViewController alloc]init];
    [self.navigationController pushViewController:app animated:YES];
}
//MARK:审批人是否能编辑页面
-(void)requestJudgeAppoverEdit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",ApproverEdit];
    NSDictionary *parameters = @{@"ProcId":[NSString stringWithFormat:@"%@",self.pushModel.procId],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
}
#pragma mark - 代理
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        [YXSpritesLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (serialNum == 0) {
        [YXSpritesLoadingView dismiss];
        _dic_request = responceDic;
    }
    
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
        {
            [self dealWithData];
            
            [self createNOdataView];

            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
            break;
        case 3:;
        {
            NSDictionary *dict=[responceDic objectForKey:@"result"];
            if (![dict isKindOfClass:[NSNull class]]) {
                if ([[NSString stringWithFormat:@"%@",dict[@"status"]] isEqualToString:@"6"]) {
                    [YXSpritesLoadingView dismiss];
                    self.currPage=1;
                    [self requestGetHist_GetAll];
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:@"已被撤回" duration:1.0];
                    return;
                }else{
                    if ([[NSString stringWithFormat:@"%@",dict[@"finished"]]isEqualToString:@"0"]) {
                        [_DealDict setValue:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dict[@"status"]]]forKey:@"status"];
                        [self goToController];
                    }else if([[NSString stringWithFormat:@"%@",dict[@"finished"]] isEqualToString:@"1"]){
                        if (![[NSString stringWithFormat:@"%@",dict[@"status"]]isEqualToString:@"7"]) {
                            [_DealDict setValue:@"4"forKey:@"status"];
                        }
                        [self goToController];
                    }
                }
            }
        }
            break;
        case 4:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"删除成功" duration:1.0];
            [self loadData];
            break;
        case 5:
            [self dealWithAppoverEdit:[NSString isEqualToNull:responceDic[@"result"]]?[NSString stringWithFormat:@"%@",responceDic[@"result"]]:@"0" WithStatus:[_ApproveEditStatus isEqualToString:@"1"]?1:2];
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}

//创建tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.resultArray[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",dic[@"module"]]isEqualToString:@"repayment"]) {
        return 80;
    }else if (![dic[@"flowCode"]isEqual:[NSNull null]]) {
        if (![dic[@"flowCode"]isEqualToString:@"F0001"]) {
            return 154;
        }else{
            return 184;
        }
    }else{
        if ([dic[@"module"]isEqualToString:@"demand"]) {
            return 184;
        }else{
            return 154;
        }
    }
    return 184;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.resultArray[indexPath.row];
    if (![dic[@"flowCode"] isEqual:[NSNull null]]) {
        if (![dic[@"flowCode"]isEqualToString:@"F0001"]) {
            ApproveRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApproveRemindTableViewCell"];
            if (cell==nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApproveRemindTableViewCell" owner:self options:nil];
                cell = [nib lastObject];
            }
            cell.dic = [[NSDictionary alloc]initWithDictionary:dic];
            cell.backgroundColor = Color_White_Same_20;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ApproveRemindByCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApproveRemindByCityTableViewCell"];
            if (cell==nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApproveRemindByCityTableViewCell" owner:self options:nil];
                cell = [nib lastObject];
            }
            cell.dic = [[NSDictionary alloc]initWithDictionary:dic];
            cell.backgroundColor = Color_White_Same_20;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        if ([dic[@"module"]isEqualToString:@"demand"]) {
            ApproveRemindByCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApproveRemindByCityTableViewCell"];
            if (cell==nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApproveRemindByCityTableViewCell" owner:self options:nil];
                cell = [nib lastObject];
            }
            cell.dic = [[NSDictionary alloc]initWithDictionary:dic];
            cell.backgroundColor = Color_White_Same_20;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ApproveRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApproveRemindTableViewCell"];
            if (cell==nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApproveRemindTableViewCell" owner:self options:nil];
                cell = [nib lastObject];
            }
            cell.dic = [[NSDictionary alloc]initWithDictionary:dic];
            cell.backgroundColor = Color_White_Same_20;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.resultArray[indexPath.row]);
    if (![self.resultArray isKindOfClass:[NSNull class]]&&self.resultArray.count!=0) {
        _DealDict=[NSMutableDictionary dictionaryWithDictionary:self.resultArray[indexPath.row]];
        if (![_DealDict isKindOfClass:[NSNull class]]) {
            if ([[NSString stringWithFormat:@"%@",_DealDict[@"isRead"]]isEqualToString:@"0"]) {
                [self requestGetmydistDocumentByread:_DealDict[@"id"]];
            }
            if ([_DealDict[@"module"] isEqualToString:@"repayment"]) {
                NSMutableDictionary *dict=self.resultArray[indexPath.row];
                [dict setValue:@"1" forKey:@"isRead"];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }else if ([_DealDict[@"module"] isEqualToString:@"invoice"]) {
                [_DealDict setValue:@"4"forKey:@"status"];
                [self goToController];
            }else if ([_DealDict[@"module"] isEqualToString:@"notices"]) {
                AnnouncementLookController *vc=[[AnnouncementLookController alloc]init];
                vc.str_LookId=[NSString isEqualToNull:_DealDict[@"taskId"]]?[NSString stringWithFormat:@"%@",_DealDict[@"taskId"]]:@"";
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([_DealDict[@"module"] isEqualToString:@"demand"]) {
                TravelReqFormController *vc=[[TravelReqFormController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[NSString stringWithFormat:@"%@",_DealDict[@"type"]] isEqualToString:@"3"]) {
                if ([NSString isEqualToNull:_DealDict[@"link"]]) {
                    BpmRemindController * BpmRemind = [[BpmRemindController alloc]init];
                    BpmRemind.BpmRemindUrl =[NSString stringWithFormat:@"%@",_DealDict[@"link"]] ;
                    BpmRemind.BpmRemindTitle=@"BPM";
                    [self.navigationController pushViewController:BpmRemind animated:YES];
                }
            }else{
                [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
                [self requestGetTaskformessage];
            }
        }
    }
}

//删除需求单
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
        NSMutableDictionary *dic = self.resultArray[indexPath.row];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",Messagedelete] Parameters:@{@"Ids":dic[@"id"]} Delegate:self SerialNum:4 IfUserCache:NO];
        [tableView reloadData];
    }
    
}

//MARK:页面跳转
-(void)goToController{
    
    if ([[NSString stringWithFormat:@"%@",_DealDict[@"status"]] isEqualToString:@"6"]) {
        [YXSpritesLoadingView dismiss];
        self.currPage=1;
        [self requestGetHist_GetAll];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"已被撤回" duration:1.0];
        return;
    }else if ([[NSString stringWithFormat:@"%@",_DealDict[@"status"]] isEqualToString:@"7"]){
        [YXSpritesLoadingView dismiss];
        self.currPage=1;
        [self requestGetHist_GetAll];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"已作废" duration:1.0];
        return;
    }
    
    NSLog(@"字点%@",_DealDict);
    
    self.pushModel=[[MyApplyModel alloc]init];
    self.pushModel.taskId=[NSString stringWithFormat:@"%@",_DealDict[@"taskId"]];
    self.pushModel.procId=[NSString stringWithFormat:@"%@",_DealDict[@"procId"]];
    self.pushModel.flowCode=[NSString stringWithFormat:@"%@",_DealDict[@"flowCode"]];
    _ApproveEditStatus=[NSString stringWithFormat:@"%@",_DealDict[@"status"]];
    [self MyApproveRemind:_DealDict];
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
