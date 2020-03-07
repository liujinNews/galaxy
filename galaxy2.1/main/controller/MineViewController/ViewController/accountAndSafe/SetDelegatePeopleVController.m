//
//  SetDelegatePeopleVController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/3/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "SetDelegatePeopleVController.h"
#import "buildCellInfo.h"
#import "TViewCell.h"

@interface SetDelegatePeopleVController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *oftenItemArray;//其他联系人

@property (nonatomic, strong) NSMutableArray *userItemArray;//用户列表

@property (nonatomic, strong) NSMutableArray *arrshowinfo;//显示数据

@property (nonatomic, strong) NSMutableArray *arrClick;//点击后数据

@property (nonatomic, strong) NSDictionary *resultDict;//请求后参数

@property (nonatomic, copy) NSString *Searchtext;

@end

@implementation SetDelegatePeopleVController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if (_arr_System.count>0) {
        [self setTitle:@"选择代理" backButton:YES];
    }
    else
    {
        [self setTitle:Custing(@"选择代理人", nil) backButton:YES];
    }
    
    _oftenItemArray = [[NSMutableArray alloc]init];
    _userItemArray = [[NSMutableArray alloc]init];
    _arrshowinfo = [[NSMutableArray alloc]init];
    _arrClick = [[NSMutableArray alloc]init];
    self.sea_Search.delegate = self;
    self.sea_Search.placeholder=Custing(@"搜索代理人", nil);
    self.tab_tableview.dataSource = self;
    self.tab_tableview.delegate = self;
    self.tab_tableview.tableFooterView = [[UIView alloc]init];
    if (_arr_System.count>0) {
        [self parsingSystem];
    }
    else
    {
        [self getagentsdelegated];
    }
    
}

//获取代理人列表参数
-(void)getagentsdelegated
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getusers] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}


//初始化选择人列表
-(void)parsingSystem
{
    [_userItemArray removeAllObjects];
    for (int i = 0 ; i<_arr_System.count; i++) {
        
        buildCellInfo *cell = [buildCellInfo retrunByDic:_arr_System[i]];
        [_userItemArray addObject:cell];
    }
    [YXSpritesLoadingView dismiss];
    [self ProvinceByCity:_oftenItemArray array:_userItemArray];
    
}

//初始化用户参数
-(void)requestUserOver
{
    [_oftenItemArray removeAllObjects];
    [_userItemArray removeAllObjects];
    NSMutableArray * lastarr = [[NSMutableArray alloc]init];
    
    [buildCellInfo GetcompanyBookDictionary:_resultDict Array:lastarr Array:_userItemArray cleanSelf:YES];
    
    if (self.arrClickPeople.count>0) {
        for (int a=0; a<self.arrClickPeople.count; a++) {
            for (int i =0; i<_userItemArray.count; i++) {
                buildCellInfo *info = _userItemArray[i];
                if ([self.arrClickPeople[a][@"agentUserId"] intValue]==info.requestorUserId) {
                    info.isClick = @"1";
                    _userItemArray[i] = info;
                }
            }
        }
    }
    
}

//原始数据转换为显示数据
-(void) ProvinceByCity:(NSMutableArray *)array1 array:(NSMutableArray *)array2
{
    //    array = [NSMutableArray arrayWithArray:array1];
    [array2 sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        buildCellInfo *dic1 = obj1;
        buildCellInfo *dic2 = obj2;
        NSString *str1=dic1.guihua;
        NSString *str2=dic2.guihua;
        return [str1 compare:str2];
    }];
    
    NSMutableArray *Temporary = [[NSMutableArray alloc]init];
    
    NSMutableArray *ma = [[NSMutableArray alloc]init];
    NSMutableDictionary *md = [[NSMutableDictionary alloc]init];
    NSString *oneguihua = @"";
    //常规用户
    for (int i = 0; i<array2.count; i++) {
        buildCellInfo *travel = array2[i];
        if ([oneguihua isEqualToString:travel.guihua]) {
            [ma addObject:travel];
        }
        else
        {
            if (i>0) {
                [md setObject:ma forKey:@"array"];
                [Temporary addObject:md];
            }
            oneguihua = travel.guihua;
            ma =[[NSMutableArray alloc]init];
            md =[[NSMutableDictionary alloc]init];
            [ma addObject:travel];
            [md setObject:travel.guihua forKey:@"title"];
        }
        if (i==array2.count-1) {
            [md setObject:ma forKey:@"array"];
            [Temporary addObject:md];
        }
    }
    
    [Temporary sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *str1=(NSString *)[obj1 objectForKey:@"title"];
        NSString *str2=(NSString *)[obj2 objectForKey:@"title"];
        return [str1 compare:str2];
    }];
    _arrshowinfo = Temporary;
}

//返回事件
- (void)addMineContent{
    if (self.chooseDelegateBlock) {
        self.chooseDelegateBlock(_arrClick);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - action 事件
//nav右侧Btn点击事件
-(void)sta_rightBtn_Click:(UIButton *)btn
{
    NSLog(@"233333");
}

#pragma mark - delegate 事件
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSLog(@" number %d resDic:%@   ",serialNum, responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    
    if (serialNum == 0) {
        _resultDict = responceDic;
        [self requestUserOver];
        [self ProvinceByCity:_oftenItemArray array:_userItemArray];
        [self.tab_tableview reloadData];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

}

//搜索代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    _Searchtext = searchText;
    if (![searchText isEqualToString:@""]) {
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        
        for (buildCellInfo *dic in _userItemArray) {
            if ([dic.requestor rangeOfString:searchText].location != NSNotFound)
            {
                [toRemove addObject:dic];
            }
        }
        
        [self ProvinceByCity:[[NSMutableArray alloc]init] array:toRemove];
        [self.tab_tableview reloadData];
    }
    else if ([searchText isEqualToString:@""])
    {
        [self ProvinceByCity:_oftenItemArray array:_userItemArray];
        [self.tab_tableview reloadData];
    }
}

#pragma mark tableview加载
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    NSLog(@"%lu",(unsigned long)arrshowinfo.count);
    return _arrshowinfo.count;
}

//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _arrshowinfo[section][@"array"];
    //    NSLog(@"%lu~~~~%ld",(unsigned long)arr.count,(long)section);
    return arr.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

//组头加载
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    
    return view;
}

/**
 *  返回右边索引条显示的字符串数据
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [_arrshowinfo valueForKeyPath:@"title"];
}

//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TViewCell"];
    if (cell==nil) {
        cell=[[TViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TViewCell"];
    }
    NSArray *arr = _arrshowinfo[indexPath.section][@"array"];
    
    buildCellInfo *cellInfo = arr[indexPath.row];
    [cell configViewWithCellInfo:cellInfo];
    
    return cell;
}



//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSArray *array = _arrshowinfo[indexPath.section][@"array"];
    buildCellInfo *cellInfo = array[indexPath.row];
    
    //进入主页面，代理模式
    
    NSDictionary *dic;
    cellInfo.isClick = @"1";
    if (cellInfo.requestorUserId == 0) {
        dic = [[NSDictionary alloc]init];
    }
    else
    {
        dic =@{@"requestorUserId":[NSString stringWithFormat:@"%ld",(long)cellInfo.requestorUserId],@"requestor":cellInfo.requestor,@"photoGraph":cellInfo.photoGraph,@"requestorAccount":cellInfo.requestorAccount};
    }
    
    [_arrClick addObject:dic];
    
    [self addMineContent];
    
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
