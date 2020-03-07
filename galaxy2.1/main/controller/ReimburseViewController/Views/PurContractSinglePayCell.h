//
//  PurContractSinglePayCell.h
//  galaxy
//
//  Created by hfk on 2019/1/7.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurContractSinglePayCell : UITableViewCell

@property (nonatomic, copy) NSString *flowCode;

-(void)configCellWithDict:(NSDictionary *)dict WithIndex:(NSInteger)index;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
