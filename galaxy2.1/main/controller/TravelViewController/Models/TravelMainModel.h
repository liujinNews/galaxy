//
//  TravelMainModel.h
//  galaxy
//
//  Created by hfk on 2017/5/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelMainModel : NSObject
/**
 *  bannerArray
 */
@property (nonatomic,strong)NSMutableArray *bannerArray;
/**
 *  titleInfo
 */
@property (nonatomic,strong)NSMutableArray *titleArray;
/**
 *  IconInfo
 */
@property (nonatomic,strong)NSMutableArray *IconArray;

+ (void)getShowModel:(TravelMainModel *)model;
@end
