//
//  ReimImportCustomCell.h
//  galaxy
//
//  Created by hfk on 2018/10/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReimImportCustomCell : UITableViewCell

-(void)configCellWithDict:(NSMutableDictionary *)dict WithIsLast:(BOOL)isLast;

+ (CGFloat)cellHeightWithObj:(NSMutableDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
