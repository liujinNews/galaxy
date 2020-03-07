//
//  SelectCardViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/7/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "SelectCardViewController.h"

@interface SelectCardViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) SelectCardViewBlock block;
@property (assign, nonatomic) NSInteger totalPages;

@end

@implementation SelectCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"选择开户行总行", nil) backButton:YES];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(0);
    }];
    self.currPage = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

-(void)loadData{
    [self requestMatchingBankNo];
}

-(void)requestMatchingBankNo{
    self.isLoading = YES;
    NSDictionary *parameters =@{@"PageIndex":[NSNumber numberWithInteger:self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_PayBankNo Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)block:(SelectCardViewBlock)block{
    _block = block;
}

#pragma mark 创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"没有开户行总行数据哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if (serialNum ==2) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        _totalPages = [[result objectForKey:@"totalPages"] integerValue];
        if (self.currPage==1) {
            [self.resultArray removeAllObjects];
        }
        if (self.totalPages >= self.currPage) {
            [self.resultArray addObjectsFromArray:responceDic[@"result"][@"items"]];
        }
    }
    
    [self createNOdataView];
    
    //修改下载的状态
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];

}


-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.resultArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [NSString stringWithFormat:@"%@/%@",dic[@"recBankNo"],dic[@"recBankName"]];
    cell.textLabel.numberOfLines = 0;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 48.5, Main_Screen_Width, 0.5)];
    image.backgroundColor = Color_LineGray_Same_20;
    [cell addSubview:image];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.resultArray[indexPath.row];
    if (_block) {
        _block(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=Color_White_Same_20;
    view.frame=CGRectMake(0, 0, Main_Screen_Width, 0.01);
    return view;
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
