//
//  ArticlesUsingRegistrationViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ArticlesUsingRegistrationViewController.h"
//#import "ProjectStatisticsTableViewCell.h"
#import "projectCostTViewCell.h"

@interface ArticlesUsingRegistrationViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate,chooseTravelDateViewDelegate>
@property (nonatomic,strong)UIView *contentView;//滚动视图contentView

@property (nonatomic, strong) UIView *FilterView;//筛选视图
@property (nonatomic, strong) UIButton *btn_date;//时间按钮
@property (nonatomic, strong) NSString *start_select_date;//当前选择的开始时间
@property (nonatomic, strong) NSString *end_select_date;//当前选择的开始时间

@property (nonatomic, strong) UIView *TableContentView;//费用内容视图
@property (nonatomic, strong) UITableView *Info_TableView;//明细表单视图

@property (nonatomic, strong) NSMutableArray *Arr_mainFld;//视图加载数据

@property (nonatomic, strong) NSDictionary *dic_requst;//返回的数据

@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框
@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSString * dataType;
@property (nonatomic, strong) UIView *HeadView;//费用详情视图

@property(nonatomic,strong)UIView *noDateView;//无数据视图

@end

@implementation ArticlesUsingRegistrationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"物品领用统计", nil) backButton:YES];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self initializeData];
    [self createScrollView];
    [self updateMainView];
    [self requestGetbudgetDocument];
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
    
    //创建筛选视图
    _FilterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    _FilterView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_FilterView];
    
    //创建费用表单视图
    _TableContentView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, Main_Screen_Width, Main_Screen_Height-44-NavigationbarHeight)];
    _TableContentView.backgroundColor=Color_White_Same_20;
    [_contentView addSubview:_TableContentView];
}


#pragma mark 更新视图
//更新视图
-(void)updateMainView
{
    [self update_FilterView];
    [self update_TableView];
}

//更新采购事由
-(void)update_FilterView{
    
    _btn_date =[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 44) action:@selector(selectionDate) delegate:self title:Custing(@"时间选择", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    self.dataType = @"start";
    _btn_date.userInteractionEnabled=NO;
    _btn_date.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_date setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_date];
    
    CGSize size = [NSString sizeWithText:_btn_date.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UIImageView * downImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2+size.width/2+2, _btn_date.frame.origin.y+16, 15, 15)];
    downImage.image = [UIImage imageNamed:@"share_Open"];
    [_btn_date addSubview:downImage];
    _btn_date.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_date];
    
    UIImageView * ling = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, Main_Screen_Width, 0.5)];
    ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:ling];
    
}

//更新tableview
-(void)update_TableView{
    
    _Info_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, HEIGHT(_TableContentView)) style:UITableViewStyleGrouped];
    _Info_TableView.dataSource = self;
    _Info_TableView.delegate = self;
    _Info_TableView.rowHeight = 55;
    _Info_TableView.backgroundColor = Color_White_Same_20;
    _Info_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TableContentView addSubview:_Info_TableView];
}

//更新头视图数据
-(void)updateHeaderData
{
    _Arr_mainFld = _dic_requst[@"result"];
    
    if (_Arr_mainFld.count==0) {
        [self createNOdataView];
    }else{
        [self removeNodateViews];
    }
    
    [_Info_TableView reloadData];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, 95, Main_Screen_Width, HEIGHT(_TableContentView))];
        _noDateView.backgroundColor=Color_form_TextFieldBackgroundColor;
        [_Info_TableView addSubview:_noDateView];
        
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
    }
}


#pragma mark 数据
//初始化数据
-(void)initializeData{
    _Arr_mainFld = [[NSMutableArray alloc]init];
    NSString * timeStr = [NSString stringWithDate:[NSDate date]];
    _start_select_date = [NSString stringWithFormat:@"%@01",[timeStr substringToIndex:8]];
    _end_select_date = [NSString stringWithDate:[NSDate date]];
}

#pragma mark 请求数据
//物品领用
-(void)requestGetbudgetDocument
{
    NSDictionary *dic = @{@"fromDate":_start_select_date,@"toDate":_end_select_date};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetMonItems_V2"] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//日期选择
-(void)selectionDate{
    [self keyClose];
    
    _datePicker = [[UIDatePicker alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *fromdate;//=[format dateFromString:dateStr];
    
    if ([self.dataType isEqualToString:@"start"]) {
        fromdate = [format dateFromString:_start_select_date];
    }else{
        fromdate = [format dateFromString:_end_select_date];
    }
    
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    _datePicker.date=fromDate;
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    if ([self.dataType isEqualToString:@"start"]) {
        lbl.text=Custing(@"起始时间", nil);
    }else{
        lbl.text=Custing(@"结束时间", nil);
    }
    
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:sureDataBtn];
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:cancelDataBtn];
    if (!_datelView) {
        _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
        _datelView.delegate = self;
    }
    
    [_datelView showUpView:_datePicker];
    [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
    
}


-(void)DateChanged:(UIDatePicker *)sender{
    [self keyClose];
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    if ([self.dataType isEqualToString:@"start"]) {
        _start_select_date = str;
    }else{
        _end_select_date = str;
    }
    
}
-(NSDate*) convertLeaveDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

-(void)sureData
{
    [self keyClose];
    if ([self.dataType isEqualToString:@"start"]) {
        self.dataType = @"end";
        [self.datelView remove];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self selectionDate];
        });
    }else{
        [self.datelView remove];
        [self dimsissPDActionView];
        self.dataType = @"start";
        if (_start_select_date) {
            NSDate *date2 = [self convertLeaveDateFromString:self.start_select_date];
            NSDate *date1 = [self convertLeaveDateFromString:self.end_select_date];
            if ([date2 timeIntervalSinceDate:date1]>=0.0)
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"开始时间不能大于等于结束时间", nil)];
                return;
            }
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            [self requestGetbudgetDocument];
        }
    }
}

-(void)btn_Cancel_Click{
    [self.datelView remove];
    [self dimsissPDActionView];
}


#pragma mark - delegate
//网络请求
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSLog(@"%@",responceDic);
    NSInteger success =[responceDic[@"success"] integerValue] ;
    if (success == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_requst = responceDic;
        [self updateHeaderData];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
}

//表单加载
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _Arr_mainFld.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 95.0;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    
    UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:Custing(@"物品领用统计", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_HeadView addSubview:titleLabel];
    _HeadView.backgroundColor=Color_White_Same_20;
    return _HeadView;
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
    projectCostTViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"projectCostTViewCell"];
    if (cell==nil) {
        cell=[[projectCostTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"projectCostTViewCell"];
    }
    NSDictionary * dic = _Arr_mainFld[indexPath.row];
    [cell configProjectCostDataCellInfo:dic];
    
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
