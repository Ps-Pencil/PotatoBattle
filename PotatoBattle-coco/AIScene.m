//
//  AIScene.m
//  PotatoBattle-coco
//
//  Created by pspencil on 16/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import "AIScene.h"
#import "CombatScene.h"
int state[10][10];

@implementation AIScene
+(CCScene*) sceneWithPositions: (NSMutableArray* ) positions andHits: (NSMutableArray*) hits andOtherPositions:(NSMutableArray*) otherPositions andOtherHits: (NSMutableArray*)otherHits
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AIScene *layer = [[[AIScene alloc]initWithPositions:positions andHits:hits andOtherPositions:otherPositions andOtherHits: otherHits]autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}
- (id) initWithPositions: (NSMutableArray* ) positions andHits: (NSMutableArray*) hits andOtherPositions: (NSMutableArray*)otherPositions andOtherHits: (NSMutableArray*)otherHits
{
    if((self = [super initWithColor:ccc4(255, 255, 255, 255)]))
    {
        numOfHits = 0;
        CCLOG(@"%d %d", [hits count], otherHits.count);
        Positions = positions;
        Hits = hits;
        OtherPositions = otherPositions;
        OtherHits = otherHits;
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        map.position = ccp(size.width / 2.0f , size.height / 2.0f);
        [self addChild:map z:0 tag:0];
        int name[10];
        name[2] = 5;
        name[3] = 3;
        name[4] = 2;
        name[5] = 1;
        for(int i = 0 ; i < 5 ; i ++){
            CGRect box = [Positions[i] CGRectValue];
            float length = [Positions[i] CGRectValue].size.width > [Positions[i] CGRectValue].size.height ? [Positions[i] CGRectValue].size.width : [Positions[i] CGRectValue].size.height;
            int x = (int) (length / (map.boundingBox.size.width / 10.0f));
            CCSprite* rect = [CCSprite spriteWithFile:[NSString stringWithFormat:@"potato%d_shade.png",name[x]]];
            rect.anchorPoint = ccp(0.5,0.5);
            rect.position = ccp(box.origin.x+box.size.width / 2.0f, box.origin.y+box.size.height/2.0f);
            if (box.size.width > box.size.height) {
                rect.rotation = 90;
            }
            [self addChild:rect z:0];
        }
        
        
        /*
        CCSprite* turn = [CCSprite spriteWithFile:@"moon.png"];
        turn.position = ccp(size.width / 2.0f, map.position.y + map.boundingBox.size.height / 2.0f + turn.boundingBox.size.height / 2.0f + 5);
        [self addChild:turn];
        */
        CCMenuItemFont* backBtn = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:1.0 scene:[CombatScene sceneWithParameters:OtherPositions andHits:OtherHits andOtherPositions: Positions andOtherHits: Hits]]];
        }];
        CCMenu* back = [CCMenu menuWithItems:backBtn, nil];
        back.position = ccp(size.width / 2.0f, 20);
        [self addChild:back];
        
        
        
                      for(int i = 0 ; i < 10 ; i ++)
            for( int j = 0 ; j < 10 ; j ++)
                state[i][j] = 0;
        //hit position
        for(int i = 0 ; i < [Hits count] ; i ++){
            bool success = false;
            for(int j = 0 ; j < 5 ; j ++)
            {
                if(CGRectContainsPoint([Positions[j] CGRectValue], [Hits[i] CGPointValue]))
                {
                    success = true;
                    break;
                }
            }
            CCSprite* hit;
            if(success){
                numOfHits++;
                hit = [CCSprite spriteWithFile:@"success.png"];
                hit.position = [Hits[i] CGPointValue];
                int x = (int) ((hit.position.x - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.x) / (map.boundingBox.size.width / 10.0f ));
                int y = (int) ((hit.position.y - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.y) / (map.boundingBox.size.width / 10.0f ));
                state[x][y] = 2; //successful hit
            }
            else{
                hit = [CCSprite spriteWithFile:@"fired.png"];
                hit.position = [Hits[i] CGPointValue];
                int x = (int) ((hit.position.x - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.x) / (map.boundingBox.size.width / 10.0f ));
                int y = (int) ((hit.position.y - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.y) / (map.boundingBox.size.width / 10.0f ));
                state[x][y] = 1; //unsuccessful hit
            }
            [self addChild:hit];
        }
        float margin = (size.width - map.boundingBox.size.width ) / 2.0f;
        CCSprite* topBar2 = [CCSprite spriteWithFile:@"button.png"];
        topBar2.scaleX = size.width / topBar2.boundingBox.size.width;
        topBar2.scaleY =topBar2.scaleY = (size.height - (map.position.y + map.boundingBox.size.height/2.0f + margin) - 20) / topBar2.boundingBox.size.height;
        topBar2.color = ccc3(255, 255,255);
        topBar2.position = ccp(topBar2.boundingBox.size.width/2.0f, map.boundingBox.size.height / 2.0f + map.position.y + margin + topBar2.boundingBox.size.height / 2.0f + 10);
        CCLabelTTF* turn = [CCLabelTTF labelWithString:@"Opponent's Turn" fontName:@"Lato-Light" fontSize:30];
        turn.color = ccc3(145, 165, 166);
        turn.position = ccp(topBar2.position.x,topBar2.position.y - 10.0);
        [self addChild:turn];
        
        map.position = ccp(map.position.x, map.position.y + 20.0);
    }
    return self;
}

-(void)onEnterTransitionDidFinish{

    
    CCSprite* map = (CCSprite*)[self getChildByTag:0];

    int x = -1,y = -1;
    
    for(int i = 0 ; i < 10&&x==-1 ; i ++){
        for(int j=0;j<10;j++)
        {
            if(state[i][j] == 2)
            {
                if(i!=0 && state[i-1][j]==0)
                {
                    x = i-1;
                    y = j;
                    break;
                }
                if(i!=9 && state[i+1][j]==0)
                {
                    x = i+1;
                    y = j;
                    break;
                }
                if(j!=0 && state[i][j-1] == 0)
                {
                    x = i;
                    y = j-1;
                    break;
                }
                if(j!=9 && state[i][j+1] == 0)
                {
                    x = i;
                    y = j+1;
                    break;
                }
            }
        }
    }
  
    if(x != -1)
    {
        direct = TRUE;
        move = ccp(map.boundingBox.origin.x + x*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f, map.boundingBox.origin.y + y*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f );
    }
    else{
        direct = FALSE;
        move = ccp(map.boundingBox.origin.x + arc4random()%10*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f, map.boundingBox.origin.y + arc4random()%10*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f );
        
        for(int i = 0 ; i < [Hits count] ; i++){
            if(CGPointEqualToPoint(move, [Hits[i] CGPointValue]))
            {
                move = ccp(map.boundingBox.origin.x + arc4random()%10*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f, map.boundingBox.origin.y + arc4random()%10*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f );
                i = -1;
            }
        }
    }
    bool success = false;
    for (int i = 0 ; i < [Positions count]; i++) {
        if (CGRectContainsPoint([Positions[i] CGRectValue], move)) {
            success = true;
            break;
        }
    }
    [Hits addObject:[NSValue valueWithCGPoint:move]];
    id delay = [CCDelayTime actionWithDuration:0.5];
    id transfer = [CCCallFunc actionWithTarget:self selector:@selector(advance)];
    id end = [CCCallFunc actionWithTarget:self selector:@selector(check)];
    id AIM = [CCCallFunc actionWithTarget:self selector:@selector(aimAction)];

    
    if(!success){
        
        CCSprite* fire = [CCSprite spriteWithFile:@"fired.png"];
        fire.position = move;
        fire.opacity = 0;
        [self addChild: fire z:2];
        id fadein = [CCFadeIn actionWithDuration:0.5];
        
                [fire runAction:[CCSequence actions:AIM,[CCDelayTime actionWithDuration:0.8],fadein,delay,transfer, nil]];
    }
    else{
        CCSprite* fire = [CCSprite spriteWithFile:@"success.png"];
        fire.position = move;
        fire.opacity = 0;
        [self addChild: fire z:2];
        id fadein = [CCFadeIn actionWithDuration:0.5];
        
        numOfHits++;
        if(numOfHits == 17)
        [fire runAction:[CCSequence actions:fadein,delay,end, nil]];
        else
            [fire runAction:[CCSequence actions:AIM,[CCDelayTime actionWithDuration:0.8],fadein,delay,transfer, nil]];

        
    }
    CCLOG(@"hits %d", numOfHits);
   
        
    //[self advance];
}

-(void) check{
  //  if (numOfHits == 1) {
       // [self stopAllActions];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:2.0 scene:[Result sceneWithWords:@"You Lose!"]]];
//    }
}
-(void) aimAction{
    CCSprite* aim = [CCSprite spriteWithFile:@"cellCover.png"];
    id moveAim = [CCMoveTo actionWithDuration:0.5 position:[self randomPosition]];
    [self addChild:aim z:5];
    
    id delay = [CCDelayTime actionWithDuration:0.24];
    id toggle = [CCFadeOut actionWithDuration:0.5];
    if(!direct)
    [aim runAction:[CCSequence actions:moveAim,delay,[CCMoveTo actionWithDuration:0.3 position:move],delay,toggle, nil]];
    else
    [aim runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3 position:move],delay,toggle, nil]];

}
-(CGPoint) randomPosition{
    CCSprite* map = (CCSprite*) [self getChildByTag:0];
    CGPoint pos = ccp(map.boundingBox.origin.x + arc4random()%10*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f, map.boundingBox.origin.y + arc4random()%10*map.boundingBox.size.width/10.0f + map.boundingBox.size.width / 20.0f );
    return pos;
}
-(void) advance{
     [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:[CombatScene sceneWithParameters:OtherPositions andHits:OtherHits andOtherPositions: Positions andOtherHits: Hits]]];
    
}

@end
