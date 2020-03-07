//
//  editCompanyData.m
//  galaxy
//
//  Created by 赵碚 on 15/12/24.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "editCompanyData.h"

@implementation editCompanyData

+ (void)GeteditCompanyDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2 Array:(NSMutableArray *)array3 Array:(NSMutableArray *)array4 {
    
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    
    
    NSArray * province = [result objectForKey:@"province"];
    if ([province isKindOfClass:[NSNull class]] || province == nil|| province.count == 0||!province){
        
    }else{
        for (NSDictionary * listDic in province) {
            editCompanyData * data = [[editCompanyData alloc]init];
            data.provinceName = [listDic objectForKey:@"provinceName"];
            data.provinceNameEn = [listDic objectForKey:@"provinceNameEn"];
            data.provinceCode = [listDic objectForKey:@"provinceCode"];
            [array2 addObject:data];
        }
    }
    
    NSArray * industry = [result objectForKey:@"industry"];
    if ([industry isKindOfClass:[NSNull class]] || industry == nil|| industry.count == 0||!industry){
        
    }else{
        for (NSDictionary * listDic in industry) {
            editCompanyData * data = [[editCompanyData alloc]init];
            data.industryid = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.industry = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"industry"]];
            [array3 addObject:data];
        }
    }
    
    NSArray * coscale = [result objectForKey:@"coScale"];
    if ([coscale isKindOfClass:[NSNull class]] || coscale == nil|| coscale.count == 0||!coscale){
        
    }else{
        for (NSDictionary * listDic in coscale) {
            editCompanyData * data = [[editCompanyData alloc]init];
            data.coid = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.scale = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"scale"]];
            [array4 addObject:data];
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
