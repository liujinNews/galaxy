//
//  BulkImportViewController.h
//  galaxy
//
//  Created by 赵碚 on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface BulkImportViewController : RootViewController
@property (nonatomic,strong)NSString * JoinStr;
@property (nonatomic,strong)NSString * corpId;
-(id)initWithType:(NSString *)type;

@end
