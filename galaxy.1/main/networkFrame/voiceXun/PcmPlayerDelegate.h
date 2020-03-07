//
//  speechRecordDelegate.h
//  MSCDemo
//
//  Created by wangdan on 14-11-4.
//
//

#import <Foundation/Foundation.h>

@protocol PcmPlayerDelegate<NSObject>


//MARK: 音频播放相关回调

@optional


//播放音频结束
-(void)onPlayCompleted;

@end
