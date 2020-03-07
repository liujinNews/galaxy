//
//  TravelBannerView.h
//  galaxy
//
//  Created by hfk on 2017/5/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelBannerView : UIView
@property (strong, nonatomic) NSArray *curBannerList;
@property (nonatomic , copy) void (^tapActionBlock)(NSInteger index, NSDictionary *dict);
@end
