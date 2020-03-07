//
//  PurAndContractDetailView.h
//  galaxy
//
//  Created by hfk on 2019/1/7.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPaymentFormData.h"
NS_ASSUME_NONNULL_BEGIN

@interface PurAndContractDetailView : UIView

-(instancetype)initWithFlowCode:(NSString *)flowcode;

-(void)updateViewWithData:(MyPaymentFormData *)formData;

@end

NS_ASSUME_NONNULL_END
