//
//  InterfaceImage.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/9/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit

public enum InterfaceImage: String {
    public enum Style {
        case normal
        case white
        case selected
        case disabled
        case red
    }
    
    case ElloLogo = "ello_logo"
    
    case DriverCar = "driver_car"
    
    case DropdownArrow = "dropdown_arrow"
    
    // Postbar Icons
    case Eye = "eye"
    case Heart = "hearts"
    case GiantHeart = "hearts_giant"
    case Repost = "repost"
    case Share = "share"
    case XBox = "xbox"
    case Pencil = "pencil"
    case Reply = "reply"
    case Flag = "flag"
    
    // Notification Icons
    case Comments = "bubble"
    case Invite = "relationships"
    
    // TabBar Icons
    case Sparkles = "sparkles"
    case Bolt = "bolt"
    case Omni = "omni"
    case Person = "person"
    case CircBig = "circbig"
    case NarrationPointer = "narration_pointer"
    
    // Validation States
    case ValidationLoading = "circ"
    case ValidationError = "x_red"
    case ValidationOK = "check_green"
    
    // NavBar Icons
    case Search = "search"
    case Burger = "burger"
    
    // Grid/List Icons
    case Grid = "grid"
    case List = "list"
    
    // Omnibar
    case Reorder = "reorder"
    case Camera = "camera"
    case Check = "check"
    case Arrow = "arrow"
    case Link = "link"
    case BreakLink = "breaklink"
    
    // Commenting
    case ReplyAll = "replyall"
    case BubbleBody = "bubble_body"
    case BubbleTail = "bubble_tail"
    
    // Relationship
    case Star = "star"
    
    // Alert
    case Question = "question"
    
    // Generic
    case X = "x"
    case Dots = "dots"
    case PlusSmall = "plussmall"
    case CheckSmall = "checksmall"
    case AngleBracket = "abracket"
    
    // Embeds
    case AudioPlay = "embetter_audio_play"
    case VideoPlay = "embetter_video_play"
    
    func image(_ style: Style) -> UIImage? {
        switch style {
        case .normal:   return normalImage
        case .white:    return whiteImage
        case .selected: return selectedImage
        case .disabled: return disabledImage
        case .red:      return redImage
        }
    }
    
    //    var normalImage: UIImage! {
    //        switch self {
    //        case .ElloLogo,
    //            .GiantHeart,
    //            .AudioPlay,
    //            .VideoPlay,
    //            .BubbleTail,
    //            .NarrationPointer,
    //            .ValidationError,
    //            .ValidationOK:
    //            return SVGKImage(named: "\(self.rawValue).svg").uiImage
    //        default:
    //            return SVGKImage(named: "\(self.rawValue)_normal.svg").uiImage
    //        }
    //    }
    //    var selectedImage: UIImage! { return SVGKImage(named: "\(self.rawValue)_selected.svg").uiImage }
    //    var whiteImage: UIImage? { return SVGKImage(named: "\(self.rawValue)_white.svg").uiImage }
    //    var disabledImage: UIImage? {
    //        switch self {
    //        case .Repost, .AngleBracket:
    //            return SVGKImage(named: "\(self.rawValue)_disabled.svg").uiImage
    //        default:
    //            return nil
    //        }
    //    }
    //    var redImage: UIImage? { return SVGKImage(named: "\(self.rawValue)_red.svg").uiImage }
    
    var normalImage: UIImage! {
        return UIImage(named:"defaultMarker")
    }
    var selectedImage: UIImage! { return UIImage(named:"defaultMarker") }
    var whiteImage: UIImage? { return UIImage(named:"defaultMarker") }
    var disabledImage: UIImage? {
        return UIImage(named:"defaultMarker")
        
    }
    
    var redImage: UIImage? { return UIImage(named:"defaultMarker") }
}
