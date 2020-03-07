//
//  CtripMainController.h
//  galaxy
//
//  Created by hfk on 2016/10/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface CtripMainController : RootViewController
@property(nonatomic,copy)NSString *GoUrl;
-(id)initWithType:(NSString *)type;
@end
