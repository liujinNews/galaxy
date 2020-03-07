//
//  MasterListViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MasterListViewController.h"
#import "MasterListModel.h"
#import "MasterListCell.h"
#define pageNum 15
@interface MasterListViewController ()<GPClientDelegate,UISearchBarDelegate>
@property(nonatomic,strong)MasterListCell *cell;
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)NSString *type;
@property (nonatomic, strong) UISearchBar *sea_searchbar;
@property(nonatomic,strong)NSString *searchAim;//搜索目标


@end

@implementation MasterListViewController

-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSearchBar];
    _searchAim=@"";
    // Do any additional setup after loading the view.
    [self setTitle:nil backButton:YES ];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

-(void)createSearchBar
{
    _sea_searchbar  = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    _sea_searchbar.delegate = self;
    [self.view addSubview:_sea_searchbar];
    
}

#pragma mark 添加网络数据
-(void)requestDate{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GetMasterData];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"Name":_searchAim,@"MasterId":_model.masterId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
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
        default:
            break;
    }
}
//MARK:数据处理
-(void)dealWithData{
    NSDictionary *dict=_resultDict[@"result"];
    if (![dict isKindOfClass:[NSNull class]]) {
        [self setTitle:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"masterName"]]]?dict[@"masterName"]:@"" backButton:YES ];
        NSArray *array=dict[@"items"];
        if (![array isKindOfClass:[NSNull class]]&&array.count!=0){
            [MasterListModel getMasterListByArray:array Array:self.resultArray];
        }
    }
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
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
    _cell=[tableView dequeueReusableCellWithIdentifier:@"MasterListCell"];
    if (_cell==nil) {
        _cell=[[MasterListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MasterListCell"];
    }
    MasterListModel *model=(MasterListModel *)self.resultArray[indexPath.section];
    NSString *strId;
    if ([_type isEqualToString:@"MasterList"]) {
        if ([NSString isEqualToNull:_aimTextField.text]&&[[NSString stringWithFormat:@"%@",model.name] isEqualToString:_aimTextField.text]) {
            strId=@"1";
        }else{
            strId=@"";
        }
    }
    [_cell configViewWithModel:model withStr:strId withType:_type];
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterListModel *model=(MasterListModel *)self.resultArray[indexPath.section];
    if ([_type isEqualToString:@"MasterList"]) {
        _aimTextField.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.name]]?model.name:@"";
        if (self.block) {
            self.block();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
}
-(void)loadData{
    [self requestDate];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([NSString isEqualToNull:_searchAim]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else{
        tips=Custing(@"您还没有记录哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
    
}

#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.currPage=1;
        _searchAim=@"";
        [self requestDate];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_sea_searchbar resignFirstResponder];
    _searchAim=searchBar.text;
    self.currPage=1;
    [self requestDate];
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
