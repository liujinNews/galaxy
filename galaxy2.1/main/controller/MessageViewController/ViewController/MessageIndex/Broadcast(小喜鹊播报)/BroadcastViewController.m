//
//  BroadcastViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define pageNum  (Main_Screen_Height-NavigationbarHeight-49)/120
#import "boWebViewController.h"

#import "BroadcastViewController.h"
#import "BroadcastTableViewCell.h"
#import "BroadcastData.h"

#import "NSDate+Change.h"

@interface BroadcastViewController ()<GPClientDelegate>
@property (nonatomic,strong)NSString * returnStr;
@property (nonatomic,strong)NSString * recordcount;
@property (assign, nonatomic)NSInteger totalPages;

//监控性能
@property (nonatomic, strong) NSDate *date;

@end

@implementation BroadcastViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"小喜鹊播报", nil) backButton:YES];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.currPage =1;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view from its nib.
    _date = [NSDate date];
    NSLog(@"进入时间，%@",[NSDate stringWithDateBySSS:_date]);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return 10;
    }else{
        return 10.0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=Color_White_Same_20;
    view.frame=CGRectMake(0, 0, Main_Screen_Width, 10);
    return view;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BroadcastData *model=(BroadcastData *)self.resultArray[indexPath.row];

    NSInteger imageHeight;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.attachment]]) {
        imageHeight = (Main_Screen_Width-50) / 9 * 5;
    }else{
        imageHeight = 0;
    }
    
    if ([NSString isEqualToNull:model.title]) {
        NSString *str=model.title;
        CGSize size = [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        return 110+imageHeight+size.height;
    }else{
        return 110+imageHeight;
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BroadcastTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BroadcastTableViewCell"];
    if (cell==nil) {
        cell=[[BroadcastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BroadcastTableViewCell"];
    }
    BroadcastData *cellInfo = self.resultArray[indexPath.row];
    [cell configBroadcastCellInfo:cellInfo];
    
    return cell;
}
//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    BroadcastData *cellInfo = self.resultArray[indexPath.row];
    if ([NSString isEqualToNull:cellInfo.body]) {
        boWebViewController * project = [[boWebViewController alloc]initWithType:cellInfo.body];
        [self.navigationController pushViewController:project animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadData{
    [self requestBroadcastListData:self.currPage];
}

//请求数据列表
-(void)requestBroadcastListData:(NSInteger)page{
    self.isLoading = YES;
    NSDictionary *dic = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"Published",@"IsAsc":@"desc"};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetSystemMessageList] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];

}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
//    NSLog([NSString stringWithFormat:@"请求成功后时间，%@,差距时间%f",[NSDate stringWithDateBySSS:[NSDate date]],[NSDate intervalSinceReferenceDate_double:[NSDate date] localeDate:_date]]);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if (serialNum ==0) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        self.recordcount = [NSString stringWithFormat:@"%@",[result objectForKey:@"recordcount"]];
        self.totalPages = [[result objectForKey:@"totalPages"] integerValue];
    }
    
    
    switch (serialNum) {
        case 0:
            
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPages >= self.currPage) {
                
                [BroadcastData GetBroadcastDictionary:responceDic Array:self.resultArray];
            }
//            NSLog([NSString stringWithFormat:@"数据解析后时间，%@,差距时间%f",[NSDate stringWithDateBySSS:[NSDate date]],[NSDate intervalSinceReferenceDate_double:[NSDate date] localeDate:_date]]);
            break;
       
        default:
            break;
    }
    [self createNOdataView];

//    NSLog([NSString stringWithFormat:@"tableview开始刷新时间，%@,差距时间%f",[NSDate stringWithDateBySSS:[NSDate date]],[NSDate intervalSinceReferenceDate_double:[NSDate date] localeDate:_date]]);
//    NSLog([NSString stringWithFormat:@"tableview结束刷新时间，%@,差距时间%f",[NSDate stringWithDateBySSS:[NSDate date]],[NSDate intervalSinceReferenceDate_double:[NSDate date] localeDate:_date]]);
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];

//    NSLog([NSString stringWithFormat:@"返回方法调用完成时间，%@,差距时间%f",[NSDate stringWithDateBySSS:[NSDate date]],[NSDate intervalSinceReferenceDate_double:[NSDate date] localeDate:_date]]);
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"暂无小喜鹊播报", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
