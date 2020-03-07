//
//  RootTabViewController.h
//  galaxy
//
//  Created by hfk on 16/5/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RDVTabBarController.h"
#import "userData.h"
@interface RootTabViewController : RDVTabBarController<RDVTabBarControllerDelegate>
@property (nonatomic, strong)userData *userdatas;
@end
