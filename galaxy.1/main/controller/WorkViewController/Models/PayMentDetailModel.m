//
//  PayMentDetailModel.m
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentDetailModel.h"

@implementation PayMentDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+(NSString *)getTaskDateWithArray:(NSMutableArray *)arr withSource:(NSDictionary *)dict{
    NSDictionary *result=dict[@"result"];
    NSString *amount;
    if (![result isKindOfClass:[NSNull class]]) {
        NSArray *array=result[@"items"];
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                PayMentDetailModel *model=[[PayMentDetailModel alloc]init];
                model.taskName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"taskName"]]]?[NSString stringWithFormat:@"%@",dic[@"taskName"]]:@"";
                model.flowCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"flowCode"]]]?[NSString stringWithFormat:@"%@",dic[@"flowCode"]]:@"";
                model.flowGuid=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"flowGuid"]]]?[NSString stringWithFormat:@"%@",dic[@"flowGuid"]]:@"";
                model.amountPayable=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"amountPayable"]]]?[NSString stringWithFormat:@"%@",dic[@"amountPayable"]]:@"0";
                model.name=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"name"]]]?[NSString stringWithFormat:@"%@: %@",Custing(@"收款人", nil),dic[@"name"]]:[NSString stringWithFormat:@"%@: ",Custing(@"收款人", nil)];
               
                model.bankName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"bankName"]]]?[NSString stringWithFormat:@"%@: %@",Custing(@"银行名称", nil),dic[@"bankName"]]:[NSString stringWithFormat:@"%@: ",Custing(@"银行名称", nil)];
                if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"bankAccount"]]]) {
                    NSMutableString *str=[NSMutableString stringWithFormat:@"%@",dic[@"bankAccount"]];
                    NSInteger i=floor((double)(str.length)/4);
                    for (int j=1; j<=i; j++) {
                        [str insertString:@" " atIndex:(5*j-1)];
                    }
                    model.bankAccount=[NSString stringWithFormat:@"%@: %@",Custing(@"银行账户", nil),str];
                }else{
                    model.bankAccount=[NSString stringWithFormat:@"%@: ",Custing(@"银行账户", nil)];
                }
               
                [arr addObject:model];
                amount=[GPUtils decimalNumberAddWithString:amount with:[NSString stringWithFormat:@"%@",model.amountPayable]];
            }
        }
    }
    return amount;
}
@end
