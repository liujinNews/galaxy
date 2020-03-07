//
//  STOnePickDateView.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/28.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "STOnePickDateView.h"

@implementation STOnePickDateView


-(STOnePickDateView *)initWithTitle:(NSString *)title Type:(int)type Date:(NSString *)date{
    
    NSString *dateString;
    
    if (![NSString isEqualToNull:date]) {
        NSDate *dates = [NSDate date];
        dateString= [NSDate stringWithDateBySSS:dates];
        
        if (type == 1||type == 2) {
            dateString=[dateString substringToIndex:type==1?10:19];
        }else if (type == 3){
            dateString=[dateString substringWithRange:NSMakeRange(11, 5)];
        }
    }else{
        dateString = date;
    }
    
    
    UIDatePicker *dap_ExpenseDate = [[UIDatePicker alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:type==1?@"yyyy/MM/dd":type==3?@"HH:mm":@"yyyy/MM/dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:dateString];
    dap_ExpenseDate.date=fromdate;
    userData *userdatas=[userData shareUserData];
    dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    dap_ExpenseDate.datePickerMode = type==1?UIDatePickerModeDate:type==2?UIDatePickerModeDateAndTime:UIDatePickerModeTime;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=title;
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_View_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    sureDataBtn.tag = type;
    [view addSubview:sureDataBtn];
    
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    cancelDataBtn.tag = type;
    [view addSubview:cancelDataBtn];
    
    self=[[STOnePickDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, dap_ExpenseDate.frame.size.height+40) pickerView:dap_ExpenseDate titleView:view];
    self.delegate = self;
    [self showUpView:dap_ExpenseDate];
    self.dap_ExpenseDate = dap_ExpenseDate;
    return self;
}

-(void)btn_View_Click:(UIButton *)btn{
    NSDate * pickerDate = [self.dap_ExpenseDate date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    if (btn.tag == 1) {
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    }
    if (btn.tag == 2) {
        [pickerFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    }
    if (btn.tag == 3) {
        [pickerFormatter setDateFormat:@"HH:mm"];
    }
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    if (self.STblock) {
        self.STblock(str);
    }
    self.dap_ExpenseDate = nil;
    [self remove];
}

-(void)btn_Cancel_Click:(UIButton *)btn{
    self.dap_ExpenseDate = nil;
    [self remove];
}

- (void)dimsissPDActionView {
//    if (self.block) {
//        self.block(@"-1");
//    }
}


@end
