//
//  CustomLeadInController.m
//  galaxy
//
//  Created by hfk on 16/7/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CustomLeadInController.h"
#import "CustomNotesCell.h"
#define pageNum  (Main_Screen_Height-NavigationbarHeight-44)/70+6
@interface CustomLeadInController ()

@end

@implementation CustomLeadInController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"华住酒店", nil) backButton:YES ];
    [self createSegment];
    _requestType=@"1";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        if (_segIndex==0){
            self.currPage=1;
            _segIndex=0;
            [self requestNoLead];
        }else if (_segIndex==1)
        {
            self.currPage=1;
            _segIndex=1;
            [self requestHasLead];
        }
    }
    _requestType=@"0";
}
//MARK:创建分段器
-(void)createSegment
{
    
    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
    _segementView.type=@"1";
    _segementView.titleArray = @[Custing(@"未导入", nil) ,Custing(@"已导入", nil)];
    _segementView.titleColor=Color_GrayDark_Same_20;
    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
    _segementView.titleSelectedColor = Color_Blue_Important_20;
    _segementView.backgroundColor=Color_White_Same_20;
    _segementView.touchDelegate = self;
    _segementView.titleFont=13.f;
    [self.view addSubview:_segementView];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    NSLog(@"我是第%ld个label",(long)index);
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            self.currPage=1;
//            _rightSearchBtn.hidden=NO;
            [self requestNoLead];
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            self.currPage=1;
//            _rightSearchBtn.hidden=YES;
            [self requestHasLead];
            break;
        default:
            break;
    }
}
#pragma mark 添加网络数据
//MARK:未导入
-(void)requestNoLead{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",NotLeadHotel];
    
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"CreateTime",@"IsAsc":@"desc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:已导入
-(void)requestHasLead{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",HasLeadHotel];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"CreateTime",@"IsAsc":@"desc"};
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
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    //下拉刷新
    if (self.currPage == 1&&self.isLoading) {
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
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            LeadHotelModel *model=[[LeadHotelModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            LeadHotelModel *model=[[LeadHotelModel alloc]init];
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
//    _segementView.otherTitles = @[@"未导入",@"已导入"];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


-(void)loadData{
    if (_segIndex==0) {
        [self requestNoLead];
    }else if (_segIndex==1){
        [self requestHasLead];

    }
}

//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return 10;
    }else{
        return 0.01;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.resultArray) {
        if (self.resultArray.count>0) {
            if (self.resultArray[indexPath.section]) {
                LeadHotelModel * model = (LeadHotelModel *)self.resultArray[indexPath.section];
                CGSize size = [model.hotelName sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-225, 10000) lineBreakMode:NSLineBreakByCharWrapping];
                return 50+size.height;
                return 0;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomNotesCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CustomNotesCell"];
    if (cell==nil) {
        cell=[[CustomNotesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomNotesCell"];
    }
    if (self.resultArray) {
        if (self.resultArray.count>0) {
            if (self.resultArray[indexPath.section]) {
                LeadHotelModel * model = (LeadHotelModel *)self.resultArray[indexPath.section];
                [cell configLeadHotelViewWithCellInfo:model withIndex:_segIndex];
            }
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeadHotelModel *leadModel=self.resultArray[indexPath.section];
    if (_segIndex!=0||![[NSString stringWithFormat:@"%@",leadModel.status]isEqualToString:@"2"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"记录不能被导入", nil) duration:2.0];
        return;
    }
    AddDetailsModel *model=[[AddDetailsModel alloc]init];
    model.expenseDate=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",leadModel.checkInDate]]?[NSString stringWithFormat:@"%@",leadModel.checkInDate]:@"";
    model.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",leadModel.Id]]?[NSString stringWithFormat:@"%@",leadModel.Id]:@"";
    model.cityCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",leadModel.cityCode]]?[NSString stringWithFormat:@"%@",leadModel.cityCode]:@"";
    model.cityName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",leadModel.cityName]]?[NSString stringWithFormat:@"%@",leadModel.cityName]:@"";
    model.amount=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",leadModel.price]]?[NSString stringWithFormat:@"%@",leadModel.price]:@"";
    if ([NSString isEqualToNull:leadModel.checkInDate]&&[NSString isEqualToNull:leadModel.checkOutDate]) {
        model.remark=[NSString stringWithFormat:@"%@\n%@-%@",leadModel.hotelName,leadModel.checkInDate,leadModel.checkOutDate];
    }else if ([NSString isEqualToNull:leadModel.checkInDate]&&![NSString isEqualToNull:leadModel.checkOutDate]){
        model.remark=[NSString stringWithFormat:@"%@\n%@",leadModel.hotelName,leadModel.checkInDate];
    }
    model.OrderId = [NSString stringWithIdOnNO:model.OrderId];
    model.expenseType=Custing(@"住宿", nil);
    model.expenseIcon=@"05";
    model.expenseCode=@"0005";
    model.type=@"1";
    model.BeforeType=@"1";
    model.checked = @"1";
    model.totalDays=[GPUtils getTimeIntervalFirstTime:leadModel.checkInDate SecondTime:leadModel.checkOutDate];
    NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
    add.Id = [model.Id integerValue];
    add.Action = 1;
    add.Enabled_addAgain = 1;
    add.model_addDetail = model;
    add.str_expenseCode = @"0005";
    add.str_expenseIcon = @"05";
    add.expenseType = Custing(@"住宿", nil);
    add.dateSource = @"9";
    [self.navigationController pushViewController:add animated:YES];

}

//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if (_segIndex==0) {
        tips=Custing(@"您还没有未导入记录哦", nil) ;
    }else if (_segIndex==1){
        tips=Custing(@"您还没有已导入记录哦", nil) ;
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
