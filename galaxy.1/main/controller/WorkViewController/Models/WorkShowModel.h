//
//  WorkShowModel.h
//  galaxy
//
//  Created by hfk on 16/5/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkShowModel : NSObject
@property(nonatomic,copy)NSString *appDesc;
@property(nonatomic,copy)NSString *appIcon;
@property(nonatomic,copy)NSString *appId;
@property(nonatomic,copy)NSString *appName;
@property(nonatomic,copy)NSString *appUrl;
@property(nonatomic,copy)NSString *companyId;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *webUrl;

@property(nonatomic,assign)NSInteger appType;

@property(nonatomic,copy)NSString *appIsNew;
@property(nonatomic,copy)NSString *appFlowCode;
@property(nonatomic,copy)NSString *appFlowGuid;


+ (void)getReportFormDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)ResultArray;

+ (void)getWorkPartDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)DataArray WithPartArray:(NSMutableArray *)partArray;

@end

