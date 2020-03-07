//
//  ZFProjectMangViewController.h
//  galaxy
//
//  Created by 赵碚 on 16/7/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "projectManagerModel.h"
#import "ChooseTypeController.h"
@interface ZFProjectMangViewController : RootViewController

@property(nonatomic,strong)projectManagerModel *model;
@property (nonatomic, assign) NSInteger codeIsSystem;

@end
