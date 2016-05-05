//
//  AnimationFireworksView.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AnimationFireworksView.h"



@interface AnimationFireworksView()
@property (nonatomic , strong) NSArray* mImagesArray;
@property (nonatomic , strong) NSArray* mColorImagesArray;
@property (nonatomic , assign) long mCurrentFarme;
@property (nonatomic , assign) LYAnimationStatus mCurrentStatus;

@property (nonatomic , strong) NSTimer* mAnimationTimer;
@property (nonatomic , strong) UIImageView* mImageView;
@property (nonatomic , strong) UIImageView* mColorImageView;

@end


@implementation AnimationFireworksView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSMutableArray* imagesArr = [NSMutableArray array];
    UIImage* sourceImage = [UIImage imageNamed:@"gift_fireworks_1"];
    CGSize sourceSize = sourceImage.size;
    long imagesNum = 10;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        [imagesArr addObject:tmp];
    }
    self.mImagesArray = imagesArr;
    
    // COLOR
    imagesArr = [NSMutableArray array];
    sourceImage = [UIImage imageNamed:@"gift_fireworks_2"];
    sourceSize = sourceImage.size;
    imagesNum = 4;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        [imagesArr addObject:tmp];
    }
    self.mColorImagesArray = imagesArr;
    
    self.mCurrentFarme = 0;
    
    self.mCurrentStatus = LYAnimationNotStart;
    
    self.mImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mImageView];
    
    return self;
}

- (void)play {
    if (self.mCurrentStatus == LYAnimationNotStart || self.mCurrentStatus == LYAnimationEnd) {
        self.mAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(onPlayNext) userInfo:nil repeats:YES];
        
        self.mCurrentFarme = 0;
        
        self.mCurrentStatus = LYAnimationPlaying;
    }
    else {
        NSLog(@"正在播放");
    }
}

- (void)onPlayNext {
    if (self.mCurrentFarme >= self.mImagesArray.count) {
        [self.mAnimationTimer invalidate];
        self.mAnimationTimer = nil;
        self.mCurrentStatus = LYAnimationEnd;
        [self playColorFireworks];
        return ;
    }
    
    [self.mImageView setImage:[self.mImagesArray objectAtIndex:self.mCurrentFarme]];
    ++self.mCurrentFarme;
}

- (void)playColorFireworks {
    UIImageView* mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.mColorImageView = mImageView;
    [self addSubview:mImageView];
    mImageView.backgroundColor = [UIColor clearColor];
    CAShapeLayer* circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor clearColor].CGColor;//这个必须透明，因为这样内圆才是不透明的
    circleLayer.strokeColor = [UIColor yellowColor].CGColor;//注意这个不能透明，因为实际上是这个显示出后面的图片了
    circleLayer.path = [self pathWithDiameter:1 uiview:mImageView].CGPath;
    mImageView.layer.mask = circleLayer;
    
    //让圆的变大的动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    UIBezierPath *toPath = [self pathWithDiameter: sqrt(CGRectGetWidth(mImageView.bounds)*CGRectGetWidth(mImageView.bounds) + CGRectGetHeight(mImageView.bounds) *CGRectGetHeight(mImageView.bounds)) uiview:mImageView];
    pathAnimation.toValue = (id)toPath.CGPath;
    pathAnimation.duration = 1.0;
    
    
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.toValue = @(sqrt(CGRectGetWidth(mImageView.bounds)*CGRectGetWidth(mImageView.bounds) + CGRectGetHeight(mImageView.bounds) *CGRectGetHeight(mImageView.bounds)));
    lineWidthAnimation.duration = 1.0;
    

    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    scaleAnimation.fromValue = @(0.5);
    scaleAnimation.toValue = @(2.0);
    scaleAnimation.duration = 1.0;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[pathAnimation, lineWidthAnimation, scaleAnimation];
    group.duration = 2.0;
    group.removedOnCompletion = NO;//这两句的效果是让动画结束后不会回到原处，必须加
    group.fillMode = kCAFillModeForwards;//这两句的效果是让动画结束后不会回到原处，必须加
    group.delegate = self;
    
    
    [circleLayer addAnimation:group forKey:@"revealAnimation"];
    

    [mImageView setImage:[self.mColorImagesArray objectAtIndex:LYAnimationFireworksRed]];
    
//    mImageView.alpha = 0.5;
//    mImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    [UIView animateWithDuration:1.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        mImageView.alpha = 1.0;
//        mImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
//    } completion:^(BOOL finished) {
//        [mImageView setImage:nil];
//    }];
    
}


/**
 *  根据直径生成圆的path，注意圆点是self的中心点，所以（x，y）不是（0，0）
 */
- (UIBezierPath *)pathWithDiameter:(CGFloat)diameter uiview:(UIView *)uiview {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake((CGRectGetWidth(uiview.bounds) - diameter) / 2, (CGRectGetHeight(uiview.bounds) - diameter) / 2, diameter, diameter)];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.mColorImageView setImage:nil];
    [self.mImageView setImage:nil];
    [self.mColorImageView removeFromSuperview];
    NSLog(@"end");
}
@end
