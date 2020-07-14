//
//  NotesViewController.swift
//  Note-ify
//
//  Created by Jonas Gamburg on 13/07/2020.
//  Copyright © 2020 Jonas Gamburg. All rights reserved.
//

import UIKit
import AVKit
import AudioKit

class NotesViewController: UIViewController {

    
    private var spacing: CGFloat = -60
    @IBOutlet weak var helpButton: CustomButton!
    @IBOutlet weak var backButton: CustomButton!
    @IBOutlet weak var sharpsLabel: UILabel!
    @IBOutlet weak var flatsLabel: UILabel!

    var helpViewCenterYAnchor: NSLayoutConstraint!
    var microphone: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var helpTapped = false
    
    var aString = StringView()
    var bString = StringView()
    var cString = StringView()
    var dString = StringView()
    var eString = StringView()
    
    var noteSharpView: UIView = .init()
    var noteSharpImageView: UIImageView = .init()
    var noteFlatView: UIView = .init()
    var noteFlatImageView: UIImageView = .init()
    
    let helpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let helpMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Just speak up or make a sound the app converts your vibrations to mathematical data which is later recognized and determained as a note, appearing as a sharp or regular note in the top circle and a flat on the in the bottom circle."
        label.textColor = .white
        label.font = UIFont(name: General.appFont, size: 16)
        label.numberOfLines = 10
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            try AudioKit.stop()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setUp() {
        view.backgroundColor                  = Colors.backgroundColor
        sharpsLabel.textColor                 = .white
        flatsLabel.textColor                  = .white
        sharpsLabel.adjustsFontSizeToFitWidth = true
        flatsLabel.adjustsFontSizeToFitWidth  = true
        
        //change if required
        sharpsLabel.isHidden = true
        flatsLabel.isHidden  = true
        
        
        
        requestMicrophonePremission()
        helpButton.setUp(as: .help)
        backButton.setUp(as: .help)
        setUpStrings()
        configureHelpView()
    }
    
    func setUpStrings() {
        setConstraints(forStringView: aString)
        setConstraints(forStringView: bString)
        setConstraints(forStringView: cString)
        setConstraints(forStringView: dString)
        setConstraints(forStringView: eString)
        
        view.addSubview(noteSharpView)
        noteSharpView.addSubview(noteSharpImageView)
        setUp(noteSharpView, as: .sharp)
        
        view.addSubview(noteFlatView)
        noteFlatView.addSubview(noteFlatImageView)
        setUp(noteFlatView, as: .flat)
    }
    
    @IBAction func backButtonTapped(_ sender: CustomButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func helpButtonTapped(_ sender: CustomButton) {
        if helpTapped {
            hideHelpMessage()
        } else {
            showHelpMessage()
        }
    }
    
    func showHelpMessage() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.helpTapped = true
            self.helpView.layer.opacity = 1.0
            self.helpView.center = self.view.center
            self.helpViewCenterYAnchor.isActive = true
            self.helpButton.setTitle("Dismiss", for: .normal)
        }, completion: nil)
    }
    
    func hideHelpMessage() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.helpTapped = false
            self.helpView.layer.opacity = 0.0
            self.helpView.center.y = 0
            self.helpButton.setTitle("Help?", for: .normal)
        }, completion: nil)
    }
}

extension NotesViewController {
    
    enum NoteType {
        case sharp
        case flat
    }
    
    
    func configureHelpView() {
        view.addSubview(helpView)
        
        helpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpViewCenterYAnchor = helpView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        helpViewCenterYAnchor.isActive = true
        helpView.widthAnchor.constraint(equalToConstant: 200).isActive          = true
        helpView.heightAnchor.constraint(equalToConstant: 300).isActive         = true
        
        helpView.backgroundColor              = Colors.startButtonColor
        helpView.layer.cornerRadius           = 50
        helpView.layer.borderColor            = UIColor.clear.cgColor
        helpView.layer.shadowColor            = UIColor.black.cgColor
        helpView.layer.shadowOffset           = .init(width: 0, height: 7)
        helpView.layer.shadowOpacity          = 0.4
        helpView.layer.masksToBounds          = false
        helpView.clipsToBounds                = false
        
        helpView.addSubview(helpMessageLabel)
        helpMessageLabel.topAnchor.constraint(equalTo: helpView.topAnchor, constant: 8).isActive       = true
        helpMessageLabel.centerYAnchor.constraint(equalTo: helpView.centerYAnchor).isActive            = true
        helpMessageLabel.leftAnchor.constraint(equalTo: helpView.leftAnchor, constant: 10).isActive    = true
        helpMessageLabel.rightAnchor.constraint(equalTo: helpView.rightAnchor, constant: -10).isActive = true
        
        helpViewCenterYAnchor.isActive = false
        helpView.layer.opacity = 0.0
        helpView.center.y = 0
    }
    
    func requestMicrophonePremission() {
        let permission = AVAudioSession.sharedInstance().recordPermission
        
        switch permission {
        case .denied:
            print("Audio recording denied.")
        case .granted:
            print("Audio recording granted.")
            setUpMicrophone()
        case .undetermined:
            print("Requestion requesting recording permission...")
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                if granted { print("Permission granted!") }
                else { print("Permission declined.") }
            }
        @unknown default:
            fatalError()
        }
    }
    
    func setUpMicrophone() {
        AKSettings.audioInputEnabled = true
        microphone = AKMicrophone()
        tracker = AKFrequencyTracker(microphone)
        silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        
        do {
            try AudioKit.start()
        }
        catch { print(error) }
        
        Timer.scheduledTimer(timeInterval: 0.1,
        target: self,
        selector: #selector(updateUI),
        userInfo: nil,
        repeats: true)
    }
    
    @objc func updateUI() {
        let frequency = tracker.frequency
        
        if tracker.amplitude > 0.1 {
            let trackerFrequency = Float(frequency)
            
            guard trackerFrequency < 7_000 else {
                // This is a bit of hack because of modern Macbooks giving super high frequencies
                return
            }
            
            var frequency = trackerFrequency
            while frequency > Float(General.noteFrequencies[General.noteFrequencies.count - 1]) {
                frequency /= 2.0
            }
            while frequency < Float(General.noteFrequencies[0]) {
                frequency *= 2.0
            }
            
            var minDistance: Float = 10_000.0
            var index = 0
            
            for i in 0..<General.noteFrequencies.count {
                let distance = fabsf(Float(General.noteFrequencies[i]) - frequency)
                if distance < minDistance {
                    index = i
                    minDistance = distance
                }
            }
            let octave = Int(log2f(trackerFrequency / frequency))
            
            sharpsLabel.text = "\(General.noteNamesWithSharps[index])\(octave)"
            flatsLabel.text = "\(General.noteNamesWithFlats[index])\(octave)"
            
            noteSharpImageView.image = UIImage(named: General.notesWithSharps[index].rawValue)
            noteFlatImageView.image  = UIImage(named: General.notesWithFlats[index].rawValue)
            
            aString.shake(count: Float.random(in: 1...16), for: 1.0)
            bString.shake(count: Float.random(in: 1...13), for: 1.0)
            cString.shake(count: Float.random(in: 1...14), for: 1.0)
            dString.shake(count: Float.random(in: 1...17), for: 1.0)
            eString.shake(count: Float.random(in: 1...20), for: 1.0)
        }
    }
    
    func setNoteImage(withFrequenct frequenct: Double) {
        
    }

    func setConstraints(forStringView stringView: StringView) {
        stringView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stringView)
        stringView.topAnchor.constraint(equalTo: view.topAnchor).isActive         = true
        stringView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive   = true
        stringView.widthAnchor.constraint(equalToConstant: 1).isActive            = true
        stringView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stringView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: spacing).isActive = true
        
        spacing += 30
    }
    
    func setUp(_ noteView: UIView, as type: NoteType) {
        view.addSubview(noteView)
        switch type {
        case .sharp:
            noteView.translatesAutoresizingMaskIntoConstraints                      = false
            noteView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noteView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            noteView.widthAnchor.constraint(equalToConstant: 200).isActive          = true
            noteView.heightAnchor.constraint(equalToConstant: 200).isActive         = true
            noteView.layer.cornerRadius = 100
            
        case .flat:
            noteView.translatesAutoresizingMaskIntoConstraints                      = false
            noteView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noteView.topAnchor.constraint(equalTo: noteSharpView.bottomAnchor, constant: 50).isActive = true
            noteView.widthAnchor.constraint(equalToConstant: 150).isActive          = true
            noteView.heightAnchor.constraint(equalToConstant: 150).isActive         = true
            noteView.layer.cornerRadius = 75
            
        }
        
        noteView.backgroundColor              = .white
        noteView.layer.borderColor            = UIColor.clear.cgColor
        noteView.layer.shadowColor            = UIColor.black.cgColor
        noteView.layer.shadowOffset           = .init(width: 0, height: 7)
        noteView.layer.shadowRadius           = 12
        noteView.layer.shadowOpacity          = 0.4
        noteView.layer.masksToBounds          = false
        noteView.clipsToBounds                = false
        
        setUp(noteSharpImageView, as: .sharp)
        setUp(noteFlatImageView, as: .flat)
    }
    
    func setUp(_ noteImageView: UIImageView, as type: NoteType) {
        view.addSubview(noteImageView)
        switch type {
        case .sharp:
            noteImageView.translatesAutoresizingMaskIntoConstraints = false
            noteImageView.centerYAnchor.constraint(equalTo: noteSharpView.centerYAnchor).isActive = true
            noteImageView.centerXAnchor.constraint(equalTo: noteSharpView.centerXAnchor).isActive = true
            noteImageView.widthAnchor.constraint(equalToConstant: 180).isActive   = true
            noteImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
            noteImageView.image = UIImage(named: NotesWithSharps.A.rawValue)
            
        case .flat:
            noteImageView.translatesAutoresizingMaskIntoConstraints = false
            noteImageView.topAnchor.constraint(equalTo: noteSharpView.bottomAnchor, constant: 65).isActive = true
            noteImageView.centerXAnchor.constraint(equalTo: noteSharpView.centerXAnchor).isActive = true
            noteImageView.widthAnchor.constraint(equalToConstant: 120).isActive   = true
            noteImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            noteImageView.image = UIImage(named: NotesWithFlats.A.rawValue)
        }
        
        
    }
}
