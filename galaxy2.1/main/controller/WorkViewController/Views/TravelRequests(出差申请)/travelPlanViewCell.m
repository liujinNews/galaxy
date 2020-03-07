//
//  travelPlanViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 15/11/10.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "travelPlanViewCell.h"
#import "GPUtils.h"

@implementation travelPlanViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self!=nil) {
        if (_type==1) {
//            self.frame = CGRectMake(-15, Y(self), Main_Screen_Width-30, HEIGHT(self));
        }
    }
}

-(travelPlanViewCell *)initModelwithByFlightCell:(TravelFlightDetailModel *)model
{
    travelPlanViewCell *cell = [[travelPlanViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    cell.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    cell.cityLabel = [GPUtils createLable:CGRectMake(12, 8, XBHelper_Title_Width, 45) text:model.flypeople font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    cell.cityLabel.numberOfLines = 0;
    cell.dateLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 31, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:model.departuredate font:Font_yearMonth_12 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    cell.dayLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 8, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:[NSString stringWithFormat:@"%@~%@",model.fromcity,model.tocity] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    [cell.mainView addSubview:cell.cityLabel];
    [cell.mainView addSubview:cell.dateLabel];
    [cell.mainView addSubview:cell.dayLabel];
    [cell addSubview:cell.mainView];
    return cell;
}

-(travelPlanViewCell *)initModelwithByHomeCell:(TravelHotelDetailModel *)model
{
    travelPlanViewCell *cell = [[travelPlanViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    cell.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    cell.cityLabel = [GPUtils createLable:CGRectMake(12, 8, XBHelper_Title_Width, 45) text:model.checkincity font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    cell.cityLabel.numberOfLines = 0;
    cell.dateLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 31, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:[NSString stringWithFormat:@"%@~%@",model.checkindate,model.checkoutdate] font:Font_yearMonth_12 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    cell.dayLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 8, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:[NSString stringWithFormat:@"%@%@",model.numberofrooms,Custing(@"间", nil)] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    [cell.mainView addSubview:cell.cityLabel];
    [cell.mainView addSubview:cell.dateLabel];
    [cell.mainView addSubview:cell.dayLabel];
    [cell addSubview:cell.mainView];
    return cell;
}

-(travelPlanViewCell *)initModelwithByHomeCellInLook:(TravelHotelDetailModel *)model
{
    if (self) {
        self = [[travelPlanViewCell alloc]initWithFrame:CGRectMake(-15, 0, Main_Screen_Width-30, 55)];
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
        _cityLabel = [GPUtils createLable:CGRectMake(12, 8, XBHelper_Title_Width, 45) text:model.checkincity font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        _cityLabel.numberOfLines = 0;
        _dateLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 31, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:[NSString stringWithFormat:@"%@~%@",model.checkindate,model.checkoutdate] font:Font_yearMonth_12 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        _dayLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 8, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:[NSString stringWithFormat:@"%@%@",model.numberofrooms,Custing(@"间", nil)] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        [_mainView addSubview:_cityLabel];
        [_mainView addSubview:_dateLabel];
        [_mainView addSubview:_dayLabel];
        
        [self addSubview:_mainView];
    }
    return self;
}

-(travelPlanViewCell *)initModelwithByTrainCell:(TravelTrainDetailModel *)model
{
    travelPlanViewCell *cell = [[travelPlanViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    cell.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    cell.cityLabel = [GPUtils createLable:CGRectMake(12, 8, XBHelper_Title_Width, 45) text:model.passenger font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    cell.cityLabel.numberOfLines = 0;
    cell.dateLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 31, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:model.departuredate font:Font_yearMonth_12 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    cell.dayLabel = [GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 8, Main_Screen_Width-XBHelper_Title_Width-42, 20) text:[NSString stringWithFormat:@"%@/%@",model.fromcity,model.tocity] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    [cell.mainView addSubview:cell.cityLabel];
    [cell.mainView addSubview:cell.dateLabel];
    [cell.mainView addSubview:cell.dayLabel];
    [cell addSubview:cell.mainView];
    return cell;
}

@end
