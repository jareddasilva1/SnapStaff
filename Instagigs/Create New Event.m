//
//  Create New Event.m
//  Instagigs
//
//  Created by Jerry Phillips on 8/24/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#import "Create New Event.h"
#import "Constants.h"
#import "confirmEventTableViewController.h"

@interface Create_New_Event ()

@end

BOOL moved;

@implementation Create_New_Event

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveContainer) name:MOVECONTENT object:nil] ;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(done) name:DISMISSKEYBOARD object:nil];
   
    confirmEventTableViewController * confirm = [self.childViewControllers lastObject];
    
    confirm.theEvent = _eventObject;
    _container.layer.cornerRadius = 15;
    
   
    
    [_closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)moveContainer
{
    if (moved == YES)
    {
        [UIView animateWithDuration:1.5 animations:^{
            _container.frame = CGRectMake(_container.frame.origin.x, _container.frame.origin.y
                                          + 50, _container.frame.size.width, _container.frame.size.height);
        } completion:^(BOOL finished) {
            moved = NO;
        }];
        
        [UIView animateWithDuration:1.5 animations:^{
            _closeButton.frame = CGRectMake(_closeButton.frame.origin.x, _closeButton.frame.origin.y
                                          + 50, _closeButton.frame.size.width, _closeButton.frame.size.height);
        } completion:nil];

    }
    else
    {
        [UIView animateWithDuration:2.0 animations:^{
            _container.frame = CGRectMake(_container.frame.origin.x, _container.frame.origin.y - 50, _container.frame.size.width, _container.frame.size.height);
        } completion:^(BOOL finished) {
            moved = YES;
        }];
        
        
        [UIView animateWithDuration:1.5 animations:^{
            _closeButton.frame = CGRectMake(_closeButton.frame.origin.x, _closeButton.frame.origin.y
                                            - 50, _closeButton.frame.size.width, _closeButton.frame.size.height);
        } completion:nil];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)done
{
    [self.view endEditing:YES];
}

- (void)closeView:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:DISMISSKEYBOARD];
}
@end
