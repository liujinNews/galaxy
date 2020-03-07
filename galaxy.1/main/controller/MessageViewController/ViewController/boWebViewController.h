//
//  boWebViewController.h
//  galaxy
//
//  Created by 赵碚 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface boWebViewController : RootViewController
-(id)initWithType:(NSString *)type;
@property (nonatomic, strong) NSString *str_title;
@end
