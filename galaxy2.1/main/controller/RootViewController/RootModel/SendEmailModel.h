//
//  SendEmailModel.h
//  galaxy
//
//  Created by hfk on 2018/3/28.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendEmailModel : NSObject

@property(nonatomic,copy)NSString *str_Link;
@property(nonatomic,copy)NSString *str_Password;
@property(nonatomic,copy)NSString *str_Title;
@property(nonatomic,copy)NSString *str_FlowCode;
@property(nonatomic,copy)NSString *str_Requestor;

+ (SendEmailModel *) modelWithInfo:(NSDictionary *)dict;
@end
