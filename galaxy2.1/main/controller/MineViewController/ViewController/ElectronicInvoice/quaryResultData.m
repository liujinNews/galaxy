//
//  quaryResultData.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "quaryResultData.h"

@implementation quaryResultData

+ (NSMutableArray *)quaryDocDatasWithUser:(NSDictionary *)quaryDoc
{
    NSMutableArray *datas = [NSMutableArray array];
    NSArray * itemsStatic = @[@{@"name":@"查询结果",
                                @"height":@"42",
                                @"type":@(quaryCellTypeTitle)},
                              @{@"name":@"发票代码",
                                @"height":@"45",
                                @"type":@(quaryCellTypeContent)},
                              @{@"name":@"发票号码",
                                @"height":@"45",
                                @"type":@(quaryCellTypeContent)},
                              @{@"name":@"开票日期",
                                @"height":@"45",
                                @"type":@(quaryCellTypeContent)},
                              @{@"name":@"开票金额",
                                @"height":@"45",
                                @"type":@(quaryCellTypeContent)},
                              @{@"name":@"销售方税号",
                                @"height":@"45",
                                @"type":@(quaryCellTypeContent)},
                              @{@"name":@"销售名称",
                                @"height":@"45",
                                @"type":@(quaryCellTypeContent)},
                              @{@"name":@"购买方名称",
                                @"height":@"45",
                                @"type":@(quaryCellTypeContent)},
                              @{@"name":@"查验结果",
                                @"height":@"45",
                                @"type":@(quaryCellTypeResult)}];
    
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:itemsStatic];
    
    
    for (int i = 0; i<items.count; i++) {
        NSDictionary *item = items[i];
        quaryResultData *row = [[quaryResultData alloc]init];
        row.quaryDoc = quaryDoc;
        row.title = item[@"name"];
        row.type = [item[@"type"] integerValue];
        row.height = FormatNumber(item[@"height"], @(59));
        [datas addObject:row];
    }
    return datas;
}

@end
