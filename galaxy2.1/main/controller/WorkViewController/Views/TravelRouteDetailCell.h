//
//  TravelRouteDetailCell.h
//  galaxy
//
//  Created by hfk on 2018/11/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TravelRouteDetailCell : UITableViewCell

@property (nonatomic, assign) BOOL bool_hideLine;

@property (nonatomic, strong) NSDictionary *dict_Info;

+ (CGFloat)cellHeightWithObj:(NSDictionary *)obj;

@end

NS_ASSUME_NONNULL_END
