//
//  HKDatePickView.m
//  ChooseTime
//
//  Created by hfk on 16/5/13.
//  Copyright © 2016年 xutai. All rights reserved.
//

#import "HKDatePickView.h"
#import "AppDelegate.h"
#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface HKDatePickView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    NSCalendar *calendar;
    
    ;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    
    
}

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, copy) NSArray *provinces;//请假类型
@property (nonatomic, copy) NSArray *selectedArray;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@end

@implementation HKDatePickView

- (id)initWithType:(NSInteger)type WithTimeFormart:(NSString *)formartTime{
    if (self = [super init]) {
        _type=type;
        _formartTime=formartTime;
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView.backgroundColor = [UIColor clearColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        [self addSubview:self.pickerView];
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, [UIScreen mainScreen].bounds.size.width+4, 40)];
        upVeiw.backgroundColor =[GPUtils colorHString:ColorBanground];
        [self addSubview:upVeiw];
        
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,100, 40)];;
        lbl.center=CGPointMake(Main_Screen_Width/2+2, 20);
        lbl.text=Custing(@"时间选择", nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [upVeiw addSubview:lbl];
        
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 40, 40);
        chooseButton.titleLabel.font=Font_Same_14_20;
        [chooseButton setTitle:Custing(@"确定", nil) forState:UIControlStateNormal];
        chooseButton.backgroundColor = [UIColor clearColor];
        [chooseButton setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(hiddenPickerViewRight) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
        
        
        
        
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        
        startYear=year-15;
        yearRange=30;
        selectedYear=2000;
        selectedMonth=1;
        selectedDay=1;
        selectedHour=0;
        selectedMinute=0;
        dayRange=[self isAllDay:startYear andMonth:1];
    }
    return self;
}

#pragma mark --
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return dayRange;
        }
            break;
        case 3:
        {
            return 24;
        }
            break;
        case 4:
        {
            return 60;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark -- UIPickerViewDelegate
//默认时间的处理
-(void)setCurDate:(NSDate *)curDate
{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//     = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *comps = [calendar0 components:unitFlags fromDate:curDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    [self.pickerView selectRow:year-startYear inComponent:0 animated:true];
    [self.pickerView selectRow:month-1 inComponent:1 animated:true];
    [self.pickerView selectRow:day-1 inComponent:2 animated:true];
    [self.pickerView selectRow:hour inComponent:3 animated:true];
    [self.pickerView selectRow:minute inComponent:4 animated:true];
    
    [self.pickerView reloadAllComponents];
}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld%@",(long)(startYear + row),Custing(@"Date年", nil)];
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld%@",(long)row+1,Custing(@"Date月", nil)];
        }
            break;
        case 2:
        {
            label.frame=CGRectMake(screenWith*3/8, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld%@",(long)row+1,Custing(@"Date日", nil)];
        }
            break;
        case 3:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld%@",(long)row,Custing(@"Date时", nil)];
        }
            break;
        case 4:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld%@",(long)row,Custing(@"Date分", nil)];
        }
            break;
        case 5:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.frame=CGRectMake(screenWith*component/6.0, 0, screenWith/6.0-5, 30);
            label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
        }
            break;
            
        default:
            break;
    }
    return label;
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            selectedYear=startYear + row;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
            selectedDay=row+1;
        }
            break;
        case 3:
        {
            selectedHour=row;
        }
            break;
        case 4:
        {
            selectedMinute=row;
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark -- show and hidden
- (void)showInView:(UIView *)view {
    
    if (!self.isShow) {
        [self setBackgroundView];
        [ApplicationDelegate.window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor=Color_form_TextFieldBackgroundColor;
            self.frame = CGRectMake(0, Main_Screen_Height-200, Main_Screen_Width, 200);
        }];
        self.isShow=YES;
    }
}

-(void)setBackgroundView
{
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectIntegral([[UIScreen mainScreen] bounds])];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    [ApplicationDelegate.window addSubview:self.backgroundView];
}

-(void)didTap:(id)sender
{
    if (self) {
        [self hiddenPickerView];
    }
}

//隐藏View
//取消的隐藏
- (void)hiddenPickerView
{
    self.isShow=NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.backgroundView.backgroundColor=[UIColor clearColor];
        [self.backgroundView removeFromSuperview];
        self.backgroundView=nil;
        [self removeFromSuperview];
    }];
    
    [self.myTextField resignFirstResponder];
}

//确认的隐藏
-(void)hiddenPickerViewRight
{
    if (selectedDay>dayRange) {
        selectedDay=dayRange;
    }
    if ([_formartTime isEqualToString:@"yyyy/MM/dd HH:mm:ss"]) {
        _string =[NSString stringWithFormat:@"%ld/%.2ld/%.2ld %.2ld:%.2ld:00",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute];
    }else if ([_formartTime isEqualToString:@"yyyy/MM/dd HH:mm"]){
        _string =[NSString stringWithFormat:@"%ld/%.2ld/%.2ld %.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute];
    }
    self.isShow=NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.backgroundView.backgroundColor=[UIColor clearColor];
        [self.backgroundView removeFromSuperview];
        self.backgroundView=nil;
    }];
    if ([self.delegate respondsToSelector:@selector(didFinishPickView:withType:)]) {
        [self.delegate didFinishPickView:_string withType:_type];
    }
    if (self.block) {
        self.block(_string, _type);
    }
    [self.myTextField resignFirstResponder];
    
}


#pragma mark -- setter getter
- (NSArray *)provinces {
    if (!_provinces) {
        self.provinces = [@[] mutableCopy];
    }
    return _provinces;
}

- (NSArray *)selectedArray {
    if (!_selectedArray) {
        self.selectedArray = [@[] mutableCopy];
    }
    return _selectedArray;
}




-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


@end
