//
//  BusiTvlOrderDateView.m
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BusiTvlOrderDateView.h"

#define BackView_Width (Main_Screen_Width-140)
#define Txf_Width  (BackView_Width/2 - 15)

@implementation BusiTvlOrderDateView

-(BusiTvlOrderDateView *)initView:(UITextField *)txf_state endTxf:(UITextField *)txf_end{
    self = [[BusiTvlOrderDateView alloc]initWithFrame:CGRectMake(0, 0, BackView_Width, 50)];
    UIView *view_Content = [[UIView alloc]initWithFrame:CGRectMake(0, 3, BackView_Width, 44)];
    [self addSubview:view_Content];
    view_Content.backgroundColor = kWhiteColor;
    
    txf_state.frame=CGRectMake(0,0,Txf_Width, 44);
    txf_state.userInteractionEnabled = NO;
    txf_state.textAlignment = NSTextAlignmentCenter;
    txf_state.textColor = Color_Black_Important_20;
    txf_state.text = [NSDate getbeforeDate_byMonth:3];
    txf_state.font = Font_Same_14_20;
    [view_Content addSubview:txf_state];
    
//    UIImageView *img_state = [GPUtils createImageViewFrame:CGRectMake(Txf_Width+5, 10, 30, 24) imageName:@"RouteDate"];
//    [view_Content addSubview:img_state];
    
    UIButton *btn = [GPUtils createButton:CGRectMake(0,0,Txf_Width, 44) action:@selector(btn_View_Click:) delegate:self];
    btn.tag = 1;
    [view_Content addSubview:btn];
    
    UIView *view_Line = [[UILabel alloc]initWithFrame:CGRectMake(Txf_Width, 21.5, 10, 1)];
    view_Line.backgroundColor = Color_Black_Important_20;
    [view_Content addSubview:view_Line];
    
    txf_end.frame=CGRectMake(Txf_Width+10,0,Txf_Width, 44);
    txf_end.userInteractionEnabled = NO;
    txf_end.textAlignment = NSTextAlignmentCenter;
    txf_end.textColor = Color_Black_Important_20;
    txf_end.font = Font_Same_14_20;
    txf_end.text = [NSDate getDateNow];
    [view_Content addSubview:txf_end];
    
//    UIImageView *img_end = [GPUtils createImageViewFrame:CGRectMake(BackView_Width/2+Txf_Width+15, 10, 30, 24) imageName:@"RouteDate"];
//    [view_Content addSubview:img_end];
    UIImageView *img_end = [GPUtils createImageViewFrame:CGRectMake(BackView_Width - 15, 14.5, 15, 15) imageName:@"arrowDown"];
    [view_Content addSubview:img_end];
    UIButton *btn_End = [GPUtils createButton:CGRectMake(Txf_Width+10,0,Txf_Width, 44) action:@selector(btn_View_Click:) delegate:self];
    btn_End.tag = 2;
    btn_End.userInteractionEnabled = YES;
    [view_Content addSubview:btn_End];
    [view_Content bringSubviewToFront:btn_End];
    
    self.txf_state = txf_state;
    self.txf_end = txf_end;
    
    return self;
}

-(void)btn_View_Click:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    [self endEditing:YES];
    switch (btn.tag) {
        case 1:
        {
            NSString *dateString;
            if (![NSString isEqualToNull:_txf_state.text]) {
                NSDate *date = [NSDate date];
                dateString= [NSString stringWithDate:date];
            }else{
                dateString=[_txf_state.text substringToIndex:10];
            }
            _dap_ExpenseDate = [[UIDatePicker alloc]init];
            NSDateFormatter *format=[[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy/MM/dd"];
            NSDate *fromdate=[format dateFromString:dateString];
            NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
            NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
            NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
            _dap_ExpenseDate.date = fromDate;
            userData *userdatas=[userData shareUserData];
            _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
            _dap_ExpenseDate.datePickerMode = UIDatePickerModeDate;
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"日期",nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_View_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            sureDataBtn.tag = 11;
            [view addSubview:sureDataBtn];
            
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            [view addSubview:cancelDataBtn];
            
            if (!_cho_datelView) {
                _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
                _cho_datelView.delegate = self;
            }
            
            [_cho_datelView showUpView:_dap_ExpenseDate];
            [_cho_datelView show];
        }
            break;
        case 2:
        {
            NSString *dateString;
            if (![NSString isEqualToNull:_txf_end.text]) {
                NSDate *date = [NSDate date];
                dateString= [NSString stringWithDate:date];
            }else{
                dateString=[_txf_end.text substringToIndex:10];
            }
            _dap_ExpenseDate = [[UIDatePicker alloc]init];
            NSDateFormatter *format=[[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy/MM/dd"];
            NSDate *fromdate=[format dateFromString:dateString];
            _dap_ExpenseDate.date = fromdate;
            userData *userdatas=[userData shareUserData];
            _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
            _dap_ExpenseDate.datePickerMode = UIDatePickerModeDate;
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"日期",nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_View_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            sureDataBtn.tag = 12;
            [view addSubview:sureDataBtn];
            
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_View_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            cancelDataBtn.tag = 13;
            [view addSubview:cancelDataBtn];
            
            if (!_cho_datelView) {
                _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
                _cho_datelView.delegate = self;
            }
            
            [_cho_datelView showUpView:_dap_ExpenseDate];
            [_cho_datelView show];
        }
            break;
        case 11:
        {
            NSDate * pickerDate = [_dap_ExpenseDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString * str = [pickerFormatter stringFromDate:pickerDate];
            
            _txf_state.text = str;
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
            if (self.block) {
                self.block();
            }
        }
            break;
        case 12:
        {
            NSDate * pickerDate = [_dap_ExpenseDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString * str = [pickerFormatter stringFromDate:pickerDate];
            
            _txf_end.text = str;
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
            if (self.block) {
                self.block();
            }
        }
            break;
        case 13:{
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
        }
            break;
        default:
            break;
    }
}

-(void)btn_Cancel_Click:(UIButton *)btn{
    self.dap_ExpenseDate = nil;
    [_cho_datelView remove];
}

-(void)dimsissPDActionView{
    _cho_datelView=nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
