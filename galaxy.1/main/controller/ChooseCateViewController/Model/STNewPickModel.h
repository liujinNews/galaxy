//
//  STNewPickModel.h
//  galaxy
//
//  Created by hfk on 2018/1/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STNewPickModel : NSObject
/**
 *  共用id
 */
@property (nonatomic,strong)NSString *Id;
/**
 *  共用id
 */
@property (nonatomic,strong)NSString *Type;
/**
 二级数组
 */
@property (nonatomic,strong)NSMutableArray *SubDataArray;


+(NSMutableArray *)getYearDataArray;
+(NSMutableArray *)getYearMonthDataArray;
+(NSMutableArray *)getYearQuarterDataArray;

@end

@interface STNewPickSubModel : NSObject

/**
 *  共用id
 */
@property (nonatomic,strong)NSString *Id;
/**
 *  共用id
 */
@property (nonatomic,strong)NSString *Type;

@end
