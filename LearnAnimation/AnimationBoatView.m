//
//  AnimationBoatView.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AnimationBoatView.h"

@interface AnimationBoatView ()
@property (nonatomic , strong) UIImageView* mWaveLeftImageView;
@property (nonatomic , strong) UIImageView* mWaveRightImageView;
@property (nonatomic , strong) UIScrollView* mScrollView;

@property (nonatomic , strong) UIImageView* mBoatImageView;
@property (nonatomic , strong) UIImageView* mShadowImageView;

@property (nonatomic , weak) id<AnimationCallBackDelegate> delegate;
@end



@implementation AnimationBoatView

static UIImage* gWaveFrameImage;
static UIImage* gBoatFrameImage;
static UIImage* gShadowFrameImage;

#define const_position_boat_x 1538
#define const_position_boat_width 622
#define const_boat_size_rate 0.8
#define const_shadow_height_rate 0.7

+ (void)initialize {
    UIImage* sourceImage = [UIImage imageNamed:@"gift_boat"];
    CGSize sourceSize = sourceImage.size;
    CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                                      CGRectMake(0, 0, const_position_boat_x, sourceSize.height));
    gWaveFrameImage = [UIImage imageWithCGImage:cgimage];
    
    cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                           CGRectMake(const_position_boat_x, 0, const_position_boat_width, sourceSize.height));
    gBoatFrameImage = [UIImage imageWithCGImage:cgimage];
    
    cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                           CGRectMake(const_position_boat_x + const_position_boat_width, 0, sourceSize.width - const_position_boat_x - const_position_boat_width, sourceSize.height));
    gShadowFrameImage = [UIImage imageWithCGImage:cgimage];
}


- (instancetype)init {
    self = [super init];
    [self customInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self customInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self customInit];
    return self;
}

- (void)customInit {
    if (self.mScrollView) {
        [self.mScrollView removeFromSuperview];
    }
    self.mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mScrollView];
    
    if (self.mWaveLeftImageView) {
        [self.mWaveLeftImageView removeFromSuperview];
    }
    self.mWaveLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.mScrollView addSubview:self.mWaveLeftImageView];
    
    if (self.mWaveRightImageView) {
        [self.mWaveRightImageView removeFromSuperview];
    }
    self.mWaveRightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.mScrollView addSubview:self.mWaveRightImageView];
    
    if (self.mBoatImageView) {
        [self.mBoatImageView removeFromSuperview];
    }
    self.mBoatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) * const_boat_size_rate, CGRectGetHeight(self.bounds) * const_boat_size_rate)];
    [self addSubview:self.mBoatImageView];
    
    
    if (self.mShadowImageView) {
        [self.mShadowImageView removeFromSuperview];
    }
    self.mShadowImageView = [[UIImageView alloc] initWithFrame:self.mBoatImageView.frame];
    [self addSubview:self.mShadowImageView];
}

- (void)setFrameWithContainer:(id)containerView {
    UIView* view = (UIView *)containerView;
    self.frame = view.bounds;
    [view addSubview:self];
    [self customInit];
    
}

- (void)startAnimationWithDelegate:(id<AnimationCallBackDelegate>)delegate {
    self.delegate = delegate;
    [self play];
}

- (void)play {
    [self.mWaveLeftImageView setImage:gWaveFrameImage];
    [self.mWaveLeftImageView sizeToFit];
    [self.mWaveRightImageView setImage:gWaveFrameImage];
    [self.mWaveRightImageView sizeToFit];
    
    CGRect frame = self.mWaveLeftImageView.frame;
    frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
    [self.mWaveRightImageView setFrame:frame];
    
    //boat
    [self.mBoatImageView setImage:gBoatFrameImage];
    [self.mShadowImageView setImage:gShadowFrameImage];
    frame = self.mBoatImageView.frame;
    frame.origin.y += CGRectGetHeight(frame) * const_shadow_height_rate;
    [self.mShadowImageView setFrame:frame];
    
    
    [UIView animateWithDuration:10.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = self.mWaveLeftImageView.frame;
        frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
        [self.mWaveLeftImageView setFrame:frame];
        
        frame.origin.x = 0;
        [self.mWaveRightImageView setFrame:frame];
        
    } completion:^(BOOL finished) {
        CGRect frame = self.mWaveLeftImageView.frame;
        frame.origin.x = 0;
        [self.mWaveLeftImageView setFrame:frame];
        
        frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
        [self.mWaveRightImageView setFrame:frame];
    }];
    
    [UIView animateWithDuration:5.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame;
        // boat
        frame = self.mBoatImageView.frame;
        frame.origin.x += 250;
        [self.mBoatImageView setFrame:frame];
        // shadow
        frame = self.mBoatImageView.frame;
        frame.origin.y += CGRectGetHeight(frame) * const_shadow_height_rate;
        [self.mShadowImageView setFrame:frame];
    } completion:^(BOOL finished) {
        self.mBoatImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);
        self.mShadowImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);

        
        [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame;
            frame = self.mBoatImageView.frame;
            frame.origin = CGPointMake(0, 0);
            [self.mBoatImageView setFrame:frame];
            
            frame = self.mBoatImageView.frame;
            frame.origin.y += CGRectGetHeight(frame) * const_shadow_height_rate;
            [self.mShadowImageView setFrame:frame];
        } completion:^(BOOL finished) {
            self.mBoatImageView.layer.transform = CATransform3DIdentity;
            self.mShadowImageView.layer.transform = CATransform3DIdentity;
            [self removeFromSuperview];
            [self.delegate onAnimationEndWithView:self];
        }];
    }];
    
    
}


@end
