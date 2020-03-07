//
//  PersonnelStatCategoryViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define pageNum  (Main_Screen_Height-NavigationbarHeight)/70
#import "PersonnelStatData.h"
#import "projectCostTViewCell.h"

#import "PersonnelStatCategoryViewController.h"

@interface PersonnelStatCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property(nonatomic,strong)UIView *noDateView;//无数据视图
@property (nonatomic, strong) NSString *start_select_date;//当前选择的起始时间
@property (nonatomic, strong) NSString *end_select_date;//当前选择的结束时间
@property (nonatomic, strong) UIView *HeadView;//费用详情视图
@property (nonatomic,strong)NSString * recordcount;

//MJ 需要内容
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property (nonatomic, assign) BOOL  isEditing;

@end

@implementation PersonnelStatCategoryViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.statisticsStatus isEqualToString:@"projectStat"]) {
        [self setTitle:self.personDict[@"projName"] backButton:YES];
    }else if ([self.statisticsStatus isEqualToString:@"depatrment"]){
        [self setTitle:self.personDict[@"userDspName"] backButton:YES];
    }else if ([self.statisticsStatus isEqualToString:@"depatrmentCategary"]){
        [self setTitle:self.personDict[@"userDspName"] backButton:YES];
    }
    else{
        [self setTitle:self.personDict[@"requestor"] backButton:YES];
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.start_select_date = self.timeDict[@"StartRequestorDate"];
    self.end_select_date = self.timeDict[@"EndRequestorDate"];
//    [self requestGetbudgetDocument];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.equalTo(@(Main_Screen_Width));
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = Color_White_Same_20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}

//下拉上拉
-(void)loadData
{
    [self requestGetbudgetDocument];
}


//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
        NSString * startDate=[NSString stringWithFormat:@"%@：",Custing(@"起始时间", nil)];//@"起始时间： ";;
        NSString * endDate= [NSString stringWithFormat:@"%@：",Custing(@"结束时间", nil)];//@"结束时间： ";;
        NSString * entityStr= Custing(@"项目费用统计", nil);

        
        self.HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 95)];
        _HeadView.backgroundColor = [UIColor clearColor];
        //起始结束时间
        UIView  * timeView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
        timeView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [_HeadView addSubview:timeView];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        line.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:line];
        
        UIImageView * startImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        startImage.image = [UIImage imageNamed:@"status_startTime"];
        startImage.backgroundColor = [UIColor clearColor];
        [timeView addSubview:startImage];
        
        UILabel * startLab = [GPUtils createLable:CGRectMake(35, 0, 200, 30) text:[NSString stringWithFormat:@"%@%@",startDate,self.start_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        startLab.backgroundColor = [UIColor clearColor];
        [timeView addSubview:startLab];
        
        UIView * timeLine = [[UIView alloc]initWithFrame:CGRectMake(17.5, 22.5, 0.5, 15)];
        timeLine.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:timeLine];
        
        UIImageView * endImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37.5, 15, 15)];
        endImage.image = [UIImage imageNamed:@"status_endTime"];
        endImage.backgroundColor = [UIColor clearColor];
        [timeView addSubview:endImage];
        
        UILabel * endLab = [GPUtils createLable:CGRectMake(35, 30, 200, 30) text:[NSString stringWithFormat:@"%@%@",endDate,self.end_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        endLab.backgroundColor = [UIColor clearColor];
        [timeView addSubview:endLab];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, Main_Screen_Width, 0.5)];
        line1.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:line1];
        
        //报销类别描述
        UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 4, 25)];
        ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        ImgView.backgroundColor=Color_Blue_Important_20;
        [_HeadView addSubview:ImgView];
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_HeadView addSubview:titleLabel];
        
        if ([self.statisticsStatus isEqualToString:@"projectStat"]) {
            titleLabel.text = entityStr;
        }else if ([self.statisticsStatus isEqualToString:@"depatrment"]){
            titleLabel.text = Custing(@"部门费用统计", nil);
        }
        else{
            titleLabel.text = Custing(@"员工费用统计", nil);
        }
        
        _HeadView.backgroundColor=Color_White_Same_20;
        [self.tableView addSubview:_HeadView];
        
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, 95, Main_Screen_Width, HEIGHT(self.tableView))];
        _noDateView.backgroundColor=Color_form_TextFieldBackgroundColor;
        [self.tableView addSubview:_noDateView];
        
        UIImageView *nodataView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 162, 84.5)];
        nodataView.center=CGPointMake(Main_Screen_Width/2, 100*SCALEH);
        nodataView.image=[UIImage imageNamed:@"TemporarilyNoData"];
        [_noDateView addSubview:nodataView];
        
        UILabel *title=[GPUtils createLable:CGRectMake(0, 0, 160, 18) text:nil font:Font_selectTitle_15 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentCenter];
        title.text = Custing(@"暂无数据", nil);
        title.center=CGPointMake(Main_Screen_Width/2, Y(nodataView)+HEIGHT(nodataView)+28);
        [_noDateView addSubview:title];
    }
}

//MARK:移除筛选无数据视图
-(void)removeNodateViews{
    if (_noDateView&&_noDateView!=nil) {
        [_noDateView removeFromSuperview];
        _noDateView=nil;
        [_HeadView removeFromSuperview];
        _HeadView=nil;
    }
}

//员工费用明细详情
-(void)requestGetbudgetDocument
{
    self.isLoading = YES;
    if ([self.statisticsStatus isEqualToString:@"projectStat"]) {
        NSDictionary *dict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date,@"ProjName":self.personDict[@"projName"],@"OrderBy":@"expenseDate",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum]};
        NSLog(@"%@",dict);
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"ProjCostAct/GetProjCostActDetail"] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
    }else if ([self.statisticsStatus isEqualToString:@"depatrment"]){
        NSDictionary *dict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date,@"UserId":self.personDict[@"userId"],@"OrderBy":@"expenseDate",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum]};
        NSLog(@"%@",dict);
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetMbrExpDetails"] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
    }else if ([self.statisticsStatus isEqualToString:@"depatrmentCategary"]){
        NSDictionary *dict = @{@"FromDate":_start_select_date,@"ToDate":_end_select_date,@"GroupId":self.personDict[@"GroupId"],@"ExpenseCode":self.personDict[@"ExpenseCode"],@"OrderBy":@"expenseDate",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum]};
        NSLog(@"%@",dict);
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetTypExpDetails"] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
    }
    else{
        NSDictionary *dict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date,@"RequestorUserId":self.personDict[@"requestorUserId"],@"OrderBy":@"expenseDate",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":[NSString stringWithFormat:@"%d",(int)pageNum]};
        NSLog(@"%@",dict);
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"RequestCostAct/GetRequestCostActDetail"] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
    }
    
}


#pragma mark - delegate
//网络请求
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSLog(@"%@",responceDic);
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        [YXSpritesLoadingView dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (serialNum ==0) {
        [YXSpritesLoadingView dismiss];
        NSDictionary *result = [responceDic objectForKey:@"result"];
        self.recordcount = [NSString stringWithFormat:@"%@",[result objectForKey:@"recordcount"]];
        self.totalPage = [[result objectForKey:@"totalPages"] integerValue];
        
    }
    
    switch (serialNum) {
        case 0:
            
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPage >= self.currPage) {
                if ([self.statisticsStatus isEqualToString:@"projectStat"]) {
                    [PersonnelStatData GetProjectStatDictionary:responceDic Array:self.resultArray];
                }else if ([self.statisticsStatus isEqualToString:@"depatrment"]){
                    [PersonnelStatData GetDepartmentStatDictionary:responceDic Array:self.resultArray];
                }else if ([self.statisticsStatus isEqualToString:@"depatrmentCategary"]){
                    [PersonnelStatData GetDepartmentStatDictionary:responceDic Array:self.resultArray];
                }
                else{
                    [PersonnelStatData GetPersonnelStatDictionary:responceDic Array:self.resultArray];
                }
                
            }
            if (self.resultArray.count==0) {
                [self createNOdataView];
            }else{
                [self removeNodateViews];
            }
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

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//返回两个组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultArray.count;
    
}

//表单加载
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        NSInteger cateHeight;
        if ([self.statisticsStatus isEqualToString:@"depatrmentCategary"]) {
            cateHeight = 135;
        }else{
            cateHeight = 95;
        }
        return cateHeight;
    }else{
        return 10.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSString * startDate= [NSString stringWithFormat:@"%@：",Custing(@"起始时间", nil)];//@"起始时间： ";;
        NSString * endDate= [NSString stringWithFormat:@"%@：",Custing(@"结束时间", nil)];//@"结束时间： ";;
        NSString * entityStr= Custing(@"项目费用统计", nil);
        
        NSInteger cateHeight;
        if ([self.statisticsStatus isEqualToString:@"depatrmentCategary"]) {
            cateHeight = 135;
        }else{
            cateHeight = 95;
        }
        
        self.HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, cateHeight)];
        _HeadView.backgroundColor = [UIColor clearColor];
        //起始结束时间
        UIView  * timeView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
        timeView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [_HeadView addSubview:timeView];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        line.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:line];
        
        UIImageView * startImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        startImage.image = [UIImage imageNamed:@"status_startTime"];
        startImage.backgroundColor = [UIColor clearColor];
        [timeView addSubview:startImage];
        
        UILabel * startLab = [GPUtils createLable:CGRectMake(35, 0, 200, 30) text:[NSString stringWithFormat:@"%@%@",startDate,self.start_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        startLab.backgroundColor = [UIColor clearColor];
        [timeView addSubview:startLab];
        
        UIView * timeLine = [[UIView alloc]initWithFrame:CGRectMake(17.5, 22.5, 0.5, 15)];
        timeLine.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:timeLine];
        
        UIImageView * endImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37.5, 15, 15)];
        endImage.image = [UIImage imageNamed:@"status_endTime"];
        endImage.backgroundColor = [UIColor clearColor];
        [timeView addSubview:endImage];
        
        UILabel * endLab = [GPUtils createLable:CGRectMake(35, 30, 200, 30) text:[NSString stringWithFormat:@"%@%@",endDate,self.end_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        endLab.backgroundColor = [UIColor clearColor];
        [timeView addSubview:endLab];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, Main_Screen_Width, 0.5)];
        line1.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:line1];
        
        //报销类别描述
        UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 4, 25)];
        ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        ImgView.backgroundColor=Color_Blue_Important_20;
        [_HeadView addSubview:ImgView];
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_HeadView addSubview:titleLabel];
        
        if ([self.statisticsStatus isEqualToString:@"projectStat"]) {
            titleLabel.text = entityStr;
        }else if ([self.statisticsStatus isEqualToString:@"depatrment"]){
            titleLabel.text = Custing(@"部门费用统计", nil);
        }else if ([self.statisticsStatus isEqualToString:@"depatrmentCategary"]) {
            ImgView.hidden = YES;
            titleLabel.hidden = YES;
            
            //总金额
            UIView * amountView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, Main_Screen_Width, 55)];
            amountView.backgroundColor = Color_ClearBlue_Same_20;
            [self.HeadView addSubview:amountView];
            
            UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
            line2.backgroundColor = Color_GrayLight_Same_20;
            [amountView addSubview:line2];
            
            UILabel * amountLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(amountView)-30, 55) text:@"" font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
            amountLa.backgroundColor = [UIColor clearColor];
            [amountView addSubview:amountLa];
            
            if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.personDict[@"amount"]]]) {
                amountLa.text = [NSString stringWithFormat:@"%@ %@",self.personDict[@"userDspName"],[GPUtils transformNsNumber:self.personDict[@"amount"]]];
            }
            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 54.5, Main_Screen_Width, 0.5)];
            line3.backgroundColor = Color_GrayLight_Same_20;
            [amountView addSubview:line3];
            
        }
        else{
            titleLabel.text = Custing(@"员工费用统计", nil);
        }
        
        _HeadView.backgroundColor=Color_White_Same_20;
        return _HeadView;
    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10.0)];
        return view;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    projectCostTViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"projectCostTViewCell"];
    if (cell==nil) {
        cell=[[projectCostTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"projectCostTViewCell"];
    }
    PersonnelStatData *cellInfo = self.resultArray[indexPath.section];
    if ([self.statisticsStatus isEqualToString:@"depatrment"]) {
        [cell configDepartmentCategoryDataCellInfo:cellInfo];
    }else if ([self.statisticsStatus isEqualToString:@"projectStat"]) {
        [cell configProjectCostCategoryDataCellInfo:cellInfo];
    }else if ([self.statisticsStatus isEqualToString:@"depatrmentCategary"]) {
        [cell configDepartmentCategoryDataCellInfo:cellInfo];
    }
    else{
        [cell configPersonnelCostCategoryDataCellInfo:cellInfo];
    }
    
    return cell;
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
