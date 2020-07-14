//
//  Constants.swift
//  Note-ify
//
//  Created by Jonas Gamburg on 13/07/2020.
//  Copyright © 2020 Jonas Gamburg. All rights reserved.
//

import Foundation
import UIKit

struct General {
    static let appFont = "SFCompactRounded-Regular"
    
    static let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    static let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    static let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    static let notesWithSharps: [NotesWithSharps] = [.A, .Asharp, .B, .C, .Csharp, .D, .Dsharp, .E, .F, .Fsharp, .G, .Gsharp]
    static let notesWithFlats: [NotesWithFlats] = [.A, .Aflat, .B, .C, .Cflat, .D, .Dflat, .E, .F, .Fflat, .G, .Gflat]
    
    static func localized(_ key: String, comment: String? = nil) -> String {
        NSLocalizedString(key, comment: comment ?? "")
    }
}

enum NotesWithSharps: String {
    case A = "Note A"
    case B = "Note B"
    case C = "Note C"
    case D = "Note D"
    case E = "Note E"
    case F = "Note F"
    case G = "Note G"
    
    case Asharp = "Note A#"
    case Csharp = "Note C#"
    case Dsharp = "Note D#"
    case Fsharp = "Note F#"
    case Gsharp = "Note G#"
}

enum NotesWithFlats: String {
    case A = "Note A"
    case B = "Note B"
    case C = "Note C"
    case D = "Note D"
    case E = "Note E"
    case F = "Note F"
    case G = "Note G"
    
    case Aflat = "Note Ab"
    case Cflat = "Note Cb"
    case Dflat = "Note Db"
    case Fflat = "Note Fb"
    case Gflat = "Note Gb"
}

enum Frequency {
    
}



struct Colors {
    static let backgroundColor: UIColor   = #colorLiteral(red: 0.4025601149, green: 0.4634543061, blue: 0.9566099048, alpha: 1)
    static let startButtonColor: UIColor  = #colorLiteral(red: 0.205580622, green: 0.830312252, blue: 0.5810541511, alpha: 1)
    static let donateButtonColor: UIColor = #colorLiteral(red: 0.8886799216, green: 0.4257495403, blue: 0.6296762824, alpha: 1)
}
