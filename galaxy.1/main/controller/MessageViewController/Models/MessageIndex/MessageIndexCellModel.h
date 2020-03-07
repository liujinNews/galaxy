//
//  MessageIndexCellModel.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageIndexCellModel : NSObject

/**
 1多公司消息提醒 2新人报道 3账单提醒
 */
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *coName;
@property (nonatomic, strong) NSString *logo;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
