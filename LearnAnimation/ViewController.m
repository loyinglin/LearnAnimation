//
//  ViewController.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"
#import "AnimationFireworksView.h"
#import "AnimationBoatView.h"
#import "AnimationManager.h"

@interface ViewController ()

@property (nonatomic , strong) IBOutlet UIImageView* myImageView;
@property (nonatomic , strong) IBOutlet UIImageView* mBounceImageView;

@property (nonatomic , strong) IBOutlet AnimationBoatView* mAnimationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onKeyFrameAnimation:(id)sender {
    [[AnimationManager instance] startAnimationWithView:self.mAnimationView Type:LYAnimationFireworks];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 200, CGRectGetWidth(self.view.bounds), 200)];
    [self.view addSubview:view];
    [[AnimationManager instance] startAnimationWithView:view Type:LYAnimationBoat];
}


@end
