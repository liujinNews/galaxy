//
//  SelectViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "SelectViewController.h"


@interface SelectViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *showarray;
@property (nonatomic, strong) ChooseCategoryCell *cell;
@property (nonatomic, strong)NSDictionary *Responce;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if (_type == 0) {
        [self setTitle:Custing(@"选择级别", nil) backButton:YES ];
    }else if (_type == 1) {
        [self setTitle:Custing(@"选择职位", nil) backButton:YES ];
    }else if (_type == 2) {
        [self setTitle:Custing(@"选择成本中心", nil) backButton:YES ];
    }else if (_type == 3) {
        [self setTitle:Custing(@"选择公司", nil) backButton:YES ];
    }else if (_type == 4) {
        [self setTitle:Custing(@"选择审批步骤", nil) backButton:YES ];
    }else if (_type == 5) {
        [self setTitle:Custing(@"选择业务部门", nil) backButton:YES ];
    }else if (_type == 8) {
        [self setTitle:Custing(@"选择车辆", nil) backButton:YES];
    }
    _tab_table.delegate = self;
    _tab_table.dataSource = self;
    _tab_table.backgroundColor = Color_White_Same_20;
    _tab_table.tableFooterView = [[UIView alloc]init];
    [self requestEditPositionData];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

//员工职位列表、级别
-(void)requestEditPositionData {
    
    NSDictionary * dic;
    if (_type == 1) {
        dic = @{@"PageIndex":@"1",@"PageSize":@"999",@"OrderBy":@"id",@"IsAsc":@"desc"};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getjobtitles] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    }else if(_type == 0){
        dic = @{@"PageIndex":@"1",@"PageSize":@"999",@"OrderBy":@"id",@"IsAsc":@"desc"};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getuserlevels] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }
    else if (_type == 2)
    {
        NSDictionary * dic =@{@"PageIndex":@"1",@"PageSize":@"999",@"OrderBy":@"id",@"IsAsc":@"desc"};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcostcs] Parameters:dic Delegate:self SerialNum:2 IfUserCache:NO];
        
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    }else if (_type == 3)
    {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetBranch] Parameters:dic Delegate:self SerialNum:3 IfUserCache:NO];
    }else if (_type == 4){
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetNodesByFlowGuid] Parameters:@{@"FlowGuid":_FlowGuid} Delegate:self SerialNum:4 IfUserCache:NO];
    }else if (_type == 5){
        [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"%@",GetBusDepts] Parameters:@{} Delegate:self SerialNum:5 IfUserCache:NO];
    }
    else if (_type == 8){
        [[GPClient shareGPClient]RequestByGetWithPath:[NSString stringWithFormat:@"%@",GetVehicleInfos] Parameters:@{} Delegate:self SerialNum:5 IfUserCache:NO];
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSString *success = [NSString stringWithFormat:@"%@",responceDic[@"success"]];
    if (![success isEqualToString:@"1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
        return;
    }else{
        NSDictionary *dic = responceDic[@"result"];
        if (![dic isEqual:nil]&&dic.count>0) {
            NSArray *arr;
            if (_type==3||_type==4||_type==5||_type==6||_type==8) {
                arr = responceDic[@"result"];
            }else{
                arr = responceDic[@"result"][@"items"];
            }
            if (arr.count>0) {
                _Responce = responceDic;
                if (_type == 1) {
                    [self positionByData];
                }else if (_type == 0) {
                    [self levelByData];
                }else if (_type == 2) {
                    [self coseByData];
                }else if (_type == 3) {
                    [self companeByData];
                }else if (_type == 4) {
                    [self stepByData];
                }else if (_type == 5) {
                    [self busDepartmentData];
                }else if (_type == 8) {
                    [self CarNoAppData];
                }
            }
            [self createNOdataView];
        }else{
            [self createNOdataView];
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//成本中心获取数据解析
-(void)positionByData
{
    NSDictionary *dic = _Responce[@"result"];
    NSArray *arr = dic[@"items"];
    _showarray = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        NSString *value = [mudic objectForKey:@"id"];
        [mudic removeObjectForKey:@"id"];
        [mudic setObject:value forKey:@"ids"];
        SelectDataModel *model = [[SelectDataModel alloc]initWithBydic:mudic];
        [_showarray addObject:model];
    }
    [_tab_table reloadData];
}

//级别获取数据解析
-(void)levelByData
{
    NSDictionary *dic = _Responce[@"result"];
    NSArray *arr = dic[@"items"];
    _showarray = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        NSString *value = [mudic objectForKey:@"id"];
        NSString *description = [mudic objectForKey:@"description"];
        [mudic removeObjectForKey:@"id"];
        [mudic removeObjectForKey:@"description"];
        [mudic setObject:value forKey:@"ids"];
        [mudic setObject:description forKey:@"descriptions"];
        SelectDataModel *model = [[SelectDataModel alloc]initWithBydic:mudic];
        [_showarray addObject:model];
    }
    [_tab_table reloadData];
}

//职位获取数据解析
-(void)coseByData
{
    
    NSDictionary *dic = _Responce[@"result"];
    NSArray *arr = dic[@"items"];
    _showarray = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        NSString *value = [mudic objectForKey:@"id"];
        [mudic removeObjectForKey:@"id"];
        [mudic setObject:value forKey:@"ids"];
        SelectDataModel *model = [[SelectDataModel alloc]initWithBydic:mudic];
        [_showarray addObject:model];
    }
    [_tab_table reloadData];
}

//公司数据解析
-(void)companeByData
{
    NSArray *arr = _Responce[@"result"];
    _showarray = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        SelectDataModel *model = [[SelectDataModel alloc]initWithBydic:mudic];
        [_showarray addObject:model];
    }
    [_tab_table reloadData];
}

//审批步骤解析
-(void)stepByData
{
    NSArray *arr = _Responce[@"result"];
    _showarray = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        SelectDataModel *model = [[SelectDataModel alloc]initWithBydic:mudic];
        [_showarray addObject:model];
    }
    [_tab_table reloadData];
}

//员工部门解析
-(void)busDepartmentData{
    NSArray *arr = _Responce[@"result"];
    _showarray = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        SelectDataModel *model = [[SelectDataModel alloc]initWithBydic:mudic];
        [_showarray addObject:model];
    }
    [_tab_table reloadData];
}


//用车解析
-(void)CarNoAppData{
    NSArray *arr = _Responce[@"result"];
    _showarray = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        SelectDataModel *model = [[SelectDataModel alloc]initWithBydic:mudic];
        [_showarray addObject:model];
    }
    [_tab_table reloadData];
}

#pragma mark 创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if (_type == 0) {
        tips=Custing(@"您还没添加级别哦", nil);
    }else if(_type == 1) {
        tips=Custing(@"您还没有设置职位哦", nil);
    }else if(_type == 2) {
        tips=Custing(@"您还没有设置成本中心哦", nil);
    }else if(_type == 3) {
        tips=Custing(@"您还没有设置公司哦", nil);
    }else if(_type == 4) {
        tips=Custing(@"您还没有设置审批步骤哦", nil);
    }else if(_type == 5) {
        tips=Custing(@"您还没有设置业务部门哦", nil);
    }else if(_type == 8) {
        tips=Custing(@"您还没有设置车辆哦", nil);
    }
    [_tab_table configBlankPage:EaseBlankNormalView hasTips:tips hasData:(_showarray.count!=0) hasError:NO reloadButtonBlock:nil];

}


#pragma mark  加载tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _showarray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseCategoryCell"];
    if (_cell==nil) {
        _cell=[[ChooseCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCategoryCell"];
    }
    SelectDataModel *model = _showarray[indexPath.section];
    NSString *str = @"";
    if ([NSString isEqualToNull:_selectId]) {
        if ([_selectId isEqualToString:[NSString stringWithFormat:@"%@",model.ids]]||[_selectId isEqualToString:[NSString stringWithFormat:@"%@",model.nodeId]]||[_selectId isEqualToString:[NSString stringWithFormat:@"%@",model.groupId]]||[_selectId isEqualToString:[NSString stringWithFormat:@"%@",model.companyId]]) {
            str = @"1";
        }
    }
    
    if ([NSString isEqualToNull:model.userLevel]) {
        [_cell configFreViewWithString:model.userLevel withIdStr:str ];
    }
    if (_type==3) {
        [_cell configFreViewWithString:model.groupName withIdStr:str ];
    }else if (_type==4){
        [_cell configFreViewWithString:model.nodeName withIdStr:str ];
    }else if (_type==5){
        [_cell configFreViewWithString:model.name withIdStr:str ];
    }else if (_type==6){
        [_cell configFreViewWithString:model.contractTyp withIdStr:str ];
    }else if (_type==8){
        [_cell configFreViewWithString:[NSString stringWithFormat:@"%@/%@",model.carNo,model.carDesc] withIdStr:str ];
    }else{
        if ([NSString isEqualToNull:model.jobTitle]) {
            [_cell configFreViewWithString:model.jobTitle withIdStr:str ];
        }
        if ([NSString isEqualToNull:model.costCenter]) {
            [_cell configFreViewWithString:model.costCenter withIdStr:str ];
        }
    }
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SelectViewControllerClickedLoadBtn:)]) {
        [self.delegate SelectViewControllerClickedLoadBtn:_showarray[indexPath.section]];
    }
    [self Navback];
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
