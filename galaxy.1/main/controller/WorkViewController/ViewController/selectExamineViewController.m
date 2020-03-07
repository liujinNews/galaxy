//
//  selectExamineViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "selectExamineViewController.h"

@interface selectExamineViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>

@property (nonatomic, strong) NSDictionary *dic_request;

@property (assign, nonatomic) NSInteger totalPage;//系统分页数
@property (nonatomic, strong) NSString *requestType;//区分viewwillapper是否请求数据


@end

@implementation selectExamineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_style isEqualToString:@"0"]) {
        [self setTitle:Custing(@"选择意见", nil) backButton:YES];
    }else{
        [self setTitle:Custing(@"选择退回人", nil) backButton:YES];
    }
    
    
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(@0);
    }];
    
    _dic_request = [NSDictionary dictionary];
    _requestType=@"1";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self requestGetApprovalReason];
    }
    _requestType=@"0";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}


#pragma mark - function
-(void)requestGetApprovalReason{
    NSString *url=[NSString stringWithFormat:@"%@",GetApprovalReason];
    self.isLoading = YES;
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)requestGetReturnProcList{
    NSString *url=[NSString stringWithFormat:@"%@",GetReturnProcList];
    self.isLoading = YES;
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@100,@"TaskId":_TaskId,@"ProcId":_ProcId} Delegate:self SerialNum:2 IfUserCache:NO];
}

-(void)dealWithData
{
    _totalPage = 1;
    if (self.currPage<=_totalPage) {
        NSArray *array=[_style isEqualToString:@"0"]?_dic_request[@"result"]:_dic_request[@"result"][@"items"];
        for (NSDictionary *dict in array) {
            [self.resultArray addObject:dict];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            [self.resultArray addObject:dict];
        }
    }
}

//下拉上拉
-(void)loadData
{
    if ([_style isEqualToString:@"0"]) {
        [self requestGetApprovalReason];
    }else{
        [self requestGetReturnProcList];
    }
}

//创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([_style isEqualToString:@"0"]) {
        tips=Custing(@"您还没有常用意见哦",nil);
    }else{
        tips=Custing(@"您还没有可选退回人哦",nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        //修改下载的状态
        self.isLoading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
        [self.resultArray removeAllObjects];
    }
    _dic_request = responceDic;
    [self dealWithData];
    [self createNOdataView];
    
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
    selectImage.center = [_style isEqualToString:@"0"]?CGPointMake(25, 22.5):CGPointMake(25, 27);
    selectImage.image = [UIImage imageNamed:@"MyApprove_UnSelect"];
    selectImage.highlightedImage = [UIImage imageNamed:@"MyApprove_Select"];
    [cell addSubview:selectImage];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 45) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    NSDictionary *dic = self.resultArray[indexPath.row];
    
    lab.text = [_style isEqualToString:@"0"]?dic[@"reason"]:dic[@"nodeName"];
    if (dic[@"reason"]==_select_id) {
        cell.highlighted = YES;
    }
    [cell addSubview:lab];
    
    if ([_style isEqualToString:@"1"]) {
        UILabel *lab = [GPUtils createLable:CGRectMake(50, 35, Main_Screen_Width-65, 15) text:dic[@"handlerUserName"] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [cell addSubview:lab];
    }
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, [_style isEqualToString:@"0"]?49:59, Main_Screen_Width, 0.5)];
    image.backgroundColor = Color_White_Same_20;
    [cell addSubview:image];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate selectExamineViewController_Delegate:self.resultArray[indexPath.row] type:_type style:_style];
    [self returnBack];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_style isEqualToString:@"0"]?49:59;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
