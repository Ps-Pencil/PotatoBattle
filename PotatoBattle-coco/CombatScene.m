//
//  CombatScene.m
//  PotatoBattle-coco
//
//  Created by pspencil on 7/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import "CombatScene.h"
#import "AIScene.h"
#import "PlayScene.h"
@implementation CombatScene

+ (CCScene *) sceneWithParameters: (NSMutableArray *)positions andHits:(NSMutableArray *)hits andOtherPositions: (NSMutableArray* )otherPositions andOtherHits: (NSMutableArray*) otherHits
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CombatScene *layer = [[[CombatScene alloc]initWithData:positions andHits:hits andOtherPositions:otherPositions andOtherHits: otherHits] autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) initWithData: (NSMutableArray *)positions andHits:(NSMutableArray *)hits andOtherPositions: (NSMutableArray *)otherPositions andOtherHits: (NSMutableArray*) otherHits{
    
    if((self = [super initWithColor:ccc4(255, 255, 255,255)]))
    {
        
        numOfHits = 0;
        
        prev = hits;
        rects = positions;
        otherpos = otherPositions;
        otherhits = otherHits;
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        map.position = ccp(size.width / 2.0f , size.height / 2.0f);
        [self addChild:map z:0 tag:0];
        /*
        CCSprite* turn = [CCSprite spriteWithFile:@"sun.png"];
        turn.position = ccp(size.width / 2.0f, map.position.y + map.boundingBox.size.height / 2.0f + turn.boundingBox.size.height / 2.0f + 5);
        [self addChild:turn];
        */
        cellCover = [CCSprite spriteWithFile:@"cellCover.png"];
        cellCover.visible = NO;
        [self addChild:cellCover z:1];
        
        CCSprite* go = [CCSprite spriteWithFile:@"go.png"];
        CCSprite* goSelected = [CCSprite spriteWithFile:@"go.png"];
        goSelected.color = ccc3(22, 160, 181);
        CCSprite* restart = [CCSprite spriteWithFile:@"restart.png"];
        
        CCSprite* restartSelected= [CCSprite spriteWithFile:@"restart.png"];
        restartSelected.color = ccc3(192, 57, 43);
        
        //go.position = ccp(size.width/2.0f, (map.position.y - map.boundingBox.size.height / 2.0f) / 2.0f + 20.0);
        
        
        CCMenuItemSprite* restartBtn = [CCMenuItemSprite itemWithNormalSprite:restart selectedSprite:restartSelected block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[PlayScene scene]];
        }];
        
        restartBtn.anchorPoint = ccp(0.5,0.5);
        restartBtn.scale = size.height * 0.08 / restartBtn.boundingBox.size.height;
        restartBtn.position = ccp(size.width/4.0f, (map.position.y - map.boundingBox.size.height / 2.0f ) / 2.0f + 20.0);
        
        CCLabelTTF* backText = [CCLabelTTF labelWithString:@"Restart" fontName:@"Lato-Light" fontSize:19];
        backText.position = ccp(restartBtn.position.x,restartBtn.position.y - restartBtn.boundingBox.size.height / 2.0f - 20.0f);
        backText.color = ccc3(145, 165, 166);
        [self addChild:backText z:3];

        
        goBtn = [CCMenuItemSprite itemWithNormalSprite:go selectedSprite:goSelected target:self selector:@selector(Go)];
        goBtn.visible = NO;
        goBtn.anchorPoint = ccp(0.5,0.5);
        goBtn.position = ccp(size.width/4.0f * 3.0f, restartBtn.position.y);
        goBtn.scale = restartBtn.scale;
        
        proceedText = [CCLabelTTF labelWithString:@"Go" fontName:@"Lato-Light" fontSize:19];
        proceedText.position = ccp(goBtn.position.x,goBtn.position.y - goBtn.boundingBox.size.height / 2.0f - 20.0f);
        proceedText.color = ccc3(145, 165, 166);
        proceedText.visible = NO;
        [self addChild:proceedText z:3];

        CCMenu* back = [CCMenu menuWithItems:restartBtn,goBtn, nil];
        back.anchorPoint = ccp(0, 0);
        back.position = ccp(0, 0);
        [self addChild:back z:3];

        
        //hit position
        for(int i = 0 ; i < [prev count] ; i ++){
            bool success = false;
            for(int j = 0 ; j < 5 ; j ++)
            {
                if(CGRectContainsPoint([rects[j] CGRectValue], [prev[i] CGPointValue]))
                {
                    success = true;
                    break;
                }
            }
            CCSprite* hit;
            if(success){
                numOfHits ++;
                hit = [CCSprite spriteWithFile:@"success2.png"];
                hit.position = [prev[i] CGPointValue];
                int x = (int) ((hit.position.x - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.x) / (map.boundingBox.size.width / 10.0f ));
                int y = (int) ((hit.position.y - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.y) / (map.boundingBox.size.width / 10.0f ));
              //  state[x][y] = 2; //successful hit
            }
            else{
                hit = [CCSprite spriteWithFile:@"fired.png"];
                hit.position = [prev[i] CGPointValue];
                int x = (int) ((hit.position.x - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.x) / (map.boundingBox.size.width / 10.0f ));
                int y = (int) ((hit.position.y - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.y) / (map.boundingBox.size.width / 10.0f ));
              //  state[x][y] = 1; //unsuccessful hit
            }
            [self addChild:hit];
            
        }
        int name[10];
        name[2] = 5;
        name[3] = 3;
        name[4] = 2;
        name[5] = 1;
        for(int i = 0 ; i < 5 ; i ++){
            CGRect box = [positions[i] CGRectValue];
            float length = [positions[i] CGRectValue].size.width > [positions[i] CGRectValue].size.height ? [positions[i] CGRectValue].size.width : [positions[i] CGRectValue].size.height;
            int x = (int) (length / (map.boundingBox.size.width / 10.0f));
            CCSprite* rect = [CCSprite spriteWithFile:[NSString stringWithFormat:@"potato%d_shade.png",name[x]]];
            rect.anchorPoint = ccp(0.5,0.5);
            rect.position = ccp(box.origin.x+box.size.width / 2.0f, box.origin.y+box.size.height/2.0f);
            if (box.size.width > box.size.height) {
                rect.rotation = 90;
            }
            
            int counter = 0;
            for(int j = 0 ; j < [prev count] ; j ++)
                if (CGRectContainsPoint(rect.boundingBox,[prev[j] CGPointValue])) {
                    counter++;
                }
            if (counter == x) {
                [self addChild:rect z:0];

            }
            
        }

        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        map.position = ccp(map.position.x, map.position.y + 20.0);
        
        float margin = (size.width - map.boundingBox.size.width ) / 2.0f;
        CCSprite* topBar2 = [CCSprite spriteWithFile:@"button.png"];
        topBar2.scaleX = size.width / topBar2.boundingBox.size.width;
        topBar2.scaleY =topBar2.scaleY = (size.height - (map.position.y + map.boundingBox.size.height/2.0f + margin) - 20) / topBar2.boundingBox.size.height;
        topBar2.color = ccc3(255, 255,255);
        topBar2.position = ccp(topBar2.boundingBox.size.width/2.0f, map.boundingBox.size.height / 2.0f + map.position.y + margin + topBar2.boundingBox.size.height / 2.0f + 10);
        CCLabelTTF* turn = [CCLabelTTF labelWithString:@"Your Turn" fontName:@"Lato-Light" fontSize:30];
        turn.color = ccc3(145, 165, 166);
        turn.position = ccp(topBar2.position.x,topBar2.position.y - 10.0);
        [self addChild:turn];

    }
    return self;
}
-(CGPoint) boundPos:(CGPoint)newPos{
    CCSprite* map = (CCSprite *)[self getChildByTag:0];
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, map.position.x - [map boundingBox].size.width / 2.0f + [cellCover boundingBox].size.width / 2.0f);
    retval.x = MIN(retval.x, map.position.x + [map boundingBox].size.width / 2.0f - [cellCover boundingBox].size.width / 2.0f);
    retval.y = MAX(retval.y, map.position.y - [map boundingBox].size.height / 2.0f + [cellCover boundingBox].size.height / 2.0f);
    retval.y = MIN(retval.y, map.position.y + [map boundingBox].size.height / 2.0f - [cellCover boundingBox].size.height / 2.0f);
    return retval;
    
}
-(void) panForTranslation: (CGPoint)translation lastTouch: (CGPoint) touchLocation{
        CGPoint newPos = ccpAdd(cellCover.position, translation);
        cellCover.position = newPos;
        
        
        float x,y;
        CCSprite *map = (CCSprite *)[self getChildByTag:0];
        for(int i = 0; i < 10 ; i++){
            x = map.position.x - map.boundingBox.size.width / 2.0f + cellCover.boundingBox.size.width / 2.0f + i * map.boundingBox.size.width / 10.0f;
            if(fabs(touchLocation.x - x) <= map.boundingBox.size.width / 20.0f)
            {
               // CCLOG(@"x: %d\n",i);
                break;
            }
        }
        for(int i = 0; i < 10 ; i++){
            y = map.position.y - map.boundingBox.size.height / 2.0f + cellCover.boundingBox.size.height / 2.0f + i * map.boundingBox.size.height / 10.0f;
            if(fabs(touchLocation.y - y) <= map.boundingBox.size.height / 20.0f)
            {
               // CCLOG(@"y: %d\n",i);
                break;
            }
        }
    CGPoint position = ccp(x,y);
    cellCover.position = [self boundPos:position];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
        
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if(cellCover.visible == YES && CGRectContainsPoint(cellCover.boundingBox, touchLocation)){
        [self proceedWithHit:cellCover.position];
    }
    else{
    cellCover.visible = YES;
    cellCover.position = touchLocation;
    [self panForTranslation:ccp(0,0) lastTouch:touchLocation];
    }
    return TRUE;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation lastTouch:touchLocation];
    CCLOG(@"%f %f",cellCover.position.x, cellCover.position.y);
    
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if ([self Check]) {
        goBtn.visible = YES;
        proceedText.visible = YES;
    }
    else{
        goBtn.visible = NO;
        proceedText.visible = NO;
    }
}
-(BOOL) Check{
    if (cellCover.visible == NO) {
        return FALSE;
    }
    else{
        for (int i = 0 ; i < [prev count]; i++) {
            if (CGPointEqualToPoint([prev[i] CGPointValue] ,cellCover.position) ){
                
                return false;
                break;
            }
        }
    }
    return true;
}
-(void)proceedWithHit: (CGPoint) hit
{
    bool ok = true;
    for (int i = 0 ; i < [prev count]; i++) {
        if (CGPointEqualToPoint([prev[i] CGPointValue] ,hit) ){
            //do something to notify?
            ok = false;
            break;
        }
    }
    if (ok) {
        [[[CCDirector sharedDirector] touchDispatcher] removeAllDelegates];
        bool success = false;
        CGRect target;
        for (int i = 0 ; i < [rects count]; i++) {
            if (CGRectContainsPoint([rects[i] CGRectValue], hit)) {
                success = true;
                target = [rects[i] CGRectValue];
                break;
            }
        }
        if(!success){
            CCSprite* fire = [CCSprite spriteWithFile:@"fired.png"];
            fire.position = hit;
            [self addChild: fire z:2];
            id fadein = [CCFadeIn actionWithDuration:1.0];
            [fire runAction:fadein];
        }
        else{
            
            CCSprite* fire = [CCSprite spriteWithFile:@"success2.png"];
            fire.position = hit;
            [self addChild: fire z:2];
            id fadein = [CCFadeIn actionWithDuration:1.0];
            
            numOfHits++;
            CCSprite* map = (CCSprite*)[self getChildByTag:0];
            int name[10];
            name[2] = 5;
            name[3] = 3;
            name[4] = 2;
            name[5] = 1;
            
            CGRect box = target;
                float length = box.size.width > box.size.height ? box.size.width : box.size.height;
                int x = (int) (length / (map.boundingBox.size.width / 10.0f));
                CCSprite* rect = [CCSprite spriteWithFile:[NSString stringWithFormat:@"potato%d_shade.png",name[x]]];
                rect.anchorPoint = ccp(0.5,0.5);
                rect.position = ccp(box.origin.x+box.size.width / 2.0f, box.origin.y+box.size.height/2.0f);
                if (box.size.width > box.size.height) {
                    rect.rotation = 90;
                }
                
                int counter = 1;
                for(int j = 0 ; j < [prev count] ; j ++)
                    if (CGRectContainsPoint(rect.boundingBox,[prev[j] CGPointValue])) {
                        counter++;
                    }
            CCLOG(@"counter: %d\n",counter);
                if (counter == x) {
                    
                    [self addChild:rect z:2];
                    
                
                
            }
            [fire runAction:fadein];
            

        }
        
    [prev addObject:[NSValue valueWithCGPoint:hit]];
        
        id delay = [CCDelayTime actionWithDuration:1.0];
        id sceneTransit = [CCCallFunc actionWithTarget:self selector:@selector(transit)];
        
        [self runAction:[CCSequence actions:delay,sceneTransit, nil]];
        
        
   //         [[CCDirector sharedDirector] replaceScene:[AIScene sceneWithPositions:otherpos andHits:otherhits andOtherPositions: rects andOtherHits: prev]];
    }

}
-(void) Go{
    [self proceedWithHit:cellCover.position];
}
- (void) transit{
    if (numOfHits == 17) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:2.0 scene:[Result sceneWithWords:@"You Win!"]]];
    }
    else
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[AIScene sceneWithPositions:otherpos andHits:otherhits andOtherPositions: rects andOtherHits: prev]]];
}
-(void) dealloc{
    CCLOG(@"DEA");
    [super dealloc];
}
-(void) onExit{
    CCLOG(@"EXIT");
   // [self removeAllChildrenWithCleanup:YES];
    [super onExit];
}
@end
