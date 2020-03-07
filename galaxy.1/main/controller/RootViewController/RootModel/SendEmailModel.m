//
//  SendEmailModel.m
//  galaxy
//
//  Created by hfk on 2018/3/28.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "SendEmailModel.h"

@implementation SendEmailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (SendEmailModel *) modelWithInfo:(NSDictionary *)dict{
    SendEmailModel *newDemoModel = [[self alloc]init];
    newDemoModel.str_Link = [NSString isEqualToNull:dict[@"link"]] ? dict[@"link"] : @"";
    newDemoModel.str_Password = [NSString isEqualToNull:dict[@"password"]] ? dict[@"password"] : @"";
    newDemoModel.str_Title = [NSString isEqualToNull:dict[@"title"]] ? dict[@"title"]:@"";
    newDemoModel.str_FlowCode = [NSString isEqualToNull:dict[@"flowCode"]] ? dict[@"flowCode"] : @"";
    newDemoModel.str_Requestor = [NSString isEqualToNull:dict[@"requestor"]] ? dict[@"requestor"] : @"";;
    return newDemoModel;
}
@end
