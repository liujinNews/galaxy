//
//  PayMentBankModel.m
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentBankModel.h"

@implementation PayMentBankModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+(void)getPayMentBankArray:(NSMutableArray *)array{
    PayMentBankModel *model=[[PayMentBankModel alloc]init];
    model.image=@"Beijing_bank";
    model.name=Custing(@"北京银行", nil);
    model.select=YES;
    [array addObject:model];
}
@end
