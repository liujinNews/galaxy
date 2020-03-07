//
//  VoiceDataManger.h
//  galaxy
//
//  Created by hfk on 2017/12/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userData.h"

typedef void(^VoiceBase_DealData_Block)(id data , BOOL hasError);

typedef void(^GetBaseShowDataBlock)(BOOL successed);

@interface VoiceDataManger : NSObject<GPClientDelegate>
+ (instancetype)sharedManager;


-(void)getUserCustomsDateWithDict:(NSDictionary *)result WithFormArray:(NSMutableArray *)resultArray;

-(void)uploadImageDataWithImgSoure:(NSMutableArray *)totalImageArray WithUrl:(NSString *)url  WithBlock:(VoiceBase_DealData_Block)block;

-(void)getBaseShowDataWithBlock:(GetBaseShowDataBlock)block;

+(void)getFlowAndApplicationInfoWithDict:(NSDictionary *)result;


+(NSMutableDictionary *)getFlowShowInfo:(NSString *)flowKey;


+(NSString *)getFlowMoneyLabelInfo:(MyApplyModel *)model withType:(NSInteger)type;


+(NSDictionary *)getApplicationWithInfoDict:(NSDictionary *)infoDict;


-(NSDictionary *)getControllerNameWithFlowCode:(NSString *)flowCode;


-(BOOL)isH5FlowFormWithFlowCode:(NSString *)flowCode;

@end
