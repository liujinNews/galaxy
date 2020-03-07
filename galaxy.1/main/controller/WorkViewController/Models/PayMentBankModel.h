//
//  PayMentBankModel.h
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayMentBankModel : NSObject
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)BOOL select;
+(void)getPayMentBankArray:(NSMutableArray *)array;
@end
