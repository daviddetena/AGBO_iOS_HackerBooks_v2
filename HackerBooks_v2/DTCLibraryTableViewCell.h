//
//  DTCLibraryTableViewCell.h
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCBook;

@interface DTCLibraryTableViewCell : UITableViewCell

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

+(CGFloat) height;
+(NSString *)cellId;

#pragma mark - Actions
- (IBAction)didToggleFavoriteState:(id)sender;

-(void) observeBook:(DTCBook*) book;

-(void) cleanUp;


@end
