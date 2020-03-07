//
//  ExpenseSonListCell.h
//  galaxy
//
//  Created by hfk on 2019/7/4.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpenseSonListCell : UITableViewCell

@property (nonatomic,copy) void(^expClickedBlock)(void);

-(void)configCellWithModel:(AddDetailsModel *)model withHasLine:(BOOL)hasLine;

+ (CGFloat)cellHeightWithModel:(AddDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
