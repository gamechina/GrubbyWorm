//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 7.0+ & iOS 8.0+
//
//  The MIT License (MIT)
//  Copyright (c) 2015 Red Wolf Studio & Yannick Stephan
//  http://www.redwolfstudio.fr
//  http://yannickstephan.com
//  Version 1.5 for Swift 2.0

import Foundation
import GameKit
import SystemConfiguration

/**
TODO List
- REMEMBER report plusieur score  pour plusieur leaderboard  en array
*/


// Protocol Easy Game Center
@objc protocol EasyGameCenterDelegate:NSObjectProtocol {
    /**
    Authentified, Delegate Easy Game Center
    */
    optional func easyGameCenterAuthentified()
    /**
    Not Authentified, Delegate Easy Game Center
    */
    optional func easyGameCenterNotAuthentified()
    /**
    Achievementes in cache, Delegate Easy Game Center
    */
    optional func easyGameCenterInCache()
    /**
    When the match start
    */
    optional func easyGameCenterMatchStarted()
    /**
    Recept data from other player and them
    
    - parameter match:          GKMatch
    - parameter didReceiveData: NSData
    - parameter fromPlayer:     String
    */
    optional func easyGameCenterMatchRecept(match: GKMatch, didReceiveData: NSData, fromPlayer: String)
    /**
    End of match
    */
    optional func easyGameCenterMatchEnded()
    /**
    Cancel match
    */
    optional func easyGameCenterMatchCancel()
}

// MARK: - Public Func
extension EasyGameCenter {
    /**
    CheckUp Connection the new
    
    - returns: Bool Connection Validation
    
    */
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
}

/// Easy Game Center Swift
public class EasyGameCenter: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLocalPlayerListener {
    
    /*####################################################################################################*/
    /*                                    Private    Instance                                             */
    /*####################################################################################################*/
    
    /// Achievements GKAchievement Cache
    private var achievementsCache:[String:GKAchievement] = [String:GKAchievement]()
    
    /// Achievements GKAchievementDescription Cache
    private var achievementsDescriptionCache = [String:GKAchievementDescription]()
    
    /// Save for report late when network working
    private var achievementsCacheShowAfter = [String:String]()
    
    /// When is load
    private var loginIsLoading: Bool = false
    
    /// When is caching
    private var inCacheIsLoading: Bool = false
    
    /// Checkup net and login to GameCenter when have Network
    private var timerNetAndPlayer:NSTimer?
    
    /// Debug mode for see message
    private var debugModeGetSet:Bool = false
    
    /// Actual Match with other players
    var match: GKMatch?
    var playersInMatch = Set<GKPlayer>()
    var invitedPlayer: GKPlayer?
    var invite: GKInvite?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /*####################################################################################################*/
    /*                                    Singleton Public Instance                                       */
    /*####################################################################################################*/
    
    /**
    Static EasyGameCenter
    
    */
    struct Static {
        /// Async EGC
        static var onceToken: dispatch_once_t = 0
        /// Instance of EGC
        static var instance: EasyGameCenter? = nil
        /// Delegate of UIViewController
        static weak var delegate: UIViewController? = nil
    }
    /**
    Start Singleton GameCenter Instance
    
    */
    public class func sharedInstance(delegate:UIViewController)-> EasyGameCenter {
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = EasyGameCenter()
                Static.delegate = delegate
                Static.instance!.loginPlayerToGameCenter()
            }
        }
        return Static.instance!
    }
    /// Delegate UIViewController
    class var delegate: UIViewController {
        get {
            do {
                let delegateInstance = try EasyGameCenter.sharedInstance.getDelegate()
                return delegateInstance
            } catch  {
                errorHandleur(ErrorEGC.NoDelegate)
                fatalError("Dont work\(error)")
            }
        }
        
        set {
            guard newValue != EasyGameCenter.delegate else {
                return
            }
            Static.delegate = EasyGameCenter.delegate
            
            EasyGameCenter.debug("\n[Easy Game Center] New delegate UIViewController is \(_stdlib_getDemangledTypeName(newValue))\n")
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func / Object                                          */
    /*####################################################################################################*/
    
    public class var debugMode:Bool {
        get {
        return EasyGameCenter.sharedInstance.debugModeGetSet
        }
        set {
            EasyGameCenter.sharedInstance.debugModeGetSet = newValue
        }
    }
    /**
    If player is Identified to Game Center
    
    - returns: Bool is identified
    
    */
    class func isPlayerIdentifiedToGameCenter() -> Bool { return GKLocalPlayer.localPlayer().authenticated }
    /**
    Get local player (GKLocalPlayer)
    
    - returns: Bool True is identified
    
    */
    class func getLocalPlayer() -> GKLocalPlayer { return GKLocalPlayer.localPlayer() }
    /**
    Get local player Information (playerID,alias,profilPhoto)
    
    :completion: Tuple of type (playerID:String,alias:String,profilPhoto:UIImage?)
    
    */
    class func getlocalPlayerInformation(completion completionTuple: (playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)?) -> ()) {
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EasyGameCenter.isConnectedToNetwork() else {
                completionTuple(playerInformationTuple: nil)
                EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
                return
            }
            
            guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                completionTuple(playerInformationTuple: nil)
                EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                return
            }
            
            EasyGameCenter.getLocalPlayer().loadPhotoForSize(GKPhotoSizeNormal, withCompletionHandler: {
                (image, error) -> Void in
                
                var playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)
                playerInformationTuple.profilPhoto = nil
                
                playerInformationTuple.playerID = EasyGameCenter.getLocalPlayer().playerID!
                playerInformationTuple.alias = EasyGameCenter.getLocalPlayer().alias!
                if error == nil { playerInformationTuple.profilPhoto = image }
                completionTuple(playerInformationTuple: playerInformationTuple)
            })
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Show                                              */
    /*####################################################################################################*/
    
    /**
    Show Game Center Player Achievements
    
    - parameter completion: Viod just if open Game Center Achievements
    */
    public class func showGameCenterAchievements(completion: ((isShow:Bool) -> Void)? = nil) {
        
        let delegate = EasyGameCenter.delegate as UIViewController
        
        guard EasyGameCenter.isConnectedToNetwork() else {
            if completion != nil { completion!(isShow:false) }
            EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
            return
        }
        
        guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
            if completion != nil { completion!(isShow:false) }
            EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = Static.instance!
        gc.viewState = GKGameCenterViewControllerState.Achievements
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            () -> Void in
            if completion != nil { completion!(isShow:true) }
        })
    }
    /**
    Show Game Center Leaderboard
    
    - parameter leaderboardIdentifier: Leaderboard Identifier
    - parameter completion:            Viod just if open Game Center Leaderboard
    */
    public class func showGameCenterLeaderboard(leaderboardIdentifier leaderboardIdentifier :String, completion: ((isShow:Bool) -> Void)? = nil) {
        
        let delegate = EasyGameCenter.delegate as UIViewController
        let instanceEGC = EasyGameCenter.sharedInstance
        
        var validation:Bool = true
        guard leaderboardIdentifier != "" else {
            EasyGameCenter.errorHandleur(ErrorEGC.Empty)
            validation = false
            // TODO break loginPlayerToGameCenter ont le coupe
            return
        }
        
        guard EasyGameCenter.isConnectedToNetwork() else {
            EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
            validation = false
            return
        }
        
        guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
            EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
            validation = false
            return
        }
        defer {
            if completion != nil && !validation { completion!(isShow:false) }
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = instanceEGC
        gc.leaderboardIdentifier = leaderboardIdentifier
        gc.viewState = GKGameCenterViewControllerState.Leaderboards
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            () -> Void in
            
            if completion != nil { completion!(isShow:true) }
        })
        
    }
    /**
    Show Game Center Challenges
    
    - parameter completion: Viod just if open Game Center Challenges
    
    */
    public class func showGameCenterChallenges(completion: ((isShow:Bool) -> Void)? = nil) {
        
        let delegate = EasyGameCenter.delegate as UIViewController
        let instanceEGC = EasyGameCenter.sharedInstance
        
        guard EasyGameCenter.isConnectedToNetwork() else {
            if completion != nil { completion!(isShow:false) }
            EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
            return
        }
        
        guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
            if completion != nil { completion!(isShow:false) }
            EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate =  instanceEGC
        gc.viewState = GKGameCenterViewControllerState.Challenges
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            () -> Void in
            
            if completion != nil { completion!(isShow:true) }
        })
        
    }
    /**
    Show banner game center
    
    - parameter title:       title
    - parameter description: description
    - parameter completion:  When show message
    
    */
    public class func showCustomBanner(title title:String, description:String,completion: (() -> Void)? = nil) {
        guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
            EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: {
                () -> Void in
                if completion != nil { completion!() }
            })
        }
        
    }
    /**
    Show page Authentication Game Center
    
    - parameter completion: Viod just if open Game Center Authentication
    
    */
    public class func showGameCenterAuthentication(completion: ((result:Bool) -> Void)? = nil) {
        if completion != nil {
            completion!(result: UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!))
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func LeaderBoard                                       */
    /*####################################################################################################*/
    
    /**
    Get Leaderboards
    
    - parameter completion: return [GKLeaderboard] or nil
    
    */
    public class func getGKLeaderboard(completion completion: ((resultArrayGKLeaderboard:Set<GKLeaderboard>?) -> Void)) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EasyGameCenter.isConnectedToNetwork() else {
                completion(resultArrayGKLeaderboard: nil)
                EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
                return
            }
            
            guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                completion(resultArrayGKLeaderboard: nil)
                EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                return
            }
            
            GKLeaderboard.loadLeaderboardsWithCompletionHandler {
                (leaderboards:[GKLeaderboard]?, error:NSError?) ->
                Void in
                
                guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                    completion(resultArrayGKLeaderboard: nil)
                    EasyGameCenter.errorHandleur(ErrorEGC.CantLoadLeaderboards)
                    return
                }
                
                guard let leaderboardsIsArrayGKLeaderboard = leaderboards as [GKLeaderboard]? else {
                    completion(resultArrayGKLeaderboard: nil)
                    EasyGameCenter.errorHandleur(ErrorEGC.CantLoadLeaderboards)
                    return
                }
                
                completion(resultArrayGKLeaderboard: Set(leaderboardsIsArrayGKLeaderboard))
                
            }
        }
    }
    /**
    Reports a  score to Game Center
    
    - parameter The: score Int
    - parameter Leaderboard: identifier
    - parameter completion: (bool) when the score is report to game center or Fail
    
    
    */
    public class func reportScoreLeaderboard(leaderboardIdentifier leaderboardIdentifier:String, score: Int) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EasyGameCenter.isConnectedToNetwork() else {
                EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
                // TODO break loginPlayerToGameCenter ont le coupe
                return
            }
            
            guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                // TODO break loginPlayerToGameCenter ont le coupe
                return
            }
            
            let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier)
            gkScore.value = Int64(score)
            gkScore.shouldSetDefaultLeaderboard = true
            GKScore.reportScores([gkScore], withCompletionHandler: nil)
        }
    }
    /**
    Get High Score for leaderboard identifier
    
    - parameter leaderboardIdentifier: leaderboard ID
    - parameter completion:            Tuple (playerName: String, score: Int, rank: Int)
    
    */
    public class func getHighScore(leaderboardIdentifier leaderboardIdentifier:String, completion:((playerName:String, score:Int,rank:Int)? -> Void)) {
        EasyGameCenter.getGKScoreLeaderboard(leaderboardIdentifier: leaderboardIdentifier, completion: {
            (resultGKScore) -> Void in
            
            guard let valGkscore = resultGKScore else {
                completion(nil)
                return
            }
            
            let rankVal = valGkscore.rank
            let nameVal  = EasyGameCenter.getLocalPlayer().alias!
            let scoreVal  = Int(valGkscore.value)
            completion((playerName: nameVal, score: scoreVal, rank: rankVal))
            
        })
    }
    /**
    Get GKScoreOfLeaderboard
    
    - parameter completion: GKScore or nil
    
    */
    public class func  getGKScoreLeaderboard(leaderboardIdentifier leaderboardIdentifier:String, completion:((resultGKScore:GKScore?) -> Void)) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EasyGameCenter.isConnectedToNetwork() else {
                EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
                completion(resultGKScore: nil)
                return
            }
            
            guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                completion(resultGKScore: nil)
                return
            }
            
            let leaderBoardRequest = GKLeaderboard()
            leaderBoardRequest.identifier = leaderboardIdentifier
            
            leaderBoardRequest.loadScoresWithCompletionHandler {
                (resultGKScore, error) ->Void in
                
                if error != nil || resultGKScore == nil {
                    completion(resultGKScore: nil)
                    
                } else  {
                    completion(resultGKScore: leaderBoardRequest.localPlayerScore)
                }
            }
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Achievements                                      */
    /*####################################################################################################*/
    /**
    Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
    
    - parameter achievementIdentifier: Identifier Achievement
    
    - returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
    
    */
    public class func getTupleGKAchievementAndDescription(achievementIdentifier achievementIdentifier:String,completion completionTuple: ((tupleGKAchievementAndDescription:(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?) -> Void)) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let instanceEGC = EasyGameCenter.sharedInstance
            
            guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                completionTuple(tupleGKAchievementAndDescription: nil)
                return
            }
            
            let achievementGKScore = instanceEGC.achievementsCache[achievementIdentifier]
            let achievementGKDes =  instanceEGC.achievementsDescriptionCache[achievementIdentifier]
            
            if achievementGKScore != nil && achievementGKDes != nil {
                completionTuple(tupleGKAchievementAndDescription: (achievementGKScore!,achievementGKDes!))
            } else {
                if instanceEGC.achievementsCache.count > 0 {
                    EasyGameCenter.debug("\n[EasyGameCenter] Achievements ID not real\n")
                } else {
                    EasyGameCenter.debug("\n[EasyGameCenter] Haven't load cache\n")
                }
                completionTuple(tupleGKAchievementAndDescription: nil)
            }
        }
    }
    /**
    Get Achievement
    
    - parameter identifierAchievement: Identifier achievement
    
    - returns: GKAchievement Or nil if not exist
    
    */
    public class func getAchievementForIndentifier(identifierAchievement identifierAchievement : NSString) -> GKAchievement? {
        if identifierAchievement != "" {
            let instanceEGC = EasyGameCenter.sharedInstance
            guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                return nil
            }
            
            if let achievementFind = instanceEGC.achievementsCache[identifierAchievement as String] {
                return achievementFind
            } else {
                if instanceEGC.achievementsCache.count == 0 {
                    EasyGameCenter.debug("\n[Easy Game Center] Not have cache\n")
                } else {
                    EasyGameCenter.debug("\n[Easy Game Center] Achievement ID \(identifierAchievement) is not real \n")
                }
            }
            
        }
        return nil
    }
    /**
    Add progress to an achievement
    
    - parameter progress:               Progress achievement Double (ex: 10% = 10.00)
    - parameter achievementIdentifier:  Achievement Identifier
    - parameter showBannnerIfCompleted: if you want show banner when now or not when is completed
    - parameter completionIsSend:       Completion if is send to Game Center
    
    */
    public class func reportAchievement( progress progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool = true ,addToExisting: Bool = false) {
        if achievementIdentifier != "" {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                if !EasyGameCenter.isAchievementCompleted(achievementIdentifier: achievementIdentifier) {
                    let instanceEGC = EasyGameCenter.sharedInstance
                    
                    if let achievement = EasyGameCenter.getAchievementForIndentifier(identifierAchievement: achievementIdentifier) {
                        
                        let currentValue = achievement.percentComplete
                        let newProgress: Double = !addToExisting ? progress : progress + currentValue
                        
                        achievement.percentComplete = newProgress
                        
                        /* show banner only if achievement is fully granted (progress is 100%) */
                        if achievement.completed && showBannnerIfCompleted {
                            EasyGameCenter.debug("[Easy Game Center] Achievement \(achievementIdentifier) completed")
                            
                            if EasyGameCenter.isConnectedToNetwork() {
                                achievement.showsCompletionBanner = true
                            } else {
                                //oneAchievement.showsCompletionBanner = true << Bug For not show two banner
                                // Force show Banner when player not have network
                                EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: achievementIdentifier, completion: {
                                    (tupleGKAchievementAndDescription) -> Void in
                                    
                                    if let tupleIsOK = tupleGKAchievementAndDescription {
                                        let title = tupleIsOK.gkAchievementDescription.title
                                        let description = tupleIsOK.gkAchievementDescription.achievedDescription
                                        
                                        EasyGameCenter.showCustomBanner(title: title!, description: description!)
                                    }
                                })
                            }
                        }
                        if  achievement.completed && !showBannnerIfCompleted {
                            instanceEGC.achievementsCacheShowAfter[achievementIdentifier] = achievementIdentifier
                        }
                        instanceEGC.reportAchievementToGameCenter(achievement: achievement)
                    }
                } else {
                    EasyGameCenter.debug("[Easy Game Center] Achievement is already completed")
                }
            }
        }
    }
    /**
    Get GKAchievementDescription
    
    - parameter completion: return array [GKAchievementDescription] or nil
    
    */
    public class func getGKAllAchievementDescription(completion completion: ((arrayGKAD:Set<GKAchievementDescription>?) -> Void)){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let instanceEGC = EasyGameCenter.sharedInstance
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                if instanceEGC.achievementsDescriptionCache.count > 0 {
                    var tempsEnvoi = Set<GKAchievementDescription>()
                    for achievementDes in instanceEGC.achievementsDescriptionCache {
                        tempsEnvoi.insert(achievementDes.1)
                    }
                    completion(arrayGKAD: tempsEnvoi)
                } else {
                    EasyGameCenter.debug("\n[Easy Game Center] Not have cache\n")
                }
            }
        }
    }
    /**
    If achievement is Completed
    
    - parameter Achievement: Identifier
    :return: (Bool) if finished
    
    */
    public class func isAchievementCompleted(achievementIdentifier achievementIdentifier: String) -> Bool{
        if let achievement = EasyGameCenter.getAchievementForIndentifier(identifierAchievement: achievementIdentifier) {
            if achievement.completed || achievement.percentComplete == 100.00 {
                return true
            }
        }
        return false
    }
    /**
    Get Achievements Completes during the game and banner was not showing
    
    - returns: [String : GKAchievement] or nil
    
    */
    public class func getAchievementCompleteAndBannerNotShowing() -> [GKAchievement]? {
        let instanceEGC = EasyGameCenter.sharedInstance
        
        let achievements : [String:String] = instanceEGC.achievementsCacheShowAfter
        var achievementsTemps = [GKAchievement]()
        
        if achievements.count > 0 {
            
            for achievement in achievements  {
                if let achievementExtract = EasyGameCenter.getAchievementForIndentifier(identifierAchievement: achievement.1) {
                    if achievementExtract.completed && achievementExtract.showsCompletionBanner == false {
                        achievementsTemps.append(achievementExtract)
                    }
                }
            }
            return achievementsTemps
        }
        return nil
    }
    /**
    Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    
    - parameter completion: if is Show Achievement banner
    (Bug Game Center if you show achievement by showsCompletionBanner = true when you report and again you show showsCompletionBanner = false is not show)
    
    */
    public class func showAllBannerAchievementCompleteForBannerNotShowing(completion: ((achievementShow:GKAchievement?) -> Void)? = nil) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let instanceEGC = EasyGameCenter.sharedInstance
            
            if !EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                EasyGameCenter.debug("\n[Easy Game Center] Player not identified\n")
                if completion != nil { completion!(achievementShow: nil) }
            } else {
                if let achievementNotShow: [GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
                    for achievement in achievementNotShow  {
                        
                        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: achievement.identifier!, completion: {
                            (tupleGKAchievementAndDescription) -> Void in
                            
                            if let tupleOK = tupleGKAchievementAndDescription {
                                //oneAchievement.showsCompletionBanner = true
                                let title = tupleOK.gkAchievementDescription.title
                                let description = tupleOK.gkAchievementDescription.achievedDescription
                                
                                EasyGameCenter.showCustomBanner(title: title!, description: description!, completion: { () -> Void in
                                    if completion != nil { completion!(achievementShow: achievement) }
                                })
                            } else {
                                if completion != nil { completion!(achievementShow: nil) }
                            }
                        })
                    }
                    instanceEGC.achievementsCacheShowAfter.removeAll(keepCapacity: false)
                } else {
                    if completion != nil { completion!(achievementShow: nil) }
                }
            }
        }
    }
    /**
    Get progress to an achievement
    
    - parameter Achievement: Identifier
    
    - returns: Double or nil (if not find)
    
    */
    public class func getProgressForAchievement(achievementIdentifier achievementIdentifier:String) -> Double? {
        let instanceEGC = EasyGameCenter.sharedInstance
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            if let achievementInArrayInt = instanceEGC.achievementsCache[achievementIdentifier]?.percentComplete {
                return achievementInArrayInt
            } else {
                EasyGameCenter.debug("\n[EasyGameCenter] Haven't cache\n")
            }
        } else {
            EasyGameCenter.debug("\n[EasyGameCenter] Player not identified\n")
        }
        return nil
    }
    /**
    Remove All Achievements
    
    completion: return GKAchievement reset or Nil if game center not work
    sdsds
    */
    public class func resetAllAchievements( completion:  ((achievementReset:GKAchievement?) -> Void)? = nil)  {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                GKAchievement.resetAchievementsWithCompletionHandler({
                    (error:NSError?) -> Void in
                    if error != nil {
                        EasyGameCenter.debug("\n[Easy Game Center] Couldn't Reset achievement (Send data error) \n")
                    } else {
                        let gameCenter = EasyGameCenter.Static.instance!
                        for lookupAchievement in gameCenter.achievementsCache {
                            let achievementID = lookupAchievement.0
                            let achievementGK = lookupAchievement.1
                            achievementGK.percentComplete = 0
                            achievementGK.showsCompletionBanner = false
                            if completion != nil { completion!(achievementReset:achievementGK) }
                            EasyGameCenter.debug("\n[Easy Game Center] Reset achievement (\(achievementID))\n")
                        }
                    }
                })
            } else {
                EasyGameCenter.debug("\n[Easy Game Center] Player not identified\n")
                if completion != nil { completion!(achievementReset: nil) }
            }
        }
    }
    
    /*####################################################################################################*/
    /*                                          Mutliplayer                                               */
    /*####################################################################################################*/
    /**
    Find player By number
    
    - parameter minPlayers: Int
    - parameter maxPlayers: Max
    */
    public class func findMatchWithMinPlayers(minPlayers: Int, maxPlayers: Int) {
        
        let instance = EasyGameCenter.sharedInstance
        
        do {
            let delegateUI = try instance.getDelegate()
            try instance.getDelegateEGC()
            
            EasyGameCenter.disconnectMatch()
            
            let request = GKMatchRequest()
            request.minPlayers = minPlayers
            request.maxPlayers = maxPlayers
            
            
            let controlllerGKMatch = GKMatchmakerViewController(matchRequest: request)
            controlllerGKMatch!.matchmakerDelegate = EasyGameCenter.sharedInstance
            
            var delegeteParent:UIViewController? = delegateUI.parentViewController
            if delegeteParent == nil {
                delegeteParent = delegateUI
            }
            delegeteParent!.presentViewController(controlllerGKMatch!, animated: true, completion: nil)
            
        } catch ErrorEGC.DelegateNotHaveProtocolEasyGameCenterDelegate {
            errorHandleur(ErrorEGC.DelegateNotHaveProtocolEasyGameCenterDelegate)
            
        } catch ErrorEGC.NoInstance {
            errorHandleur(ErrorEGC.NoInstance)
            
        } catch {
            fatalError("Dont work\(error)")
        }
    }
    /**
    Get Player in match
    
    - returns: Set<GKPlayer>
    */
    public class func getPlayerInMatch() -> Set<GKPlayer>? {
        let instanceEGC = EasyGameCenter.sharedInstance
        
        if instanceEGC.match == nil {
            EasyGameCenter.debug("\n[Easy Game Center] No Match\n")
        } else {
            if instanceEGC.playersInMatch.count > 0 {
                return instanceEGC.playersInMatch
            }
        }
        return nil
    }
    /**
    Deconnect the Match
    */
    public class func disconnectMatch() {
        let instanceEGC = EasyGameCenter.sharedInstance
        
        if instanceEGC.match != nil {
            EasyGameCenter.debug("\n[Easy Game Center] Disconnect from match \n")
            instanceEGC.match!.disconnect()
            instanceEGC.match = nil
            guard let delegateEGC = self.delegate  as? EasyGameCenterDelegate else {
                return
            }
            delegateEGC.easyGameCenterMatchEnded?()
        }
    }
    /**
    Get match
    
    - returns: GKMatch or nil if haven't match
    */
    public class func getMatch() -> GKMatch? {
        let instanceEGC = EasyGameCenter.sharedInstance
        if instanceEGC.match == nil {
            EasyGameCenter.debug("\n[Easy Game Center] No Match\n")
        } else {
            return instanceEGC.match!
        }
        return nil
    }
    /**
    player in net
    */
    @available(iOS 8.0, *)
    private func lookupPlayers() {
        let instance = EasyGameCenter.sharedInstance
        
        do {
            let delegateEGC = try instance.getDelegateEGC()
            
            guard instance.match != nil else {
                EasyGameCenter.debug("\n[Easy Game Center] No Match\n")
                return
            }
            
            let playerIDs = match!.players.map { ($0 as GKPlayer).playerID! }
            
            /* Load an array of player */
            GKPlayer.loadPlayersForIdentifiers(playerIDs) {
                (players, error) -> Void in
                
                guard error == nil else {
                    EasyGameCenter.debug("[Easy Game Center] Error retrieving player info: \(error!.localizedDescription)")
                    EasyGameCenter.disconnectMatch()
                    return
                }
                
                if let arrayPlayers = players as [GKPlayer]? { self.playersInMatch = Set(arrayPlayers) }
                
                GKMatchmaker.sharedMatchmaker().finishMatchmakingForMatch(self.match!)
                delegateEGC.easyGameCenterMatchStarted?()
                
            }
        } catch ErrorEGC.DelegateNotHaveProtocolEasyGameCenterDelegate {
            EasyGameCenter.errorHandleur(ErrorEGC.DelegateNotHaveProtocolEasyGameCenterDelegate)
            
            
        } catch ErrorEGC.NoInstance {
            EasyGameCenter.errorHandleur(ErrorEGC.NoInstance)
            
        } catch {
            fatalError("Dont work\(error)")
            
        }
    }
    
    /**
    Transmits data to all players connected to the match.
    
    - parameter data:     NSData
    - parameter modeSend: GKMatchSendDataMode
    
    :GKMatchSendDataMode Reliable: a.s.a.p. but requires fragmentation and reassembly for large messages, may stall if network congestion occurs
    :GKMatchSendDataMode Unreliable: Preferred method. Best effort and immediate, but no guarantees of delivery or order; will not stall.
    */
    public class func sendDataToAllPlayers(data: NSData!, modeSend:GKMatchSendDataMode) {
        
        let instance = EasyGameCenter.sharedInstance
        
        do {
            let delegateEGC = try instance.getDelegateEGC()
            
            guard instance.match != nil else {
                EasyGameCenter.debug("\n[Easy Game Center] No Match\n")
                return
            }
            
            
            do {
                try instance.match!.sendDataToAllPlayers(data, withDataMode: modeSend)
                EasyGameCenter.debug("\n[Easy Game Center] Succes sending data all Player \n")
            } catch  {
                EasyGameCenter.disconnectMatch()
                delegateEGC.easyGameCenterMatchEnded?()
                EasyGameCenter.debug("\n[Easy Game Center] Fail sending data all Player\n")
            }
            
        } catch {
            EasyGameCenter.errorHandleur(.DelegateNotHaveProtocolEasyGameCenterDelegate)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*####################################################################################################*/
    /*                                    Singleton  Private  Instance                                    */
    /*####################################################################################################*/
    
    /**
    ShareInstance Private
    
    - throws: .NoInstance
    
    - returns: Instance of EasyGameCenter
    */
    class private func getInstance() throws -> EasyGameCenter {
        guard let instanceEGC = Static.instance else {
            throw ErrorEGC.NoInstance
        }
        return instanceEGC
    }
    /// ShareInstance Private
    class private var sharedInstance : EasyGameCenter {
        do {
            let instance = try EasyGameCenter.getInstance()
            return instance
        } catch  {
            errorHandleur(ErrorEGC.NoInstance)
            fatalError("Dont work\(error)")
        }
    }
    /**
    Delegate UIViewController
    
    
    - throws: .NoDelegate
    
    - returns: UIViewController
    */
    private func getDelegate() throws -> UIViewController {
        guard let delegate = Static.delegate else {
            throw ErrorEGC.NoDelegate
        }
        return delegate
    }
    /**
    Delegate UIViewController repect protocol EasyGameCenterDelegate
    
    - throws: .DelegateNotHaveProtocolEasyGameCenterDelegate
    
    - returns: Instance of EasyGameCenter Delegate Protocol
    */
    private func getDelegateEGC() throws -> EasyGameCenterDelegate {
        guard let delegateEGC = Static.delegate as? EasyGameCenterDelegate else {
            throw ErrorEGC.DelegateNotHaveProtocolEasyGameCenterDelegate
        }
        return delegateEGC
    }
    
    /*####################################################################################################*/
    /*                                            private Start                                           */
    /*####################################################################################################*/
    /**
    Init Implemented by subclasses to initialize a new object
    
    - returns: An initialized object
    */
    override init() { super.init() }
    
    /**
    Completion for cachin Achievements and AchievementsDescription
    
    - parameter achievementsType: GKAchievement || GKAchievementDescription
    */
    private static func completionCachingAchievements(achievementsType :[AnyObject]?) {
        
        let instance = EasyGameCenter.sharedInstance
        
        func finish() {
            if instance.achievementsCache.count > 0 && instance.achievementsDescriptionCache.count > 0 {
                do {
                    let _ = try? instance.getDelegateEGC().easyGameCenterInCache?()
                }
            }
            instance.inCacheIsLoading = false
        }
        
        
        // Type GKAchievement
        if achievementsType is [GKAchievement] {
            
            guard let arrayGKAchievement = achievementsType as? [GKAchievement] where arrayGKAchievement.count > 0 else {
                return
            }
            
            for anAchievement in arrayGKAchievement where  anAchievement.identifier != nil {
                instance.achievementsCache[anAchievement.identifier!] = anAchievement
            }
            finish()
            
            // Type GKAchievementDescription
        } else if achievementsType is [GKAchievementDescription] {
            
            guard let arrayGKAchievementDes = achievementsType as? [GKAchievementDescription] where arrayGKAchievementDes.count > 0 else {
                EasyGameCenter.errorHandleur(ErrorEGC.CantCachingNoAchievements)
                return
            }
            
            for anAchievementDes in arrayGKAchievementDes where  anAchievementDes.identifier != nil {
                
                // Add GKAchievement
                if instance.achievementsCache.indexForKey(anAchievementDes.identifier!) == nil {
                    instance.achievementsCache[anAchievementDes.identifier!] = GKAchievement(identifier: anAchievementDes.identifier!)
                    
                }
                // Add CGAchievementDescription
                instance.achievementsDescriptionCache[anAchievementDes.identifier!] = anAchievementDes
            }
            
            GKAchievement.loadAchievementsWithCompletionHandler({
                ( allAchievements:[GKAchievement]?, error:NSError?) -> Void in
                
                guard (error == nil) && allAchievements!.count != 0  else {
                    finish()
                    return
                }
                
                EasyGameCenter.completionCachingAchievements(allAchievements)
                
            })
        }
    }
    
    
    
    /**
    Load achievements in cache
    (Is call when you init EasyGameCenter, but if is fail example for cut connection, you can recall)
    And when you get Achievement or all Achievement, it shall automatically cached
    
    */
    private func cachingAchievements() {
        if !self.inCacheIsLoading {
            self.inCacheIsLoading = true
            
            guard EasyGameCenter.isConnectedToNetwork() else {
                self.inCacheIsLoading = false
                EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
                return
            }
            guard EasyGameCenter.isPlayerIdentifiedToGameCenter() else {
                self.inCacheIsLoading = false
                EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                return
            }
            
            // Load GKAchievementDescription
            GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler({
                ( achievementsDescription:[GKAchievementDescription]?, error:NSError?) -> Void in
                if  (error != nil) {
                    self.inCacheIsLoading = false
                    EasyGameCenter.errorHandleur(ErrorEGC.CantCachingA)
                } else {
                    EasyGameCenter.completionCachingAchievements(achievementsDescription)
                }
            })
        }
    }
    /**
    Login player to GameCenter With Handler Authentification
    This function is recall When player connect to Game Center
    
    - parameter completion: (Bool) if player login to Game Center
    */
    private func loginPlayerToGameCenter()  {
        
        let instanceEGC = EasyGameCenter.sharedInstance
        let delegate = EasyGameCenter.delegate
        
        /**
        Send Authentified
        */
        func authentified() {
            self.loginIsLoading = false
            dispatch_async(dispatch_get_main_queue()) {
                
                do {
                    let delegateEGC = try? EasyGameCenter.sharedInstance.getDelegateEGC()
                    delegateEGC?.easyGameCenterAuthentified?()
                    instanceEGC.cachingAchievements()
                }
            }
        }
        
        guard EasyGameCenter.isConnectedToNetwork() else {
            EasyGameCenter.errorHandleur(ErrorEGC.NoConnection)
            return
        }
        
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            authentified()
            return
        }
        
        
        if !loginIsLoading {
            self.loginIsLoading = true
            
            GKLocalPlayer.localPlayer().authenticateHandler = {
                (gameCenterVC:UIViewController?, error:NSError?) -> Void in
                /* If got error / Or player not set value for login */
                if error != nil {
                    self.loginIsLoading = false
                    EasyGameCenter.errorHandleur(ErrorEGC.CantCachingA)
                    
                    /* Login to game center need Open page */
                } else {
                    if gameCenterVC != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            var delegeteParent:UIViewController? = delegate.parentViewController
                            if delegeteParent == nil {
                                delegeteParent = delegate
                            }
                            delegeteParent!.presentViewController(gameCenterVC!, animated: true, completion: nil)
                        }
                    } else if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                        authentified()
                        
                    } else  {
                        self.loginIsLoading = false
                        EasyGameCenter.errorHandleur(ErrorEGC.NoLogin)
                    }
                }
            }
        }
    }
    /*####################################################################################################*/
    /*                              Private Timer checkup                                                 */
    /*####################################################################################################*/
    /**
    Function checkup when he have net work login Game Center
    */
    func checkupNetAndPlayer() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.timerNetAndPlayer == nil {
                self.timerNetAndPlayer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkupNetAndPlayer"), userInfo: nil, repeats: true)
            }
            
            if EasyGameCenter.isConnectedToNetwork() {
                self.timerNetAndPlayer!.invalidate()
                self.timerNetAndPlayer = nil
                
                EasyGameCenter.sharedInstance.loginPlayerToGameCenter()
            }
        }
    }
    
    /*####################################################################################################*/
    /*                                      Private Func Achievements                                     */
    /*####################################################################################################*/
    /**
    Report achievement classic
    
    - parameter achievement: GKAchievement
    */
    private func reportAchievementToGameCenter(achievement achievement:GKAchievement) {
        /* try to report the progress to the Game Center */
        
        GKAchievement.reportAchievements([achievement], withCompletionHandler:  {
            (error:NSError?) -> Void in
            if error != nil { /* Game Center Save Automatique */ }
        })
    }
    /*####################################################################################################*/
    /*                             Public Delagate Game Center                                          */
    /*####################################################################################################*/
    /**
    Dismiss Game Center when player open
    - parameter GKGameCenterViewController:
    
    Override of GKGameCenterControllerDelegate
    
    */
    public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*####################################################################################################*/
    /*                                          GKMatchDelegate                                           */
    /*####################################################################################################*/
    /**
    Called when data is received from a player.
    
    - parameter theMatch: GKMatch
    - parameter data:     NSData
    - parameter playerID: String
    */
    public func match(theMatch: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        
        let instance = EasyGameCenter.sharedInstance
        
        do {
            let delegateEGC = try instance.getDelegateEGC()
            
            guard instance.match == theMatch else {
                return
            }
            
            delegateEGC.easyGameCenterMatchRecept?(theMatch, didReceiveData: data, fromPlayer: playerID)
        } catch {
            EasyGameCenter.errorHandleur(.DelegateNotHaveProtocolEasyGameCenterDelegate)
        }
    }
    /**
    Called when a player connects to or disconnects from the match.
    
    Echange avec autre players
    
    - parameter theMatch: GKMatch
    - parameter playerID: String
    - parameter state:    GKPlayerConnectionState
    */
    public func match(theMatch: GKMatch, player playerID: String, didChangeState state: GKPlayerConnectionState) {
        /* recall when is desconnect match = nil */
        guard self.match == theMatch else { return }
        
        switch state {
            /* Connected */
        case .StateConnected:
            if theMatch.expectedPlayerCount == 0 {
                if #available(iOS 8.0, *) {
                    self.lookupPlayers()
                } else {
                    // Fallback on earlier versions
                }
            }
            
            /* Lost deconnection */
        case .StateDisconnected:
            EasyGameCenter.disconnectMatch()
        default:
            break
        }
    }
    /**
    Called when the match cannot connect to any other players.
    
    - parameter theMatch: GKMatch
    - parameter error:    NSError
    
    */
    public func match(theMatch: GKMatch, didFailWithError error: NSError?) {
        guard self.match == theMatch else { return }
        
        if error != nil {
            EasyGameCenter.debug("[Easy Game Center] Match failed with error: \(error!.localizedDescription)")
            EasyGameCenter.disconnectMatch()
        }
    }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewControllerDelegate                                      */
    /*####################################################################################################*/
    /**
    Called when a peer-to-peer match is found.
    
    - parameter viewController: GKMatchmakerViewController
    - parameter theMatch:       GKMatch
    */
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch theMatch: GKMatch) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        self.match = theMatch
        self.match!.delegate = self
        if match!.expectedPlayerCount == 0 {
            if #available(iOS 8.0, *) {
                self.lookupPlayers()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    /*####################################################################################################*/
    /*                             GKLocalPlayerListener                                                  */
    /*####################################################################################################*/
    /**
    Called when another player accepts a match invite from the local player
    
    - parameter player:         GKPlayer
    - parameter inviteToAccept: GKPlayer
    */
    public func player(player: GKPlayer, didAcceptInvite inviteToAccept: GKInvite) {
        let gkmv = GKMatchmakerViewController(invite: inviteToAccept)
        gkmv!.matchmakerDelegate = self
        
        let delegate = EasyGameCenter.delegate
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gkmv!, animated: true, completion: nil)
    }
    /**
    Initiates a match from Game Center with the requested players
    
    - parameter player:          The GKPlayer object containing the current player’s information
    - parameter playersToInvite: An array of GKPlayer
    */
    public func player(player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) { }
    
    /**
    Called when the local player starts a match with another player from Game Center
    
    - parameter player:            The GKPlayer object containing the current player’s information
    - parameter playerIDsToInvite: An array of GKPlayer
    */
    public func player(player: GKPlayer, didRequestMatchWithPlayers playerIDsToInvite: [String]) { }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewController                                              */
    /*####################################################################################################*/
    /**
    Called when the user cancels the matchmaking request (required)
    
    - parameter viewController: GKMatchmakerViewController
    */
    public func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        do {
            let delegateEGC = try EasyGameCenter.sharedInstance.getDelegateEGC()
            delegateEGC.easyGameCenterMatchCancel?()
            EasyGameCenter.debug("\n[Easy Game Center] Player cancels the matchmaking request \n")
        } catch {
            EasyGameCenter.errorHandleur(.DelegateNotHaveProtocolEasyGameCenterDelegate)
        }
    }
    /**
    Called when the view controller encounters an unrecoverable error.
    
    - parameter viewController: GKMatchmakerViewController
    - parameter error:          NSError
    */
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        do {
            let delegateEGC = try EasyGameCenter.sharedInstance.getDelegateEGC()
            delegateEGC.easyGameCenterMatchCancel?()
            EasyGameCenter.debug("\n[Easy Game Center] Error finding match: \(error.localizedDescription)\n")
            
        } catch {
            EasyGameCenter.errorHandleur(.DelegateNotHaveProtocolEasyGameCenterDelegate)
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////


// MARK: - Debug  /  Error Func
extension EasyGameCenter {
    
    
    private class func debug(object: Any) {
        if EasyGameCenter.debugMode {
            dispatch_async(dispatch_get_main_queue()) {
                Swift.print(object)
            }
        }
    }
    /**
    Init Implemented by subclasses to initialize a new object
    
    - returns: An initialized object
    */
    private enum ErrorEGC : ErrorType {
        case CantCachingAds
        case CantCachingA
        case CantCachingNoA
        case CantCachingNoAchievements
        case Empty
        case IndexOut
        case NoConnection
        case NoLogin
        case NoDelegate
        case DelegateNotHaveProtocolEasyGameCenterDelegate
        case NoInstance
        case NoUIViewController
        case ParamEmpty
        case CantLoadLeaderboards
        
        /// Description
        var description : String {
            defer { }
            
            switch self {
            case .CantLoadLeaderboards:
                return "[Easy Game Center] Couldn't load Leaderboards"
                
            case CantCachingAds:
                return "CantCachingAds"
            case CantCachingA:
                return "CantCachingA"
            case CantCachingNoA:
                return "[Easy Game Center] Can't caching Achievement they are no create"
            case .CantCachingNoAchievements:
                return "[Easy Game Center] Can't caching GKAchievement and GKAchievementDescription, check ItuneConnect if you have create Achievements"
            case NoConnection:
                return "[Easy Game Center] No connexion"
            case .NoLogin:
                return "[Easy Game Center] No login"
            case NoDelegate :
                return "\n[Easy Game Center] Error delegate UIViewController not set\n"
            case .NoUIViewController:
                return "\n[Easy Game Center] Error delegate is not UIViewController\n"
            case .ParamEmpty:
                return "\n[Easy Game Center] Error Param is empty\n"
            default:
                return ""
            }
        }
    }
    
    private class func errorHandleur(errorEgc:ErrorEGC) {
        
        defer { EasyGameCenter.debug(errorEgc) }
        
        switch errorEgc {
        case .NoLogin:
            guard let delegateEGC = self.delegate  as? EasyGameCenterDelegate else {
                return
            }
            delegateEGC.easyGameCenterNotAuthentified?()
            break
        case .CantCachingNoA:
            EasyGameCenter.sharedInstance.inCacheIsLoading = false
            EasyGameCenter.sharedInstance.checkupNetAndPlayer()
            break
        case .CantCachingA:
            //EasyGameCenter.sharedInstance.checkupNetAndPlayer()
            break
        default:
            break
        }
    }
    
}