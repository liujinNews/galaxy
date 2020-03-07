//
//  MyMsgVideoModel.h
//  MyDemo
//
//  Created by tomzhu on 15/12/8.
//  Copyright © 2015年 sofawang. All rights reserved.
//

#import "MyMsgBaseModel.h"

@interface MyMsgVideoModel : MyMsgBaseModel

@property (nonatomic, strong)NSString* videoPath;
@property (nonatomic, strong)NSString* videoType;
@property (nonatomic, assign)int duration;
@property (nonatomic, strong)NSString* snapshotPath;
@property (nonatomic, strong)NSString* snapshotType;
@property (nonatomic, assign)int width;
@property (nonatomic, assign)int height;

@end
