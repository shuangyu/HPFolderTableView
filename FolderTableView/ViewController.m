//
//  ViewController.m
//  FolderTableView
//
//  Created by Hu, Peng on 11/9/15.
//  Copyright © 2015 Hu, Peng. All rights reserved.
//

#import "ViewController.h"
#import "HPFolderAnimation.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
{
    HPFolderAnimation *_animation;
    NSIndexPath *_selectedIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    _animation = [[HPFolderAnimation alloc] initWithView:self.view];
}


#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"openDetailPage" sender:self];
}

#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    CGRect frame = [_tableView cellForRowAtIndexPath:_selectedIndexPath].frame;
    frame = [_tableView convertRect:frame toView:self.view] ;
    
    switch (operation) {
        case UINavigationControllerOperationPush: {
            _animation.type = HPFolderAnimationPush;
            _animation.anchorFrame = frame;
            return  _animation;
        }
        case UINavigationControllerOperationPop:
        {
            
            _animation.type = HPFolderAnimationPop;
            return _animation;
        }
        default:
            return nil;
    }
}

@end
