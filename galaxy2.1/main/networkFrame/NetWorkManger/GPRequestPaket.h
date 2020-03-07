//
//  GPRequestPaket.h
//  galaxy
//
//  Created by 赵碚 on 15/7/28.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPRequestPaket : NSObject

@property (strong,nonatomic)NSMutableDictionary* parametersDic;
@property (copy,nonatomic)NSString* requestId;
@property (copy,nonatomic)userData * datas;

-(id)initWithRequestId:(NSString*)requestId;
-(void)setDataWithObject:(NSString*)obj forKey:(NSString*)key;

@end
