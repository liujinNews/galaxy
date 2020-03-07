//
//  FormSubChildModel.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormSubChildModel.h"
#import "TravelPeopleInfoModel.h"
#import "TravelInfoModel.h"
#import "FeeBudgetInfoModel.h"
#import "MyProcurementModel.h"

@interface FormSubChildModel ()

@property (nonatomic, strong) NSMutableArray *showSetArray;
@property (nonatomic, strong) NSMutableArray *showDataArray;

@end

@implementation FormSubChildModel
+ (instancetype)sharedManager {
    static FormSubChildModel *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(NSMutableArray *)getShowDealArrayWithSetArray:(NSMutableArray *)showSetArray withDataArray:(NSMutableArray *)showDataArray WithType:(NSInteger)type{
    
    self.showSetArray = showSetArray;
    self.showDataArray = showDataArray;
    if (type == 1) {
        return [self getTravelPeopleInfo];
    }else if (type == 2){
        return [self getTravelinfo];
    }else if (type == 3){
        return [self getFeeBudgetInfo];
    }else{
        return [NSMutableArray array];
    }
}

-(NSMutableArray *)getTravelPeopleInfo{
    NSMutableArray *arr = [NSMutableArray array];
    for (TravelPeopleInfoModel *model in self.showDataArray) {
        FormSubChildModel *sub = [[FormSubChildModel alloc]init];
        NSMutableArray *title = [NSMutableArray array];
        for (MyProcurementModel *model1 in self.showSetArray) {
            if ([model1.fieldName isEqualToString:@"TravelAddr"]&&[model1.isShow floatValue]==1) {
                sub.str_param1 = [NSString stringIsExist:model.TravelAddr];
            }else if ([model1.fieldName isEqualToString:@"UserName"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringIsExist:model.UserName]];
            }else if ([model1.fieldName isEqualToString:@"UserDept"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringIsExist:model.UserDept]];
            }else if ([model1.fieldName isEqualToString:@"JobTitle"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringIsExist:model.JobTitle]];
            }else if ([model1.fieldName isEqualToString:@"UserLevel"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringIsExist:model.UserLevel]];
            }else if ([model1.fieldName isEqualToString:@"TravelTime"]&&[model1.isShow floatValue]==1){
                sub.str_param3 = [NSString stringIsExist:model.TravelTime];
            }else if ([model1.fieldName isEqualToString:@"IdNumber"]&&[model1.isShow floatValue]==1){
                sub.str_param4 = [NSString stringIsExist:model.IdNumber];
            }else if ([model1.fieldName isEqualToString:@"TravelPurpose"]&&[model1.isShow floatValue]==1){
                sub.str_param5 = [NSString isEqualToNull:model.TravelPurpose] ? [NSString stringWithFormat:@"%@",model.TravelPurpose]:nil;
            }
        }
        if (title.count > 0) {
            sub.str_param2 = [GPUtils getSelectResultWithArray:title WithCompare:@","];
        }
        [arr addObject:sub];
    }
    return arr;
}

-(NSMutableArray *)getTravelinfo{
    NSMutableArray *arr = [NSMutableArray array];
    for (TravelInfoModel *model in self.showDataArray) {
        FormSubChildModel *sub = [[FormSubChildModel alloc]init];
        for (MyProcurementModel *model1 in self.showSetArray) {
            if ([model1.fieldName isEqualToString:@"Departure"]&&[model1.isShow floatValue]==1) {
                sub.str_param1 = [NSString stringIsExist:model.Departure];
            }else if ([model1.fieldName isEqualToString:@"ReturnAddr"]&&[model1.isShow floatValue]==1){
                sub.str_param2 = [NSString stringIsExist:model.ReturnAddr];
            }else if ([model1.fieldName isEqualToString:@"UserName"]&&[model1.isShow floatValue]==1){
                sub.str_param3 = [NSString stringIsExist:model.UserName];
            }else if ([model1.fieldName isEqualToString:@"DepartureAmt"]&&[model1.isShow floatValue]==1){
                sub.str_param4 = [GPUtils transformNsNumber:model.DepartureAmt];
            }else if ([model1.fieldName isEqualToString:@"ReturnAmt"]&&[model1.isShow floatValue]==1){
                sub.str_param5 = [GPUtils transformNsNumber:model.ReturnAmt];
            }else if ([model1.fieldName isEqualToString:@"TotalAmount"]&&[model1.isShow floatValue]==1){
                sub.str_param6 = [GPUtils transformNsNumber:model.TotalAmount];
            }
        }
        [arr addObject:sub];
    }
    return arr;

}
-(NSMutableArray *)getFeeBudgetInfo{
    NSMutableArray *arr = [NSMutableArray array];
    for (FeeBudgetInfoModel *model in self.showDataArray) {
        FormSubChildModel *sub = [[FormSubChildModel alloc]init];
        NSMutableArray *title = [NSMutableArray array];
        for (MyProcurementModel *model1 in self.showSetArray) {
            if ([model1.fieldName isEqualToString:@"UserName"]&&[model1.isShow floatValue]==1) {
                sub.str_param1 = [NSString stringIsExist:model.UserName];
            }else if ([model1.fieldName isEqualToString:@"TotalAmount"]&&[model1.isShow floatValue]==1){
                sub.str_param2 = [GPUtils transformNsNumber:model.TotalAmount];
            }else if ([model1.fieldName isEqualToString:@"InterTransFee"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.InterTransFee]]];
            }else if ([model1.fieldName isEqualToString:@"InterTransDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.InterTransDay]]];
            }else if ([model1.fieldName isEqualToString:@"CityTransFee"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.CityTransFee]]];
            }else if ([model1.fieldName isEqualToString:@"CityTransDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.CityTransDay]]];
            }else if ([model1.fieldName isEqualToString:@"HotelFee"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.HotelFee]]];
            }else if ([model1.fieldName isEqualToString:@"HotelDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.HotelDay]]];
            }else if ([model1.fieldName isEqualToString:@"EntertainmentFee"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.EntertainmentFee]]];
            }else if ([model1.fieldName isEqualToString:@"EntertainmentDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.EntertainmentDay]]];
            }else if ([model1.fieldName isEqualToString:@"MealFee"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.MealFee]]];
            }else if ([model1.fieldName isEqualToString:@"MealDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.MealDay]]];
            }else if ([model1.fieldName isEqualToString:@"CommunicationFee"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.CommunicationFee]]];
            }else if ([model1.fieldName isEqualToString:@"CommunicationDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.CommunicationDay]]];
            }else if ([model1.fieldName isEqualToString:@"TravelAllowance"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.TravelAllowance]]];
            }else if ([model1.fieldName isEqualToString:@"TravelAllowanceDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.TravelAllowanceDay]]];
            }else if ([model1.fieldName isEqualToString:@"OverseasAllowance"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.OverseasAllowance]]];
            }else if ([model1.fieldName isEqualToString:@"OverseasAllowanceDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.OverseasAllowanceDay]]];
            }else if ([model1.fieldName isEqualToString:@"OtherFee"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.OtherFee]]];
            }else if ([model1.fieldName isEqualToString:@"OtherDay"]&&[model1.isShow floatValue]==1){
                [title addObject:[NSString stringWithFormat:@"%@:%@",model1.Description,[GPUtils transformNsNumber:model.OtherDay]]];
            }else if ([model1.fieldName isEqualToString:@"Remark"]&&[model1.isShow floatValue]==1){
                sub.str_param4 = [NSString isEqualToNull:model.Remark]?model.Remark:nil;
            }
        }
        if (title.count > 0) {
            sub.str_param3 = [GPUtils getSelectResultWithArray:title WithCompare:@"、"];
        }
        [arr addObject:sub];
    }
    return arr;
}
@end
