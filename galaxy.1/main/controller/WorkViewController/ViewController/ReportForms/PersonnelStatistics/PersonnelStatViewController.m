//
//  PersonnelStatViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/6/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "PersonnelStatCategoryViewController.h"
#import "PersonnelStatData.h"

#import "projectCostTViewCell.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "PersonnelStatViewController.h"
#import "MLKMenuPopover.h"

@interface PersonnelStatViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate,ByvalDelegate,chooseTravelDateViewDelegate,MLKMenuPopoverDelegate>
@property (nonatomic,strong)UIView *contentView;//滚动视图contentView
@property (nonatomic, strong) UIView *FilterView;//筛选视图
@property (nonatomic, strong) UIButton *btn_date;//时间按钮
@property (nonatomic, strong) NSString *start_select_date;//当前选择的起始时间
@property (nonatomic, strong) NSString *end_select_date;//当前选择的结束时间
@property (nonatomic, strong) UIButton *btn_type;
@property (nonatomic, strong) UIImageView *img_type;
@property (nonatomic, strong) NSArray *arr_type;

@property (nonatomic, strong) UIButton *btn_leavePer;//申请人按钮
@property (nonatomic, strong) NSString *str_select_leavePer;//申请人

@property (nonatomic, strong) UIView *TableContentView;//费用内容视图
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框

@property(nonatomic,strong)UIView *noDateView;//无数据视图

@property(nonatomic,strong)UIDatePicker * datePicker;
@property(nonatomic,strong)NSString * dataType;
@property (nonatomic, strong) UIView *HeadView;//费用详情视图
@property(nonatomic,strong)UIImageView * downImage2;

@property(nonatomic,strong) MLKMenuPopover *menuPopover;//1.3版本弹出窗

//MJ 需要内容
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property (nonatomic, assign) BOOL  isEditing;

@end

@implementation PersonnelStatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"员工费用统计", nil) backButton:YES];
    
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
    [self update_tableView];
}

//下拉上拉
-(void)loadData
{
    [self requestGetbudgetDocument];
}


//更新采购事由
-(void)update_FilterView{
    
    NSInteger cellwidth = Main_Screen_Width/3;
    
    _btn_date =[GPUtils createButton:CGRectMake(0, 0, cellwidth, 44) action:@selector(btn_click:) delegate:self title:Custing(@"时间选择", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
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
    
    UIImageView *people_ling = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth-1, 0, 0.5, 44)];
    people_ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:people_ling];
    
    //创建查询
    _btn_leavePer =[GPUtils createButton:CGRectMake(cellwidth, 0, cellwidth, 44) action:@selector(btn_click:) delegate:self title:Custing(@"申请人", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_leavePer.tag = 101;
    _btn_leavePer.userInteractionEnabled=NO;
    _btn_leavePer.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btn_leavePer.contentEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    [_btn_leavePer setBackgroundColor:Color_form_TextFieldBackgroundColor];
    
    CGSize money_size = [NSString sizeWithText:_btn_leavePer.titleLabel.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.downImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth/2+ money_size.width/2, _btn_date.frame.origin.y+16, 15, 15)];
    self.downImage2.image = [UIImage imageNamed:@"share_Open"];
    [_btn_leavePer addSubview:self.downImage2];
    _btn_leavePer.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_leavePer];
    
    UIImageView *people_ling1 = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth+cellwidth-1, 0, 0.5, 44)];
    people_ling1.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:people_ling1];
    
    //创建查询
    _btn_type =[GPUtils createButton:CGRectMake(cellwidth*2, 0, cellwidth, 44) action:@selector(btn_click:) delegate:self title:Custing(@"全部", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
    _btn_type.tag = 102;
    _btn_type.userInteractionEnabled=NO;
    _btn_type.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _btn_type.contentEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    [_btn_type setBackgroundColor:Color_form_TextFieldBackgroundColor];
    
    CGSize money_size1 = [NSString sizeWithText:_btn_leavePer.titleLabel.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    _img_type = [[UIImageView alloc]initWithFrame:CGRectMake(cellwidth/2+ money_size1.width/2, _btn_type.frame.origin.y+16, 15, 15)];
    _img_type.image = [UIImage imageNamed:@"share_Open"];
    [_btn_type addSubview:_img_type];
    _btn_type.userInteractionEnabled=YES;
    [_FilterView addSubview:_btn_type];
    
    UIImageView * ling = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, Main_Screen_Width, 0.5)];
    ling.backgroundColor = Color_GrayLight_Same_20;
    [_FilterView addSubview:ling];
}

//更新tableview
-(void)update_tableView{
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
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:Custing(@"员工费用统计", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
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
    NSString * timeStr = [NSString stringWithDate:[NSDate date]];
    _start_select_date = [NSString stringWithFormat:@"%@01",[timeStr substringToIndex:8]];
    _end_select_date = [NSString stringWithDate:[NSDate date]];
    self.str_select_leavePer = @"";
    _arr_type = @[Custing(@"全部", nil),Custing(@"审批中", nil),Custing(@"审批完成(未支付)", nil),Custing(@"审批完成(已支付)", nil)];
}

#pragma mark 请求数据
//报销统计
-(void)requestGetbudgetDocument
{
    self.isLoading = YES;
    NSString *state = @"0";
    NSString *type = _btn_type.titleLabel.text;
    if ([NSString isEqualToNull:type]) {
        if ([type isEqualToString:Custing(@"审批中", nil)]) {
            state = @"1";
        }else if ([type isEqualToString:Custing(@"审批完成(未支付)", nil)]) {
            state = @"100";
        }else if ([type isEqualToString:Custing(@"审批完成(已支付)", nil)]) {
            state = @"101";
        }
    }
    NSDictionary *dict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date,@"Requestor":_str_select_leavePer,@"OrderBy":@"totalAmount",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": @"15",@"Status":state};
    NSLog(@"%@",dict);
    //type 0 差旅 1 日常
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetRequestList] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
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
    if (btn.tag == 100) {
        [self selectionDate];
    }
    if (btn.tag == 101) {
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"2";
        contactVC.Radio = @"1";
        contactVC.menutype = 1;
        contactVC.itemType = 99;
        contactVC.universalDelegate = self;
        __weak typeof(self) weakSelf = self;
        [contactVC setBlock:^(NSMutableArray *array) {
            [weakSelf contactsVCClickedLoadBtn:array];
        }];
        contactVC.isAll = 1;
        [self.navigationController pushViewController:contactVC animated:YES];
    }
    if (btn.tag == 102) {
        if (self.menuPopover) {
            [self.menuPopover dismissMenuPopover];
            self.menuPopover = nil;
        }
        else
        {
            self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44*_arr_type.count) menuItems:_arr_type];
            self.menuPopover.menuPopoverDelegate = self;
            [self.menuPopover showInView:self.view];
        }
    }
}

//MARK:-审批人选择代理
- (void)contactsVCClickedLoadBtn:(NSMutableArray *)array
{
    if (array.count>0) {
        buildCellInfo *people = array[0];
        self.str_select_leavePer = people.requestor;
        [_btn_leavePer setTitle:_str_select_leavePer forState:UIControlStateNormal];
    }else
    {
        self.str_select_leavePer = @"";
        [_btn_leavePer setTitle:Custing(@"申请人", nil) forState:UIControlStateNormal];
    }
    
    CGSize size = [NSString sizeWithText:_btn_leavePer.titleLabel.text font:Font_Same_14_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.downImage2.frame = CGRectMake(Main_Screen_Width/4 +size.width/2+2, _btn_leavePer.frame.origin.y+16, 15, 15);
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
    [self requestGetbudgetDocument];
    
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
        self.totalPage = [[result objectForKey:@"totalPages"] integerValue];
        
    }
    switch (serialNum) {
        case 0:
            
            if (self.currPage==1) {
                [self.resultArray removeAllObjects];
            }
            if (self.totalPage >= self.currPage) {
                [PersonnelStatData GetPersonnelStatDictionary:responceDic Array:self.resultArray];
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
        default:
            break;

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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
        
        UILabel * titleLabel = [GPUtils createLable:CGRectMake(10, 73.5, Main_Screen_Width - 20, 18) text:Custing(@"员工费用统计", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
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
    [cell configPersonnelStatCellInfo:cellInfo];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary * dic = _Arr_mainFld[indexPath.section];
    PersonnelStatData *cellInfo = self.resultArray[indexPath.section];
    PersonnelStatCategoryViewController *info = [[PersonnelStatCategoryViewController alloc]init];
    info.timeDict = @{@"StartRequestorDate":_start_select_date,@"EndRequestorDate":_end_select_date};
    info.personDict = @{@"requestor":cellInfo.requestor,@"requestorUserId":cellInfo.requestorUserId};
    info.statisticsStatus = @"personnelStat";
    [self.navigationController pushViewController:info animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [_btn_type setTitle:_arr_type[selectedIndex] forState:UIControlStateNormal];
    
    CGSize size = [NSString sizeWithText:_btn_type.titleLabel.text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _img_type.frame = CGRectMake(Main_Screen_Width/6+size.width/2+2, _btn_type.frame.origin.y+16, 15, 15);
    [self requestGetbudgetDocument];
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
