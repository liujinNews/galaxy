//
//  TravelMainModel.m
//  galaxy
//
//  Created by hfk on 2017/5/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "TravelMainModel.h"

@implementation TravelMainModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)getShowModel:(TravelMainModel *)model{
    
    userData *userdatas = [userData shareUserData];
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    model.bannerArray = [NSMutableArray array];
    
    model.bannerArray = [NSMutableArray arrayWithArray:
                         @[@{@"name":@"Travel_BannerOne",@"action":@"GotoCtripFlight"},
                         @{@"name":@"Travel_BannerTwo",@"action":@"GotoCtripHotel"},
                         @{@"name":(lan) ? @"Travel_BannerThree":@"Travel_BannerThreeEn",@"action":@"GotoHuazhuHotel"}]];
    
    model.titleArray = [NSMutableArray array];
    model.IconArray = [NSMutableArray array];
    
//    为了应用appstore的审核，获取测试账号的公司ID
    userData *datas = [userData shareUserData];
    NSString *cid = [NSString stringWithFormat:@"%@",datas.companyId];
    NSInteger cidNum = [cid integerValue];
//    此cidNum为测试公司ID，不影响其他公司使用差旅报销
    if (cidNum == 4) {
        [userdatas.arr_XBCode removeObject:@"Ctrip"];
        [userdatas.arr_XBCode removeObject:@"HuaZhu"];
        [userdatas.arr_XBCode removeObject:@"JD"];
    }
    

    if ([userdatas.arr_XBCode containsObject:@"Ctrip"]) {
        
        if ([[NSString stringWithFormat:@"%@",userdatas.str_RelateTravelForm] isEqualToString:@"1"]) {
            [model.titleArray addObject:@{@"titleImage":@"xieChengSL",@"Actitle":@[Custing(@"我的订单", nil),Custing(@"出差需求单", nil)]}];
        }else{
            [model.titleArray addObject:@{@"titleImage":@"xieChengSL",@"Actitle":@[Custing(@"我的订单", nil)]}];
        }
        
        if ([[userData shareUserData].userRole containsObject:@"2"]||[[userData shareUserData].userRole containsObject:@"4"]) {
            [model.IconArray addObject:@[@{@"image":@"travelTicketPlan",@"name":Custing(@"机票_", nil),@"action":@"GotoCtripFlight"},
                                         @{@"image":@"travelTicketHotel",@"name":Custing(@"酒店", nil),@"action":@"GotoCtripHotel"},
                                         @{@"image":@"travelTicketTrain",@"name":Custing(@"火车票_", nil),@"action":@"GotoCtripTrain"},
                                         @{@"image":@"Travel_Car",@"name":Custing(@"接送机", nil),@"action":@"GotoCtripBus"},
                                         @{@"image":@"Travel_Help",@"name":Custing(@"帮助", nil),@"action":@"GotoCtripHelp"},
                                         @{@"image":@"",@"name":@"",@"action":@""}]];
        }else{
            [model.IconArray addObject:@[@{@"image":@"travelTicketPlan",@"name":Custing(@"机票_", nil),@"action":@"GotoCtripFlight"},
                                         @{@"image":@"travelTicketHotel",@"name":Custing(@"酒店", nil),@"action":@"GotoCtripHotel"},
                                         @{@"image":@"travelTicketTrain",@"name":Custing(@"火车票_", nil),@"action":@"GotoCtripTrain"},
                                         @{@"image":@"Travel_Car",@"name":Custing(@"接送机", nil),@"action":@"GotoCtripBus"},
                                         @{@"image":@"",@"name":@"",@"action":@""},
                                         @{@"image":@"",@"name":@"",@"action":@""}]];
        }
    }
    
    if (cidNum == 4) {
//        此cidNum为测试公司ID，不影响其他公司使用差旅报销
        [model.titleArray addObject:@{@"titleImage":@"",@"Actitle":@[Custing(@"暂未开通", nil)]}];
        [model.IconArray addObject: @[@{@"image":@"",@"name":Custing(@"", nil),@"action":@""},
                                      @{@"image":@"",@"name":@"",@"action":@""},
                                      @{@"image":@"",@"name":@"",@"action":@""}]];
        
    }else{
//        if ([userdatas.arr_XBCode containsObject:@"HuaZhu"]) {
        [model.titleArray addObject:@{@"titleImage":@"TravelMain_DidiTitle",@"Actitle":@[Custing(@"滴滴出行单", nil)]}];
        [model.IconArray addObject: @[@{@"image":@"TravelMain_DidiLog",@"name":Custing(@"滴滴", nil),@"action":@"GotoDiDi"},
                                      @{@"image":@"",@"name":@"",@"action":@""},
                                      @{@"image":@"",@"name":@"",@"action":@""}]];
//        }
        
//        [model.titleArray addObject:@{@"titleImage":@"Plane",@"Actitle":@[Custing(@"出行需求", nil),Custing(@"我的订单", nil)]}];
        [model.titleArray addObject:@{@"titleImage":@"Plane"}];
        [model.IconArray addObject:@[@{@"image":@"travelTicketPlan",@"name":Custing(@"机票", nil),@"action":@"GoToPlane"},
                                     @{@"image":@"travelTicketHotel",@"name":Custing(@"酒店", nil),@"action":@"GoToHotel"},
                                     @{@"image":@"travelTicketTrain",@"name":Custing(@"火车票", nil),@"action":@"GoToTrain"}]];
        
        [model.titleArray addObject:@{@"titleImage":@"Car",@"Actitle":@[Custing(@"出行需求", nil)]}];
        [model.IconArray addObject: @[@{@"image":@"Travel_Car",@"name":Custing(@"用车", nil),@"action":@"GoToCar"},
                                      @{@"image":@"",@"name":@"",@"action":@""},
                                      @{@"image":@"",@"name":@"",@"action":@""}]];
    }
    
    
    
    
    if ([userdatas.arr_XBCode containsObject:@"HuaZhu"]) {
        [model.titleArray addObject:@{@"titleImage":@"huazhuHotel",@"Actitle":@[]}];
        [model.IconArray addObject: @[@{@"image":@"travelTicketHotel",@"name":Custing(@"酒店", nil),@"action":@"GotoHuazhuHotel"},
                                      @{@"image":@"",@"name":@"",@"action":@""},
                                      @{@"image":@"",@"name":@"",@"action":@""}]];
    }
    
    if ([userdatas.arr_XBCode containsObject:@"JD"]) {
        [model.titleArray addObject:@{@"titleImage":@"travelTicketJing",@"Actitle":@[]}];
        [model.IconArray addObject:@[@{@"image":@"travelTicketComputer",@"name":Custing(@"电脑办公", nil),@"action":@"GotoJDoffice"},
                                     @{@"image":@"TravelTicketTationery",@"name":Custing(@"文具耗材", nil),@"action":@"GotoJDstationery"},
                                     @{@"image":@"travelTicketHousehold",@"name":Custing(@"家用电器",nil),@"action":@"GotoJDelectric"},
                                     @{@"image":@"travelTicketMobile",@"name":Custing(@"手机数码",nil),@"action":@"GotoJDdigital"},
                                     @{@"image":@"travelTicketBook",@"name":Custing(@"图书",nil),@"action":@"GotoJDbook"},
                                     @{@"image":@"travelTicketMore",@"name":Custing(@"更多",nil),@"action":@"GotoJDmore"}]];
    }
    
    
    
    
    
}

@end
