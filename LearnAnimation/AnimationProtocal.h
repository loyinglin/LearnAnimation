//
//  AnimationProtocal.h
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#ifndef AnimationProtocal_h
#define AnimationProtocal_h


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LYAnimationStatus) {
    LYAnimationNotStart,
    LYAnimationPlaying,
    LYAnimationEnd,
};

typedef NS_ENUM(NSUInteger, LYAnimationType) {
    LYAnimationFireworks,
    LYAnimationBoat,
    LYAnimationCar,
};

/**
 *  1、播放完动画回调
 *  2、
 */
@protocol BaseAnimation;
@protocol AnimationCallBackDelegate <NSObject>

- (void)onAnimationEndWithView:(id<BaseAnimation>)view;

@end

@protocol BaseAnimation <NSObject>

- (void)startAnimationWithDelegate:(id<AnimationCallBackDelegate>)delegate;

//- (LYAnimationType)getAnimationType;

- (void)setFrameWithContainer:(id)containerView;

@end



#endif /* AnimationProtocal_h */
