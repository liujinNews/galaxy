//
//  ContractBatchPayCell.h
//  galaxy
//
//  Created by hfk on 2019/1/7.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractBatchPayCell : UITableViewCell

-(void)configCellWithDict:(NSDictionary *)dict WithHideLine:(BOOL)hideLine;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
