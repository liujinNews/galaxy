//
//  RouteDetailView.h
//  galaxy
//
//  Created by hfk on 2017/8/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteModel.h"
@interface RouteDetailView : UIView
-(RouteDetailView *)initRouteDetail:(RouteModel *)model withType:(NSInteger)type;
@end
