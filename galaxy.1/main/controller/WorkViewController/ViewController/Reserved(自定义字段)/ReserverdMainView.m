//
//  ReserverdMainView.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/5.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ReserverdMainView.h"

@implementation ReserverdMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(ReserverdMainView *)initArr:(NSMutableArray *)arr isRequiredmsdic:(NSMutableDictionary *)isRequiredmsdic reservedDic:(NSMutableDictionary *)reservedDic UnShowmsArray:(NSMutableArray *)UnShowmsArray view:(UIView *)view model:(ReserverdMainModel *)models block:(ReserverdMainBlock)block{
    self=[super init];
    if (self) {
        _int_Height = 0;
        _Re_model = models;
        if (!self.Re_block) {
            self.Re_block = block;
        }
        _Re_model = [[ReserverdMainModel alloc]init];
        for (MyProcurementModel *model in arr) {
            if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
                if ([model.fieldName isEqualToString:@"Reserved1"])
                {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_1 = [[UITextField alloc]init];
                    _view_1 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_1 addSubview:[[ReservedView alloc]init:_txf_1 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_1.frame = CGRectMake(X(weakSelf.view_1), Y(weakSelf.view_1), WIDTH(weakSelf.view_1), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_1 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd1 = contextFiled.text;
                    }]];
                    [self addSubview:_view_1];
                    [_txf_1 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd1 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_1.text = model.fieldValue;
                        models.Reserverd1 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved2"]) {
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_2 = [[UITextField alloc]init];
                    _view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_2 addSubview:[[ReservedView alloc]init:_txf_2 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_2.frame = CGRectMake(X(weakSelf.view_2), Y(weakSelf.view_2), WIDTH(weakSelf.view_2), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_2 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd2 = contextFiled.text;
                    }]];
                    [self addSubview:_view_2];
                    [_txf_2 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd2 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_2.text = model.fieldValue;
                        models.Reserverd2 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved3"]) {
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_3 = [[UITextField alloc]init];
                    _view_3 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_3 addSubview:[[ReservedView alloc]init:_txf_3 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_3.frame = CGRectMake(X(weakSelf.view_3), Y(weakSelf.view_3), WIDTH(weakSelf.view_3), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_3 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd3 = contextFiled.text;
                    }]];
                    [self addSubview:_view_3];
                    [_txf_3 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd3 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_3.text = model.fieldValue;
                        models.Reserverd3 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved4"]) {
                    
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_4 = [[UITextField alloc]init];
                    _view_4 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_4 addSubview:[[ReservedView alloc]init:_txf_4 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_4.frame = CGRectMake(X(weakSelf.view_4), Y(weakSelf.view_4), WIDTH(weakSelf.view_4), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_4 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd4 = contextFiled.text;
                    }]];
                    [self addSubview:_view_4];
                    [_txf_4 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd4 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_4.text = model.fieldValue;
                        models.Reserverd4 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved5"]) {
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_5 = [[UITextField alloc]init];
                    _view_5 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_5 addSubview:[[ReservedView alloc]init:_txf_5 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_5.frame = CGRectMake(X(weakSelf.view_5), Y(weakSelf.view_5), WIDTH(weakSelf.view_5), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_5 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd5 = contextFiled.text;
                    }]];
                    [self addSubview:_view_5];
                    [_txf_5 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd5 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_5.text = model.fieldValue;
                        models.Reserverd5 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved6"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_6 = [[UITextField alloc]init];
                    _view_6 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_6 addSubview:[[ReservedView alloc]init:_txf_6 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_6.frame = CGRectMake(X(weakSelf.view_6), Y(weakSelf.view_6), WIDTH(weakSelf.view_6), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_6 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd6 = contextFiled.text;
                    }]];
                    [self addSubview:_view_6];
                    [_txf_6 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd6 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_6.text = model.fieldValue;
                        models.Reserverd6 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved7"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_7 = [[UITextField alloc]init];
                    _view_7 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_7 addSubview:[[ReservedView alloc]init:_txf_7 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_7.frame = CGRectMake(X(weakSelf.view_7), Y(weakSelf.view_7), WIDTH(weakSelf.view_7), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_7 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd7 = contextFiled.text;
                    }]];
                    [self addSubview:_view_7];
                    [_txf_7 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd7 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_7.text = model.fieldValue;
                        models.Reserverd7 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved8"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_8 = [[UITextField alloc]init];
                    _view_8 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_8 addSubview:[[ReservedView alloc]init:_txf_8 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_8.frame = CGRectMake(X(weakSelf.view_8), Y(weakSelf.view_8), WIDTH(weakSelf.view_8), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_8 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd8 = contextFiled.text;
                    }]];
                    [self addSubview:_view_8];
                    [_txf_8 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd8 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_8.text = model.fieldValue;
                        models.Reserverd8 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved9"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_9 = [[UITextField alloc]init];
                    _view_9 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_9 addSubview:[[ReservedView alloc]init:_txf_9 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_9.frame = CGRectMake(X(weakSelf.view_9), Y(weakSelf.view_9), WIDTH(weakSelf.view_9), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_9 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd9 = contextFiled.text;
                    }]];
                    [self addSubview:_view_9];
                    [_txf_9 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd9 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_9.text = model.fieldValue;
                        models.Reserverd9 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved10"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_10 = [[UITextField alloc]init];
                    _view_10 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_10 addSubview:[[ReservedView alloc]init:_txf_10 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_10.frame = CGRectMake(X(weakSelf.view_10), Y(weakSelf.view_10), WIDTH(weakSelf.view_10), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_10 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd10 = contextFiled.text;
                    }]];
                    [self addSubview:_view_10];
                    [_txf_10 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd10 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_10.text = model.fieldValue;
                        models.Reserverd10 = model.fieldValue;
                    }
                }
            }
        }
        self.frame = CGRectMake(0, 0, Main_Screen_Width, _int_Height);
        self.Re_block(self.int_Height);
    }
    return self;
}

-(ReserverdMainView *)initReimShareArr:(NSMutableArray *)arr isRequiredmsdic:(NSMutableDictionary *)isRequiredmsdic reservedDic:(NSMutableDictionary *)reservedDic UnShowmsArray:(NSMutableArray *)UnShowmsArray view:(UIView *)view model:(ReserverdMainModel *)models DataModel:(ReimShareModel *)dataModel block:(ReserverdMainBlock)block{
    
    self=[super init];
    if (self) {
        _int_Height = 0;
        _Re_model = models;
        if (!self.Re_block) {
            self.Re_block = block;
        }
        _Re_model = [[ReserverdMainModel alloc]init];
        for (MyProcurementModel *model in arr) {
            if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
                if ([model.fieldName isEqualToString:@"Reserved1"])
                {
                    model.fieldValue=dataModel.Reserved1;
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_1 = [[UITextField alloc]init];
                    _view_1 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_1 addSubview:[[ReservedView alloc]init:_txf_1 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_1.frame = CGRectMake(X(weakSelf.view_1), Y(weakSelf.view_1), WIDTH(weakSelf.view_1), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_1 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd1 = contextFiled.text;
                    }]];
                    [self addSubview:_view_1];
                    [_txf_1 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd1 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_1.text = model.fieldValue;
                        models.Reserverd1 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved2"]) {
                    
                    model.fieldValue=dataModel.Reserved2;
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_2 = [[UITextField alloc]init];
                    _view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_2 addSubview:[[ReservedView alloc]init:_txf_2 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_2.frame = CGRectMake(X(weakSelf.view_2), Y(weakSelf.view_2), WIDTH(weakSelf.view_2), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_2 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd2 = contextFiled.text;
                    }]];
                    [self addSubview:_view_2];
                    [_txf_2 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd2 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_2.text = model.fieldValue;
                        models.Reserverd2 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved3"]) {
                    
                    model.fieldValue=dataModel.Reserved3;
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_3 = [[UITextField alloc]init];
                    _view_3 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_3 addSubview:[[ReservedView alloc]init:_txf_3 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_3.frame = CGRectMake(X(weakSelf.view_3), Y(weakSelf.view_3), WIDTH(weakSelf.view_3), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_3 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd3 = contextFiled.text;
                    }]];
                    [self addSubview:_view_3];
                    [_txf_3 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd3 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_3.text = model.fieldValue;
                        models.Reserverd3 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved4"]) {
                    
                    model.fieldValue=dataModel.Reserved4;
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_4 = [[UITextField alloc]init];
                    _view_4 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_4 addSubview:[[ReservedView alloc]init:_txf_4 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_4.frame = CGRectMake(X(weakSelf.view_4), Y(weakSelf.view_4), WIDTH(weakSelf.view_4), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_4 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd4 = contextFiled.text;
                    }]];
                    [self addSubview:_view_4];
                    [_txf_4 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd4 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_4.text = model.fieldValue;
                        models.Reserverd4 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved5"]) {
                    
                    model.fieldValue=dataModel.Reserved5;
                    
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_5 = [[UITextField alloc]init];
                    _view_5 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_5 addSubview:[[ReservedView alloc]init:_txf_5 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_5.frame = CGRectMake(X(weakSelf.view_5), Y(weakSelf.view_5), WIDTH(weakSelf.view_5), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_5 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd5 = contextFiled.text;
                    }]];
                    [self addSubview:_view_5];
                    [_txf_5 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd5 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_5.text = model.fieldValue;
                        models.Reserverd5 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved6"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_6 = [[UITextField alloc]init];
                    _view_6 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_6 addSubview:[[ReservedView alloc]init:_txf_6 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_6.frame = CGRectMake(X(weakSelf.view_6), Y(weakSelf.view_6), WIDTH(weakSelf.view_6), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_6 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd6 = contextFiled.text;
                    }]];
                    [self addSubview:_view_6];
                    [_txf_6 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd6 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_6.text = model.fieldValue;
                        models.Reserverd6 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved7"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_7 = [[UITextField alloc]init];
                    _view_7 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_7 addSubview:[[ReservedView alloc]init:_txf_7 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_7.frame = CGRectMake(X(weakSelf.view_7), Y(weakSelf.view_7), WIDTH(weakSelf.view_7), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_7 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd7 = contextFiled.text;
                    }]];
                    [self addSubview:_view_7];
                    [_txf_7 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd7 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_7.text = model.fieldValue;
                        models.Reserverd7 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved8"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_8 = [[UITextField alloc]init];
                    _view_8 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_8 addSubview:[[ReservedView alloc]init:_txf_8 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_8.frame = CGRectMake(X(weakSelf.view_8), Y(weakSelf.view_8), WIDTH(weakSelf.view_8), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_8 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd8 = contextFiled.text;
                    }]];
                    [self addSubview:_view_8];
                    [_txf_8 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd8 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_8.text = model.fieldValue;
                        models.Reserverd8 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved9"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_9 = [[UITextField alloc]init];
                    _view_9 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_9 addSubview:[[ReservedView alloc]init:_txf_9 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_9.frame = CGRectMake(X(weakSelf.view_9), Y(weakSelf.view_9), WIDTH(weakSelf.view_9), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_9 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd9 = contextFiled.text;
                    }]];
                    [self addSubview:_view_9];
                    [_txf_9 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd9 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_9.text = model.fieldValue;
                        models.Reserverd9 = model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"Reserved10"]) {
                    [isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                    [reservedDic setValue:model.Description forKey:model.fieldName];
                    [UnShowmsArray removeObject:model.fieldName];
                    __weak typeof(self) weakSelf = self;
                    _txf_10 = [[UITextField alloc]init];
                    _view_10 = [[UIView alloc]initWithFrame:CGRectMake(0, _int_Height, Main_Screen_Width, 50)];
                    [_view_10 addSubview:[[ReservedView alloc]init:_txf_10 model:model Y:10 block:^(NSInteger height) {
                        weakSelf.view_10.frame = CGRectMake(X(weakSelf.view_10), Y(weakSelf.view_10), WIDTH(weakSelf.view_10), height +10);
                        weakSelf.int_Height = weakSelf.int_Height + 10 + height;
                        [weakSelf.view_10 addSubview:[self createLineView]];
                    } txfblock:^(MyProcurementModel *model, UITextField *contextFiled) {
                        models.Reserverd10 = contextFiled.text;
                    }]];
                    [self addSubview:_view_10];
                    [_txf_10 setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textField, NSRange range, NSString *string) {
                        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        models.Reserverd10 = newString;
                        return YES;
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_10.text = model.fieldValue;
                        models.Reserverd10 = model.fieldValue;
                    }
                }
            }
        }
        self.frame = CGRectMake(0, 0, Main_Screen_Width, _int_Height);
        self.Re_block(self.int_Height);
    }
    return self;
    
}


-(UIView *)createLineView{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}


@end
