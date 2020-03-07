//
//  secondDepartmentViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "PersonnelStatCategoryViewController.h"

#import "secondDepartmentViewController.h"
#import "departmentStatData.h"
#import "DepartmentStatTableViewCell.h"

#import "secondDepartmentViewController.h"

@interface secondDepartmentViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UIView *contentView;//滚动视图contentView
@property (nonatomic, strong) UITableView *tableView;//明细表单视图
@property (nonatomic, strong) NSString *start_select_date;//当前选择的起始时间
@property (nonatomic, strong) NSString *end_select_date;//当前选择的结束时间

@property (nonatomic, strong) NSMutableArray *Arr_array;
@property (nonatomic, strong) NSMutableArray *Arr_groups;//部门数据
@property (nonatomic, strong) NSMutableArray *Arr_groupMbrs;//员工数据

@property(nonatomic,strong)UIView *noDateView;//无数据视图
@property (nonatomic, strong) UIView *HeadView;//费用详情视图

@property(nonatomic,copy)NSString * totalAmount;
@property(nonatomic,copy)NSString * departHeight;


@end

@implementation secondDepartmentViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSString isEqualToNull:self.personDict[@"groupName"]]) {
        [self setTitle:self.personDict[@"groupName"] backButton:YES];
    }
    
    self.Arr_array = [[NSMutableArray alloc]init];
    self.Arr_groups = [[NSMutableArray alloc]init];
    self.Arr_groupMbrs = [[NSMutableArray alloc]init];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.start_select_date = self.timeDict[@"StartRequestorDate"];
    self.end_select_date = self.timeDict[@"EndRequestorDate"];
    
    if ([self.statisticsStatus isEqualToString:@"0"]) {
        [self requestGetbudgetDocument];
    }else if ([self.statisticsStatus isEqualToString:@"1"]){
        [self requestGetbudgetCategaryDocument];
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - function
#pragma mark  创建视图
-(void)createScrollView
{
    //创建内容视图
    _contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    _contentView.userInteractionEnabled=YES;
    _contentView.backgroundColor=Color_White_Same_20;
    [self.view addSubview:_contentView];
    
}


#pragma mark 请求数据
//按员工费用统计
-(void)requestGetbudgetDocument
{
    NSDictionary *dic = @{@"fromDate":_start_select_date,@"toDate":_end_select_date,@"ParentId":self.personDict[@"groupId"]};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetGroupExp"] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//按费用类别统计
-(void)requestGetbudgetCategaryDocument
{
    NSDictionary *dic = @{@"FromDate":_start_select_date,@"ToDate":_end_select_date,@"ParentId":self.personDict[@"groupId"]};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetGroupExpsByTyp"] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - delegate
//网络请求
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        if (self.Arr_groups.count==0&&self.Arr_groupMbrs.count ==0) {
            [self createNOdataView];
        }else{
            [self removeNodateViews];
        }
        
        self.Arr_array = [NSMutableArray array];
        self.Arr_array = [NSMutableArray arrayWithObjects:@[], nil];
        [self.tableView reloadData];
        
        return;
    }
    
    switch (serialNum) {
        case 0:
            self.Arr_array = [NSMutableArray array];
            self.Arr_groups = [NSMutableArray array];
            self.Arr_groupMbrs = [NSMutableArray array];
            if ([self.statisticsStatus isEqualToString:@"0"]) {
                [departmentStatData GetDepartmentStatDictionary:responceDic Array:self.Arr_groups Array:self.Arr_groupMbrs Array:self.Arr_array];
            }else{
                NSDictionary * result = [responceDic objectForKey:@"result"];
                if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                    return;
                }
                self.totalAmount = [NSString stringWithFormat:@"%@",[result objectForKey:@"totalAmount"]];
                [departmentStatData GetDepartmentStatCategaryDictionary:responceDic Array:self.Arr_groups Array:self.Arr_groupMbrs Array:self.Arr_array];
            }
            break;
            
        default:
            break;
    }
    if (self.Arr_groups.count==0&&self.Arr_groupMbrs.count ==0) {
        [self createNOdataView];
    }else{
        [self removeNodateViews];
    }
    
    [self.tableView reloadData];
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
        NSInteger noHeight;
        if ([self.statisticsStatus isEqualToString:@"0"]) {
            noHeight = 95;
        }else{
            noHeight = 80;
        }
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, noHeight, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-noHeight)];
        _noDateView.backgroundColor=Color_form_TextFieldBackgroundColor;
        [_tableView addSubview:_noDateView];
        
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
        [_HeadView removeFromSuperview];
        _noDateView=nil;
        _HeadView=nil;
    }
}


//表单加载
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.Arr_array.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.Arr_array[section];
    return [itemArray count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    departmentStatData *cellInfo = self.Arr_array[indexPath.section][indexPath.row];
    return [cellInfo.height floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.statisticsStatus isEqualToString:@"0"]) {
        if (section ==0) {
            return 95.0;
        }else{
            return 0.01;
        }
    }else{
        if (section ==0) {
            if (self.Arr_groups.count == 0) {
                return 135;
            }else{
                return 160.0;
            }
            
        }else{
            if (self.Arr_groupMbrs.count == 0) {
                return 0.01;
            }else{
                return 25.0;
            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.statisticsStatus isEqualToString:@"0"]) {
        if (section == 0) {
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
            
            UILabel * startLab = [GPUtils createLable:CGRectMake(35, 0, 200, 30) text:[NSString stringWithFormat:@"%@： %@",Custing(@"起始时间", nil),self.start_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            startLab.backgroundColor = [UIColor clearColor];
            [timeView addSubview:startLab];
            
            UIView * timeLine = [[UIView alloc]initWithFrame:CGRectMake(17.5, 22.5, 0.5, 15)];
            timeLine.backgroundColor = Color_GrayLight_Same_20;
            [timeView addSubview:timeLine];
            
            UIImageView * endImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37.5, 15, 15)];
            endImage.image = [UIImage imageNamed:@"status_endTime"];
            endImage.backgroundColor = [UIColor clearColor];
            [timeView addSubview:endImage];
            
            UILabel * endLab = [GPUtils createLable:CGRectMake(35, 30, 200, 30) text:[NSString stringWithFormat:@"%@： %@",Custing(@"结束时间", nil),self.end_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
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
            
            UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:Custing(@"部门费用统计", nil)font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            titleLabel.backgroundColor = [UIColor clearColor];
            [_HeadView addSubview:titleLabel];
            _HeadView.backgroundColor=Color_White_Same_20;
            return _HeadView;
        }else{
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
            return view;
        }
    }else{
        if (section == 0) {
            if (self.Arr_groups.count == 0) {
                self.departHeight = @"135";
            }else{
                self.departHeight = @"160";
            }
            self.HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [self.departHeight integerValue])];
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
            
            UILabel * startLab = [GPUtils createLable:CGRectMake(35, 0, 200, 30) text:[NSString stringWithFormat:@"%@： %@",Custing(@"起始时间", nil),self.start_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            startLab.backgroundColor = [UIColor clearColor];
            [timeView addSubview:startLab];
            
            UIView * timeLine = [[UIView alloc]initWithFrame:CGRectMake(17.5, 22.5, 0.5, 15)];
            timeLine.backgroundColor = Color_GrayLight_Same_20;
            [timeView addSubview:timeLine];
            
            UIImageView * endImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37.5, 15, 15)];
            endImage.image = [UIImage imageNamed:@"status_endTime"];
            endImage.backgroundColor = [UIColor clearColor];
            [timeView addSubview:endImage];
            
            UILabel * endLab = [GPUtils createLable:CGRectMake(35, 30, 200, 30) text:[NSString stringWithFormat:@"%@： %@",Custing(@"结束时间", nil),self.end_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            endLab.backgroundColor = [UIColor clearColor];
            [timeView addSubview:endLab];
            
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, Main_Screen_Width, 0.5)];
            line1.backgroundColor = Color_GrayLight_Same_20;
            [timeView addSubview:line1];
            
            //总金额
            UIView * amountView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, Main_Screen_Width, 55)];
            amountView.backgroundColor = Color_ClearBlue_Same_20;
            [self.HeadView addSubview:amountView];
            
            UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
            line2.backgroundColor = Color_GrayLight_Same_20;
            [amountView addSubview:line2];
            
            UILabel * amountLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(amountView)-30, 55) text:Custing(@"合计",nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
            amountLa.backgroundColor = [UIColor clearColor];
            [amountView addSubview:amountLa];
            
            if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.totalAmount]]) {
                amountLa.text = [NSString stringWithFormat:@"%@ %@",Custing(@"合计",nil),[GPUtils transformNsNumber:self.totalAmount]];
            }
            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 54.5, Main_Screen_Width, 0.5)];
            line3.backgroundColor = Color_GrayLight_Same_20;
            [amountView addSubview:line3];
            
            //报销类别描述
            UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 135, 4, 25)];
            ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
            ImgView.backgroundColor=Color_Blue_Important_20;
            [_HeadView addSubview:ImgView];
            
            UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 138.5, Main_Screen_Width - 20, 18) text:Custing(@"部门", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            titleLabel.backgroundColor = [UIColor clearColor];
            [_HeadView addSubview:titleLabel];
            
            if ([NSString isEqualToNull:self.personDict[@"groupName"]]) {
                titleLabel.text = [NSString stringWithFormat:@"%@",self.personDict[@"groupName"]];
            }
            
            UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 159.5, Main_Screen_Width, 0.5)];
            line5.backgroundColor = Color_GrayLight_Same_20;
            [_HeadView addSubview:line5];
            if (self.Arr_groups.count == 0) {
                ImgView.hidden = YES;
                titleLabel.hidden = YES;
                line3.hidden = YES;
                line5.hidden = YES;
            }
            
            _HeadView.backgroundColor=Color_White_Same_20;
            return _HeadView;
        }else{
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 25.0)];
            
            UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
            line6.backgroundColor = Color_GrayLight_Same_20;
            [view addSubview:line6];
            
            UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 25)];
            ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
            ImgView.backgroundColor=Color_Blue_Important_20;
            [view addSubview:ImgView];
            
            UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 3.5, Main_Screen_Width - 20, 18) text:Custing(@"费用类别", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            titleLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:titleLabel];
            
            UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(0, 24.5, Main_Screen_Width, 0.5)];
            line7.backgroundColor = Color_GrayLight_Same_20;
            [view addSubview:line7];
            
            if (self.Arr_groupMbrs.count == 0) {
                view.frame = CGRectMake(0, 0, Main_Screen_Width, 0.01);
                line6.hidden = YES;
                ImgView.hidden = YES;
                titleLabel.hidden = YES;
                line7.hidden = YES;
            }
            
            return view;
        }
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
    
    DepartmentStatTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DepartmentStatTableViewCell"];
    if (cell==nil) {
        cell=[[DepartmentStatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentStatTableViewCell"];
    }
    departmentStatData *cellInfo = self.Arr_array[indexPath.section][indexPath.row];
    [cell configViewWithMineCellInfo:cellInfo];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    departmentStatData *cellInfo = self.Arr_array[indexPath.section][indexPath.row];
    if (cellInfo.type == departmentCell) {
        secondDepartmentViewController *info = [[secondDepartmentViewController alloc]init];
        info.timeDict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date};
        info.personDict = @{@"groupId":cellInfo.groupId,@"groupName":cellInfo.groupName,@"totalAmount":cellInfo.totalAmount};
        info.statisticsStatus = @"0";
        [self.navigationController pushViewController:info animated:YES];
    }else if (cellInfo.type == departmentCellPerson){
        PersonnelStatCategoryViewController *info = [[PersonnelStatCategoryViewController alloc]init];
        info.timeDict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date};
        info.personDict = @{@"userDspName":cellInfo.userDspName,@"userId":cellInfo.userId};
        info.statisticsStatus = @"depatrment";
        [self.navigationController pushViewController:info animated:YES];
    }
    //按费用类别统计
    else if (cellInfo.type == departmentCellDepart){
        secondDepartmentViewController *info = [[secondDepartmentViewController alloc]init];
        info.timeDict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date};
        info.personDict = @{@"groupId":cellInfo.groupId,@"groupName":cellInfo.groupName,@"totalAmount":cellInfo.totalAmount};
        info.statisticsStatus = @"1";
        [self.navigationController pushViewController:info animated:YES];
    }else if (cellInfo.type == departmentCellCategary){
        PersonnelStatCategoryViewController *info = [[PersonnelStatCategoryViewController alloc]init];
        info.timeDict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date};
        info.personDict = @{@"amount":cellInfo.amount,@"userDspName":cellInfo.expenseType,@"ExpenseCode":cellInfo.expenseCode,@"GroupId":cellInfo.groupId};
        info.statisticsStatus = @"depatrmentCategary";
        [self.navigationController pushViewController:info animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
