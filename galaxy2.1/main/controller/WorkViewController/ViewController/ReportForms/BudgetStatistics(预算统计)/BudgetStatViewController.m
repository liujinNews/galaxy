//
//  BudgetStatViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "askLStaticTableViewCell.h"
#import "UIView+ChartBase.h"
#import "UIColor+Hex.h"
#import "GPBarChartView.h"

#import "BudgetStatisticsTableViewCell.h"
#import "BudgetStatisticsInfoViewController.h"
#import "MLKMenuPopover.h"
#import "BudgetStatViewController.h"

@interface BudgetStatViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,GPClientDelegate,MLKMenuPopoverDelegate,chooseTravelDateViewDelegate,GPBarChartViewDelegate>

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
@property(nonatomic,strong)UIPickerView * pickerView;//弹出的时间图
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框


@property(nonatomic,strong)UIView *noDateView;//无数据视图
@property (nonatomic, strong) NSString *totalAmount;//总预算
@property (nonatomic,strong)UIImageView * downImage2;

@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSString * dataType;

@property (nonatomic, strong) NSMutableArray *headArr;//数据字典
@property(nonatomic,strong)NSMutableArray * arr_dateArray;//年份数组

//标记位置
@property (nonatomic,assign)NSInteger MarkIndex;


@end

@implementation BudgetStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"预算统计", nil) backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self initializeData];
    [self createScrollView];
    [self updateMainView];
    [self requestGetbudgetDocument];
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
    _contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-44)];
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
    
    _btn_date =[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width/2, 44) action:@selector(btn_click:) delegate:self title:[NSString stringWithFormat:@"%@%@",_str_select_date,Custing(@"过年", nil)] font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
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
    
    _btn_state = [GPUtils createButton:CGRectMake(Main_Screen_Width/2+1, 0, Main_Screen_Width/2, 44) action:@selector(btn_click:) delegate:self title:_arr_select[[_str_select_arr intValue]-1] font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_state.tag = 101;
    _btn_state.userInteractionEnabled=NO;
    _btn_state.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_state setBackgroundColor:Color_form_TextFieldBackgroundColor];
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
    
    NSDictionary * pursTyp = dic[@"total"][@"items"];
    if ([pursTyp isKindOfClass:[NSNull class]] || pursTyp == nil|| pursTyp.count == 0||!pursTyp){
        NSArray * items = @[@{@"hasDetail":@"1",@"name":Custing(@"已用预算", nil),@"percent":@"0.00%",@"value":@"0.00",@"color":@"#ff6757"},@{@"hasDetail":@"2",@"name":Custing(@"审批中预算", nil),@"percent":@"0.00%",@"value":@"0.00",@"color":@"#02adfc"},@{@"hasDetail":@"3",@"name":Custing(@"剩余预算", nil),@"percent":@"0.00%",@"value":@"0.00",@"color":@"#76dab4"}];
        self.headArr = [NSMutableArray arrayWithArray:items];
    }else{
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
    }
    
    
    
    
    _totalAmount = dic[@"total"][@"totalAmount"];
    
    id a = self.headArr;
    if ([NSString isEqualToNull:a]) {
        if (self.headArr.count>=1) {
            for (NSDictionary *dic in self.headArr) {
                if ([dic[@"name"]isEqualToString:Custing(@"已用预算", nil)]) {
                    self.lab_paid = [NSString stringWithFormat:@"%@",dic[@"value"]];
                    if ([[NSString stringWithFormat:@"%@",dic[@"percent"]] isEqualToString:@"0"]) {
                        self.percent_paid = @"0.00%";
                    }else{
                        self.percent_paid = [NSString stringWithFormat:@"%@",dic[@"percent"]];
                    }
                    
                }
                if ([dic[@"name"]isEqualToString:Custing(@"审批中预算", nil)]) {
                    self.lab_Notpaid = [NSString stringWithFormat:@"%@",dic[@"value"]];
                    if ([[NSString stringWithFormat:@"%@",dic[@"percent"]] isEqualToString:@"0"]) {
                        self.percent_Notpaid = @"0.00%";
                    }else{
                        self.percent_Notpaid = [NSString stringWithFormat:@"%@",dic[@"percent"]];
                    }
                }
                if ([dic[@"name"]isEqualToString:Custing(@"剩余预算", nil)]) {
                    self.lab_Uncommitted = [NSString stringWithFormat:@"%@",dic[@"value"]];
                    if ([[NSString stringWithFormat:@"%@",dic[@"percent"]] isEqualToString:@"0"]) {
                        self.percent_Uncommitted = @"0.00%";
                    }else{
                        self.percent_Uncommitted = [NSString stringWithFormat:@"%@",dic[@"percent"]];
                    }
                }
            }
        }
        
    }
    
    _str_Type = [NSString stringWithFormat:@"%@",dic[@"total"][@"budgetType"]];
    _Arr_mainFld = dic[@"detail"];
    if ([_Arr_mainFld isKindOfClass:[NSNull class]] || _Arr_mainFld == nil|| _Arr_mainFld.count == 0||!_Arr_mainFld){
        _Arr_mainFld = [NSMutableArray arrayWithArray:@[]];
        
    }
    
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
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, 285, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
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
    _str_select_date = [NSString stringWithFormat:@"%@",[timeStr substringToIndex:4]];
    _arr_select = [[NSMutableArray alloc]init];
    [_arr_select addObject:Custing(@"已用预算", nil)];
    [_arr_select addObject:Custing(@"审批中预算", nil)];
    [_arr_select addObject:Custing(@"剩余预算", nil)];
    
    _str_select_arr = @"1";
    
    _arr_dateArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<5; i++) {
        [_arr_dateArray addObject:[NSString stringWithFormat:@"%d%@",[_str_select_date intValue]-4+i,Custing(@"过年", nil)]];
    }
}



#pragma mark 请求数据
//预算统计
-(void)requestGetbudgetDocument
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",analyzesGetinitbudget] Parameters:@{@"Year":_str_select_date,@"Type":_str_select_arr} Delegate:self SerialNum:0 IfUserCache:NO];
}

//日期选择
-(void)selectionDate{
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 162)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=Custing(@"时间", nil);
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData:) delegate:self title:Custing(@"确定", nil) font:Font_cellTitle_14 titleColor:Color_Blue_Important_20];
    [view addSubview:sureDataBtn];
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:cancelDataBtn];
    sureDataBtn.tag = 301;
    if (!_datelView) {
        _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, self.pickerView.frame.size.height+40) pickerView:self.pickerView titleView:view];
        _datelView.delegate = self;
    }
    
    int year = 0;
    for (int i = 0; i<_arr_dateArray.count; i++) {
        if ([_arr_dateArray[i]isEqualToString:[NSString stringWithFormat:@"%@%@",_str_select_date,Custing(@"过年", nil)]])
        {
            year = i;
        }
    }
    [self.pickerView selectRow:year inComponent:0 animated:YES];
    
    
    [_datelView showUpView:self.pickerView];
}


//MARK:时间选择确定按钮
-(void)sureData:(UIButton *)btn{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [_btn_date setTitle:[NSString stringWithFormat:@"%@%@",_str_select_date,Custing(@"过年", nil)] forState:UIControlStateNormal];
    [self requestGetbudgetDocument];
    [self.datelView remove];
    
}

-(void)btn_Cancel_Click{
    [self.datelView remove];
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


//弹窗代理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _str_select_date = [[_arr_dateArray objectAtIndex:row]substringToIndex:4];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arr_dateArray.count;
    
}

-(void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _str_select_arr = [NSString stringWithFormat:@"%ld",(long)selectedIndex+1];
    [_btn_state setTitle:_arr_select[selectedIndex] forState:UIControlStateNormal];
    
    CGSize size = [NSString sizeWithText:_btn_state.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.downImage2.frame = CGRectMake(Main_Screen_Width/4+size.width/2+2, _btn_state.frame.origin.y+16, 15, 15);
    

    [self requestGetbudgetDocument];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_arr_dateArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
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
        bingView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [_headView addSubview:bingView];
        
//        if ([self.lab_Notpaid isEqualToString:@"0"]&&[self.lab_paid isEqualToString:@"0"]&&[self.lab_Uncommitted isEqualToString:@"0"]) {
//            self.headArr = [[NSMutableArray alloc]init];
//        }
        
        
        ///////////////////////////////////////////////////////////////////////////////
        GPBarChartView *chartView = [[GPBarChartView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-100, 10, 200, 135)];
        [bingView addSubview:chartView];
        chartView.yAxisViewWidth = 10;
        chartView.xAxisTitleArray = @[Custing(@"已用预算", nil),Custing(@"审批中预算", nil),Custing(@"剩余预算", nil)];
        
        
        if (self.headArr.count==0) {
            chartView.xAxisTitleArray=@[@""];
            double max =(double)20;
            chartView.yAxisMaxValue =max;
//            chartView.xValues = @[@0];
            chartView.showPointLabel=NO;
            chartView.index=0;
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(80, 47.5, 40, 40)];
//            imageView.center=CGPointMake(WIDTH(chartView)/2-20, chartView.center.y-20);
            imageView.image=[UIImage imageNamed:@"ReportFormNoData"];
            [chartView addSubview:imageView];
            UILabel *label=[GPUtils createLable:CGRectMake(0, 0,150,20) text:Custing(@"无数据", nil) font:Font_Same_11_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
            label.center=CGPointMake(imageView.center.x, imageView.center.y+30);
            [chartView addSubview:label];
        }else{
            double max = [self.totalAmount doubleValue];
            chartView.yAxisMaxValue =max+1;
            chartView.xValues = self.headArr;
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
        
        UIView * statisticView = [[UIView alloc]initWithFrame:CGRectMake(0, 145, Main_Screen_Width, 90)];
        statisticView.backgroundColor = [UIColor clearColor];
        [bingView addSubview:statisticView];
        if (![NSString isEqualToNull:_lab_paid]) {
            _lab_paid = @"0.00";
        }
        if (![NSString isEqualToNull:_lab_Notpaid]) {
            _lab_Notpaid = @"0.00";
        }
        if (![NSString isEqualToNull:_lab_Uncommitted]) {
            _lab_Uncommitted = @"0.00";
        }
        
        if (![NSString isEqualToNull:_percent_paid]) {
            _percent_paid = @"0.00%";
        }
        if (![NSString isEqualToNull:_percent_Notpaid]) {
            _percent_Notpaid = @"0.00%";
        }
        if (![NSString isEqualToNull:_percent_Uncommitted]) {
            _percent_Uncommitted = @"0.00%";
        }
        
        
        
        NSArray * setArr = @[
                             @{@"image":@"status_red",@"name":Custing(@"已用预算", nil),@"amount":[GPUtils transformNsNumber:_lab_paid],@"percentage":_percent_paid},
                             @{@"image":@"status_blue",@"name":Custing(@"审批中预算", nil),@"amount":[GPUtils transformNsNumber:_lab_Notpaid],@"percentage":_percent_Notpaid},
                             @{@"image":@"status_green",@"name":Custing(@"剩余预算", nil),@"amount":[GPUtils transformNsNumber:_lab_Uncommitted],@"percentage":_percent_Uncommitted}];
        
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
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 90, Main_Screen_Width-20, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [statisticView addSubview:lineView];
        
        
        //费用类别描述
        UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 260, 4, 25)];
        ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        ImgView.backgroundColor=Color_Blue_Important_20;
        [_headView addSubview:ImgView];
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 263.5, Main_Screen_Width - 20, 18) text:Custing(@"预算类别统计", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_headView addSubview:titleLabel];
        return _headView;
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
    if (_Arr_mainFld.count==0) {
        return [[UITableViewCell alloc]init];
    }
    
    if ([self.str_Type isEqualToString:@"0"]||[self.str_Type isEqualToString:@"2"]) {
        askLStaticTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"askLStaticTableViewCell"];
        if (cell==nil) {
            cell=[[askLStaticTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"askLStaticTableViewCell"];
        }
        NSDictionary * dic = _Arr_mainFld[indexPath.row];
        [cell configBudgetStaticClassDataCellInfo:dic];
        if (![self.str_Type isEqualToString:@"2"]) {
            cell.skipImage.hidden = YES;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        BudgetStatisticsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BudgetStatisticsTableViewCell"];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BudgetStatisticsTableViewCell" owner:self options:nil];
            cell = [nib lastObject];
        }
        cell.dic = _Arr_mainFld[indexPath.row];
        if (![_str_Type isEqualToString:@"2"]) {
            cell.img_right.hidden = YES;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
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
