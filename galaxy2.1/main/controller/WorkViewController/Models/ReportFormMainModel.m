//
//  ReportFormMainModel.m
//  galaxy
//
//  Created by hfk on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ReportFormMainModel.h"

@implementation ReportFormMainModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)getReportFormMainDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)ResultArray{
    NSArray *array=[dic objectForKey:@"result"];
    if ([array isKindOfClass:[NSNull class]]||array == nil||array.count == 0||!array){
        return;
    }
    for (NSDictionary * listDic in array) {
        ReportFormMainModel *model = [[ReportFormMainModel alloc]init];
        model.value1=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"value1"]];
        model.value2=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"value2"]];
        model.value3=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"value3"]];
        model.title=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"title"]];
        model.name1=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name1"]];
        model.name2=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name2"]];
        model.name3=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name3"]];
        model.code=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"code"]];
        if ([model.code isEqualToString:@"005"]) {
            if (![[listDic objectForKey:@"groups"] isKindOfClass:[NSNull class]]) {
                model.Xarray=[NSMutableArray arrayWithArray:[listDic objectForKey:@"groups"]];
            }
            if (![[listDic objectForKey:@"amounts"] isKindOfClass:[NSNull class]]) {
                model.Yarray=[NSMutableArray arrayWithArray:[listDic objectForKey:@"amounts"]];
            }
        }
        if ([model.code isEqualToString:@"001"]||[model.code isEqualToString:@"002"]||[model.code isEqualToString:@"003"]||[model.code isEqualToString:@"004"]||[model.code isEqualToString:@"005"]||[model.code isEqualToString:@"006"]||[model.code isEqualToString:@"007"]||[model.code isEqualToString:@"008"]||[model.code isEqualToString:@"009"]||[model.code isEqualToString:@"010"]||[model.code isEqualToString:@"011"]){
            [ResultArray addObject:model];

        }
    }
}
@end
