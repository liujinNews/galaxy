//
//  MulChooseShowView.h
//  galaxy
//
//  Created by hfk on 2018/8/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MulChooseShowView : UIView

@property (nonatomic, copy) void(^CellClickBlock)(NSDictionary *dict, NSInteger status);

@property (nonatomic, copy) NSString *flowCode;

-(instancetype)initWithStatus:(NSInteger)status withFlowCode:(NSString *)flowcode;

-(void)updateView:(NSDictionary *)dict;

@end
