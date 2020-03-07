//
//  ElectInvoiceData.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/21.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ElectInvoiceData.h"

@implementation ElectInvoiceData
+ (NSMutableArray *)electDocDatasWithUser:(NSDictionary *)quaryDoc
{
    NSMutableArray *datas = [NSMutableArray array];
    NSArray * itemsStatic = @[ @[@{@"name":@"个人",
                                   @"height":@"45",
                                   @"type":@(electCellTypeTitle)}],
                               @[@{@"name":@"企业",
                                   @"height":@"45",
                                   @"type":@(electCellTypeTitle)}],];
    
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:itemsStatic];
    
    
    for (int i = 0; i<items.count; i++) {
        NSArray *sectionRows = items[i];
        NSMutableArray *section = [NSMutableArray array];
        for (int j=0; j<sectionRows.count; j++) {
            NSDictionary *item = sectionRows[j];
            ElectInvoiceData *row = [[ElectInvoiceData alloc]init];
            row.quaryDoc = quaryDoc;
            row.title = item[@"name"];
            row.type = [item[@"type"] integerValue];
            row.height = FormatNumber(item[@"height"], @(59));
            [section addObject:row];
        }
        [datas addObject:section];
    }
    return datas;
}

////发票查询列表
//+ (void)electListDocDatasWithUser:(NSDictionary *)dic Array:(NSMutableArray *)array {
//    
//    NSArray * items = [dic objectForKey:@"result"];
//    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
//        for (NSDictionary * listDic in items) {
//            ElectInvoiceData * data    = [[ElectInvoiceData alloc]init];
//            data.fP_DM = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"fP_DM"]];
//            data.fP_HM = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"fP_HM"]];
//            data.fplx = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"fplx"]];
//            data.gmF_MC = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"gmF_MC"]];
//            data.jshj = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jshj"]];
//            data.quaryType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"type"]];;
//            [array addObject:data];
//            
//        }
//    }
//}


@end
