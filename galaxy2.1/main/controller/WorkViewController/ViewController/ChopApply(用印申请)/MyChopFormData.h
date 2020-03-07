//
//  MyChopFormData.h
//  galaxy
//
//  Created by hfk on 2017/12/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "MyChopDeatil.h"
#import "MyChopData.h"
@interface MyChopFormData : FormBaseModel
/**
 用印文件类型id
 */
@property (nonatomic, strong) NSString *str_FileTypeId;
/**
 用印文件类型
 */
@property (nonatomic, strong) NSString *str_FileType;

/**
 * 拼接数据
 */
@property(nonatomic,strong)MyChopData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
/**
 获取表名
 */
-(NSString *)getTableName;
@end
