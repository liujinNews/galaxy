//
//  RouteDetailView.m
//  galaxy
//
//  Created by hfk on 2017/8/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RouteDetailView.h"

@implementation RouteDetailView
-(RouteDetailView *)initRouteDetail:(RouteModel *)model withType:(NSInteger)type{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, Main_Screen_Width, 215);
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        UILabel *MileLab=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width, 26) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        if (type==1) {
            MileLab.text=Custing(@"里程", nil);
        }else if (type==2){
            MileLab.text=Custing(@"金额", nil);
        }
        MileLab.center=CGPointMake(Main_Screen_Width/2, 10+13);
        [self addSubview:MileLab];
        
        
        UILabel *MileNumLab=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width, 36) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
        MileNumLab.center=CGPointMake(Main_Screen_Width/2, 36+18);
        NSMutableAttributedString *str;
        if (type==1) {
            str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",[NSString isEqualToNull:model.mileage]?model.mileage:@"0",@"KM"]];
            [str addAttribute:NSForegroundColorAttributeName value:Color_Black_Important_20 range:NSMakeRange(0, str.length)];
            [str addAttribute:NSFontAttributeName value:Font_Important_18_20 range:NSMakeRange(0, str.length-3)];
            [str addAttribute:NSFontAttributeName value:Font_Important_15_20 range:NSMakeRange(str.length-3, 3)];
        }else if (type==2){
            str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",[NSString isEqualToNull:model.amount]?model.amount:@"0.00",Custing(@"元", nil)]];
            [str addAttribute:NSForegroundColorAttributeName value:Color_Black_Important_20 range:NSMakeRange(0, str.length)];
            [str addAttribute:NSFontAttributeName value:Font_Important_18_20 range:NSMakeRange(0, str.length-1)];
            [str addAttribute:NSFontAttributeName value:Font_Important_15_20 range:NSMakeRange(str.length-1, 1)];
        }
        [MileNumLab setAttributedText:str];
        [self addSubview:MileNumLab];
        
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 90, Main_Screen_Width, 0.5)];
        line1.backgroundColor=Color_GrayLight_Same_20;
        [self addSubview:line1];
        
        
        UIImageView *startImg=[GPUtils createImageViewFrame:CGRectMake(0, 0, 10, 10) imageName:@"Self_Drive_Green"];
        startImg.center=CGPointMake(12+5, 117);
        [self addSubview:startImg];
        
        UILabel *startLab=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-42, 25) text:[NSString isEqualToNull:model.departureName]?model.departureName:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        startLab.center=CGPointMake(Main_Screen_Width/2+9, 117);
        [self addSubview:startLab];
        
        
        UIImageView *endImg=[GPUtils createImageViewFrame:CGRectMake(0, 0, 10, 10) imageName:@"Self_Drive_Red"];
        endImg.center=CGPointMake(12+5, 145);
        [self addSubview:endImg];
        
        UILabel *endLab=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-42, 25) text:[NSString isEqualToNull:model.arrivalName]?model.arrivalName:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        endLab.center=CGPointMake(Main_Screen_Width/2+9, 145);
        [self addSubview:endLab];
        
        
        
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 168, Main_Screen_Width, 0.5)];
        line2.backgroundColor=Color_GrayLight_Same_20;
        [self addSubview:line2];
        
        
        UILabel *startTime=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width/2-25, 25) text:[NSString isEqualToNull:model.departureTimeStr]?model.departureTimeStr:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        startTime.center=CGPointMake(Main_Screen_Width/4-0.5, 194);
        [self addSubview:startTime];
        
        
        UILabel *endTime=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width/2-25, 25) text:[NSString isEqualToNull:model.arrivalTimeStr]?model.arrivalTimeStr:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        endTime.center=CGPointMake(Main_Screen_Width-12-(Main_Screen_Width/2-25)/2, 194);
        [self addSubview:endTime];
        
        
        
        
        UIImageView *midImg=[GPUtils createImageViewFrame:CGRectMake(0, 0, 25, 6) imageName:@"Self_Drive_Middle"];
        midImg.center=CGPointMake(Main_Screen_Width/2, 194);
        [self addSubview:midImg];
    
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
