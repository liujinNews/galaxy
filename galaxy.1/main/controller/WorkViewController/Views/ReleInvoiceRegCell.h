//
//  ReleInvoiceRegCell.h
//  galaxy
//
//  Created by hfk on 2018/12/17.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReleInvoiceRegCell : UITableViewCell

@property (nonatomic,copy) void(^serialNoBtnClickedBlock)(NSDictionary *dict);

-(void)configCellWithInfoDict:(NSDictionary *)dict;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
