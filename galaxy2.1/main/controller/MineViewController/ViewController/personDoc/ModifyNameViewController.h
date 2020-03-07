//
//  ModifyNameViewController.h
//  galaxy
//
//  Created by 赵碚 on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface ModifyNameViewController : RootViewController
@property (nonatomic,strong)NSDictionary * personDic;
-(id)initWithType:(NSString *)type;
@end
