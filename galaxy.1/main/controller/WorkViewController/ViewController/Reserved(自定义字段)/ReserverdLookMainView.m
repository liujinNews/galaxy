//
//  ReserverdLookMainView.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ReserverdLookMainView.h"

@implementation ReserverdLookMainView

+(ReserverdLookMainView *)initArr:(NSArray *)arr view:(UIView *)view block:(ReserverdLookMainViewBlock)block{
    ReserverdLookMainView *rootview = [[ReserverdLookMainView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 32)];
    rootview.int_Height = 0;
    __block ReserverdLookMainView *blockself = rootview;
    for (MyProcurementModel *model in arr) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Reserved1"]||[model.fieldName isEqualToString:@"Reserved2"]||[model.fieldName isEqualToString:@"Reserved3"]||[model.fieldName isEqualToString:@"Reserved4"]||[model.fieldName isEqualToString:@"Reserved5"]||[model.fieldName isEqualToString:@"Reserved6"]||[model.fieldName isEqualToString:@"Reserved7"]||[model.fieldName isEqualToString:@"Reserved8"]||[model.fieldName isEqualToString:@"Reserved9"]||[model.fieldName isEqualToString:@"Reserved10"]){
                [view addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:rootview.int_Height block:^(NSInteger height) {
                    blockself.int_Height = height + blockself.int_Height;
                    [view updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(blockself.int_Height+height);
                    }];
                }]];
            }
        }
    }
    if (block) {
        block(rootview.int_Height);
    }
    return rootview;
}

@end
