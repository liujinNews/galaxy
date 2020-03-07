//
//  CompanyAllNoticeViewController.m
//  galaxy
//
//  Created by hfk on 2018/6/28.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "CompanyAllNoticeViewController.h"
#import "ApproveRemindTableViewCell.h"
#import "AnnouncementLookController.h"
@interface CompanyAllNoticeViewController ()<GPClientDelegate>
/**
 *  系统分页数
 */
@property (assign, nonatomic)NSInteger totalPage;
/**
 *  下载成功字典
 */
@property(assign,nonatomic)NSDictionary *resultDict;
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,assign)BOOL requestType;

@end

@implementation CompanyAllNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"公告", nil) backButton:YES];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_requestType) {
        self.currPage=1;
        [self requestNoticeList];
    }
    _requestType=YES;
}

-(void)requestNoticeList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSDictionary *dic = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": @"20"};//@"CompanyId":self.userdatas.multCompanyId
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GETNOTICEALL] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:改变状态
-(void)requestGetmydistDocumentByread:(NSString *)index{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",MessageIsRead] Parameters:@{@"Id":index} Delegate:self SerialNum:1 IfUserCache:NO];//@"CompanyId":self.userdatas.multCompanyId
}

//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    
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
    
    if (self.currPage == 1&&serialNum==0) {
        [self.resultArray removeAllObjects];
    }
    _resultDict=responceDic;
    switch (serialNum) {
        case 0:
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            break;
        case 4:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"删除成功" duration:1.0];
            self.currPage=1;
            [self loadData];
            break;
        default:
            break;
    }
}
//MARK:数据处理
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
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



//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 154;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic = self.resultArray[indexPath.section];
    ApproveRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApproveRemindTableViewCell"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ApproveRemindTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    cell.dic = [[NSDictionary alloc]initWithDictionary:dic];
    cell.backgroundColor = Color_White_Same_20;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    return [[UITableViewCell alloc]init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.resultArray isKindOfClass:[NSNull class]]&&self.resultArray.count!=0) {
        NSDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:self.resultArray[indexPath.section]];
        if (![dict isKindOfClass:[NSNull class]]) {
            if ([[NSString stringWithFormat:@"%@",dict[@"isRead"]]isEqualToString:@"0"]) {
                [self requestGetmydistDocumentByread:dict[@"id"]];
            }
             if ([dict[@"module"] isEqualToString:@"notices"]) {
                AnnouncementLookController *vc=[[AnnouncementLookController alloc]init];
                vc.str_LookId=[NSString isEqualToNull:dict[@"taskId"]]?[NSString stringWithFormat:@"%@",dict[@"taskId"]]:@"";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }

}
//删除需求单
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *dic = self.resultArray[indexPath.section];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",Messagedelete] Parameters:@{@"Ids":dic[@"id"]} Delegate:self SerialNum:4 IfUserCache:NO];
    }
}


-(void)loadData{
    [self requestNoticeList];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有公告哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
