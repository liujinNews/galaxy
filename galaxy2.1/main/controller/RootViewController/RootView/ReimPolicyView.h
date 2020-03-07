//
//  ReimPolicyView.h
//  galaxy
//
//  Created by hfk on 2017/10/24.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BaseView_Height_Block)(NSInteger height ,NSDictionary *date);

@interface ReimPolicyView : UIView
@property (strong, nonatomic) NSDictionary  *bodydict;
@property (strong, nonatomic) NSString  *flowCode;
@property (nonatomic , copy) void (^clickBlock)(NSString *bodyUrl);

- (instancetype)initWithFlowCode:(NSString *)flowcode withBodydict:(NSDictionary *)bodydict withBaseViewHeight:(BaseView_Height_Block)block;

@end
