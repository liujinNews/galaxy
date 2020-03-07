//
//  OverTimeHistoryOutputView.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/2/28.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "OverTimeHistoryOutputView.h"

@implementation OverTimeHistoryOutputView

+(OverTimeHistoryOutputView *)createViewByDic:(NSDictionary *)dic{
    OverTimeHistoryOutputView *rootview = [[OverTimeHistoryOutputView alloc]init];
    rootview.backgroundColor = Color_eaeaea_20;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    view.backgroundColor = Color_White_Same_20;
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 27)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [view addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [view addSubview:titleLabel];
    titleLabel.text=Custing(@"本月加班明细", nil);
    [rootview addSubview:view];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 27, Main_Screen_Width, 0.5)];
    line1.backgroundColor = Color_LineGray_Same_20;
    [rootview addSubview:line1];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 27, Main_Screen_Height, 40)];
    [rootview addSubview:titleView];
    
    UILabel *lab_number = [GPUtils createLable:CGRectMake(12, 0, 60, 40) text:Custing(@"序号", nil) font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [titleView addSubview:lab_number];
    
    UILabel *lab_time = [GPUtils createLable:CGRectMake(72, 0, Main_Screen_Width-156, 40) text:Custing(@"加班时间", nil) font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [titleView addSubview:lab_time];
    
    UILabel *lab_timeCount = [GPUtils createLable:CGRectMake(Main_Screen_Width-96, 0, 84, 40) text:Custing(@"时长(h)", nil) font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentRight];
    [titleView addSubview:lab_timeCount];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 67, Main_Screen_Width, 0.5)];
    line2.backgroundColor = Color_LineGray_Same_20;
    [rootview addSubview:line2];
    
    NSArray *arr = dic[@"overtimeHistoryDtos"];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic_value = arr[i];
        UIView *view_content = [[UIView alloc]initWithFrame:CGRectMake(0, i*60+67, Main_Screen_Width, 60)];
//        view_content.backgroundColor = Color_WhiteWeak_Same_20;
        UILabel *lab_number_value = [GPUtils createLable:CGRectMake(12, 0, 60, 60) text:[NSString stringWithFormat:@"%d",i+1] font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
        [view_content addSubview:lab_number_value];
        
        UILabel *lab_time_value = [GPUtils createLable:CGRectMake(72, 0, Main_Screen_Width-156, 60) text:[NSString stringWithFormat:@"%@\n%@",dic_value[@"fromDate"],dic_value[@"toDate"]] font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
        lab_time_value.numberOfLines = 0;
        [view_content addSubview:lab_time_value];
        
        UILabel *lab_timeCount_value = [GPUtils createLable:CGRectMake(Main_Screen_Width-96, 0, 84, 60) text:dic_value[@"overTime"] font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentRight];
        [view_content addSubview:lab_timeCount_value];
        [rootview addSubview:view_content];
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, i*60+127, Main_Screen_Width, 0.5)];
        line3.backgroundColor = Color_LineGray_Same_20;
        [rootview addSubview:line3];
    }
    
    UILabel *lab_count = [GPUtils createLable:CGRectMake(12, arr.count*60+67, 60, 36) text:Custing(@"合计", nil) font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [rootview addSubview:lab_count];
    
    UILabel *lab_total = [GPUtils createLable:CGRectMake(Main_Screen_Width-196, arr.count*60+67, 184, 40) text:dic[@"totalTime"] font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentRight];
    [rootview addSubview:lab_total];
    
    UIView *viewinfo = [[UIView alloc]initWithFrame:CGRectMake(0, arr.count*60+107, Main_Screen_Width, 60)];
    viewinfo.backgroundColor = Color_WhiteWeak_Same_20;
    [rootview addSubview:viewinfo];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",Custing(@"本月最多加班时间为", nil),dic[@"monthParamValue"],Custing(@"，超过时长", nil)];
    
    NSString *str1 = [NSString stringWithIdOnNO:dic[@"overtime"]];
    NSString *str2 = Custing(@"小时。", nil);
    
    NSMutableAttributedString *attriString1 = [[NSMutableAttributedString alloc] initWithString:str];
    [attriString1 addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(0, attriString1.length)];
    NSMutableAttributedString *attriString2 = [[NSMutableAttributedString alloc] initWithString:str1];
    [attriString2 addAttribute:NSForegroundColorAttributeName value:Color_Red_Weak_20 range:NSMakeRange(0, str1.length)];
    [attriString2 addAttribute:NSFontAttributeName value:Font_Important_18_20 range:NSMakeRange(0, str1.length)];
    NSMutableAttributedString *attriString3 = [[NSMutableAttributedString alloc] initWithString:str2];
    [attriString3 addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(0, str2.length)];
    
    [attriString1 appendAttributedString:attriString2];
    [attriString1 appendAttributedString:attriString3];
    
    UILabel *lab_info = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-24, 36) text:@"" font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [lab_info setAttributedText:attriString1];
    [viewinfo addSubview:lab_info];
    
    UILabel *lab_info1 = [GPUtils createLable:CGRectMake(12, 36, Main_Screen_Width-24, 20) text:[NSString stringWithFormat:@"%@%@%@",Custing(@"每天最多加班时间为", nil),dic[@"timeParamValue"],Custing(@"小时", nil)] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [viewinfo addSubview:lab_info1];
    
    rootview.frame = CGRectMake(0, 0, Main_Screen_Width, arr.count*60+163);
    return rootview;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
