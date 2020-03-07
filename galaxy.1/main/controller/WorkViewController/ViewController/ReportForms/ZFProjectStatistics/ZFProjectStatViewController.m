//
//  ZFProjectStatViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/7/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "PersonnelStatCategoryViewController.h"
#import "PersonnelStatData.h"
#import "MLKMenuPopover.h"

#import "projectCostTViewCell.h"
#import "ZFProjectStatViewController.h"

@interface ZFProjectStatViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate,chooseTravelDateViewDelegate,MLKMenuPopoverDelegate,chooseTravelDateViewDelegate>
@property (nonatomic,strong)UIView *contentView;//滚动视图contentView
@property (nonatomic, strong) UIView *FilterView;//筛选视图
@property (nonatomic, strong) UIButton *btn_date;//时间按钮
@property (nonatomic, strong) NSString *start_select_date;//当前选择的起始时间
@property (nonatomic, strong) NSString *end_select_date;//当前选择的结束时间


@property (nonatomic, strong) UIButton *btn_query;//查询
@property (nonatomic, strong) UIButton *btn_queryView;//查询视图
@property (nonatomic, strong) UIView *View_queryView;//查询弹出视图
@property (nonatomic, strong) UITextField *txf_lastQuery;//查询输入框
@property (nonatomic, strong) UIButton *btn_queryOK;//查询确定
@property (nonatomic, strong) NSString *str_lastQuery;//当前选择的时间

@property (nonatomic, strong) UIButton *btn_entity;//实体按钮
@property (nonatomic, strong) NSMutableArray *arr_select;//状态数组
@property (nonatomic, strong) NSString *str_select_arr;//当前选择的实体


@property (nonatomic, strong) UIView *TableContentView;//费用内容视图
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框
@property(nonatomic,strong) MLKMenuPopover *menuPopover;//1.3版本弹出窗

@property(nonatomic,strong)UIView *noDateView;//无数据视图
@property(nonatomic,strong)UIImageView * downImage2;

@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSString * dataType;
@property (nonatomic, strong) UIView *HeadView;//费用详情视图

//MJ 需要内容
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property (nonatomic, assign) BOOL  isEditing;

@end

@implementation ZFProjectStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Project Expense Report" backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self initializeData];
    [self createScrollView];
    [self updateMainView];
    [self requestGetbudgetDocument];
    [self requestGetProjEntitiesBox];
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

//下拉上拉
-(void)loadData
{
    [self requestGetbudgetDocument];
}


//更新采购事由
-(void)update_FilterView{
    
    NSInteger cellwidth = Main_Screen_Width/3;
    
    _btn_date =[GPUtils createButton:CGRectMake(0, 0, cellwidth, 44) action:@selector(btn_click:) delegate:self title:@"Date" font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    self.dataType = @"start";
    _btn_date.tag = 100;
    _btn_date.userInteractionEnabled=NO;
    _btn_date.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_btn_date setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [_FilterView addSubview:_btn_date];
    
    CGSize size = [NSString sizeWithText:_btn_date.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UIImageView * downImage = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth/2+ size.width/2, _btn_date.frame.origin.y+16, 15, 15)];
    downImage.image = [UIImage imageNamed:@"share_Open"];
    [_btn_date addSubview:downImage];
    _btn_date.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_date];
    
    UIImageView *people_ling = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth-1, 0, 0.5, 44)];
    people_ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:people_ling];
    
    //创建查询
    _btn_query =[GPUtils createButton:CGRectMake(cellwidth, 0, cellwidth, 44) action:@selector(btn_click:) delegate:self title:@"Project" font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_query.tag = 101;
    _btn_query.userInteractionEnabled=NO;
    _btn_query.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btn_query.contentEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    [_btn_query setBackgroundColor:Color_form_TextFieldBackgroundColor];
    
    CGSize money_size = [NSString sizeWithText:_btn_query.titleLabel.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UIImageView * money_Image = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth/2+ money_size.width/2, _btn_query.frame.origin.y+16, 15, 15)];
    money_Image.image = [UIImage imageNamed:@"share_Open"];
    [_btn_query addSubview:money_Image];
    _btn_query.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_query];
    
    UIImageView *project_ling = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth*2-1, 0, 0.5, 44)];
    project_ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:project_ling];
    
    //创建实体
    _btn_entity =[GPUtils createButton:CGRectMake(cellwidth*2, 0, cellwidth, 44) action:@selector(btn_click:) delegate:self title:@"Entity" font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_entity.tag = 102;
    _btn_entity.userInteractionEnabled=NO;
    _btn_entity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btn_entity.contentEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    [_btn_entity setBackgroundColor:Color_form_TextFieldBackgroundColor];
    
    CGSize entity_size = [NSString sizeWithText:_btn_entity.titleLabel.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.downImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth/2+ entity_size.width/2, _btn_entity.frame.origin.y+16, 15, 15)];
    self.downImage2.image = [UIImage imageNamed:@"share_Open"];
    [_btn_entity addSubview:self.downImage2];
    _btn_entity.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_entity];
    
    
    UIImageView * ling = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, Main_Screen_Width, 0.5)];
    ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:ling];
    
}

//更新tableview
-(void)update_TableView{
    self.tableView.frame = CGRectMake(0, 0, Main_Screen_Width, HEIGHT(_TableContentView));
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = Color_White_Same_20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_TableContentView addSubview:self.tableView];
}


//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
    if (!_noDateView) {
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
        
        UILabel * startLab = [GPUtils createLable:CGRectMake(35, 0, 200, 30) text:[NSString stringWithFormat:@"Start Date： %@",self.start_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        startLab.backgroundColor = [UIColor clearColor];
        [timeView addSubview:startLab];
        
        UIView * timeLine = [[UIView alloc]initWithFrame:CGRectMake(17.5, 22.5, 0.5, 15)];
        timeLine.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:timeLine];
        
        UIImageView * endImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37.5, 15, 15)];
        endImage.image = [UIImage imageNamed:@"status_endTime"];
        endImage.backgroundColor = [UIColor clearColor];
        [timeView addSubview:endImage];
        
        UILabel * endLab = [GPUtils createLable:CGRectMake(35, 30, 200, 30) text:[NSString stringWithFormat:@"End Date： %@",self.end_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
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
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:@"Project Expense Report" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_HeadView addSubview:titleLabel];
        _HeadView.backgroundColor=Color_White_Same_20;
        [self.tableView addSubview:_HeadView];
        
        _noDateView=[[UIView alloc]initWithFrame:CGRectMake(0, 95, Main_Screen_Width, HEIGHT(_TableContentView)-95)];
        _noDateView.backgroundColor=Color_form_TextFieldBackgroundColor;
        [self.tableView addSubview:_noDateView];
        
        UIImageView *nodataView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 162, 84.5)];
        nodataView.center=CGPointMake(Main_Screen_Width/2, 100*SCALEH);
        nodataView.image=[UIImage imageNamed:@"TemporarilyNoData"];
        [_noDateView addSubview:nodataView];
        
        UILabel *title=[GPUtils createLable:CGRectMake(0, 0, 160, 18) text:nil font:Font_selectTitle_15 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentCenter];
        title.text = @"no data";
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
    NSString * timeStr = [NSString stringWithDate:[NSDate date]];
    _start_select_date = [NSString stringWithFormat:@"%@01",[timeStr substringToIndex:8]];
    _end_select_date = [NSString stringWithDate:[NSDate date]];
    _str_lastQuery = @"";
    
    _arr_select = [[NSMutableArray alloc]init];
    _str_select_arr = @"";
    
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
        lbl.text=GPString(@"Start Date");
    }else{
        lbl.text=GPString(@"End Date");
    }
    
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData) delegate:self title:@"ok" font:Font_Important_18_20 titleColor:Color_Blue_Important_20];
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
                [[GPAlertView sharedAlertView] showAlertText:self WithText:@"The start time cannot be greater than or equal to end time"];
                return;
                
            }
            
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            [self requestGetbudgetDocument];
            
        }
        
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
        if (_btn_queryView) {
            [_btn_queryView removeFromSuperview];
            _btn_queryView = nil;
        }
        else
        {
            _btn_queryView = [GPUtils createButton:CGRectMake(0, 44, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-44) action:@selector(btn_click:) delegate:self];
            [_btn_queryView setBackgroundColor:Color_White_Same_20];
            [_btn_queryView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
            _btn_queryView.alpha = 0;
            _btn_queryView.tag = 201;
            _View_queryView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 75)];
            _View_queryView.backgroundColor = Color_form_TextFieldBackgroundColor;
            
            _txf_lastQuery = [GPUtils createTextField:CGRectMake(15, 15, Main_Screen_Width-48, 44) placeholder:@"Please enter the project name" delegate:self font:Font_Important_15_20 textColor:Color_Blue_Important_20];
            _txf_lastQuery.borderStyle = UITextBorderStyleLine;
            _txf_lastQuery.layer.borderColor = [Color_GrayLight_Same_20 CGColor];
            _txf_lastQuery.layer.borderWidth = 1.0;
            _txf_lastQuery.keyboardType = UIKeyboardTypeDefault;
            [_View_queryView addSubview:_txf_lastQuery];
            
            
            _btn_queryOK = [GPUtils createButton:CGRectMake(15, 100, Main_Screen_Width-30, 40) action:@selector(btn_click:) delegate:self title:@"ok" font:Font_Important_18_20 titleColor:Color_Blue_Important_20];
            _btn_queryOK.tag = 202;
            [_btn_queryOK setBackgroundImage:[UIImage imageNamed:@"my_modifyPhoneCorn"] forState:UIControlStateNormal];
            [_View_queryView addSubview:_btn_queryOK];
            
            [_btn_queryView addSubview:_View_queryView];
            [self.view addSubview:_btn_queryView];
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.btn_queryView.alpha = 1;
                             }
                             completion:^(BOOL finished) {}];
        }
    }
    if (btn.tag == 201) {
        _str_lastQuery = _txf_lastQuery.text;
        [_btn_queryView removeFromSuperview];
        _btn_queryView = nil;
        [self requestGetbudgetDocument];
    }
    
    if (btn.tag == 102) {
        if (self.menuPopover) {
            [self.menuPopover dismissMenuPopover];
            self.menuPopover = nil;
        }
        else
        {
            NSInteger height = 44 * _arr_select.count;
            if (height >= HEIGHT(self.TableContentView)) {
                height = HEIGHT(self.TableContentView);
            }
            self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, height) menuItems:_arr_select];
            self.menuPopover.menuPopoverDelegate = self;
            self.menuPopover.menuItemsTableView.scrollEnabled = YES;
            [self.menuPopover showInView:self.view];
        }
    }
    
    
    
}


-(void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _str_select_arr = [NSString stringWithFormat:@"%@",_arr_select[selectedIndex]];
    if ([_str_select_arr isEqualToString:@"All"]) {
        _str_select_arr = @"";
        [_btn_entity setTitle:@"Entity" forState:UIControlStateNormal];
    }else{
        [_btn_entity setTitle:_arr_select[selectedIndex] forState:UIControlStateNormal];
    }
    
    
    CGSize size = [NSString sizeWithText:_btn_entity.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.downImage2.frame = CGRectMake(Main_Screen_Width/6+size.width/2+2, _btn_entity.frame.origin.y+16, 15, 15);
    
    [self requestGetbudgetDocument];
}


#pragma mark 请求数据
//项目费用统计
-(void)requestGetbudgetDocument
{
    self.isLoading = YES;
    
    NSDictionary *dict = @{@"FromDate":_start_select_date,@"ToDate":_end_select_date,@"projName":_str_lastQuery,@"description":_str_select_arr,@"OrderBy":@"totalAmount",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": @"15"};
    NSLog(@"%@",dict);
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StatisticsWk/GetProjEntities"] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
}

//项目费用统计
-(void)requestGetProjEntitiesBox
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"proj/GetProjEntitiesBox"] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (serialNum ==0) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        self.totalPage = [[result objectForKey:@"totalPages"] integerValue];
        
    }
    
    if (serialNum == 1) {
        NSArray * items = [responceDic objectForKey:@"result"];
        [self.arr_select addObject:@"All"];
        if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
            for (NSDictionary * listDic in items) {
                NSString * selectStr = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"description"]];
                if (![NSString isEqualToNull:selectStr]) {
                    [self.arr_select addObject:@""];
                }else{
                    [self.arr_select addObject:selectStr];
                }
            }
        }
    }
    
    switch (serialNum) {
        case 0:
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPage >= self.currPage) {
                [PersonnelStatData GetZFProjectStatDictionary:responceDic Array:self.resultArray];
            }
            if (self.totalPage == 0) {
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
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    //修改下载的状态
    self.isLoading = NO;
    if (self.totalPage == 0) {
        [self createNOdataView];
    }else{
        [self removeNodateViews];
    }
}


//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
}

//表单加载
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 95.0;
    }else{
        return 10.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
        
        UILabel * startLab = [GPUtils createLable:CGRectMake(35, 0, 200, 30) text:[NSString stringWithFormat:@"Start Date: %@",self.start_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        startLab.backgroundColor = [UIColor clearColor];
        [timeView addSubview:startLab];
        
        UIView * timeLine = [[UIView alloc]initWithFrame:CGRectMake(17.5, 22.5, 0.5, 15)];
        timeLine.backgroundColor = Color_GrayLight_Same_20;
        [timeView addSubview:timeLine];
        
        UIImageView * endImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 37.5, 15, 15)];
        endImage.image = [UIImage imageNamed:@"status_endTime"];
        endImage.backgroundColor = [UIColor clearColor];
        [timeView addSubview:endImage];
        
        UILabel * endLab = [GPUtils createLable:CGRectMake(35, 30, 200, 30) text:[NSString stringWithFormat:@"End Date: %@",self.end_select_date] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
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
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:@"Project Expense Report" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_HeadView addSubview:titleLabel];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    projectCostTViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"projectCostTViewCell"];
    if (cell==nil) {
        cell=[[projectCostTViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"projectCostTViewCell"];
    }
    PersonnelStatData *cellInfo = self.resultArray[indexPath.section];
    [cell configZFProjectStatDataCellInfo:cellInfo];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonnelStatData *cellInfo = self.resultArray[indexPath.section];
    PersonnelStatCategoryViewController *info = [[PersonnelStatCategoryViewController alloc]init];
    info.timeDict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date};
    info.personDict = @{@"projName":cellInfo.projName};
    info.statisticsStatus = @"projectStat";
    [self.navigationController pushViewController:info animated:YES];
    
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
