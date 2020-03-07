//
//  UnReadManager.h
//  galaxy
//
//  Created by hfk on 2018/5/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnReadManager : NSObject<GPClientDelegate>

+ (instancetype)shareManager;
- (void)updateUnRead;

@end
