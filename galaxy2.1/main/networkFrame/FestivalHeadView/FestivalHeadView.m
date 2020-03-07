//
//  FestivalHeadView.m
//  galaxy
//
//  Created by hfk on 2016/12/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FestivalHeadView.h"
@interface FestivalHeadView()
{
    CGRect initialFrame;
}
@end
@implementation FestivalHeadView
- (void)stretchHeaderForTableView:(UITableView*)tableView{
    _tableView                   = tableView;
    _BgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width/1.37)];
    _BgimgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Width/1.37)];
    _BgimgView.image=[UIImage imageNamed:@"Festival_Reim_TimeBg"];
    [_BgView addSubview:_BgimgView];
    
//    _showTimeLab=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width/1.65, 50) text:nil font:Font_Amount_21_20 textColor:Color_Red_Festival_20 textAlignment:NSTextAlignmentCenter];
//    _showTimeLab.center=CGPointMake(Main_Screen_Width/2,HEIGHT(_BgView)/1.52+30);
//    _showTimeLab.alpha=0.8;
//    _showTimeLab.backgroundColor=Color_form_TextFieldBackgroundColor;
//    _showTimeLab.layer.cornerRadius = 10.0f;
//    _showTimeLab.layer.masksToBounds=YES;
//    _showTimeLab.layer.shadowOffset = CGSizeMake(0, 1);
//    _showTimeLab.layer.shadowOpacity = 0.25;
//    _showTimeLab.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
//    _showTimeLab.layer.shadowOffset = CGSizeMake(2, 2);
//    [_BgView addSubview:_showTimeLab];
//    
//    _LeftCloudimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(_BgView)*0.83, Main_Screen_Width/3.07, HEIGHT(_BgView)/5.93)];
//    _LeftCloudimg.image=[UIImage imageNamed:@"Festival_LeftCloud"];
//    [_BgView addSubview:_LeftCloudimg];
//    
//    _RightCloudimg=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*0.57, HEIGHT(_BgView)*0.78, Main_Screen_Width/2.34, HEIGHT(_BgView)/4.48)];
//    _RightCloudimg.image=[UIImage imageNamed:@"Festival_RightCloud"];
//    [_BgView addSubview:_RightCloudimg];
//    _tableView.tableHeaderView = _BgView;
//    if(_timer){
//        [self close];
//    }
//    [self createDate];
    
}
-(void)close{
    [_timer invalidate];
    _timer = nil;
}
-(void)closeUI{
    [self close];
    [_showTimeLab removeFromSuperview];
    [_LeftCloudimg removeFromSuperview];
    [_RightCloudimg removeFromSuperview];
    _BgimgView.image=[UIImage imageNamed:@"Festival_Reim_NewYearBg"];
}
-(void)createDate{
    _calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setYear:2017];
    [components setMonth:1];
    [components setDay:27];
    [components setHour:24];
    [components setMinute:00];
    [components setSecond:0];
    _fireDate = [_calender dateFromComponents:components];
    _unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    NSTimeInterval ti = 1.0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timeMethodGo:) userInfo:nil repeats:YES];
    [_timer fire];
}
-(void)timeMethodGo:(NSTimer *)timer{
    NSDate *today = [NSDate date];
    NSDateComponents *day = [_calender components:_unitFlags fromDate:today toDate:_fireDate options:0];
    if (([day day]==0&&[day hour]==0&&[day minute]==0&&[day second]==0)||[day second]<0) {
        [self closeUI];
        _showTimeLab.text = [NSString stringWithFormat:@"%@",@"happy new year"];
        
    }else{
        _showTimeLab.text = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",(long)[day day] , (long)[day hour], (long)[day minute], (long)[day second]];
    }
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if(scrollView.contentOffset.y < 0) {

    }
}
@end
