//
//  ReportFormMainModel.h
//  galaxy
//
//  Created by hfk on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  报表列表数据类型
 */
@interface ReportFormMainModel : NSObject
@property(nonatomic,copy)NSString *value1;
@property(nonatomic,copy)NSString *value2;
@property(nonatomic,copy)NSString *value3;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *name1;
@property(nonatomic,copy)NSString *name3;
@property(nonatomic,copy)NSString *name2;
@property(nonatomic,strong)NSMutableArray *Xarray;
@property(nonatomic,strong)NSMutableArray *Yarray;

+ (void)getReportFormMainDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)ResultArray;
@end
