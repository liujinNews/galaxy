//
//  ApplyStatViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "PNPieChart.h"

#import "MLKMenuPopover.h"
#import "BudgetStatisticsTableViewCell.h"
#import "ApplyStatViewController.h"

@interface ApplyStatViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,GPClientDelegate,MLKMenuPopoverDelegate,chooseTravelDateViewDelegate>
@property (nonatomic,strong)UIView *contentView;//滚动视图contentView

@property (nonatomic, strong) UIView *FilterView;//筛选视图
@property (nonatomic, strong) UIButton *btn_date;//时间按钮
@property (nonatomic, strong) NSString *start_select_date;//当前选择的开始时间
@property (nonatomic, strong) NSString *end_select_date;//当前选择的开始时间

@property (nonatomic, strong) UIButton *btn_state;//状态按钮
@property (nonatomic, strong) NSMutableArray *arr_select;//状态数组
@property (nonatomic, strong) NSString *str_select_arr;//当前选择的数组

@property (nonatomic, strong) UIView *HeadView;//费用详情视图
@property (nonatomic, strong) NSString *lab_paid;//差旅费用
@property (nonatomic, strong) NSString *lab_Notpaid;//日常费用

@property (nonatomic, strong) UIView *TableContentView;//费用内容视图
@property (nonatomic, strong) UITableView *Info_TableView;//明细表单视图

@property (nonatomic, strong) NSMutableArray *Arr_mainFld;//视图加载数据

@property (nonatomic, strong) NSDictionary *dic_requst;//返回的数据
@property (nonatomic, strong) NSString *str_Type;//当前返回数据类型

@property(nonatomic,strong) MLKMenuPopover *menuPopover;//1.3版本弹出窗
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框


@property(nonatomic,strong)UIView *noDateView;//无数据视图
@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSString * dataType;

@property (nonatomic, strong) NSMutableArray *headArr;//数据字典
@property (nonatomic, strong) UILabel   * noDataLab;

@end

@implementation ApplyStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"报销统计", nil) backButton:YES];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self initializeData];
    [self createScrollView];
    [self updateMainView];
    [self requestGetbudgetDocument];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
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
    
    _btn_date =[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width/2, 44) action:@selector(btn_click:) delegate:self title:Custing(@"时间选择", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    self.dataType = @"start";
    _btn_date.tag = 100;
    _btn_date.userInteractionEnabled=NO;
    _btn_date.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_date setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_date];
    
    CGSize size = [NSString sizeWithText:_btn_date.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UIImageView * downImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/4+size.width/2+2, _btn_date.frame.origin.y+16, 15, 15)];
    downImage.image = [UIImage imageNamed:@"share_Open"];
    [_btn_date addSubview:downImage];
    _btn_date.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_date];
    
    UIImageView *ling = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2, 0, 0.5, 44)];
    ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:ling];
    
    _btn_state = [GPUtils createButton:CGRectMake(Main_Screen_Width/2+1, 0, Main_Screen_Width/2, 44) action:@selector(btn_click:) delegate:self title:_arr_select[[_str_select_arr intValue]] font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_state.tag = 101;
    _btn_state.userInteractionEnabled=NO;
    _btn_state.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_state setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_state];
    CGSize size2 = [NSString sizeWithText:_btn_state.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UIImageView * downImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/4 +size2.width/2+2, _btn_state.frame.origin.y+16, 15, 15)];
    downImage2.image = [UIImage imageNamed:@"share_Open"];
    [_btn_state addSubview:downImage2];
    _btn_state.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_state];
    
    UIImageView * diLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, Main_Screen_Width, 0.5)];
    diLine.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:diLine];
    
}


//更新tableview
-(void)update_TableView{
    
    _Info_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, HEIGHT(_TableContentView)) style:UITableViewStyleGrouped];
    _Info_TableView.dataSource = self;
    _Info_TableView.delegate = self;
//    _Info_TableView.rowHeight = 78;
    _Info_TableView.backgroundColor = Color_White_Same_20;
    _Info_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TableContentView addSubview:_Info_TableView];
}


//更新头视图数据
-(void)updateHeaderData
{
    [self.headArr removeAllObjects];
    NSDictionary *dic = _dic_requst[@"result"];
    
    if ([dic isKindOfClass:[NSNull class]] || dic == nil|| dic.count == 0||!dic){
        dic = @{@"dailyAmount":@"0",@"travelAmount":@"0",@"items":@[]};
    }
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"travelAmount"]]]) {
        self.lab_paid = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:dic[@"travelAmount"]]];
        NSDictionary *travelAmount = @{@"color":@"#ff6757",@"type":@"travelAmount",@"amount":dic[@"travelAmount"]};
        [self.headArr addObject:travelAmount];

    }else{
        self.lab_paid = @"0.00";
        NSDictionary *travelAmount = @{@"color":@"#ff6757",@"type":@"travelAmount",@"amount":@"0.00"};
        [self.headArr addObject:travelAmount];
    }
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"dailyAmount"]]]) {
        self.lab_Notpaid = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:dic[@"dailyAmount"]]];
        NSDictionary *dailyAmount = @{@"color":@"#02adfc",@"type":@"dailyAmount",@"amount":dic[@"dailyAmount"]};
        [self.headArr addObject:dailyAmount];

    }else{
        self.lab_Notpaid = @"0.00";
        NSDictionary *dailyAmount = @{@"color":@"#02adfc",@"type":@"dailyAmount",@"amount":@"0.00"};
        [self.headArr addObject:dailyAmount];
    }
    
    
    if ([self.lab_Notpaid isEqualToString:@"0.00"]&&[self.lab_paid isEqualToString:@"0.00"]) {
       self.headArr = [[NSMutableArray alloc]init];
    }
   
    
    _str_Type = @"0";
    _Arr_mainFld = dic[@"items"];
    
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
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, 315, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
        _noDateView.backgroundColor=Color_form_TextFieldBackgroundColor;
        [_Info_TableView addSubview:_noDateView];
        
        UIImageView *nodataView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 162, 84.5)];
        nodataView.center=CGPointMake(Main_Screen_Width/2, 50);
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
    self.headArr = [[NSMutableArray alloc]init];
    NSString * timeStr = [NSString stringWithDate:[NSDate date]];
    _start_select_date = [NSString stringWithFormat:@"%@01",[timeStr substringToIndex:8]];
    _end_select_date = [NSString stringWithDate:[NSDate date]];
    _arr_select = [[NSMutableArray alloc]init];
    [_arr_select addObject:Custing(@"差旅费用", nil)];
    [_arr_select addObject:Custing(@"日常费用", nil)];
    
    _str_select_arr = @"0";
}

#pragma mark 请求数据
//报销统计
-(void)requestGetbudgetDocument
{
    //type 0 差旅 1 日常
    NSDictionary *dic = @{@"startdate":_start_select_date,@"enddate":_end_select_date,@"Type":_str_select_arr};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",analyzesGetinitclaimss] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
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

//MARK:时间选择确定按钮
-(void)sureData{
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
                [[GPAlertView sharedAlertView] showAlertText:self WithText: Custing(@"开始时间不能大于等于结束时间", nil)];
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

#pragma mark - action
-(void)btn_click:(UIButton *)btn
{
    [self.menuPopover dismissMenuPopover];
    if (btn.tag == 100) {
        [self selectionDate];
    }
    if (btn.tag == 101) {
        if (self.menuPopover) {
            [self.menuPopover dismissMenuPopover];
            self.menuPopover = nil;
        }
        else
        {
            self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44*_arr_select.count) menuItems:_arr_select];
            self.menuPopover.menuPopoverDelegate = self;
            [self.menuPopover showInView:self.view];
        }
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
        return;
    }
    if (serialNum == 0) {
        [YXSpritesLoadingView dismiss];
        _dic_requst = responceDic;
        [self updateHeaderData];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}



-(void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _str_select_arr = [NSString stringWithFormat:@"%ld",(long)selectedIndex];
    [_btn_state setTitle:_arr_select[selectedIndex] forState:UIControlStateNormal];
    [self requestGetbudgetDocument];
}


//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
}

//表单加载
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_Arr_mainFld.count==0) {
        return 1;
    }else{
        return _Arr_mainFld.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 315.0;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        self.HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 315)];
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
        
        //饼状图
        UIView * bingView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, Main_Screen_Width, 210)];
        bingView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [_HeadView addSubview:bingView];
        
        
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0; i<self.headArr.count; i++) {
            NSDictionary *dic = self.headArr[i];
            [items addObject:[PNPieChartDataItem dataItemWithValue:[dic[@"amount"]doubleValue] color:[GPUtils colorHString:dic[@"color"]]]];
        }
        if (self.headArr.count==0) {
            [items addObject:[PNPieChartDataItem dataItemWithValue:1 color:[GPUtils colorHString:@"#ff6757"]]];
        }
        
        PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-59, 10, 118, 118) items:items];
        pieChart.descriptionTextColor = Color_form_TextFieldBackgroundColor;
        pieChart.descriptionTextFont  = Font_circleTitle_14;
        pieChart.descriptionTextShadowColor = [UIColor clearColor];
        pieChart.showAbsoluteValues = NO;
        pieChart.showOnlyValues = NO;
        pieChart.shouldHighlightSectorOnTouch = NO;
        pieChart.enableMultipleSelection = NO;
        pieChart.innerCircleRadius = 0.0;
        [pieChart strokeChart];
        pieChart.legendStyle = PNLegendItemStyleSerial;
        pieChart.legendFont = [UIFont boldSystemFontOfSize:14.0f];
        [bingView addSubview:pieChart];
        
        if (self.headArr.count==0) {
            self.noDataLab = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-50, 88, 100, 20) text:Custing(@"无数据", nil) font:Font_circleTitle_14 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
            [bingView addSubview:self.noDataLab];
        }else{
            [self.noDataLab removeFromSuperview];
        }

        
        //统计类型图
        
        UIView * statisticView = [[UIView alloc]initWithFrame:CGRectMake(0, 215, Main_Screen_Width, 60)];
        statisticView.backgroundColor = [UIColor clearColor];
        [_HeadView addSubview:statisticView];
        if (![NSString isEqualToNull:_lab_paid]) {
            _lab_paid = @"0.00";
        }
        if (![NSString isEqualToNull:_lab_Notpaid]) {
            _lab_Notpaid = @"0.00";
        }
        
        //
        NSDictionary *dic = _dic_requst[@"result"];
//        NSString *str2 = [NSString stringWithFormat:@"%.2f%%",[percentRC floatValue]*100];

        double travelStr = 0;
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"travelAmount"]]]) {
            travelStr = [[NSString stringWithFormat:@"%@",dic[@"travelAmount"]] doubleValue];
        }
        double dailyStr = 0;
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"dailyAmount"]]]) {
            dailyStr = [[NSString stringWithFormat:@"%@",dic[@"dailyAmount"]] doubleValue];
        }
        
        float p = travelStr/(travelStr+dailyStr);
        float co = dailyStr/(travelStr+dailyStr);
        
        
        NSString * percentPaid = [NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%.2f",p*100]];
        NSString * percentNotpaid = [NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%.2f",co*100]];
        NSLog(@"%f-----%f-----%f------%f------%@--------%@",travelStr,dailyStr,p,co,percentPaid,percentNotpaid);
        if ([percentPaid isEqualToString:@"nan%"]) {
            percentPaid = @"0.00%";
        }
        if ([percentNotpaid isEqualToString:@"nan%"]) {
            percentNotpaid = @"0.00%";
        }
        
        NSArray * setArr = @[
                             @{@"image":@"status_red",@"name":Custing(@"差旅报销", nil),@"amount":_lab_paid,@"percentage":percentPaid},
                             @{@"image":@"status_blue",@"name":Custing(@"日常报销", nil),@"amount":_lab_Notpaid,@"percentage":percentNotpaid}];
        
        for (int j = 0 ; j < [setArr count] ; j ++ ) {
            
            UIImageView * staImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, j*30+10, 10, 10)];
            staImage.image = GPImage([[setArr objectAtIndex:j] objectForKey:@"image"]);
            staImage.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:staImage];
            
            UILabel * staLab = [GPUtils createLable:CGRectMake(30, j*30, 90, 30) text:[[setArr objectAtIndex:j] objectForKey:@"name"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            staLab.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:staLab];
            
            UILabel * amountLab = [GPUtils createLable:CGRectMake(139, j*30, Main_Screen_Width-219, 30) text:[[setArr objectAtIndex:j] objectForKey:@"amount"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            amountLab.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:amountLab];
            
            UILabel * percentageLab = [GPUtils createLable:CGRectMake(Main_Screen_Width-75, j*30, 60, 30) text:[[setArr objectAtIndex:j] objectForKey:@"percentage"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            percentageLab.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:percentageLab];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, j*30, Main_Screen_Width-20, 0.5)];
            lineView.backgroundColor = Color_GrayLight_Same_20;
            [statisticView addSubview:lineView];
            
        }
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, Main_Screen_Width-20, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [statisticView addSubview:lineView];
//        _lab_paid = @"";
//        _lab_Notpaid = @"";
        
        
        //报销类别描述
        UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 290, 4, 25)];
        ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        ImgView.backgroundColor=Color_Blue_Important_20;
        [_HeadView addSubview:ImgView];
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 293.5, Main_Screen_Width - 20, 18) text:Custing(@"报销类别统计", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_HeadView addSubview:titleLabel];
        _HeadView.backgroundColor=Color_White_Same_20;
        return _HeadView;
    }else{
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_Arr_mainFld.count==0) {
        return Main_Screen_Height-NavigationbarHeight-100;
    }else{
        return 78;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BudgetStatisticsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BudgetStatisticsTableViewCell"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetStatisticsTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    if (_Arr_mainFld.count==0) {
        return [[UITableViewCell alloc]init];
    }
    NSLog(@"%ld",(long)indexPath.row);
    cell.type = 1;
    cell.dic = _Arr_mainFld[indexPath.row];
    if (![_str_Type isEqualToString:@"2"]) {
        cell.img_right.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


//小数四舍五入
-(NSInteger) getRoundFloat:(float ) floatNumber {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];   // .1f
    [formatter setRoundingMode:NSNumberFormatterRoundHalfDown];  // up / down / half down
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:floatNumber]];
    NSInteger intNum=[numberString integerValue];
    return intNum;
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
