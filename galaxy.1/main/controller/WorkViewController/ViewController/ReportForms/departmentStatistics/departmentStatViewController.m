//
//  departmentStatViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "PersonnelStatCategoryViewController.h"
#import "MLKMenuPopover.h"
#import "secondDepartmentViewController.h"
#import "departmentStatData.h"
#import "DepartmentStatTableViewCell.h"

#import "departmentStatViewController.h"

@interface departmentStatViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate,chooseTravelDateViewDelegate,MLKMenuPopoverDelegate>//MLKMenuPopoverDelegate
@property (nonatomic,strong)UIView *contentView;//滚动视图contentView
@property (nonatomic, strong) UITableView *tableView;//明细表单视图
@property (nonatomic, strong) UIView *FilterView;//筛选视图
@property (nonatomic, strong) UIButton *btn_date;//时间按钮
@property (nonatomic, strong) NSString *start_select_date;//当前选择的起始时间
@property (nonatomic, strong) NSString *end_select_date;//当前选择的结束时间

@property (nonatomic, strong) UIButton *btn_state;//状态按钮
@property (nonatomic, strong) NSMutableArray *arr_select;//状态数组
@property (nonatomic, strong) NSString *str_select_arr;//当前选择的数组
@property(nonatomic,strong)UIImageView * downImage2;
@property(nonatomic,strong) MLKMenuPopover *menuPopover;//1.3版本弹出窗


@property (nonatomic, strong) UIView *TableContentView;//费用内容视图

@property (nonatomic, strong) NSMutableArray *Arr_array;
@property (nonatomic, strong) NSMutableArray *Arr_groups;//部门数据
@property (nonatomic, strong) NSMutableArray *Arr_groupMbrs;//员工数据

@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框

@property(nonatomic,strong)UIView *noDateView;//无数据视图

@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSString * dataType;
@property (nonatomic, strong) UIView *HeadView;//费用详情视图

@property(nonatomic,copy)NSString * totalAmount;
@property(nonatomic,copy)NSString * departHeight;

@end

@implementation departmentStatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"部门费用统计", nil) backButton:YES];
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
    _btn_state.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, HEIGHT(_TableContentView)) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TableContentView addSubview:_tableView];
}


//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
        NSInteger noHeight;
        if ([self.str_select_arr isEqualToString:@"0"]) {
            noHeight = 95;
        }else{
            noHeight = 80;
        }
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, noHeight, Main_Screen_Width, HEIGHT(_TableContentView)-noHeight)];
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


#pragma mark 数据
//初始化数据
-(void)initializeData{
    self.Arr_array = [[NSMutableArray alloc]init];
    self.Arr_groups = [[NSMutableArray alloc]init];
    self.Arr_groupMbrs = [[NSMutableArray alloc]init];
    NSString * timeStr = [NSString stringWithDate:[NSDate date]];
    _start_select_date = [NSString stringWithFormat:@"%@01",[timeStr substringToIndex:8]];
    _end_select_date = [NSString stringWithDate:[NSDate date]];
    _arr_select = [[NSMutableArray alloc]init];
    [_arr_select addObject:Custing(@"按员工统计", nil)];
    [_arr_select addObject:Custing(@"按费用类别统计", nil)];
    
    _str_select_arr = @"0";
}

#pragma mark 请求数据
//按员工统计
-(void)requestGetbudgetDocument
{
    NSDictionary *dic = @{@"fromDate":_start_select_date,@"toDate":_end_select_date,@"ParentId":@"0"};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetGroupExp"] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//按费用类别统计
-(void)requestGetbudgetCategaryDocument
{
    NSDictionary *dic = @{@"FromDate":_start_select_date,@"ToDate":_end_select_date,@"ParentId":@"0"};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetGroupExpsByTyp"] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
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
            if ([_str_select_arr isEqualToString:@"0"]) {
                [self requestGetbudgetDocument];
            }else{
                [self requestGetbudgetCategaryDocument];
            }
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

-(void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _str_select_arr = [NSString stringWithFormat:@"%ld",(long)selectedIndex];
    [_btn_state setTitle:_arr_select[selectedIndex] forState:UIControlStateNormal];
    
    CGSize size = [NSString sizeWithText:_btn_state.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.downImage2.frame = CGRectMake(Main_Screen_Width/4+size.width/2+2, _btn_state.frame.origin.y+16, 15, 15);
    
    if ([_str_select_arr isEqualToString:@"0"]) {
        [self requestGetbudgetDocument];
    }else{
        [self requestGetbudgetCategaryDocument];
    }
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
        return;
    }
    
    switch (serialNum) {
        case 0:
            self.Arr_array = [NSMutableArray array];
            self.Arr_groups = [NSMutableArray array];
            self.Arr_groupMbrs = [NSMutableArray array];
            if ([_str_select_arr isEqualToString:@"0"]) {
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


//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
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
    if ([_str_select_arr isEqualToString:@"0"]) {
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
    if ([_str_select_arr isEqualToString:@"0"]) {
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
            
            UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:Custing(@"部门费用统计", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
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
            
            UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 3.5, Main_Screen_Width - 20, 18) text:Custing(@"类别", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
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
