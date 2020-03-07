//
//  ColleagueListController.m
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ColleagueListController.h"
#import "ColleagueListCell.h"
#import "ColleagueCalendarController.h"
@interface ColleagueListController ()

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ColleagueListCell *cell;
@property (nonatomic, strong) UISearchBar *sea_searchbar;
@property(nonatomic,strong)NSString *searchAim;

@end

@implementation ColleagueListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"同事日程", nil) backButton:YES ];
    _searchAim=@"";
    _arr_result=[NSMutableArray array];
    [self createView];
    [self getData];
}
//MARK:创建tableView
-(void)createView{
    _sea_searchbar  = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    _sea_searchbar.delegate = self;
    [self.view addSubview:_sea_searchbar];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=Color_White_Same_20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@44);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
}
-(void)getData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETCOLLCaldaner];
    NSDictionary * dic =@{@"Name":_searchAim};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
            [self dealWithData];
            [self createNOdataView];
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
-(void)dealWithData{
    [_arr_result removeAllObjects];
    if ([_resultDict[@"result"] isKindOfClass:[NSArray class]]) {
        NSArray *array=_resultDict[@"result"];
        if (array.count>0) {
            [_arr_result addObjectsFromArray:array];
        }
    }
}

//MARK:tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr_result.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"ColleagueListCell"];
    if (_cell==nil) {
        _cell=[[ColleagueListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ColleagueListCell"];
    }
    _cell.dict_data=_arr_result[indexPath.row];
    _cell.bool_hasLine=(indexPath.row+1==_arr_result.count);
    return _cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict_data=_arr_result[indexPath.row];
    
    ColleagueCalendarController *vc=[[ColleagueCalendarController alloc]init];
    vc.str_useId=[NSString isEqualToNull:dict_data[@"userId"]]?[NSString stringWithFormat:@"%@",dict_data[@"userId"]]:@"";
    vc.str_useName=[NSString isEqualToNull:dict_data[@"userDspName"]]?[NSString stringWithFormat:@"%@",dict_data[@"userDspName"]]:@"";
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        _searchAim=@"";
        [self getData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    [self getData];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([NSString isEqualToNull:_searchAim]) {
        tips=Custing(@"您还没有相关记录哦", nil);
    }else{
        tips=Custing(@"您还没有同事日程哦", nil);
    }
    [self.view configBlankPage:EaseBlankNormalView hasTips:tips hasData:(_arr_result.count!=0) hasError:NO reloadButtonBlock:nil];
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
