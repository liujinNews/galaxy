//
//  BudgetStatViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "PNPieChart.h"

#import "DVLineChartView.h"
#import "UIView+ChartBase.h"
#import "UIColor+Hex.h"
#import "DVBarChartView.h"

#import "BudgetStatisticsTableViewCell.h"
#import "BudgetStatisticsInfoViewController.h"
#import "MLKMenuPopover.h"
#import "BudgetStatViewController.h"

@interface BudgetStatViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,GPClientDelegate,MLKMenuPopoverDelegate,chooseTravelDateViewDelegate,DVLineChartViewDelegate,DVBarChartViewDelegate>

@property (nonatomic,strong)UIView *contentView;//滚动视图contentView

@property (nonatomic, strong) UIView *FilterView;//筛选视图
@property (nonatomic, strong) UIButton *btn_date;//时间按钮
@property (nonatomic, strong) NSString *str_select_date;//当前选择的时间
@property (nonatomic, strong) UIButton *btn_state;//状态按钮
@property (nonatomic, strong) NSMutableArray *arr_select;//状态数组
@property (nonatomic, strong) NSString *str_select_arr;//当前选择的数组

@property (nonatomic, strong) UIView *headView;//费用详情视图
@property (nonatomic, strong) NSString *lab_paid;//已支付费用
@property (nonatomic, strong) NSString *percent_paid;//已支付费用标题
@property (nonatomic, strong) NSString *lab_Notpaid;//未支付费用
@property (nonatomic, strong) NSString *percent_Notpaid;//未支付费用标题
@property (nonatomic, strong) NSString *lab_Uncommitted;//未提交费用
@property (nonatomic, strong) NSString *percent_Uncommitted;//未提交费用标题

@property (nonatomic, strong) UIView *TableContentView;//费用内容视图
@property (nonatomic, strong) UITableView *Info_TableView;//明细表单视图

@property (nonatomic, strong) NSMutableArray *Arr_mainFld;//视图加载数据

@property (nonatomic, strong) NSDictionary *dic_requst;//返回的数据
@property (nonatomic, strong) NSString *str_Type;//当前返回数据类型

@property(nonatomic,strong) MLKMenuPopover *menuPopover;//1.3版本弹出窗
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框


@property(nonatomic,strong)UIView *noDateView;//无数据视图
@property (nonatomic, strong) NSString *totalAmount;//总预算
@property (nonatomic,strong)UIImageView * downImage2;

@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSString * dataType;

@property (nonatomic, strong) NSMutableArray *headArr;//数据字典

//标记位置
@property (nonatomic,assign)NSInteger MarkIndex;


@end

@implementation BudgetStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"预算统计" backButton:YES];
    [YXSpritesLoadingView showWithText:@"光速加载中..." andShimmering:NO andBlurEffect:NO];
    [self initializeData];
    [self createScrollView];
    [self updateMainView];
    [self requestGetbudgetDocument];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}

#pragma mark - function
#pragma mark  创建视图
-(void)createScrollView
{
    //创建内容视图
    _contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-44)];
    _contentView.userInteractionEnabled=YES;
    _contentView.backgroundColor=Color_White_Same_20;
    [self.view addSubview:_contentView];
    
    //创建筛选视图
    _FilterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    _FilterView.backgroundColor=[UIColor whiteColor];
    [_contentView addSubview:_FilterView];
    
    //创建费用表单视图
    _TableContentView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, Main_Screen_Width, Main_Screen_Height-44-NavBarHeight)];
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
    
    _btn_date =[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width/2, 44) action:@selector(btn_click:) delegate:self title:[NSString stringWithFormat:@"%@年",_str_select_date] font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_date.tag = 100;
    _btn_date.userInteractionEnabled=NO;
    _btn_date.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_date setBackgroundColor:[UIColor whiteColor]];
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
    
    _btn_state = [GPUtils createButton:CGRectMake(Main_Screen_Width/2+1, 0, Main_Screen_Width/2, 44) action:@selector(btn_click:) delegate:self title:_arr_select[[_str_select_arr intValue]-1] font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_state.tag = 101;
    _btn_state.userInteractionEnabled=NO;
    _btn_state.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_state setBackgroundColor:[UIColor whiteColor]];
    [_FilterView addSubview:_btn_state];
    CGSize size2 = [NSString sizeWithText:_btn_state.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.downImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/4 +size2.width/2+2, _btn_state.frame.origin.y+16, 15, 15)];
    self.downImage2.image = [UIImage imageNamed:@"share_Open"];
    [_btn_state addSubview:self.downImage2];
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
    _Info_TableView.rowHeight = 78;
    _Info_TableView.backgroundColor = Color_White_Same_20;
    _Info_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TableContentView addSubview:_Info_TableView];
}


//更新头视图数据
-(void)updateHeaderData
{
    
    [self.headArr removeAllObjects];
    NSDictionary *dic = _dic_requst[@"result"];
    NSArray *arr_blue = @[@"#ff6757",@"#02adfc",@"#76dab4"];
    
    NSMutableArray *pursOfTyp = [NSMutableArray arrayWithArray:dic[@"total"][@"items"]];
    for (int i = 0; i<pursOfTyp.count; i++) {
        NSMutableDictionary *typ = [NSMutableDictionary dictionaryWithDictionary:pursOfTyp[i]];
        if (i<3) {
            [typ setValue:arr_blue[i] forKey:@"color"];
            [pursOfTyp replaceObjectAtIndex:i withObject:typ];
        }
    }
    
    self.headArr = [NSMutableArray arrayWithArray:pursOfTyp];
    
    
    _totalAmount = dic[@"total"][@"totalAmount"];
    
    id a = self.headArr;
    if ([NSString isEqualToNull:a]) {
        if (self.headArr.count>=1) {
            for (NSDictionary *dic in self.headArr) {
                if ([dic[@"name"]isEqualToString:@"已用预算"]) {
                    self.lab_paid = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:dic[@"value"]]];
                    self.percent_paid = [NSString stringWithFormat:@"%@",dic[@"percent"]];
                }
                if ([dic[@"name"]isEqualToString:@"审批中预算"]) {
                    self.lab_Notpaid = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:dic[@"value"]]];
                    self.percent_Notpaid = [NSString stringWithFormat:@"%@",dic[@"percent"]];
                }
                if ([dic[@"name"]isEqualToString:@"剩余预算"]) {
                    self.lab_Uncommitted = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:dic[@"value"]]];
                    self.percent_Uncommitted = [NSString stringWithFormat:@"%@",dic[@"percent"]];
                }
            }
        }
        
    }
    
    _str_Type = [NSString stringWithFormat:@"%@",dic[@"total"][@"budgetType"]];
    _Arr_mainFld = dic[@"detail"];
    
    if (_Arr_mainFld.count==0) {
        [self createNOdataView];
    }else{
        [self removeNodateViews];
    }
    
    [_Info_TableView reloadData];
}

#pragma mark--创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavBarHeight)];
        _noDateView.backgroundColor=[UIColor whiteColor];
        [_Info_TableView addSubview:_noDateView];
        
        UIImageView *nodataView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
        nodataView.center=CGPointMake(Main_Screen_Width/2, 130*SCALEH);
        nodataView.image=[UIImage imageNamed:@"share_NoData"];
        [_noDateView addSubview:nodataView];
        
        UILabel *title=[GPUtils createLable:CGRectMake(0, 0, 160, 18) text:nil font:Font_selectTitle_15 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentCenter];
        title.text = @"暂无数据";
        title.center=CGPointMake(Main_Screen_Width/2, Y(nodataView)+HEIGHT(nodataView)+28);
        [_noDateView addSubview:title];
    }
}

#pragma mark--移除筛选无数据视图
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
    _str_select_date = [NSString stringWithFormat:@"%@",[timeStr substringToIndex:4]];
    _arr_select = [[NSMutableArray alloc]init];
    [_arr_select addObject:@"已用预算"];
    [_arr_select addObject:@"审批中预算"];
    [_arr_select addObject:@"剩余预算"];
    
    _str_select_arr = @"1";
}



#pragma mark 请求数据
//预算统计
-(void)requestGetbudgetDocument
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@%@",kServer,analyzesGetinitbudget] Parameters:@{@"Year":_str_select_date,@"Type":_str_select_arr} Delegate:self SerialNum:0 IfUserCache:NO];
}

//日期选择
-(void)selectionDate{
    
    [self keyClose];
    
    _datePicker = [[UIDatePicker alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSDate *fromdate = [format dateFromString:_str_select_date];
    
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    _datePicker.date=fromDate;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=GPString(@"时间选择");
    
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData) delegate:self title:@"确定" font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:sureDataBtn];
    
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
    _str_select_date = str;
    
}
-(NSDate*) convertLeaveDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

#pragma mark--时间选择确定按钮
-(void)sureData{
    [self keyClose];
    [self.datelView remove];
    [self dimsissPDActionView];
    if (_str_select_date) {
        [YXSpritesLoadingView showWithText:@"光速加载中..." andShimmering:NO andBlurEffect:NO];
        [self requestGetbudgetDocument];
    }
    
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
}



-(void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [YXSpritesLoadingView showWithText:@"光速加载中..." andShimmering:NO andBlurEffect:NO];
    _str_select_arr = [NSString stringWithFormat:@"%ld",(long)selectedIndex+1];
    [_btn_state setTitle:_arr_select[selectedIndex] forState:UIControlStateNormal];
    
    CGSize size = [NSString sizeWithText:_btn_state.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.downImage2.frame = CGRectMake(Main_Screen_Width/4+size.width/2+2, _btn_state.frame.origin.y+16, 15, 15);
    

    [self requestGetbudgetDocument];
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
        return 285.0;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 285)];
        _headView.backgroundColor = [UIColor clearColor];
        
        //饼状图
        UIView * bingView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 250)];
        bingView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:bingView];
        
        if ([self.lab_Notpaid isEqualToString:@"0.00"]&&[self.lab_paid isEqualToString:@"0.00"]&&[self.lab_Uncommitted isEqualToString:@"0.00"]) {
            self.headArr = [[NSMutableArray alloc]init];
        }
        
        
        ///////////////////////////////////////////////////////////////////////////////
        DVBarChartView *chartView = [[DVBarChartView alloc] initWithFrame:CGRectMake(-10, 0, Main_Screen_Width+20, 135)];
        [bingView addSubview:chartView];
        chartView.yAxisViewWidth = 10;
        chartView.xAxisTitleArray = @[@"已用预算",@"审批中预算",@"剩余预算"];
        
        
        if (self.headArr.count==0) {
            chartView.xAxisTitleArray=@[@""];
            double max =(double)20;
            chartView.yAxisMaxValue =max;
            chartView.xValues = @[@0];
            chartView.showPointLabel=NO;
            chartView.index=0;
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            imageView.center=CGPointMake(chartView.center.x, chartView.center.y-20);
            imageView.image=[UIImage imageNamed:@"ReportFormNoData"];
            [chartView addSubview:imageView];
            UILabel *label=[GPUtils createLable:CGRectMake(0, 0,150,20) text:@"暂无数据" font:Font_Same_11_20 textColor:[GPUtils colorHString:CustomColorForLightText] textAlignment:NSTextAlignmentCenter];
            label.center=CGPointMake(imageView.center.x, imageView.center.y+30);
            [chartView addSubview:label];
        }else{
            NSMutableArray * arr = [NSMutableArray arrayWithObjects:self.lab_paid,self.lab_Notpaid,self.lab_Uncommitted, nil];
            double max = [self.totalAmount doubleValue];
            chartView.yAxisMaxValue =max+1;
            chartView.xValues = arr;
            NSInteger count=(Main_Screen_Width)/45;
            if (chartView.xValues.count>count) {
                chartView.index=chartView.xValues.count-count;
            }else{
                chartView.index=0;
            }
        }
        
        
        chartView.delegate = self;
        
        [chartView draw];
        
        //////////////////////////////////////////////////////////////
        
        //统计类型图
        
        UIView * statisticView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, Main_Screen_Width, 90)];
        statisticView.backgroundColor = [UIColor clearColor];
        [bingView addSubview:statisticView];
        if (![NSString isEqualToNull:_lab_paid]) {
            _lab_paid = @"0";
        }
        if (![NSString isEqualToNull:_lab_Notpaid]) {
            _lab_Notpaid = @"0";
        }
        if (![NSString isEqualToNull:_lab_Uncommitted]) {
            _lab_Uncommitted = @"0";
        }
        
        if (![NSString isEqualToNull:_percent_paid]) {
            _percent_paid = @"0";
        }
        if (![NSString isEqualToNull:_percent_Notpaid]) {
            _percent_Notpaid = @"0";
        }
        if (![NSString isEqualToNull:_percent_Uncommitted]) {
            _percent_Uncommitted = @"0";
        }
        
        
        
        NSArray * setArr = @[
                             @{@"image":@"status_red",@"name":@"已用预算",@"amount":_lab_paid,@"percentage":_percent_paid},
                             @{@"image":@"status_blue",@"name":@"审批中预算",@"amount":_lab_Notpaid,@"percentage":_percent_Notpaid},
                             @{@"image":@"status_green",@"name":@"剩余预算",@"amount":_lab_Uncommitted,@"percentage":_percent_Uncommitted}];
        
        for (int j = 0 ; j < [setArr count] ; j ++ ) {
            
            UIImageView * staImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, j*30+10, 10, 10)];
            staImage.image = GPImage([[setArr objectAtIndex:j] objectForKey:@"image"]);
            staImage.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:staImage];
            
            UILabel * staLab = [GPUtils createLable:CGRectMake(30, j*30, 90, 30) text:[[setArr objectAtIndex:j] objectForKey:@"name"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            staLab.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:staLab];
            
            UILabel * amountLab = [GPUtils createLable:CGRectMake(139, j*30, Main_Screen_Width-209, 30) text:[[setArr objectAtIndex:j] objectForKey:@"amount"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            amountLab.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:amountLab];
            
            UILabel * percentageLab = [GPUtils createLable:CGRectMake(Main_Screen_Width-70, j*30, 55, 30) text:[[setArr objectAtIndex:j] objectForKey:@"percentage"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            percentageLab.backgroundColor = [UIColor clearColor];
            [statisticView addSubview:percentageLab];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, j*30, Main_Screen_Width-20, 0.5)];
            lineView.backgroundColor = Color_GrayLight_Same_20;
            [statisticView addSubview:lineView];
            
        }
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 90, Main_Screen_Width-20, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [statisticView addSubview:lineView];
        
        
        //费用类别描述
        UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 260, 4, 25)];
        ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        ImgView.backgroundColor=Color_Blue_Important_20;
        [_headView addSubview:ImgView];
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 263.5, 180, 18) text:@"预算类别统计" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_headView addSubview:titleLabel];
        return _headView;
    }else{
        
        return nil;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BudgetStatisticsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BudgetStatisticsTableViewCell"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetStatisticsTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    NSLog(@"%ld",(long)indexPath.row);
    cell.dic = _Arr_mainFld[indexPath.row];
    if (![_str_Type isEqualToString:@"2"]) {
        cell.img_right.hidden = YES;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_str_Type isEqualToString:@"2"]) {
        BudgetStatisticsInfoViewController *info = [[BudgetStatisticsInfoViewController alloc]init];
        info.Dic = _Arr_mainFld[indexPath.row];
        info.year = _str_select_date;
        info.type = _str_select_arr;
        info.totalAmount = info.Dic[@"amount"];
        [self.navigationController pushViewController:info animated:YES];
    }
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
