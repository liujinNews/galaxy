//
//  TIMRefreshListenerImpl.m
//  MyDemo
//
//  Created by wilderliao on 15/12/7.
//  Copyright © 2015年 sofawang. All rights reserved.
//

#import "TIMRefreshListenerImpl.h"

@implementation TIMRefreshListenerImpl

- (void) onRefresh
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil]; 
}

@end
