//
//  ColleagueCalendarController.m
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ColleagueCalendarController.h"
#import "FSCalendar.h"
#import "LunarFormatter.h"
#import "CalendarShowModel.h"
#import "CalendarShowCell.h"
#import "NoDataCell.h"

@interface ColleagueCalendarController ()<GPClientDelegate,FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    void * _KVOContext;
}
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

@property (nonatomic, weak) FSCalendar *calendar;
@property (nonatomic, assign) BOOL showsLunar;
@property (nonatomic, strong) LunarFormatter *lunarFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;

@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIPanGestureRecognizer *scopeGesture;
@property (nonatomic, strong) NSMutableArray *arr_Events;

@property (nonatomic, strong) NSMutableArray *arr_DayEventInfo;

@property (nonatomic, strong) NSString *str_SelectDate;
@property (nonatomic, strong) NSString *str_SelectMonth;

@property (nonatomic, strong) UIButton *btn_Today;

@property (nonatomic, assign) BOOL bool_MonthReq;
@property (nonatomic, assign) BOOL bool_NoData;
@property (nonatomic, assign) BOOL bool_TodayClick;

@end

@implementation ColleagueCalendarController
-(NSMutableArray *)arr_Events{
    if (!_arr_Events) {
        _arr_Events=[NSMutableArray array];
    }
    return _arr_Events;
}
-(NSMutableArray *)arr_DayEventInfo {
    if (!_arr_DayEventInfo) {
        _arr_DayEventInfo=[NSMutableArray array];
    }
    return _arr_DayEventInfo;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.lunarFormatter = [[LunarFormatter alloc] init];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy/MM/dd";
        self.dateFormatter1 = [[NSDateFormatter alloc] init];
        self.dateFormatter1.dateFormat= @"yyyy/MM";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"%@%@%@",_str_useName,Custing(@"的", nil),Custing(@"日程", nil)] backButton:YES];
    self.view.backgroundColor=Color_White_Same_20;
    [self createViews];
    _bool_MonthReq=NO;
    [self getMonthData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_bool_MonthReq) {
        [self getMonthData];
    }
    _bool_MonthReq=YES;
}
-(void)createViews{
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectZero];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = Color_form_TextFieldBackgroundColor;
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    calendar.appearance.headerDateFormat = @"yyyy/MM";
    NSLocale *locale;
    if ([self.userdatas.language isEqualToString:@"ch"]) {
        calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        locale= [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    }else{
        calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesUpperCase;
        locale= [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    }
    calendar.locale = locale;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.selectionColor=Color_Blue_Important_20;
    calendar.calendarHeaderView.backgroundColor=Color_White_Same_20;
    calendar.appearance.headerTitleColor=Color_Black_Important_20;
    calendar.appearance.weekdayTextColor=Color_Black_Important_20;
    calendar.appearance.eventDefaultColor=Color_Blue_Important_20;
    calendar.appearance.eventSelectionColor=Color_Blue_Important_20;
    calendar.appearance.titleTodayColor=Color_Blue_Important_20;
    calendar.appearance.todayColor=Color_form_TextFieldBackgroundColor;
    //    calendar.appearance.titleWeekendColor=[UIColor redColor];
    //    calendar.firstWeekday = 2;
    [self.view addSubview:calendar];
    [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(350);
    }];
    self.calendar = calendar;
    
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    _str_SelectDate=[self.dateFormatter stringFromDate:[NSDate date]];
    _str_SelectMonth=[NSString stringWithFormat:@"%@/01",[self.dateFormatter1 stringFromDate:self.calendar.currentPage]];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendar.bottom).offset(@10);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeMonth;
    
    self.calendar.accessibilityIdentifier = @"calendar";
    
    
    UIView *preView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, (Main_Screen_Width-150)/2, 34)];
    preView.backgroundColor=Color_White_Same_20;
    [self.view addSubview:preView];
    
    UIView *nextView=[[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2+75, 5, (Main_Screen_Width-150)/2, 34)];
    nextView.backgroundColor=Color_White_Same_20;
    [self.view addSubview:nextView];
    
//    _btn_Today=[GPUtils createButton:CGRectMake((Main_Screen_Width-150)/2-34-12, 0, 34, 34) action:@selector(ClickToday:) delegate:self title:Custing(@"今", nil) font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
//    _btn_Today.backgroundColor=Color_Blue_Important_20;
//    _btn_Today.layer.masksToBounds = YES;
//    _btn_Today.layer.cornerRadius = 17.0f;
//    _btn_Today.hidden=YES;
//    [nextView addSubview:_btn_Today];
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}
//MARK:返回今天
-(void)ClickToday:(id)sen{
    _bool_TodayClick=YES;
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    _btn_Today.hidden=YES;
    _str_SelectDate=[self.dateFormatter stringFromDate:[NSDate date]];
    _str_SelectMonth=[NSString stringWithFormat:@"%@/01",[self.dateFormatter1 stringFromDate:[NSDate date]]];
    [self getMonthData];
    _bool_TodayClick=NO;
}
//MARK:是否显示农历
-(void)ShowLunar:(id)sen{
    self.showsLunar = !self.showsLunar;
    [self.calendar reloadData];
}
//MARK:获取日程详情
-(void)getMonthData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETMONTHCaldaner];
    NSDictionary *Parameters=@{@"ScheduleDate":_str_SelectMonth,@"UserId":_str_useId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
-(void)getDayData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETDAYCaldaner];
    NSDictionary *Parameters=@{@"ScheduleDate":_str_SelectDate,@"UserId":_str_useId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:1 IfUserCache:NO];
}
-(void)getTapDayData{
    NSString *url=[NSString stringWithFormat:@"%@",GETDAYCaldaner];
    NSDictionary *Parameters=@{@"ScheduleDate":_str_SelectDate,@"UserId":_str_useId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:Parameters Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    self.resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    switch (serialNum) {
        case 0:
            [self dealWithMonthData];
            [self.calendar reloadData];
            [self getDayData];
            break;
        case 1:
            [self dealWithDayData];
            [_tableView reloadData];
            break;
        default:
            break;
    }
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

-(void)dealWithMonthData{
    [self.arr_Events removeAllObjects];
    if ([_resultDict[@"result"]isKindOfClass:[NSArray class]]) {
        NSArray *arr=_resultDict[@"result"];
        if (arr.count>0) {
            for (NSDictionary *dict in arr) {
                [self.arr_Events addObject:dict[@"scheduleDate"]];
            }
        }
    }
}

-(void)dealWithDayData{
    [self.arr_DayEventInfo removeAllObjects];
    if ([_resultDict[@"result"]isKindOfClass:[NSArray class]]) {
        NSArray *arr=_resultDict[@"result"];
        if (arr.count>0) {
            for (NSDictionary *dict in arr) {
                CalendarShowModel *model=[[CalendarShowModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.arr_DayEventInfo addObject:model];
            }
        }
    }
    if (self.arr_DayEventInfo.count==0) {
        _bool_NoData=YES;
    }else{
        _bool_NoData=NO;
    }
}
#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(bounds.size.height));
    }];
    [self.view layoutIfNeeded];
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSString *str=[self.dateFormatter stringFromDate:date];
    if (![str isEqualToString:_str_SelectDate]) {
        _str_SelectDate=str;
        [self TodayShow];
        [self getTapDayData];
    }
}
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    if (!_bool_TodayClick) {
        if ([[NSString stringWithFormat:@"%@/01",[self.dateFormatter1 stringFromDate:calendar.currentPage]] isEqualToString:_str_SelectMonth]) {
            _str_SelectDate=[self.dateFormatter stringFromDate:calendar.currentPage];
            [_calendar selectDate:calendar.currentPage];
            [self getDayData];
        }else{
            _str_SelectMonth=[self.dateFormatter stringFromDate:calendar.currentPage];
            _str_SelectDate=[self.dateFormatter stringFromDate:calendar.currentPage];
            [_calendar selectDate:calendar.currentPage];
            [self getMonthData];
        }
        [self TodayShow];
        
    }
}
#pragma mark - <FSCalendarDataSource>
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [self.dateFormatter dateFromString:@"2016/01/01"];
}
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    return [self.dateFormatter dateFromString:@"2021/12/31"];
}
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    if ([self.arr_Events containsObject:dateString]) {
        return 1;
    }
    return 0;
}
//MARK:显示农历
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    if (self.showsLunar) {
        return [self.lunarFormatter stringFromDate:date];
    }
    return nil;
}
//- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date{
//    if ([self calendar:calendar subtitleForDate:date]) {
//        return CGPointZero;
//    }
//    if ([_arr_Events containsObject:[self.dateFormatter stringFromDate:date]]) {
//        return CGPointMake(0, -10);
//    }
//    return CGPointZero;
//}

- (void)dealloc
{
    [self.calendar removeObserver:self forKeyPath:@"scope" context:_KVOContext];
}

//MARK:tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arr_DayEventInfo&&self.arr_DayEventInfo.count>0) {
        return self.arr_DayEventInfo.count;
    }else if(_bool_NoData){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.arr_DayEventInfo&&self.arr_DayEventInfo.count>0) {
        CalendarShowModel * model = (CalendarShowModel *)self.arr_DayEventInfo[indexPath.row];
        return [CalendarShowCell cellHeightWithObj:model WithType:2];
    }else if(_bool_NoData){
        return 210;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arr_DayEventInfo&&self.arr_DayEventInfo.count>0) {
        CalendarShowCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CalendarShowCell"];
        if (cell==nil) {
            cell=[[CalendarShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarShowCell"];
        }
        CalendarShowModel * model = (CalendarShowModel *)self.arr_DayEventInfo[indexPath.row];
        [cell configCellWithObj:model WithType:2];
        
        return cell;
    }else if(_bool_NoData){
        NoDataCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoDataCell"];
        if (cell==nil) {
            cell=[[NoDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataCell"];
        }
        [cell ConfigNoDataViewWithCellHeight:210 WithImageName:@"noData_image_Default" WithTitle:Custing(@"今天还没有日程", nil)];
        return cell;
    }else{
        return [[UITableViewCell alloc]init];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_bool_NoData) {
        return;
    }
    
    CalendarShowModel * model = (CalendarShowModel *)self.arr_DayEventInfo[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",model.isPrivate]floatValue]==1&&![[NSString stringWithFormat:@"%@",self.userdatas.userId] isEqualToString:[NSString stringWithFormat:@"%@",model.userId]]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"该日程不能查看", nil) duration:1.0];
        return;
    }
    CalendarDetailController *vc=[[CalendarDetailController alloc]init];
    vc.int_status=2;
    vc.str_ScheduleId=[NSString isEqualToNull:model.scheduleId]?[NSString stringWithFormat:@"%@",model.scheduleId]:@"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = _tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    _tableView.contentOffset = offset;
}
-(void)TodayShow{
    _btn_Today.hidden=[self.str_SelectDate isEqualToString:[self.dateFormatter stringFromDate:[NSDate date]]];
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
