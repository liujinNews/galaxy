//
//  FormChildTableView.h
//  galaxy
//
//  Created by hfk on 2018/4/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormChildTableView : UIView

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void (^cellClick)(NSString *taskId);


- (instancetype)initWithFrame:(CGRect)frame;

//更新关联合同
-(void)updateReletContractViewWithArray:(NSMutableArray *)array;
//合同付款、收票和开票信息
-(void)updateContractReletInfoViewWithArray:(NSMutableArray *)array;

@end
