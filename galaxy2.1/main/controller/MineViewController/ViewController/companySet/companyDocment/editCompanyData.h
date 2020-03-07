//
//  editCompanyData.h
//  galaxy
//
//  Created by 赵碚 on 15/12/24.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface editCompanyData : NSObject
@property(nonatomic,strong)NSString *coid;
@property(nonatomic,strong)NSString *scale;

@property(nonatomic,strong)NSString *provinceName;
@property(nonatomic,strong)NSString *provinceNameEn;
@property(nonatomic,strong)NSString *provinceCode;

@property(nonatomic,strong)NSString *industryid;
@property(nonatomic,strong)NSString * industry;


+ (void)GeteditCompanyDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2 Array:(NSMutableArray *)array3 Array:(NSMutableArray *)array4;

@property(nonatomic,strong) NSString * messageType;
@property(nonatomic,strong) NSString * messageUrl;
@property(nonatomic,strong) NSString * messageContent;

@end
