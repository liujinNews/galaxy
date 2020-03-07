//
//  mineModel.m
//  galaxy
//
//  Created by 赵碚 on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "mineModel.h"

@implementation mineModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (NSMutableArray *)datasWithUser:(NSString *)quanxian  personDict:(userData *)dic
{
    
    NSMutableArray *datas = [NSMutableArray array];
    NSArray * itemsStatic;
    NSString *heiStr = @"194";
    if ([quanxian isEqualToString:@"10"]) {//根据账号权限判断是否有设置功能
        itemsStatic = @[
                        @[@{@"image":@"Message_Man",
                            @"name":@"",
                            @"height":heiStr,
                            @"type":@(mineCellTypeInfo),
                            @"action": @"pushUserInfomationController"}],
                        @[@{@"image":@"My_CompanyAdd",
                            @"name":@"公司管理",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushSetCompanyAdreesBookController"},
                          @{@"image":@"My_Finance",
                            @"name":@"财务管理",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushSetFinanceController"}],
                        @[@{@"image":@"My_Shares",
                            @"name":@"分享给好友",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushShareToFriendsController"},
                          @{@"image":@"My_Helps",
                            @"name":@"帮助与反馈",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushHelpAndFeedbackController"}],
                        @[@{@"image":@"my_setting",
                            @"name":@"设置",
                            @"height":@"48",
                            @"type":@(mineCellTypeSetting),
                            @"action": @"pushTypeSetting"}],
                        ];
    }else if ([quanxian isEqualToString:@"11"]) {
        itemsStatic = @[
                        @[@{@"image":@"Message_Man",
                            @"name":@"",
                            @"height":heiStr,
                            @"type":@(mineCellTypeInfo),
                            @"action": @"pushUserInfomationController"}],
                        @[@{@"image":@"My_invoiceInformation",
                            @"name":@"企业信息",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushNormalCompanyController"},
                          @{@"image":@"NormalInvoiceInfo",
                            @"name":Custing(@"发票抬头", nil),
                            @"height":@"48",
                            @"type":@(mineCellTypeShare),
                            @"action": @"pushCompanyInfo"},
                          @{@"image":@"My_Finance",
                            @"name":@"财务管理",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushSetFinanceController"}],
                        @[@{@"image":@"My_InvitationWorker",
                            @"name":@"邀请同事加入",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushInvitingColleaguesController"},
                          @{@"image":@"My_Shares",
                            @"name":@"分享给好友",
                            @"height":@"48",
                            @"type":@(mineCellTypeShare),
                            @"action": @"pushShareToFriendsController"},
                          @{@"image":@"My_Helps",
                            @"name":@"帮助与反馈",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushHelpAndFeedbackController"}],
                        @[@{@"image":@"my_setting",
                            @"name":@"设置",
                            @"height":@"48",
                            @"type":@(mineCellTypeSetting),
                            @"action": @"pushTypeSetting"}],
                        ];
        
    }else if ([quanxian isEqualToString:@"12"]) {
        itemsStatic = @[
                        @[@{@"image":@"Message_Man",
                            @"name":@"",
                            @"height":heiStr,
                            @"type":@(mineCellTypeDelegateInfo),
                            @"action": @"pushUserInfomationController"}],
                        @[@{@"image":@"My_invoiceInformation",
                            @"name":@"企业信息",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushNormalCompanyController"},
                          @{@"image":@"NormalInvoiceInfo",
                            @"name":Custing(@"发票抬头", nil),
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushCompanyInfo"}],
                        @[@{@"image":@"My_InvitationWorker",
                            @"name":@"邀请同事加入",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushInvitingColleaguesController"},
                          @{@"image":@"My_Shares",
                            @"name":@"分享给好友",
                            @"height":@"48",
                            @"type":@(mineCellTypeShare),
                            @"action": @"pushShareToFriendsController"},
                          @{@"image":@"My_Helps",
                            @"name":@"帮助与反馈",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushHelpAndFeedbackController"}],
                        @[@{@"image":@"my_setting",
                            @"name":@"设置",
                            @"height":@"48",
                            @"type":@(mineCellTypeSetting),
                            @"action": @"pushTypeSetting"}],
                        ];
        
    }else if ([quanxian isEqualToString:@"13"]) {
        itemsStatic = @[
                        @[@{@"image":@"Message_Man",
                            @"name":@"",
                            @"height":heiStr,
                            @"type":@(mineCellTypeInfo),
                            @"action": @"pushUserInfomationController"}],
                        @[@{@"image":@"My_invoiceInformation",
                            @"name":@"企业信息",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushNormalCompanyController"},
                          @{@"image":@"NormalInvoiceInfo",
                            @"name":Custing(@"发票抬头", nil),
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushCompanyInfo"}],
                        @[@{@"image":@"My_InvitationWorker",
                            @"name":@"邀请同事加入",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushInvitingColleaguesController"},
                          @{@"image":@"My_Shares",
                            @"name":@"分享给好友",
                            @"height":@"48",
                            @"type":@(mineCellTypeShare),
                            @"action": @"pushShareToFriendsController"},
                          @{@"image":@"My_Helps",
                            @"name":@"帮助与反馈",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushHelpAndFeedbackController"}],
                        @[@{@"image":@"my_setting",
                            @"name":@"设置",
                            @"height":@"48",
                            @"type":@(mineCellTypeSetting),
                            @"action": @"pushTypeSetting"}],
                        ];
    }else if ([quanxian isEqualToString:@"15"]) {
        itemsStatic = @[
                        @[@{@"image":@"Message_Man",
                            @"name":@"",
                            @"height":heiStr,
                            @"type":@(mineCellTypeInfo),
                            @"action": @"pushUserInfomationController"}],
                        @[@{@"image":@"My_invoiceInformation",
                            @"name":@"企业信息",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushNormalCompanyController"},
                          @{@"image":@"NormalInvoiceInfo",
                            @"name":Custing(@"发票抬头", nil),
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushCompanyInfo"}],
                        @[@{@"image":@"My_Shares",
                            @"name":@"分享给好友",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushShareToFriendsController"},
                          @{@"image":@"My_Helps",
                            @"name":@"帮助与反馈",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushHelpAndFeedbackController"}],
                        @[@{@"image":@"my_setting",
                            @"name":@"设置",
                            @"height":@"48",
                            @"type":@(mineCellTypeSetting),
                            @"action": @"pushTypeSetting"}],
                        ];
    }else if ([quanxian isEqualToString:@"16"]) {
        itemsStatic = @[
                        @[@{@"image":@"Message_Man",
                            @"name":@"",
                            @"height":heiStr,
                            @"type":@(mineCellTypeDelegateInfo),
                            @"action": @"pushUserInfomationController"}],
                        @[@{@"image":@"My_invoiceInformation",
                            @"name":@"企业信息",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushNormalCompanyController"},
                          @{@"image":@"NormalInvoiceInfo",
                            @"name":Custing(@"发票抬头", nil),
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushCompanyInfo"}],
                        @[@{@"image":@"My_Shares",
                            @"name":@"分享给好友",
                            @"height":@"48",
                            @"type":@(mineCellTypeCompany),
                            @"action": @"pushShareToFriendsController"},
                          @{@"image":@"My_Helps",
                            @"name":@"帮助与反馈",
                            @"height":@"48",
                            @"type":@(mineCellTypeMessage),
                            @"action": @"pushHelpAndFeedbackController"}],
                        @[@{@"image":@"my_setting",
                            @"name":@"设置",
                            @"height":@"48",
                            @"type":@(mineCellTypeSetting),
                            @"action": @"pushTypeSetting"}],
                        ];
        
        
    }
    
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:itemsStatic];
    
    
    for (int i = 0; i<items.count; i++) {
        NSArray *sectionRows = items[i];
        NSMutableArray *section = [NSMutableArray array];
        for (int j=0; j<sectionRows.count; j++) {
            NSDictionary *item = sectionRows[j];
            mineModel *row = [[mineModel alloc]init];
            row.iconImage = GPImage(item[@"image"]);
            row.perDic = dic;
            row.title = item[@"name"];
            row.type = [item[@"type"] integerValue];
            row.height = FormatNumber(item[@"height"], @(48));
            row.action = NSSelectorFromString(GPString(item[@"action"]));
            [section addObject:row];
        }
        [datas addObject:section];
    }
    return datas;
}
@end
