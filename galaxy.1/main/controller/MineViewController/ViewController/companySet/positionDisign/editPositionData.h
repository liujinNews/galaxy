//
//  editPositionData.h
//  galaxy
//
//  Created by 赵碚 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface editPositionData : NSObject
@property(nonatomic,copy)NSString * active;
@property(nonatomic,copy)NSString * companyId;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * creater;
@property(nonatomic,copy)NSString * idd;
@property(nonatomic,copy)NSString * jobTitle;
@property(nonatomic,copy)NSString * jobTitleCode;
@property(nonatomic,copy)NSString * jobTitleEn;
@property(nonatomic,copy)NSString * updateTime;
@property(nonatomic,copy)NSString * updater;
+ (void)GetEditPositionListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@property(nonatomic,copy)NSString * descriptino;
@property(nonatomic,copy)NSString * total;
@property(nonatomic,copy)NSString * userLevel;
@property(nonatomic,copy)NSString * userLevelEn;
@property(nonatomic,copy)NSString * userLevelNo;



+ (void)GetEditUserLevealDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
