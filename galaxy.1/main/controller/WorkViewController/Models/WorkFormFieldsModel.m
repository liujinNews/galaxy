//
//  WorkFormFieldsModel.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/4.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "WorkFormFieldsModel.h"

@implementation WorkFormFieldsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(instancetype)initialize{
    if (self) {
        [self superclass];
    }
    self.model = [[MyProcurementModel alloc]init];
    self.view_View = [[UIView alloc]init];
    self.txf_TexfField = [[UITextField alloc]init];
    self.Value = @"";
    return  self;
}

@end
