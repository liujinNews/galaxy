//
//  WorkFormFieldsModel.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/4.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyProcurementModel.h"

@interface WorkFormFieldsModel : NSObject

@property (nonatomic, strong) MyProcurementModel *model;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *Value;
@property (nonatomic, strong) UITextField *txf_TexfField;
@property (nonatomic, strong) UIView *view_View;

-(instancetype)initialize;

@end
