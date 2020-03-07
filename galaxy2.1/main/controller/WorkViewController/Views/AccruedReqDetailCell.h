//
//  AccruedReqDetailCell.h
//  galaxy
//
//  Created by APPLE on 2020/1/14.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccruedReqDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccruedReqDetailCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger editType;

-(void)configCellWithPaymentExpDetail:(AccruedReqDetail *)PaymentExpDetail;

+ (CGFloat)cellHeightWithModel:(AccruedReqDetail *)model withEditType:(NSInteger)editType;
@end

NS_ASSUME_NONNULL_END
