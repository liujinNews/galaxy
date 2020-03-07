//
//  TravelCarDetailCell.h
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelCarDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelCarDetailCell : UITableViewCell


-(void)configCellWithModel:(TravelCarDetail *)model;

+ (CGFloat)cellHeightWithModel:(TravelCarDetail *)model;

@end

NS_ASSUME_NONNULL_END
