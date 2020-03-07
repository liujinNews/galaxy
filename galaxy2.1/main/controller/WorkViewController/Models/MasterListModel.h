//
//  MasterListModel.h
//  galaxy
//
//  Created by hfk on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterListModel : NSObject
/**
 *  id
 */
@property (nonatomic,strong)NSString *Id;
/**
 *  name
 */
@property (nonatomic,copy)NSString *name;
/**
 *  no
 */
@property (nonatomic,copy)NSString *no;

+ (void)getMasterListByArray:(NSArray *)resultArray Array:(NSMutableArray *)array;
@end
