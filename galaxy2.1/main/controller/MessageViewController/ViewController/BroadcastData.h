//
//  BroadcastData.h
//  galaxy
//
//  Created by 赵碚 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BroadcastData : NSObject
@property(nonatomic,copy)NSString * attachment;
@property(nonatomic,copy)NSString * body;
@property(nonatomic,copy)NSString * published;
@property(nonatomic,copy)NSString * title;


+ (void)GetBroadcastDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
