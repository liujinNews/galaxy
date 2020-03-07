//
//  MainReleSubInfoView.h
//  galaxy
//
//  Created by hfk on 2018/12/14.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainReleSubInfoView : UIView

@property (nonatomic,copy) void(^serialNoBtnClickedBlock)(NSDictionary *dict);

-(instancetype)initWithFlowCode:(NSString *)flowcode;


-(void)updateView:(NSMutableArray *)array;


@end

NS_ASSUME_NONNULL_END
