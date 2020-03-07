//
//  PaymentExpDetailCell.h
//  galaxy
//
//  Created by hfk on 2018/11/14.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentExpDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentExpDetailCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger editType;

-(void)configCellWithPaymentExpDetail:(PaymentExpDetail *)PaymentExpDetail;

+ (CGFloat)cellHeightWithModel:(PaymentExpDetail *)model withEditType:(NSInteger)editType;

@end

NS_ASSUME_NONNULL_END
