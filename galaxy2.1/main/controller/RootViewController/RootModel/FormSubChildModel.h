//
//  FormSubChildModel.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormSubChildModel : NSObject
+ (instancetype)sharedManager;

@property (nonatomic, copy) NSString *str_param1;
@property (nonatomic, copy) NSString *str_param2;
@property (nonatomic, copy) NSString *str_param3;
@property (nonatomic, copy) NSString *str_param4;
@property (nonatomic, copy) NSString *str_param5;
@property (nonatomic, copy) NSString *str_param6;

-(NSMutableArray *)getShowDealArrayWithSetArray:(NSMutableArray *)showSetArray withDataArray:(NSMutableArray *)showDataArray WithType:(NSInteger)type;

@end
