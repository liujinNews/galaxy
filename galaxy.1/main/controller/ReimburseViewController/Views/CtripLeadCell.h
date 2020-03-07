//
//  CtripLeadCell.h
//  galaxy
//
//  Created by hfk on 2019/8/26.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CtripLeadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CtripLeadCell : UITableViewCell

- (void)configCtripViewCellWithModel:(CtripLeadModel *)model withIsEdit:(BOOL)isEdit withIndex:(NSInteger)index;

+ (CGFloat)cellHeightWithModel:(CtripLeadModel *)model;

@end

NS_ASSUME_NONNULL_END
