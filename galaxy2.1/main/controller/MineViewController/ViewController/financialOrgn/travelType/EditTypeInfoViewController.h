//
//  EditTypeInfoViewController.h
//  galaxy
//
//  Created by hfk on 2019/5/27.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditTypeInfoViewController : VoiceBaseController

@property (nonatomic,strong) id EditInfo;

-(id)initWithType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
