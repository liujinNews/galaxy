//
//  personDocModel.m
//  galaxy
//
//  Created by 赵碚 on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "personDocModel.h"

@implementation personDocModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (NSMutableArray *)personDocDatasWithUser:(NSDictionary *)perDoc
{
    NSMutableArray *datas = [NSMutableArray array];
//    NSArray * itemsStatic = @[@[@{@"image":@"Message_Man",
//                                  @"name":@"头像",
//                                  @"height":@"59",
//                                  @"type":@(personDocCellTypeAvater),
//                                  @"action": @"SwitchHeadPortrait"}],
//                              @[@{@"image":@"My_Helps",
//                                  @"name":@"姓名",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeName),
//                                  @"action": @"modifyName"},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"性别",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeName),
//                                  @"action": @"modifyGener"},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"手机",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeName),
//                                  @"action": @""},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"邮箱",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeName),
//                                  @"action": @"modifyEmailAdress"}],
//                              @[@{@"image":@"My_Helps",
//                                  @"name":@"部门",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeDept),
//                                  @"action": @"pushDepartmentLook"},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"职位",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeDept),
//                                  @"action": @"pushPositionLook"},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"级别",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeDept),
//                                  @"action": @"pushNewMessageNotifationController"},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"成本中心",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeDept),
//                                  @"action": @"pushNewMessageNotifationController"},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"公司",
//                                  @"height":@"49",
//                                  @"type":@(personDocCellTypeDept),
//                                  @"action": @"pushNewMessageNotifationController"}],
//                              @[@{@"image":@"My_Helps",
//                                  @"name":@"银行卡",
//                                  @"height":@"59",
//                                  @"type":@(personDocCellTypeBankCard),
//                                  @"action": @"pushModifyCardNumber"},
//                                @{@"image":@"My_Helps",
//                                  @"name":@"证件号",
//                                  @"height":@"59",
//                                  @"type":@(personDocCellTypeBankCard),
//                                  @"action": @"pushModifyIdentityCard"}],
//                              @[@{@"image":@"My_Helps",
//                                  @"name":@"号码隐藏",
//                                  @"height":@"69",
//                                  @"type":@(personDocCellTypePhoneHidden),
//                                  @"action": @"pushHelpAndFeedbackController"}],
//                              @[@{@"image":@"My_Helps",
//                                  @"name":@"查看报表权限",
//                                  @"height":@"89",
//                                  @"type":@(personDocCellTypeLookReportRoot),
//                                  @"action": @"pushLookReportRoot"}],
//                              @[@{@"image":@"My_Helps",
//                                  @"name":@"签名",
//                                  @"height":@"75",
//                                  @"type":@(personDocCellTypeSignature),
//                                  @"action": @"pushLookReportRootSignature"}]
//                              ];
    
    NSArray * itemsStatic = @[@[@{@"image":@"Message_Man",
                                  @"name":@"头像",
                                  @"height":@"59",
                                  @"type":@(personDocCellTypeAvater),
                                  @"action": @"SwitchHeadPortrait"}],
                              @[@{@"image":@"My_Helps",
                                  @"name":@"姓名",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeName),
                                  @"action": @"modifyName"},
                                @{@"image":@"My_Helps",
                                  @"name":@"性别",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeName),
                                  @"action": @"modifyGener"},
                                @{@"image":@"My_Helps",
                                  @"name":@"手机",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeName),
                                  @"action": @""},
                                @{@"image":@"My_Helps",
                                  @"name":@"邮箱",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeName),
                                  @"action": @"modifyEmailAdress"},
                                @{@"image":@"My_Helps",
                                  @"name":@"工号",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeName),
                                  @"action": @""}],
                              @[@{@"image":@"My_Helps",
                                  @"name":@"部门/职位",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeDept),
                                  @"action": @"pushDepartmentLook"},
                                @{@"image":@"My_Helps",
                                  @"name":@"级别",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeDept),
                                  @"action": @"pushNewMessageNotifationController"},
                                @{@"image":@"My_Helps",
                                  @"name":@"成本中心",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeDept),
                                  @"action": @"pushNewMessageNotifationController"},
                                @{@"image":@"My_Helps",
                                  @"name":@"公司",
                                  @"height":@"49",
                                  @"type":@(personDocCellTypeDept),
                                  @"action": @"pushNewMessageNotifationController"}],
                              @[@{@"image":@"My_Helps",
                                  @"name":@"收款人",
                                  @"height":@"59",
                                  @"type":@(personDocCellTypeBankCard),
                                  @"action": @"pushModifyCardNumber"},
                                @{@"image":@"My_Helps",
                                  @"name":@"证件号",
                                  @"height":@"59",
                                  @"type":@(personDocCellTypeBankCard),
                                  @"action": @"pushModifyIdentityCard"}],
                              @[@{@"image":@"My_Helps",
                                  @"name":@"号码隐藏",
                                  @"height":@"69",
                                  @"type":@(personDocCellTypePhoneHidden),
                                  @"action": @"pushHelpAndFeedbackController"}],
                              @[@{@"image":@"My_Helps",
                                  @"name":@"查看报表权限",
                                  @"height":@"89",
                                  @"type":@(personDocCellTypeLookReportRoot),
                                  @"action": @"pushLookReportRoot"}],
                              @[@{@"image":@"My_Helps",
                                  @"name":@"签名",
                                  @"height":@"75",
                                  @"type":@(personDocCellTypeSignature),
                                  @"action": @"pushLookReportRootSignature"}]
                              ];
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:itemsStatic];
    
    
    for (int i = 0; i<items.count; i++) {
        NSArray *sectionRows = items[i];
        NSMutableArray *section = [NSMutableArray array];
        for (int j=0; j<sectionRows.count; j++) {
            NSDictionary *item = sectionRows[j];
            personDocModel *row = [[personDocModel alloc]init];
            row.perDoc = perDoc;
            row.title = item[@"name"];
            row.type = [item[@"type"] integerValue];
            row.height = FormatNumber(item[@"height"], @(59));
            row.action = NSSelectorFromString(GPString(item[@"action"]));
            
            if ([item[@"name"]isEqualToString:@"部门/职位"]) {
                NSDictionary *dic = perDoc[@"userGroup"];
                row.height = [NSNumber numberWithInteger:dic.count*18+31];
            }
            
            [section addObject:row];
        }
        [datas addObject:section];
    }
    return datas;
}

@end
