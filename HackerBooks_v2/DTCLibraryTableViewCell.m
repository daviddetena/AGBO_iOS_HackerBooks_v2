//
//  DTCLibraryTableViewCell.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCLibraryTableViewCell.h"
#import "DTCBook.h"

@interface DTCLibraryTableViewCell()

@property (nonatomic, strong) DTCBook *model;

@end


@implementation DTCLibraryTableViewCell

#pragma mark -  Class Methods
+(CGFloat) height{
    return 94;
}

+(NSString *)cellId{
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) dealloc{
    // baja en notificaciones
    [self removeObserver];
}


#pragma mark - Actions
- (IBAction)didToggleFavoriteState:(id)sender {
    self.model.isFavorite = !self.model.isFavorite;
}


#pragma mark - Notifications

-(void) observeBook:(DTCBook*) book{
    
    self.model = book;
    [self addObserver];
    [self syncWithBook];
}


-(void) addObserver{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // Muy importante, solo nos interesa los cambios en NUESTRO libro!
    [nc addObserver:self
           selector:@selector(syncWithBook)
               name:DTCBOOK_DID_CHANGE_NOTIFICATION
             object:self.model];
}

-(void) removeObserver{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}



#pragma mark -  Sync
-(void) syncWithBook{
    
    // Puede cambiar imagen y favoritos
    [UIView transitionWithView:self.coverView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.coverView.image = self.model.coverImage;
                    } completion:nil];
    
    
    [self syncFavoriteState];
}

- (void) syncFavoriteState{

    if (self.model.isFavorite) {
        self.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite-filled"];
    }
    else{
        self.favoriteButton.imageView.image = [UIImage imageNamed:@"favorite-outline"];
    }
}



#pragma mark - Cleanup
-(void) prepareForReuse{
    [super prepareForReuse];
    
    
    // hacemos limpieza
    [self cleanUp];
}

-(void) cleanUp{
    
    // baja en notificaciones
    [self removeObserver];
    
    self.model = nil;
    self.coverView.image = nil;
    self.titleLabel.text = nil;
    self.authorsLabel.text = nil;
}


@end
