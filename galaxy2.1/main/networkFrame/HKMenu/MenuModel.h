//
//  MenuModel.h
//  PopMenuTableView
//
//  Created by hfk on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *itemName;

+ (instancetype)MenuModelWithDict:(NSDictionary *)dict;

@end
