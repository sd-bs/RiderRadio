//
//  HomeViewController.m
//  RiderRadio
//
//  Created by Fabien Moussavi on 05/09/13.
//  Copyright (c) 2013 Fabien Moussavi. All rights reserved.
//


#import "HomeViewController.h"
#import "SectionCell.h"
#import "Parallax.h"
#import "FluxIsDownViewController.h"


@interface HomeViewController ()
@end

@implementation HomeViewController
///////////////////
#pragma mark - Init
//====================================================================================================//
//                                              INIT                                                  //
//====================================================================================================//
//**/
- (id)init
{
    self = [super init];
    if (self) {
        // Section Array
        self.section_Array = [NSArray arrayWithObjects:
                              NSLocalizedString(@"On_air", @""),
                              NSLocalizedString(@"Mixes", @""),
                              NSLocalizedString(@"Replays", @""),
                              NSLocalizedString(@"Fresh_news", @""),
                              NSLocalizedString(@"Infos", @""),
                              nil];
        
        // Error Message
        self.isErrorMsgFirstLaunch = YES;
    }
    return self;
}


/////////////////////////////
#pragma mark - View lifecycle
//====================================================================================================//
//                                            LIFECYCLE                                               //
//====================================================================================================//
//**/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the NavBar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Parallax effect on the top button
    [Parallax registerEffectForView:self.topImage_Imv withDepth:20];
    
    // Player
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:URL_RIDER_RADIO_STREAMING_FLUX_WINAMP]];
    [self.player setMovieSourceType:MPMovieSourceTypeStreaming];
    [self.player.view setHidden:YES];
    [self.view addSubview:self.player.view];
    [self.player play];
    
    // Check if there is a problem on the RiderRadio flux
    [self checkIfFluxIsDown]; // Comment this method call just during development
}

//**/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    // Resize the tableView content inset
    [self.tableView setContentInset:UIEdgeInsetsMake(0.f, 0.f, self.tableView.frame.size.height - 70.f, 0.f)];
}

//**/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Display a modal view if there is a problem on the RiderRadio flux on the first launch only
    if (self.isErrorMsgFirstLaunch) {
        self.isErrorMsgFirstLaunch = NO;
        [self displayErrorFluxMessage];
    }
}


///////////////////////
#pragma mark - IBAction
//====================================================================================================//
//                                            IBAction                                                //
//====================================================================================================//
//**/
- (IBAction)topButtonAction:(UIButton *)button
{
    [self pushSection:button.tag];
}


/////////////////////
#pragma mark - Method
//====================================================================================================//
//                                             Method                                                 //
//====================================================================================================//
//**/ Check if there is a error message about the flux from the serveur
- (void)checkIfFluxIsDown
{
    // It's retina display
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        // It's iPhone 5
        if ([[UIScreen mainScreen] bounds].size.height > 460) {
            self.errorFluxMessageURL_Str = [NSString stringWithFormat:@"%@%@%@-568h@2x%@", URL_RIDER_RADIO_ERROR_MESSAGE_FLUX, URL_RIDER_RADIO_ERROR_MSG_IMG_NAME, [[NSLocale preferredLanguages] objectAtIndex:0], URL_RIDER_RADIO_ERROR_MSG_IMG_EXT];
        }
        // It's iPhone 4 or 4s
        else {
            self.errorFluxMessageURL_Str  = [NSString stringWithFormat:@"%@%@%@@2x%@", URL_RIDER_RADIO_ERROR_MESSAGE_FLUX, URL_RIDER_RADIO_ERROR_MSG_IMG_NAME, [[NSLocale preferredLanguages] objectAtIndex:0], URL_RIDER_RADIO_ERROR_MSG_IMG_EXT];
        }
    }
    // It's normal display
    else {
        self.errorFluxMessageURL_Str  = [NSString stringWithFormat:@"%@%@%@%@", URL_RIDER_RADIO_ERROR_MESSAGE_FLUX, URL_RIDER_RADIO_ERROR_MSG_IMG_NAME, [[NSLocale preferredLanguages] objectAtIndex:0], URL_RIDER_RADIO_ERROR_MSG_IMG_EXT];
    }
}

//**/ Display a modal view if there is a problem on the RiderRadio flux
- (void)displayErrorFluxMessage
{
    // Security check on string
    if (self.errorFluxMessageURL_Str) {
        self.errorFluxMessage_Img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.errorFluxMessageURL_Str]]];
        
        // Display modal if the error message image has been successfully downloaded
        if (self.errorFluxMessage_Img) {
            [self presentViewController:[[FluxIsDownViewController alloc] initWithImage:self.errorFluxMessage_Img] animated:YES completion:NULL];
        }
    }
}

//**/
- (void)pushSection:(int)sectionIndex
{
    switch (sectionIndex) {
        case On_Air:
        {
            // Display an error message if there is a problem on the RiderRadio flux
            if (self.errorFluxMessage_Img) {
                [self presentViewController:[[FluxIsDownViewController alloc] initWithImage:self.errorFluxMessage_Img] animated:YES completion:NULL];
            }
            // No problem: normal case
            else {
                OnAirViewController *onAirVC = [[OnAirViewController alloc] init];
                [onAirVC setPlayer:self.player];
                [self.navigationController pushViewController:onAirVC animated:YES];
            }
            break;
        }
            
        case Mixes:
        {
            MixesViewController *mixesVC = [[MixesViewController alloc] init];
            [mixesVC setPlayer:self.player];
            [self.navigationController pushViewController:mixesVC animated:YES];
            break;
        }
            
        case Replays:
        {
            ReplaysViewController *replaysVC = [[ReplaysViewController alloc] init];
            [replaysVC setPlayer:self.player];
            [self.navigationController pushViewController:replaysVC animated:YES];
            break;
        }
            
        case Fresh_news:
        {
            FreshnewsViewController *freshnewsVC = [[FreshnewsViewController alloc] init];
            [freshnewsVC setPlayer:self.player];
            [self.navigationController pushViewController:freshnewsVC animated:YES];
            break;
        }
            
        case Infos:
            [self.navigationController pushViewController:[[InfosViewController alloc] init] animated:YES];
            break;
    }
}


///////////////////////////////////
#pragma mark - UITableView Delegate
//====================================================================================================//
//                                       UITableView Delegate                                         //
//====================================================================================================//
//**/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

//**/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.section_Array && 0 < self.section_Array.count) {
        return self.section_Array.count;
    }
    return 0;
}

//**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SectionCell";
    
    SectionCell *cell;
    if (self.section_Array && 0 < self.section_Array.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[SectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        // Fill the cell
        [cell.sectionName_Lbl setText:[self.section_Array objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
            case On_Air:
                [cell.background_View setBackgroundColor:colorDarkGrey];
                [cell.sectionIcon_Imv setImage:[UIImage imageNamed:@"cell_icon_OnAir"]];
                break;
                
            case Mixes:
                [cell.background_View setBackgroundColor:colorBurgundy];
                [cell.sectionIcon_Imv setImage:[UIImage imageNamed:@"cell_icon_Mixes"]];
                break;
                
            case Replays:
                [cell.background_View setBackgroundColor:colorAniseGreen];
                [cell.sectionIcon_Imv setImage:[UIImage imageNamed:@"cell_icon_Replays"]];
                break;
                
            case Fresh_news:
                [cell.background_View setBackgroundColor:colorGold];
                [cell.sectionIcon_Imv setImage:[UIImage imageNamed:@"cell_icon_Freshnews"]];
                break;
                
            case Infos:
                [cell.background_View setBackgroundColor:colorGrey];
                [cell.sectionIcon_Imv setImage:[UIImage imageNamed:@"cell_icon_Infos"]];
                break;
        }
    }
    
    return cell;
}

//**/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.section_Array && 0 < self.section_Array.count)
        [self pushSection:indexPath.row];
}

//**/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch ([self.tableView indexPathForRowAtPoint:scrollView.contentOffset].row) {
        case On_Air:
            [self.topImage_Btn setTag:On_Air];
            [self.topImage_Btn setBackgroundColor:colorDarkGrey];
            [self.topImage_Imv setImage:[UIImage imageNamed:@"btn_OnAir"]];
            break;
            
        case Mixes:
            [self.topImage_Btn setTag:Mixes];
            [self.topImage_Btn setBackgroundColor:colorBurgundy];
            [self.topImage_Imv setImage:[UIImage imageNamed:@"btn_Mixes"]];
            break;
            
        case Replays:
            [self.topImage_Btn setTag:Replays];
            [self.topImage_Btn setBackgroundColor:colorAniseGreen];
            [self.topImage_Imv setImage:[UIImage imageNamed:@"btn_Replays"]];
            break;
            
        case Fresh_news:
            [self.topImage_Btn setTag:Fresh_news];
            [self.topImage_Btn setBackgroundColor:colorGold];
            [self.topImage_Imv setImage:[UIImage imageNamed:@"btn_Freshnews"]];
            break;
            
        case Infos:
            [self.topImage_Btn setTag:Infos];
            [self.topImage_Btn setBackgroundColor:colorGrey];
            [self.topImage_Imv setImage:[UIImage imageNamed:@"btn_Infos"]];
            break;
            
        default:
            [self.topImage_Btn setTag:0];
            [self.topImage_Btn setBackgroundColor:[UIColor blackColor]];
            [self.topImage_Imv setImage:nil];
            break;
    }
}

//**/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self adjustScrollingPosition:scrollView];
}

//**/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustScrollingPosition:scrollView];
}

//**/
- (void)adjustScrollingPosition:(UIScrollView *)scrollView
{
//    NSLog(@"Adjust: %f", scrollView.contentOffset.y);
//    NSLog(@"Row: %d", [self.tableView indexPathForRowAtPoint:scrollView.contentOffset].row);
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForRowAtPoint:scrollView.contentOffset] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollView.contentOffset.y / 70 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


/////////////////////
#pragma mark - Memory
//====================================================================================================//
//                                              MEMORY                                                //
//====================================================================================================//
//**/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

