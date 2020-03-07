//
//  BroadcastData.m
//  galaxy
//
//  Created by 赵碚 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BroadcastData.h"

@implementation BroadcastData
+ (void)GetBroadcastDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        int i = 0;
        for (NSDictionary * listDic in items) {
            BroadcastData * data    = [[BroadcastData alloc]init];
            data.attachment = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"attachment"]];
            data.body = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"body"]];
            data.published = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"published"]];
            data.title = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"title"]];
//            if (i==0) {
//                data.attachment = @"http://7xt76f.com2.z0.glb.clouddn.com/test/view/450_1.jpg";
//            }else{
//                data.attachment = @"http://7xt76f.com2.z0.glb.clouddn.com/test/view/900x500.jpg";
//            }
            
            
            [array addObject:data];
            i++;
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
