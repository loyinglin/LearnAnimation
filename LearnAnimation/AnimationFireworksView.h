//
//  AnimationFireworksView.h
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LYAnimationStatus) {
    LYAnimationNotStart,
    LYAnimationPlaying,
    LYAnimationEnd,
};

typedef NS_ENUM(NSUInteger, LYAnimationFireworksColor) {
    LYAnimationFireworksGreen,
    LYAnimationFireworksRed,
    LYAnimationFireworksYellow,
    LYAnimationFireworksBlue,
};

@interface AnimationFireworksView : UIView

- (void)play;

@end
