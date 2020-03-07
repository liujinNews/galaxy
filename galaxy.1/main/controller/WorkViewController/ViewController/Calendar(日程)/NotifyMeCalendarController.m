//
//  NotifyMeCalendarController.m
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "NotifyMeCalendarController.h"

@interface NotifyMeCalendarController ()

@property (assign, nonatomic)NSInteger totalPages;
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)CalendarShowCell *cell;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL bool_needReq;

@end

@implementation NotifyMeCalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"知会我的日程", nil) backButton:YES ];
    _bool_needReq=NO;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_bool_needReq) {
        self.currPage=1;
        [self requestGetData];
    }
    _bool_needReq=YES;
}

-(void)requestGetData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETNOTIFYMECaldaner];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading=NO;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        return;
    }
    
    //下拉刷新
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
    }
    _resultDict=responceDic;
    
    switch (serialNum) {
        case 0:
            [self dealWithData];
            [self createNOdataView];
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}


//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotifyMeCalendarModel *model=(NotifyMeCalendarModel *)self.resultArray[indexPath.row];
    if (indexPath.row>0) {
        NotifyMeCalendarModel *befomodel=(NotifyMeCalendarModel *)self.resultArray[indexPath.row-1];
        return [CalendarShowCell cellNotifyMeHeightWithModel:model WithBeforeModel:befomodel];
    }else{
        return [CalendarShowCell cellNotifyMeHeightWithModel:model WithBeforeModel:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
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
    _cell=[tableView dequeueReusableCellWithIdentifier:@"CalendarShowCell"];
    if (_cell==nil) {
        _cell=[[CalendarShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarShowCell"];
    }
    NotifyMeCalendarModel * model = (NotifyMeCalendarModel *)self.resultArray[indexPath.row];
    if (indexPath.row>0) {
        NotifyMeCalendarModel *befomodel=(NotifyMeCalendarModel *)self.resultArray[indexPath.row-1];
        [_cell configNotifyMeCellWithModel:model WithBeforeModel:befomodel];
    }else{
        [_cell configNotifyMeCellWithModel:model WithBeforeModel:nil];
    }
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NotifyMeCalendarModel * model = (NotifyMeCalendarModel *)self.resultArray[indexPath.row];
    CalendarDetailController *vc=[[CalendarDetailController alloc]init];
    vc.int_status=2;
    vc.str_ScheduleId=[NSString isEqualToNull:model.Id]?[NSString stringWithFormat:@"%@",model.Id]:@"";
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:数据处理
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPages=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPages) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            NotifyMeCalendarModel *model=[[NotifyMeCalendarModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            NotifyMeCalendarModel *model=[[NotifyMeCalendarModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
}
//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

-(void)loadData{
    [self requestGetData];
    
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有知会记录哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
