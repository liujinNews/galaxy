//
//  TrvOneImportCell.h
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteTrvOneModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrvOneImportCell : UITableViewCell

@property (nonatomic, strong) NSString *choosed;

-(void)configCellWithModel:(RouteTrvOneModel *)model isEdit:(BOOL)isEdit isChoosed:(NSString *)choosed;
@end

NS_ASSUME_NONNULL_END
